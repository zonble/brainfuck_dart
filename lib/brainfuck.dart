import 'dart:io';
import 'dart:typed_data';

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

  /// Creates a new instance.
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
        case '<':
          program.add(Instruction(Operator.decreasePointer));
        case '+':
          program.add(Instruction(Operator.increaseValue));
        case '-':
          program.add(Instruction(Operator.decreaseValue));
        case '.':
          program.add(Instruction(Operator.output));
        case ',':
          program.add(Instruction(Operator.input));
        case '[':
          stack.add(program.length);
          program.add(Instruction(Operator.jumpForward));
        case ']':
          if (stack.isEmpty) {
            return Status.failed;
          }
          final jumpIndex = stack.removeLast();
          program[jumpIndex].operand = program.length;
          program.add(Instruction(Operator.jumpBack, operand: jumpIndex));
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
    var data = Uint8List(_kDataSize);
    var ptr = 0;
    var index = 0;
    while (_program![index].op != Operator.end && ptr < _kDataSize) {
      final instruction = _program![index];
      switch (instruction.op) {
        case Operator.increasePointer:
          ptr++;
        case Operator.decreasePointer:
          ptr--;
        case Operator.increaseValue:
          data[ptr]++;
        case Operator.decreaseValue:
          data[ptr]--;
        case Operator.output:
          stdout.writeCharCode(data[ptr]);
        case Operator.input:
          data[ptr] = stdin.readByteSync();
        case Operator.jumpForward:
          if (data[ptr] == 0) {
            index = _program![index].operand!;
          }
        case Operator.jumpBack:
          if (data[ptr] != 0) {
            index = _program![index].operand!;
          }
        case Operator.end:
          // Unreachable: while loop guards against Operator.end
      }
      index++;
    }

    return Status.success;
  }
}
