import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';

class SendRescueReview extends StatelessWidget {
  const SendRescueReview({Key? key, required this.content, required this.title}) : super(key: key);

  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title: ",
                  style: TextStyle(
                    fontSize: 25,
                    color: kTextColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: "$content",
                  style: TextStyle(
                    fontSize: 25,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

