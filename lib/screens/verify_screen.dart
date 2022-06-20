import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/entities/sms_entity.dart';
import 'package:psq/helpers/number_converter.dart';
import 'package:psq/helpers/router.dart';
import 'package:psq/widgets/button_input_widget.dart';
import 'package:psq/widgets/loader_widget.dart';

import '../helpers/custom_input_formatter.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final SmsEntity smsEntity;
  const VerifyScreen(this.phone, this.smsEntity);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController codeController = TextEditingController();

  int secondsRemaining = 60;
  bool enableSwitchButton;
  Timer timer;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sendAgain();
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  sendAgain() {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserVerifyState) {
            setState(() {
              isLoading = false;
            });

            Navigator.pushNamed(context, RouteGenerator.REGISTER_SCREEN,
                arguments: {
                  'phone': widget.phone,
                  'code': int.parse(codeController.text.replaceAll(' ', ''))
                });
          }

          if (state is UserLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if (state is UserVerifyErrorState) {
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
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 30),
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
                              horizontal: 130, vertical: 10),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 36, color: Colors.black),
                            keyboardType: TextInputType.phone,
                            controller: codeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                              CustomInputFormatter()
                            ],
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(fontSize: 16),
                              hintText: '123 456',
                              border: InputBorder.none,
                            ),
                            onSaved: (val) {
                              setState(() {
                                codeController.text = val;
                              });
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Введите код';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
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
                              sendAgain();
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
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final code = int.parse(
                                  codeController.text.replaceAll(' ', ''));
                              final phone = numberConverter(widget.phone);
                              context
                                  .read<UserBloc>()
                                  .add(UserVerifyEvent(code, phone));
                            }
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
