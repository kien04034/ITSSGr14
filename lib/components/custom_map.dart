import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/location_helper.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class CustomMap extends StatefulWidget {
  LatLng? initialCameraPosition;
  ArgumentCallback<LatLng>? onTap;
  Set<Marker> markers;

   CustomMap({
    this.initialCameraPosition,
    this.onTap,
    this.markers = const {},
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  LatLng? _pickedLocation;
  late Set<Marker> _markers;
  bool isMapCreated = false;

  @override
  void initState() {
    //_markers = widget.markers;
    _markers = {};

    super.initState();
  }

  Future<LatLng> _getInitialCameraPosition() async {
    if (widget.initialCameraPosition != null) {
      return widget.initialCameraPosition!;
    }

    try {
      var currentLocation = await LocationHelper.getCurrentLocation();
      /*if (currentLocation == null) {
        return const LatLng(21.0291518, 105.8523056); //Hồ Gươm, Hà Nội
      }*/
      return LatLng(currentLocation.latitude, currentLocation.longitude);
    } catch (error) {
      Util.showDialogNotification(
          context: context, title: "Đã xảy ra lỗi!", content: error.toString());
    }

    //Mặc định nếu null: Hồ Gươm, Hà Nội
    return const LatLng(21.0291518, 105.8523056);
  }

  ArgumentCallback<LatLng>? _onTap(LatLng position) {
    if (widget.onTap == null) {
      return null;
    }

    setState(() {
      _pickedLocation = position;
    });

    _markers = {
      ...widget.markers,
      Marker(
          markerId: const MarkerId('marker_picked_1'),
          position: _pickedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange)),
    };

    widget.onTap!(position);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _getInitialCameraPosition(),
      builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: snapshot.data!,
              zoom: 16,
            ),
            onTap: _onTap,
            markers: _markers.isNotEmpty ? _markers : widget.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 100,
            ),
            onMapCreated: (GoogleMapController controller) {
              //required to apply padding correctly on Android
              setState(() {});
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
