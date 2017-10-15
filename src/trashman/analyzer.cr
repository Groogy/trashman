struct Trashman::AnalyzerRecord
  @callstack : CallStack
  @avg_lifetime : Time::Span
  @allocations : UInt64
  @deallocations : UInt64
  @type : String

  getter callstack, avg_lifetime, allocations, deallocations, type

  def initialize(record)
    @callstack = record.callstack
    @avg_lifetime = record.calc_average_lifetime
    @allocations = record.allocations
    @deallocations = record.deallocations
    @type = record.type_str
  end
end

class Trashman::Analyzer
  @sorter : Proc(AnalyzerRecord, AnalyzerRecord, Int32)
  @formatter : Formatter
  @records : Array(AnalyzerRecord)

  property sorter, formatter

  def initialize
    Statistics.guard=true
    @sorter = ->(a : AnalyzerRecord, b : AnalyzerRecord) {
      a.avg_lifetime <=> b.avg_lifetime
    }
    @formatter = DefaultFormatter.new
    @records = [] of AnalyzerRecord
    process_records
    Statistics.guard=false
  end

  def print_stats(io)
    records = @records.sort &@sorter
    records.each do |record|
      print_record io, record
    end
  end

  def print_record(io, record)
    @formatter.print_record_header io, record
    @formatter.print_record_backtrace io, record.callstack
  end

  private def process_records
    Statistics.records.each do |record|
      @records << AnalyzerRecord.new record
    end
  end
end