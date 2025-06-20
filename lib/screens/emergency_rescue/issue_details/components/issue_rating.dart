import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/issue.dart';
import 'package:flutter_application_1/models/rating_issue.dart';
import 'package:flutter_application_1/providers/issue_provider.dart';
import 'package:flutter_application_1/repositories/rating_issue_repository.dart';

import 'rating_form.dart';

class IssueRating extends StatelessWidget {
  IssueRating({
    Key? key,
    required this.issue,
    this.isPartnerReceiveNew = false,
    this.isPartnerHistoryReceived = false,
  }) : super(key: key);

  final Issue issue;
  bool isPartnerReceiveNew;
  bool isPartnerHistoryReceived;

  Future<RatingIssue?> _fetchData(BuildContext context) async {
    return await RatingIssueRepository.findByIssueId(issueId: issue.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RatingIssue?>(
        future: _fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Util.showWidgetNotification(
              content: snapshot.error.toString(),
              isError: true,
            );
          } else if (snapshot.connectionState != ConnectionState.waiting) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Text(
                    "Đánh giá",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                snapshot.data != null
                    ? ListTile(
                        leading:
                            Image.network(snapshot.data!.userMember!.imageUrl!),
                        title: Text(
                          snapshot.data!.userMember!.firstName! +
                              " " +
                              snapshot.data!.userMember!.lastName!,
                          maxLines: 1,
                        ),
                        subtitle: Text(getRate(snapshot.data!.ratePoint!) +
                            "\n" +
                            snapshot.data!.comment!),
                        trailing: RoundedIconBtn(
                          icon: Icons.thumb_up,
                          press: () {},
                        ),
                        isThreeLine: true,
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Text("Chưa có đánh giá về sự cố này."),
                            if(!isPartnerReceiveNew && !isPartnerHistoryReceived)
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: kPrimaryColor,
                              ),
                              icon: const Icon(
                                Icons.create,
                              ),
                              label: Text('Viết đánh giá'),
                              onPressed: () => _showMyDialog(context),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  String getRate(int rate) {
    String result = "";

    for (int i = 0; i < rate; i++) {
      result += "⭐";
    }

    result += " (" + rate.toString() + ")";

    return result;
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Viết đánh giá của bạn',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: RatingForm(
            onSubmit: (ratePoint, comment) async {
              RatingIssue ratingIssue = RatingIssue();
              ratingIssue.ratePoint = ratePoint.toInt();
              ratingIssue.comment = comment;
              ratingIssue.issue = issue;

              try {
                await Provider.of<IssueProvider>(context, listen: false)
                    .createRatingIssue(ratingIssue);
              } catch (error) {
                await Util.showDialogNotification(
                    context: context, content: error.toString());
              }
            },
          ),
        );
      },
    );
  }
}
