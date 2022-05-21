import 'package:brainfuck/brainfuck.dart';
import 'package:test/test.dart';

void main() {
  test('', () {
    var fuck = Brainfuck('++++++++++[>++++++++<-]>+++++++.---.--------------.');
    fuck.run();
  });

  test('', () {
    var fuck = Brainfuck(
        '+[>>>->-[>->----<<<]>>]>.---.>+..+++.>>.<.>>---.<<<.+++.------.<-.>>+.');
    fuck.run();
  });
}
