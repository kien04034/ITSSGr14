import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/url_launcher_helper.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/garage.dart';
import 'package:flutter_application_1/providers/garage_provider.dart';
import 'package:flutter_application_1/screens/place/repair_place/repair_place_details/components/garage_rating.dart';

import '/components/default_button.dart';
import 'garage_description.dart';
import 'slider_images.dart';
import 'top_rounded_container.dart';

class Body extends StatelessWidget {
  final Garage garage;

  const Body({Key? key, required this.garage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GarageProvider>(
      builder: (context, value, child) => ListView(
        children: [
          SliderImages(garage: garage),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                GarageDescription(
                  garage: garage,
                  pressOnSeeMore: () {},
                ),
                TopRoundedContainer(
                  color: Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      GarageRating(garage: garage),
                      TopRoundedContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 0.15,
                            right: SizeConfig.screenWidth * 0.15,
                            bottom: getProportionateScreenWidth(40),
                            top: getProportionateScreenWidth(15),
                          ),
                          child: DefaultButton(
                            text: "Xem trên bản đồ",
                            press: () {
                              try {
                                UrlLauncherHelper.launchURL(
                                    "https://www.google.com/maps/search/?api=1&query=${garage.latitude},${garage.longitude}");
                              } catch (e) {
                                Util.showDialogNotification(
                                    context: context, content: e.toString());
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
