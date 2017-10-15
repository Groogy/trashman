abstract class Trashman::BaseRecord
  abstract def callstack
  abstract def allocations
  abstract def deallocations
  abstract def untrack
  abstract def type_str
end

class Trashman::Record(T) < Trashman::BaseRecord
  @callstack : CallStack
  @references : Array(Ref(T))
  @lifetimes : Array(Time::Span)
  @allocations : UInt64
  @deallocations : UInt64

  getter callstack, allocations, deallocations

  def initialize(@callstack)
    @references = Array(Ref(T)).new
    @lifetimes = Array(Time::Span).new
    @allocations = 0u64
    @deallocations = 0u64
  end

  def type_str
    T.to_s
  end

  def type_size
    sizeof(T)
  end

  def tracks?(ptr)
    @references.each do |ref|
      return true if ref.reference == ptr
    end
  end

  def track(ref)
    @references << Ref.new ref, Time.utc_now
    @allocations += 1u64
  end

  def untrack
    @references.reject! do |ref|
      if ref.invalid?
        @lifetimes << ref.calc_lifetime Time.utc_now
        @deallocations += 1u64
      end
      ref.invalid?
    end
  end

  def calc_average_lifetime
    now = Time.utc_now
    total_lifetime = @lifetimes.sum { |lifetime| lifetime }
    total_lifetime += @references.sum { |ref| now - ref.life_start }
    total_lifetime / (@lifetimes.size + @references.size)
  end
end