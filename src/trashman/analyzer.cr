@[Trashman::Ignore]
struct Trashman::AnalyzerRecord
  @callstack : CallStack
  @avg_lifetime : Time::Span
  @allocations : UInt64
  @deallocations : UInt64
  @type : String
  @type_size : Int32

  getter callstack, avg_lifetime, allocations, deallocations, type, type_size

  def initialize(record)
    @callstack = record.callstack
    @avg_lifetime = record.calc_average_lifetime
    @allocations = record.allocations
    @deallocations = record.deallocations
    @type = record.type_str
    @type_size = record.type_size
  end
end

@[Trashman::Ignore]
class Trashman::Analyzer
  @sorter : Proc(AnalyzerRecord, AnalyzerRecord, Int32)
  @formatter : Formatter
  @records : Array(AnalyzerRecord)

  property sorter, formatter

  def initialize
    @sorter = ->(a : AnalyzerRecord, b : AnalyzerRecord) {
      a.avg_lifetime <=> b.avg_lifetime
    }
    @formatter = DefaultFormatter.new
    @records = [] of AnalyzerRecord
    {% if Trashman::Config::IS_ENABLED %}
      process_records
    {% end %}
  end

  def print_stats(io)
    records = @records.sort &@sorter
    @records.each do |record|
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
