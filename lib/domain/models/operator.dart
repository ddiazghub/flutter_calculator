// ignore_for_file: constant_identifier_names
enum Operator {
  Add("+"),
  Sub("-"),
  Mul("*");

  final String str;

  const Operator(this.str);

  factory Operator.from(String str) {
    switch (str) {
      case "+":
        return Operator.Add;
      case "-":
        return Operator.Sub;
      case "*":
        return Operator.Mul;
      default:
        throw Exception("Invalid operator");
    }
  }

  int apply(int first, int second) {
    switch (this) {
      case Add:
        return first + second;
      case Sub:
        return first - second;
      case Mul:
        return first * second;
    }
  }

  @override
  String toString() => str;
}
