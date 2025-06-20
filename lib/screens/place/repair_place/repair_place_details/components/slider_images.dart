import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/models/garage.dart';

class SliderImages extends StatefulWidget {
  const SliderImages({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;

  @override
  _SliderImagesState createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.garage.id.toString(),
              child: widget.garage.garageImages.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder_processing.gif",
                      image:
                          widget.garage.garageImages[selectedImage].imageUrl!,
                    )
                  : const Center(child: Text("No Image")),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          width: SizeConfig.screenWidth * 0.9,
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(widget.garage.garageImages.length,
                (index) => buildSmallProductPreview(index)),
          ),
        ),
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Hero(
          tag: widget.garage.garageImages[index].imageUrl! +
              "RepairPlaceDetails_RepairPlaceManageImage",
          child: FadeInImage.assetNetwork(
              placeholder: "assets/images/placeholder_processing.gif",
              image: widget.garage.garageImages[index].imageUrl!),
        ),
      ),
    );
  }
}
