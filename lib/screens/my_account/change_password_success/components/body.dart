import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/screens/my_account/my_account/my_account_screen.dart';
import '/components/default_button.dart';
import '/screens/home/home_screen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Đổi mật khẩu thành công",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(25),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Tài khoản của tôi",
            press: () {
              Navigator.pushNamed(context, MyAccountScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
