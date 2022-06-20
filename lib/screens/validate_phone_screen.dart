import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/helpers/number_converter.dart';
import 'package:psq/helpers/router.dart';
import 'package:psq/widgets/button_input_widget.dart';
import 'package:psq/widgets/loader_widget.dart';

class ValidatePhoneScreen extends StatefulWidget {
  const ValidatePhoneScreen({Key key}) : super(key: key);

  @override
  State<ValidatePhoneScreen> createState() => _ValidatePhoneScreenState();
}

class _ValidatePhoneScreenState extends State<ValidatePhoneScreen> {
  TextEditingController numberController = TextEditingController();
  bool isLoading = false;

  final _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    PhoneInputFormatter.replacePhoneMask(
      countryCode: 'RU',
      newMask: '+0 000 000-00-00',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserValidatePhoneState) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushNamed(context, RouteGenerator.VERIFY_SCREEN,
                arguments: {
                  'phone': numberController.text,
                  'smsEntity': state.smsEntity
                });
          }

          if (state is UserLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if (state is UserValidateErrorState) {
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
                  key: _globalKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            'Номер телефона',
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
                            style: const TextStyle(
                                fontSize: 36, color: Colors.black),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [PhoneInputFormatter()],
                            controller: numberController,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 16.0,
                              ),
                              hintText: '+7 000 000-00-00',
                              border: InputBorder.none,
                            ),
                            onSaved: (val) {
                              setState(() {
                                numberController.text = val;
                              });
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Введите номер телефона';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            'На него мы отправим СМС с кодом',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ButtonInputWidget(
                          text: 'Отправить код',
                          function: () {
                            if (_globalKey.currentState.validate()) {
                              _globalKey.currentState.save();
                              final phone =
                                  numberConverter(numberController.text);
                              context
                                  .read<UserBloc>()
                                  .add(UserValidatePhoneEvent(phone));
                            }
                          },
                        )
                      ]),
                ),
              ),
      ),
    );
  }
}
