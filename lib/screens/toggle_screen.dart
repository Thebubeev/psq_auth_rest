import 'package:flutter/material.dart';
import 'package:psq/helpers/router.dart';
import 'package:psq/preference_storage/preference_storage_impl.dart';

import '../preference_storage/preference_storage.dart';

class ToggleWidget extends StatefulWidget {
  const ToggleWidget({Key key}) : super(key: key);

  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  final PreferenceStorage prefs = PreferenceStorageImpl();
  @override
  void initState() {
    prefs.getUser().then((user) {
      if (user != null) {
        Navigator.of(context)
            .pushNamed(RouteGenerator.INFO_SCREEN, arguments: user);
      } else {
        Navigator.of(context).pushNamed(RouteGenerator.VALIDATE_PHONE_SCREEN);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
