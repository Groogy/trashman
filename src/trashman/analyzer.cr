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
  @records = [] of AnalyzerRecord

  property sorter

  def initialize
    Statistics.guard=true
    @sorter = ->(a : AnalyzerRecord, b : AnalyzerRecord) {
      a.avg_lifetime <=> b.avg_lifetime
    }
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
    io.puts "#{record.type} -- Avg Lifetime: #{record.avg_lifetime}"
    io.puts "Allocations: #{record.allocations}, Deallocations: #{record.deallocations}"
    backtrace = record.callstack.printable_backtrace
    backtrace.each do |line|
      io.puts line
    end
  end

  private def process_records
    Statistics.records.each do |record|
      @records << AnalyzerRecord.new record
    end
  end
end