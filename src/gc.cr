require "./gc/*"

module GCProfiler
end

class Foo
  include GCProfiler

  @val = 50
end

class Array
  include GCProfiler
end

foo = Foo.new
pp foo

File.open "data.log", "w" do |file|
  analyzer = GCProfiler::Analyzer.new
  analyzer.print_stats(file)
end

#arr = Array(Int32).new(10, 0)
#pp arr