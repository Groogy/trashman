require "./gc/*"

module GCProfiler
end

class Foo
  include GCProfiler

  @val = StaticArray(Int32, 128).new(0)
end

def test_meth
  foo = Foo.new
end

100000.times do
  test_meth
  foo = Foo.new
end
GC.collect

File.open "data.log", "w" do |file|
  analyzer = GCProfiler::Analyzer.new
  analyzer.print_stats(file)
end

#arr = Array(Int32).new(10, 0)
#pp arr