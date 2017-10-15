class GCProfiler::Analyzer
  def print_stats(io)
    records = Statistics.records
    records.each do |record|
      print_record io, record
    end
  end

  def print_record(io, record)
    io.puts "#{record.type} -- Avg Lifetime: #{record.calc_average_lifetime}"
    io.puts "Allocations: #{record.allocations}, Deallocations: #{record.deallocations}"
    backtrace = record.callstack.printable_backtrace
    backtrace.each do |line|
      io.puts line
    end
  end
end