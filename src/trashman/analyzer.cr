class Trashman::Analyzer
  @sorter : Proc(BaseRecord, BaseRecord, Int32)

  property sorter

  def initialize
    @sorter = ->(a : BaseRecord, b : BaseRecord) {
      a.calc_average_lifetime <=> b.calc_average_lifetime
    }
  end

  def print_stats(io)
    records = Statistics.records
    records = records.sort &@sorter
    records.each do |record|
      print_record io, record
    end
  end

  def print_record(io, record)
    io.puts "#{record.type_str} -- Avg Lifetime: #{record.calc_average_lifetime}"
    io.puts "Allocations: #{record.allocations}, Deallocations: #{record.deallocations}"
    backtrace = record.callstack.printable_backtrace
    backtrace.each do |line|
      io.puts line
    end
  end
end