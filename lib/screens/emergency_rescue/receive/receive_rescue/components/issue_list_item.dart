import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/enums.dart';
import 'package:flutter_application_1/helper/location_helper.dart';
import 'package:flutter_application_1/models/issue.dart';
import 'package:flutter_application_1/screens/emergency_rescue/issue_details/issue_details_screen.dart';

class IssueListItem extends StatelessWidget {
  final Issue issue;
  bool isPartnerReceiveNew;
  bool isPartnerHistoryReceived;

  IssueListItem({
    Key? key,
    required this.issue,
    this.isPartnerReceiveNew = false,
    this.isPartnerHistoryReceived = false,
  }) : super(key: key);

  Future<double> _getDistanceInKilometers() async {
    return LocationHelper.getDistanceInKilometers(
      issue.latitude!,
      issue.longitude!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        IssueDetailsScreen.routeName,
        arguments: IssueDetailsArguments(
          issue: issue,
          isPartnerReceiveNew: isPartnerReceiveNew,
          isPartnerHistoryReceived: isPartnerHistoryReceived,
        ),
      ),
      leading: Hero(
        tag: issue.id.toString(),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: issue.userMember?.imageUrl != null
              ? AspectRatio(
                  aspectRatio: 1 / 1,
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/placeholder_processing.gif",
                    image: issue.userMember!.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Text("No\nImage", textAlign: TextAlign.center),
        ),
      ),
      title: FutureBuilder<double>(
        future: _getDistanceInKilometers(),
        builder: (context, snapshot) => Text(
            (snapshot.hasData && isPartnerReceiveNew
                    ? '${snapshot.data!.toStringAsFixed(1)} Km | '
                    : '') +
                issue.category!.name),
      ),
      subtitle: Column(
        children: [
          if (issue.description != null && issue.description!.isNotEmpty)
            Text(
              issue.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                size: 16,
                color: Colors.black45,
              ),
              Expanded(
                child: Text(
                  issue.address!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
