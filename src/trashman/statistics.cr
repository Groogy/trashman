module Trashman::Statistics
  @@records = [] of BaseRecord
  @@guard = false

  def self.guard=(flag)
    @@guard = flag
  end

  def self.guard?
    @@guard
  end

  def self.records
    @@records
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
    @@records.each do |record|
      return record.as(Record(T)) if record.callstack == callstack
    end
    record = Record(T).new callstack
    @@records << record
    record
  end
end