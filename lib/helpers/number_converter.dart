String numberConverter(String phone) {
  String formatted_phone = phone.replaceAll('+', '')
      .replaceAll('7', '')
      .replaceAll(' ', '')
      .replaceAll('-', '');
  return formatted_phone;
}
