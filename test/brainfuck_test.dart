import 'package:brainfuck/brainfuck.dart';
import 'package:test/test.dart';

void main() {
  test('prints characters from simple arithmetic loop', () {
    var fuck = Brainfuck('++++++++++[>++++++++<-]>+++++++.---.--------------.');
    fuck.run();
  });

  test('prints Hello World', () {
    var fuck = Brainfuck(
        '+[>>>->-[>->----<<<]>>]>.---.>+..+++.>>.<.>>---.<<<.+++.------.<-.>>+.');
    fuck.run();
  });
}
