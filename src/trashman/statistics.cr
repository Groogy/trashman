module Trashman::Statistics
  @@records = Trashman::RecordNode.new
  @@guard = true

  def self.initialize()
    records = @@records
  end

  def self.records
    @@records
  end

  def self.guard=(@@guard)
  end

  def self.guard?
    @@guard
  end

  def self.on_allocation(ref, callstack)
    record = find_record callstack, ref
    record.track ref
  end

  def self.on_finalize(ref)
    @@records.each do |record|
      record.untrack
    end
  end

  def self.find_record(callstack : CallStack, ref : T) : Record(T) forall T
    @@records.each do |r|
      if record = r.as?(Record(T))
        return record if record.callstack == callstack
      end
    end
    record = Record(T).new callstack
    @@records.push record
    record
  end
end