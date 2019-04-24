import 'package:brainfuck/brainfuck.dart';
import 'package:test/test.dart';

void main() {
  var fuck = Brainfuck("++++++++++[>++++++++<-]>+++++++.---.--------------.");
  fuck.run();
}
