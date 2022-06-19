import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:psq/bloc/bloc/user_bloc.dart';
import 'package:psq/helpers/number_converter.dart';
import 'package:psq/screens/sms_screen.dart';
import 'package:psq/widgets/button_input_widget.dart';
import 'package:psq/widgets/loader_widget.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController numberController = TextEditingController();
  bool isLoading = false;
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
          if (state is UserLoginStateState) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ConfirmScreen(
                          phone: numberController.text,
                          smsEntity: state.smsEntity,
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
                            horizontal: 30, vertical: 20),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 36, color: Colors.black),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [PhoneInputFormatter()],
                          controller: numberController,
                          decoration: const InputDecoration(
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
                              return 'Номер телефона не может быть пустым';
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
                          setState(() {
                            isLoading = true;
                          });
                          context.read<UserBloc>().add(UserLoginEvent(
                              numberConverter(numberController.text)));
                        },
                      )
                    ]),
              ),
      ),
    );
  }
}
