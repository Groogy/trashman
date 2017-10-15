class GCProfiler::Record
  @callstack : CallStack
  @type : String
  @references : Array(Ref)
  @lifetimes : Array(Time::Span)
  @allocations : UInt64
  @deallocations : UInt64

  getter callstack, allocations, deallocations, type

  def initialize(@callstack, @type)
    @references = Array(Ref).new
    @lifetimes = Array(Time::Span).new
    @allocations = 0u64
    @deallocations = 0u64
  end

  def tracks?(ref)
    @references.includes? ref
  end

  def track(ref)
    @references << Ref.new ref, Time.utc_now
    @allocations += 1u64
  end

  def untrack(ref)
    if ref = @references.delete ref
      @lifetimes << ref.calc_lifetime Time.utc_now
      @deallocations += 1u64
    end
  end

  def calc_average_lifetime
    now = Time.utc_now
    total_lifetime = @lifetimes.sum { |lifetime| lifetime }
    total_lifetime += @references.sum { |ref| now - ref.life_start }
    total_lifetime / (@lifetimes.size + @references.size)
  end
end