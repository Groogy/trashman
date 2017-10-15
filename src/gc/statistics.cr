module GCProfiler::Statistics
  @@records = [] of Record
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
    record = find_record callstack, typeof(ref)
    record.track ref.as(Void*)
  end

  def self.on_finalize(ref)
    record = find_record ref.as(Void*)
    if record
      record.untrack ref.as(Void*)
    end
  end

  def self.find_record(callstack : CallStack, type) : Record
    @@records.each do |record|
      return record if record.callstack == callstack
    end
    record = Record.new callstack, type.to_s
    @@records << record
    record
  end

  def self.find_record(ref : Void*) : Record?
    @@records.each do |record|
      return record if record.tracks?(ref)
    end
    nil
  end
end