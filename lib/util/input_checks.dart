class InputCheck {

  bool isNumeric (String input) {
    RegExp numeric = RegExp(r'^-?(0|[1-9][0-9]*)$');
    return numeric.hasMatch(input);
  }

  bool isQty (String input) {
    RegExp qty = RegExp(r'^(\d+(\.\d+)?|\d+/\d+)$');
    return qty.hasMatch(input);
  }

  bool isNumeric0 (String input) {
    RegExp numeric = RegExp(r'^[0-9]+$');
    return numeric.hasMatch(input);
  }

  bool isZero (String input) {
    return double.parse(input)==0;
  }

  bool isText (String input) {
    RegExp text = RegExp(r'[^0-9]+$');
    return text.hasMatch(input);
  }

  bool hasNoSpecialChar () {
    return true;
  }
}