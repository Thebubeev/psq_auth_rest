import 'package:flutter/material.dart';
import 'package:psq/entities/user_entity.dart';

class InfoScreen extends StatelessWidget {
  final UserEntity userEntity;
  const InfoScreen({Key key, this.userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userEntity.data.name,
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
          Text(
            '+7${userEntity.data.phone}',
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
          Text(
            userEntity.data.code.toString(),
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
        ],
      )),
    );
  }
}
