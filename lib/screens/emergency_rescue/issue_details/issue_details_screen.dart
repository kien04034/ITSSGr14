import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/models/issue.dart';

import 'components/body.dart';

class IssueDetailsScreen extends StatelessWidget {
  static String routeName = "/issue_details";


  final IssueDetailsArguments arguments;
  const IssueDetailsScreen({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen:
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      body: Body(
        issue: arguments.issue,
        isPartnerReceiveNew: arguments.isPartnerReceiveNew,
        isPartnerHistoryReceived: arguments.isPartnerHistoryReceived,
      ),
    );
  }
}

class IssueDetailsArguments {
  final Issue issue;
  final bool isPartnerReceiveNew;
  final bool isPartnerHistoryReceived;

  IssueDetailsArguments({
    required this.issue,
    this.isPartnerReceiveNew = false,
    this.isPartnerHistoryReceived = false,
  });
}
