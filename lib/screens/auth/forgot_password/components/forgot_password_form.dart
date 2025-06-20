import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/custom_surfix_icon.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/components/form_error.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/keyboard.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/auth/components/no_account_text.dart';
import 'package:flutter_application_1/screens/auth/otp/otp_screen.dart';
import 'package:flutter_application_1/screens/auth/reset_password/reset_password_screen.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  List<String?> errors = [];
  String? email;
  bool isLoadingSubmit = false;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }

              email = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Vui lòng nhập Email...",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/email.svg"),
            ),
          ),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          // DefaultButton(
          //   text: "Gửi OTP",
          //   press: () {
          //     if (_formKey.currentState!.validate()) {
          //       _submitForm();
          //     }
          //   },
          // ),
          !isLoadingSubmit
              ? DefaultButton(
                  text: "Gửi OTP",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                )
              : Container(
                  width: double.infinity,
                  height: getProportionateScreenHeight(56),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: kPrimaryColor,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);

    try {
      setState(() {
        isLoadingSubmit = true;
      });

      await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(email: email);

      setState(() {
        isLoadingSubmit = false;
      });

      Navigator.pushNamed(
        context,
        OtpScreen.routeName,
        arguments: OtpArguments(
          to: email!,
          onSubmit: _submitVerificationResetPasswordCode,
          onResend: () {},
        ),
      );
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }

  Future<void> _submitVerificationResetPasswordCode(
      String resetPasswordCode) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPasswordVerification(email!, resetPasswordCode);

      Navigator.pushNamed(context, ResetPasswordScreen.routeName,
          arguments: ResetPasswordArgument(emailTo: email!));
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }
}
