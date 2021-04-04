class Regex {
  static final username = RegExp(r'^[a-zA-Z0-9_.]{1,16}$');

  // https://stackoverflow.com/a/32686261/9449426
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}
