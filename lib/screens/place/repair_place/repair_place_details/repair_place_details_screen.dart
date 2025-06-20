import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/models/garage.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class RepairPlaceDetailsScreen extends StatelessWidget {
  static String routeName = "/repair_place_details";

  const RepairPlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen:
    SizeConfig().init(context);

    final RepairPlaceDetailsArguments agrs = ModalRoute.of(context)!
        .settings
        .arguments as RepairPlaceDetailsArguments;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          rating: agrs.garage.rateAvg,
          isManage: agrs.isManage,
          garage: agrs.garage,
        ),
      ),
      body: Body(garage: agrs.garage),
    );
  }
}

class RepairPlaceDetailsArguments {
  final Garage garage;
  final bool isManage;

  RepairPlaceDetailsArguments({required this.garage, this.isManage = false});
}
