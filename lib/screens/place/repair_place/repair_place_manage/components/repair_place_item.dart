import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/garage.dart';
import 'package:flutter_application_1/screens/place/repair_place/repair_place_details/repair_place_details_screen.dart';

class RepairPlaceItem extends StatelessWidget {
  const RepairPlaceItem({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(
        context,
        RepairPlaceDetailsScreen.routeName,
        arguments: RepairPlaceDetailsArguments(garage: garage, isManage: true),
      ),
      leading: Hero(
        tag: garage.id.toString(),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: garage.garageImages.isNotEmpty
              ? AspectRatio(
                  aspectRatio: 3 / 2,
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/placeholder_processing.gif",
                    image: garage.garageImages[0].imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Text("No\nImage", textAlign: TextAlign.center),
        ),
      ),
      title: Text(garage.name!),
      subtitle: Text(garage.address!),
    );
  }
}
