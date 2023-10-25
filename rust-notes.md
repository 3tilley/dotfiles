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

