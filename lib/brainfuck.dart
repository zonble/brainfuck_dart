import 'dart:io';

/// The status of calling [Brainfuck.run].
enum Status {
  success,
  failed,
}

/// The Brainfuck operators.
enum Operator {
  end,
  increasePointer,
  decreasePointer,
  increaseValue,
  decreaseValue,
  output,
  input,
  jumpForward,
  jumpBack,
}

/// The Instructions of a Brainfuck program.
class Instruction {
  /// The operator.
  final Operator op;

  /// The operand.
  int? operand;

  /// Cretaes a new instance.
  Instruction(this.op, {this.operand});
}

const _kDataSize = 65535;

/// The Brainfuck interpreter.
class Brainfuck {
  /// The source code.
  final String source;

  /// The compiled instructions.
  List<Instruction>? _program;

  /// Creates a new instance.
  Brainfuck(this.source);

  /// Compiles the source code into instructions.
  Status compile() {
    var program = <Instruction>[];
    var stack = <int>[];
    for (var i = 0; i < source.length; i++) {
      final c = source[i];

      switch (c) {
        case '>':
          program.add(Instruction(Operator.increasePointer));
          break;
        case '<':
          program.add(Instruction(Operator.decreasePointer));
          break;
        case '+':
          program.add(Instruction(Operator.increaseValue));
          break;
        case '-':
          program.add(Instruction(Operator.decreaseValue));
          break;
        case '.':
          program.add(Instruction(Operator.output));
          break;
        case ',':
          program.add(Instruction(Operator.input));
          break;
        case '[':
          stack.add(program.length);
          program.add(Instruction(Operator.jumpForward));
          break;
        case ']':
          if (stack.isEmpty) {
            return Status.failed;
          }
          final jumpIndex = stack.removeLast();
          program[jumpIndex].operand = program.length;
          program.add(Instruction(Operator.jumpBack, operand: jumpIndex));
          break;
        default:
          break;
      }
    }

    program.add(Instruction(Operator.end));
    _program = program;
    return Status.success;
  }

  /// Run the program.
  Status run() {
    if (_program == null) {
      final result = compile();
      if (result == Status.failed) {
        return Status.failed;
      }
    }
    var data = List<int>.generate(_kDataSize, (i) => 0);
    var ptr = 0;
    var index = 0;
    while (_program![index].op != Operator.end && ptr < _kDataSize) {
      final instruction = _program![index];
      switch (instruction.op) {
        case Operator.increasePointer:
          ptr++;
          break;
        case Operator.decreasePointer:
          ptr--;
          break;
        case Operator.increaseValue:
          data[ptr]++;
          break;
        case Operator.decreaseValue:
          data[ptr]--;
          break;
        case Operator.output:
          stdout.writeCharCode(data[ptr]);
          break;
        case Operator.input:
          data[ptr] = stdin.readByteSync();
          break;
        case Operator.jumpForward:
          if (data[ptr] == 0) {
            index = _program![index].operand!;
          }
          break;
        case Operator.jumpBack:
          if (data[ptr] != 0) {
            index = _program![index].operand!;
          }
          break;
        default:
          return Status.failed;
      }
      index++;
    }

    return Status.success;
  }
}
