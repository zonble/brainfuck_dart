import 'package:brainfuck/brainfuck.dart' as brainfuck;

main(List<String> arguments) {
  // print(arguments);
  if (arguments.isEmpty) {
    print("Usage: brainfuck \"YOUR_CODE\"");
    return;
  }
  final code = arguments[0];
  final fuck = brainfuck.Brainfuck(code);
  fuck.run();
}
