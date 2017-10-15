struct GCProfiler::Ref
  @reference : Void*
  @life_start : Time

  getter reference, life_start

  def initialize(@reference, @life_start)
  end

  def calc_lifetime(death)
    death - @life_start
  end
end