@[Trashman::Ignore]
class Trashman::BaseRecord
  @callstack : CallStack
  @allocations : UInt64
  @deallocations : UInt64

  getter callstack : CallStack
  getter allocations : UInt64
  getter deallocations : UInt64

  def initialize(@callstack)
    @allocations = 0u64
    @deallocations = 0u64
  end

  def untrack() : Nil
  end

  def calc_average_lifetime
    Time::Span.new(0, 0, 0)
  end

  def type_str
    ""
  end

  def type_size
    0i32
  end
end

@[Trashman::Ignore]
class Trashman::Record(T) < Trashman::BaseRecord
  @references : Array(Ref(T))

  def initialize(callstack)
    super(callstack)
    @references = Array(Ref(T)).new
  end

  def type_str : String
    T.to_s
  end

  def type_size : Int32
    instance_sizeof(T)
  end

  def tracks?(ptr) : Bool
    @references.each do |ref|
      return true if ref.reference == ptr
    end
  end

  def track(ref) : Nil
    @references << Ref.new ref, Time.utc
    @allocations += 1u64
  end

  def untrack : Nil
    @references.each do |ref|
      if !ref.dead? && ref.invalid?
        ref.kill
        @deallocations += 1u64
      end
      ref.invalid?
    end
  end

  def calc_average_lifetime
    total_lifetime = @references.sum { |ref| ref.lifetime }
    total_lifetime / @references.size
  end
end

@[Trashman::Ignore]
class Trashman::RecordNode
  @record : BaseRecord?
  @next_node : RecordNode?

  property record
  property next_node

  def each
    n = self
    until n.nil?
      if record = n.record
        yield record
      end
      n = n.next_node
    end
  end

  def last : RecordNode
    node = self
    until node.next_node.nil?
      node.next_node.try { |n| node = n }
    end
    node
  end

  def push(record)
    node = RecordNode.new
    node.record = record
    last.next_node = node
  end
end