import 'package:flutter/material.dart';
import 'package:psq/screens/register_screen.dart';
import 'package:psq/screens/user_info_screen.dart';
import 'package:psq/screens/validate_phone_screen.dart';
import 'package:psq/screens/verify_screen.dart';

class RouteGenerator {
  static const VALIDATE_PHONE_SCREEN = 'validate_phone_screen';
  static const VERIFY_SCREEN = 'verify_screen';
  static const REGISTER_SCREEN = 'register_screen';
  static const INFO_SCREEN = 'info_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arg = settings.arguments;
    switch (settings.name) {
      case VALIDATE_PHONE_SCREEN:
        return MaterialPageRoute(builder: (_) => const ValidatePhoneScreen());

      case VERIFY_SCREEN:
        Map<String, Object> args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => VerifyScreen(args['phone'], args['smsEntity']));

      case REGISTER_SCREEN:
        Map<String, Object> args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => RegisterScreen(args['phone'], args['code']));

      case INFO_SCREEN:
        return MaterialPageRoute(builder: (_) => UserInfoScreen(arg));

      default:
        return MaterialPageRoute(builder: (_) => const ValidatePhoneScreen());
    }
  }
}
