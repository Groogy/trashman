# gc

TODO: Write a description here

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gc:
    github: [your-github-name]/gc
```

## Usage

```crystal
require "gc"

class Foo
  include Trashman

  @val = StaticArray(Int32, 128).new(0)
end

def test_meth
  foo = Foo.new
end

10000000.times do
  test_meth
  foo = Foo.new
end
GC.collect

File.open "data.log", "w" do |file|
  analyzer = Trashman::Analyzer.new
  analyzer.print_stats(file)
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/gc/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Henrik Valter Vogelius Hansson - creator, maintainer
