import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/screens/auth/reset_password/components/reset_password_form.dart';


class Body extends StatelessWidget {

  final String emailTo;

  Body({
    required this.emailTo,
    Key? key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text("Đổi Mật Khẩu", style: headingStyle),
                  Text(
                    "Vui lòng điền mật khẩu mới của bạn",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  ResetPasswordForm(emailTo: emailTo,),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),

                  SizedBox(height: getProportionateScreenHeight(0)),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
