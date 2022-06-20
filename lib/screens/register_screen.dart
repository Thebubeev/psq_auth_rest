import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/helpers/number_converter.dart';
import 'package:psq/helpers/router.dart';
import 'package:psq/widgets/button_input_widget.dart';
import 'package:psq/widgets/loader_widget.dart';

class RegisterScreen extends StatefulWidget {
  final String phone;
  final int code;
  const RegisterScreen(this.phone, this.code);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  final _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserRegisterState) {
            setState(() {
              isLoading = false;
            });

            Navigator.pushNamed(context, RouteGenerator.INFO_SCREEN,
                arguments: state.userEntity);
          }

          if (state is UserLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if (state is UserRegisterErrorState) {
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
            : Form(
                key: _globalKey,
                child: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            'Ваше имя',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 36),
                            textCapitalization: TextCapitalization.sentences,
                            controller: nameController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                errorStyle: TextStyle(fontSize: 16)),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Введите имя';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) {
                              setState(() {
                                nameController.text = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            'Ваше имя будут видеть водители',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ButtonInputWidget(
                          function: () {
                            if (_globalKey.currentState.validate()) {
                              _globalKey.currentState.save();
                              final code = widget.code;
                              final phone = numberConverter(widget.phone);
                              final name = nameController.text.trim();
                              context.read<UserBloc>().add(UserRegisterEvent(
                                    code: code,
                                    phone: phone,
                                    name: name,
                                  ));
                            }
                          },
                          text: 'Дальше',
                        )
                      ]),
                ),
              ),
      ),
    );
  }
}
