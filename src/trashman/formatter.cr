abstract class Trashman::Formatter
  abstract def print_record_header(io, record)
  abstract def print_record_backtrace(io, callstack)
end

class Trashman::DefaultFormatter < Trashman::Formatter
  def print_record_header(io, record)
    io.puts "===== #{record.type} ====="
    io.puts "Allocations: #{record.allocations} --- Deallocations: #{record.deallocations}"
    io.puts "Avg Lifetime: #{record.avg_lifetime}"
  end

  def print_record_backtrace(io, callstack)
    backtrace = callstack.printable_backtrace
    backtrace.each do |line|
      io.puts line
    end
  end
end