# Trashman

This is a simple memory profiler for Crystal applications. It works with any type that derives itself from Reference. It hooks itself into the allocation and finalizer methods of your classes so it is quite invasive. Thus it is an opt in feature and you have to mixin the Trashman module for it to record allocations on the type. You can also use this on standard library types such as Arrays and Strings to try and find poltergeist objects that might trigger the GC unnessecarily. It will however not be enabled unless you compile the application with -D ENABLE_TRASHMAN in order to make it as easy as possible to ignore it when running production code.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  trashman:
    github: Groogy/trashman
```

## Usage

```crystal
require "trashman"

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

1. Fork it ( https://github.com/Groogy/trashman/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Groogy](https://github.com/Groogy) Henrik Valter Vogelius Hansson - creator, maintainer
