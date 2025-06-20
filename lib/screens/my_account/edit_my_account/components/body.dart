import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/my_account/edit_my_account/components/form_edit_my_account.dart';
import 'package:flutter_application_1/screens/my_account/edit_my_account/components/my_account_pic.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    "Sửa thông tin tài khoản",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  MyAccountPic(
                      imageUrl: authProvider.authData.currentUser?.imageUrl,
                      onSelectImage: (imageFileSelected) =>
                          onSelectImage(context, imageFileSelected)),
                  // Text(
                  //   "Sign in with your email and password  \nor continue with social media",
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  FormEditMyAccount(
                    user: authProvider.authData.currentUser!,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSelectImage(context, imageFileSelected) async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .updateAvatarUser(imageFile: imageFileSelected,);

    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }
}
