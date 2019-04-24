import 'dart:io';

enum Status {
  success,
  failed,
}

enum Operator {
  end,
  increasePointer,
  decreatePointer,
  increaseValue,
  decreaseValue,
  output,
  input,
  jumpForward,
  jumpBack,
}

class Instruction {
  final Operator op;
  int operand;

  Instruction(this.op, {this.operand});
}

const dataSize = 65535;

class Brainfuck {
  final String source;
  List<Instruction> program;

  Brainfuck(this.source);

  Status compile() {
    List<Instruction> program = [];
    List<int> stack = [];
    for (int i = 0; i < source.length; i++) {
      final c = source[i];

      switch (c) {
        case ">":
          program.add(Instruction(Operator.increasePointer));
          break;
        case "<":
          program.add(Instruction(Operator.decreatePointer));
          break;
        case "+":
          program.add(Instruction(Operator.increaseValue));
          break;
        case "-":
          program.add(Instruction(Operator.decreaseValue));
          break;
        case ".":
          program.add(Instruction(Operator.output));
          break;
        case ",":
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
    this.program = program;
    return Status.success;
  }

  Status run() {
    if (this.program == null) {
      final result = compile();
      if (result == Status.failed) {
        return Status.failed;
      }
    }
    List<int> data = List.generate(dataSize, (i) => 0);
    int ptr = 0;
    int index = 0;
    while (program[index].op != Operator.end && ptr < dataSize) {
      final instruction = program[index];
      switch (instruction.op) {
        case Operator.increasePointer:
          ptr++;
          break;
        case Operator.decreatePointer:
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
            index = program[index].operand;
          }
          break;
        case Operator.jumpBack:
          if (data[ptr] != 0) {
            index = program[index].operand;
          }
          break;
        default:
          return Status.failed;
          break;
      }
      index++;
    }

    return Status.success;
  }
}
