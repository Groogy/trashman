require "weak_ref"

@[Trashman::Ignore]
class Trashman::Ref(T)
  @reference : WeakRef(T)
  @life_start : Time
  @death : Time?

  getter life_start
  getter death

  def initialize(reference : T, @life_start)
    @reference = WeakRef.new reference
  end

  def invalid?
    @reference.value.nil?
  end

  def dead?
    !@death.nil?
  end

  def lifetime
    if death = @death
      death - @life_start
    else
      Time.utc - @life_start
    end
  end

  def kill
    @death = Time.utc
    dead = true
  end
end