require "weak_ref"

class GCProfiler::Ref(T)
  @reference : WeakRef(T)
  @life_start : Time

  getter life_start

  def initialize(reference : T, @life_start)
    @reference = WeakRef.new reference
  end

  def invalid?
    @reference.value.nil?
  end

  def calc_lifetime(death)
    death - @life_start
  end
end