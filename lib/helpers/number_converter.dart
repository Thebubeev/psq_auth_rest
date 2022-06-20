String numberConverter(String phone) {
  String formatted_phone =
      phone.substring(3).replaceAll(' ', '').replaceAll('-', '');
  return formatted_phone;
}

