import 'package:flutter/material.dart';

import 'components/body.dart';

class BecomeToPartnerScreen extends StatelessWidget {
  static String routeName = "/become_to_partner";

  const BecomeToPartnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title - Change me now"),
      ),
      body: Body(),
    );
  }
}
