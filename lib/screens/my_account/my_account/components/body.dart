import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/screens/my_account/my_account/components/my_account_detail.dart';
import 'package:flutter_application_1/screens/my_account/my_account/components/my_account_pic.dart';

class Body extends StatelessWidget {

  const Body({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Container(
        constraints: BoxConstraints(
          minWidth: double.maxFinite,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              MyAccountPic(imageUrl: authProvider.authData.currentUser?.imageUrl),
              SizedBox(height: 40),
              MyAccountDetail(
                user: authProvider.authData.currentUser!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
