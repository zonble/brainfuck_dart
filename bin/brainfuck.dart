import 'package:brainfuck/brainfuck.dart' as brainfuck;

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: brainfuck \"YOUR_CODE\"');
    return;
  }
  final code = arguments[0];
  final fuck = brainfuck.Brainfuck(code);
  fuck.run();
}
