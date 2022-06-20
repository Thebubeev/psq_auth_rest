import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/entities/user_entity.dart';
import 'package:psq/helpers/router.dart';
import 'package:psq/widgets/loader_widget.dart';

class UserInfoScreen extends StatefulWidget {
  final UserInfoDataEntity userEntity;
  const UserInfoScreen(this.userEntity);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLogoutState) {
            setState(() {
              isLoading = false;
            });
          }

          if (state is UserLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if (state is UserLogoutErrorState) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: isLoading
            ? const LoaderWidget()
            : SafeArea(
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Имя: ${widget.userEntity.name}',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Номер телефона:\n+7${widget.userEntity.phone}',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Смс-код: ${widget.userEntity.code}',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.VALIDATE_PHONE_SCREEN);
                        context.read<UserBloc>().add(UserLogoutEvent());
                      },
                      icon: const Icon(
                        Icons.exit_to_app_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: const Text(
                        'Выйти из приложения',
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    )
                  ],
                ),
              )),
      ),
    );
  }
}
