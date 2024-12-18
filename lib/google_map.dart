import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapComponent extends StatelessWidget {
  final LatLng? currentPosition;
  final ValueSetter<GoogleMapController> onMapCreated;

  const GoogleMapComponent({
    super.key,
    required this.currentPosition,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentPosition ?? const LatLng(0, 0),
        zoom: 16.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}
