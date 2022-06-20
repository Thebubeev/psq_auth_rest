import 'package:flutter/material.dart';

class ButtonInputWidget extends StatelessWidget {
  final Function function;
  final String text;
  const ButtonInputWidget({Key key, this.function, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          height: 60,
          width: 330,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Gilroy', fontSize: 17),
          )),
        ));
  }
}
