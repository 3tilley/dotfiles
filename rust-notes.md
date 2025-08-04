# Generic Parameters

## By trait (static compilation)
* Faster
* Information must be available at compile time
* Can only be used for homogeneous structures
```
fn foo<T>(x: T) {
    ...
}
```

## By trait object (dynamic dispatch)
* Requires a vtable lookup
* Can't subsequently downcast (without crates like `Any`)
```
fn foo(x: Box<dyn impl BarTrait>) {
    ...
}
```

# Unusual Type Signatures
Type signatures for callables are really unintuitive. There is also an older deprecated form out in the wild

* A unit func with no args: `Fn()`
* A unit func with one arg: `Fn(u8)`
* A func that takes an arg and returns bool: `Fn(u8) -> bool`
* A func that takes args and returns bool: `Fn(u8, String) -> bool`

The compiler will help, but there is trick to invoking them as well
```
struct Foo {
    callable: Fn(u8) -> bool
...

let foo = Foo::new();

(foo.callable)(255)
```

<<<<<<< Updated upstream
# Using clap

The following will create a CLI with subcommands. Requires verbosity crate

```
#[derive(Parser)]
#[command(arg_required_else_help = true)]
struct Cli {
    #[command(subcommand)]
    command: Command,
    #[command(flatten)]
    verbose: clap_verbosity_flag::Verbosity,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// List audio devices
    Foo {
        #[clap(long, short, action)]
        input: bool,
        #[clap(long, short, action)]
        output: bool,
        #[clap(long, short, action)]
        json: bool,
    },
    /// Switch default audio device
    Switch {
    },
}

pub fn main() {
    let args = Cli::parse();
    match &args.command {
        Command::Foo {
            ....
        }
    }
}
```


# Older syntax for importing macros
```
#[macro_use]
extern crate log
```

# Enums
// Default syntax for enums
//

# Borrowing
The `&` symbol borrows a reference `T -> &T`: i.e. you don't take ownership of it. `*` deferences this into a value `&T -> T`, 
but there is still no ownership. `*` cannot transfer ownership since it was originally a reference. When this works automatically
it's because the type implemented `Copy`, and therefore a copy of the reference can be taken.

Additionally calling methods will automatically add the required `&`, `&mut`, or `*`. `p1.distance()` is equivalent to `(&p1).distance()`

In general `&*` shouldn't do anything, however some types like `String` overload Deref to make it do other things.

# Copy vs Clone
`Copy` says that a type can be duplicated purely with memcpy. `Clone` offers an interface to perform a potentially expensive cloning
operation. Anything copyable can be cloneable, but the reverse isn't true. Both methods need to be implemented or derived though.

# Iterators

Like Python, `Iterator` is just a trait with a single method: `next(&mut self) -> Option<Self::Item>`. This is rarely used directly
though.

On `Vec<T>`:
* `iter()` iterates over the items by reference
* `iter_mut()` iterates over the items giving a mutable reference
* `into_iter()` iterates over the items by value, i.e. with a move

How iterators are implemented for other types are by convention:
* `into_iter()` is largely to enable for loops (through `IntoIterator` trait), author's choice. `T`, `&T`, or `&mut T`
* `iter()` has no trait, but by convention it returns `&T` 
* `iter_mut()` has no trait, but by convention it returns `mut &T`

Given that the method names are arbitrary, `String` for example has `chars` and `bytes`, returning iterators over the string's
characters and bytes respectively.

# Functions that take iterators as arguments

## New style using `impl Trait`
*Todo: are there downsides to this?*
```
use std::collections::HashMap;

fn find_min<'a>(vals: impl Iterator<Item = &'a u32>) -> Option<&'a u32> {
    vals.min()
}

fn main() {
    let mut map = HashMap::new();
    map.insert("zero", 0u32);
    map.insert("one", 1u32);
    println!("Min value {:?}", find_min(map.values()));
}
```

## Old style using generics
```
fn find_min<'a, I>(vals: I) -> Option<&'a u32>
where
    I: IntoIterator<Item = &'a u32>,
{
    vals.into_iter().min()
}
```

## Tracing


