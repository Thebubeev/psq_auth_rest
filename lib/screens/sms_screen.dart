import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/entities/sms_entity.dart';
import 'package:psq/screens/name_screen.dart';
import 'package:psq/widgets/button_input_widget.dart';
import 'package:psq/widgets/loader_widget.dart';

import '../helpers/custom_input_formatter.dart';

class ConfirmScreen extends StatefulWidget {
  final String phone;
  final SmsEntity smsEntity;
  const ConfirmScreen({Key key, this.phone, this.smsEntity}) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  TextEditingController smsController = TextEditingController();
  int secondsRemaining = 60;
  bool enableSwitchButton;
  Timer timer;
  bool isLoading = false;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      enableSwitchButton = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        if (mounted) {
          setState(() {
            secondsRemaining--;
          });
        }
      } else {
        setState(() {
          secondsRemaining = 60;
          enableSwitchButton = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserConfirmStateState) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AuthScreen(
                          phone: widget.phone,
                          smsEntity: widget.smsEntity,
                        )));
          }
          if (state is UserErrorState) {
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
                child: Form(
                  key: key,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            'Код из СМС',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 110, vertical: 20),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 36, color: Colors.black),
                            keyboardType: TextInputType.phone,
                            controller: smsController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                              CustomInputFormatter()
                            ],
                            decoration: const InputDecoration(
                              prefixStyle:
                                  TextStyle(color: Colors.black, fontSize: 36),
                              hintText: '000 000',
                              border: InputBorder.none,
                            ),
                            onSaved: (val) {
                              if (key.currentState.validate()) {
                                key.currentState.save();
                                setState(() {
                                  smsController.text = val;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const AuthScreen()));
                              }
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Номер телефона не может быть пустым';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            'Отправили на ${widget.phone}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                enableSwitchButton = true;
                              });
                              timer = Timer.periodic(const Duration(seconds: 1),
                                  (_) {
                                if (secondsRemaining != 0) {
                                  if (mounted) {
                                    setState(() {
                                      secondsRemaining--;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    secondsRemaining = 60;
                                    enableSwitchButton = false;
                                  });
                                  timer.cancel();
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: enableSwitchButton
                                    ? Colors.white
                                    : Colors.blue,
                              ),
                              height: 60,
                              width: 330,
                              child: Center(
                                child: enableSwitchButton
                                    ? Text(
                                        'Отправить еще раз ${secondsRemaining.toString()}с',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 17),
                                      )
                                    : const Text(
                                        'Отправить еще раз',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ButtonInputWidget(
                          function: () {
                            setState(() {
                              isLoading = true;
                            });
                            final sms = int.parse(
                                smsController.text.replaceAll(' ', ''));
                            context
                                .read<UserBloc>()
                                .add(UserConfirmEvent(123456, '9991234567'));
                          },
                          text: 'Выполнить',
                        )
                      ]),
                ),
              ),
      ),
    );
  }
}
