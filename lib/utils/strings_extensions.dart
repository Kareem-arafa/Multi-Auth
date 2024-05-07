extension StringExtention on String {
  bool get isPhone => RegExp(r'^01(0|1|2|5){1}[0-9]{8}$').hasMatch(this);
}
