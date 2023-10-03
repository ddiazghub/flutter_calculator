// ignore_for_file: constant_identifier_names
enum Operator {
  Add("+"),
  Sub("-"),
  Mul("*");

  final String str;

  const Operator(this.str);

  @override
  String toString() => str;
}
