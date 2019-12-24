# Trashman

This is a simple memory profiler for Crystal applications. It works with any type that derives itself from Reference. It hooks itself into the allocation and finalizer methods of your classes so it is quite invasive. Thus it is an opt in feature and you have to mixin the Trashman module for it to record allocations on the type. You can also use this on standard library types such as Arrays and Strings to try and find poltergeist objects that might trigger the GC unnessecarily. It will however not be enabled unless you compile the application with -D ENABLE_TRASHMAN in order to make it as easy as possible to ignore it when running production code.

There is also the annotation `@[Trashman::Ignore]` which will have the system ignore the type including if it is used as a generic argument for another type.

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

  @test = 25
  @val = StaticArray(Int32, 128).new(0)
end

@[Trashman::Ignore]
class IgnoreMe
end

class Array(T)
  include Trashman
end

def test_meth
  foo = Foo.new
  arr = Array(Int32).new(100) { 1 }
  ignored = Array(IgnoreMe).new(100) { IgnoreMe.new }
end

1000.times do
  test_meth
  foo = Foo.new
end
GC.collect

File.open "data.log", "w" do |file|
  analyzer = Trashman::Analyzer.new
  analyzer.print_stats(file)
end
```

With the default formatter provided with this shard the data.log file will look something like this

```
===== Foo =====
Allocations: 1000 --- Deallocations: 1000
Alive memory: 0 --- Total memory: 520000
Avg Lifetime: 00:00:00.003664139
src/trashman.cr:10:3 in 'allocate'
/usr/share/crystal/src/primitives.cr:36:1 in 'new'
src/trashman.cr:21:3 in 'test_meth'
src/trashman.cr:26:3 in '__crystal_main'
/usr/share/crystal/src/crystal/main.cr:97:5 in 'main_user_code'
/usr/share/crystal/src/crystal/main.cr:86:7 in 'main'
/usr/share/crystal/src/crystal/main.cr:106:3 in 'main'
__libc_start_main
_start
???
===== Array(Int32) =====
Allocations: 1000 --- Deallocations: 999
Alive memory: 24 --- Total memory: 24000
Avg Lifetime: 00:00:00.003919594
src/trashman.cr:17:3 in 'allocate'
/usr/share/crystal/src/array.cr:81:3 in 'new'
src/trashman.cr:152:5 in 'test_meth'
src/trashman.cr:26:3 in '__crystal_main'
/usr/share/crystal/src/crystal/main.cr:97:5 in 'main_user_code'
/usr/share/crystal/src/crystal/main.cr:86:7 in 'main'
/usr/share/crystal/src/crystal/main.cr:106:3 in 'main'
__libc_start_main
_start
???
===== Foo =====
Allocations: 1000 --- Deallocations: 999
Alive memory: 520 --- Total memory: 520000
Avg Lifetime: 00:00:00.004000138
src/trashman.cr:10:3 in 'allocate'
/usr/share/crystal/src/primitives.cr:36:1 in 'new'
src/trashman.cr:27:3 in '__crystal_main'
/usr/share/crystal/src/crystal/main.cr:97:5 in 'main_user_code'
/usr/share/crystal/src/crystal/main.cr:86:7 in 'main'
/usr/share/crystal/src/crystal/main.cr:106:3 in 'main'
__libc_start_main
_start
???
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
