A command-line [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) interpreter implemented with Dart language.

## Installation

You can install the command-line tool via [dart pub](https://pub.dev/). Just run the command below.

```sh
dart pub global activate brainfuck
```

## Usage

```sh
brainfuck "YOUR_BRAINFUCK_CODE"
```

For example, to print "Hi":

```sh
brainfuck "++++++++++[>++++++++<-]>+++++++.---.--------------."
```

## Technical Details

### The Brainfuck Language

Brainfuck operates on an array of memory cells (this interpreter uses 65,535 cells, each initialized to zero) and a data pointer that starts at the first cell. The language has eight commands:

| Command | Description |
|---------|-------------|
| `>`     | Move the data pointer to the next cell. |
| `<`     | Move the data pointer to the previous cell. |
| `+`     | Increment the value at the current cell by 1. |
| `-`     | Decrement the value at the current cell by 1. |
| `.`     | Output the byte at the current cell as an ASCII character. |
| `,`     | Read one byte of input and store it in the current cell. |
| `[`     | If the value at the current cell is zero, jump forward to the matching `]`. |
| `]`     | If the value at the current cell is non-zero, jump back to the matching `[`. |

Any other characters in the source string are treated as comments and ignored.

### Interpreter Architecture

The interpreter works in two phases:

1. **Compile** – The `compile()` method parses the source string and converts it into an internal list of `Instruction` objects. During this phase the matching jump targets for `[` and `]` are pre-computed so that branching at runtime is an O(1) operation.
2. **Run** – The `run()` method executes the compiled instruction list. If `compile()` has not been called beforehand, `run()` calls it automatically.

Both methods return a `Status` value (`Status.success` or `Status.failed`). Compilation fails when a `]` is encountered without a matching `[`.

### Using the Library

The interpreter can be used as a Dart library:

```dart
import 'package:brainfuck/brainfuck.dart';

void main() {
  final interpreter = Brainfuck('++++++++++[>++++++++<-]>+++++++.---.--------------.');
  final status = interpreter.run();
  if (status == Status.failed) {
    print('Program failed to run.');
  }
}
```
