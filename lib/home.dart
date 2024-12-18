import 'package:flutter/material.dart';
import 'package:lulutong/app_bar.dart';
import 'package:lulutong/floating_button.dart';
import 'package:lulutong/google_map.dart';
import 'package:lulutong/job_list_box.dart';
import 'package:lulutong/job_list_page.dart';
import 'package:lulutong/styled_body_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;

  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    print("sfasfas");
    try {
      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      print("1");

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permissions denied");
        return;
      }

      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        print("Location services are disabled. Please enable them.");
        return;
      }
      print("2");

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Lower the accuracy
        timeLimit: const Duration(seconds: 10),
      );

      print("3");
      print("Fetched location: ${position.latitude}, ${position.longitude}");

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // Dummy job list data
    final List<Map<String, dynamic>> jobs = [
      {'id': 1, 'address': '123 Main St', 'status': 'Pending'},
      {'id': 2, 'address': '456 Park Ave', 'status': 'Completed'},
      {'id': 3, 'address': '789 Elm St', 'status': 'Pending'},
      {'id': 4, 'address': '101 Pine Rd', 'status': 'Pending'},
      {'id': 5, 'address': '202 Oak Ave', 'status': 'Completed'},
    ];
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBarComponent(
        title: "Parcel Delivery",
        onEditJobs: () {
          print("Edit Jobs tapped");
        },
        onViewJobs: () {
          print("View Jobs tapped");
        },
        onOptimizeRoute: () {
          print("Optimize Route tapped");
        },
        onProfile: () {
          print("Profile tapped");
        },
      ),
      body: Stack(
        children: [
          // Google Map Section
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : // Google Map Section
              Positioned.fill(
                  child: GoogleMapComponent(
                      currentPosition: _currentPosition,
                      onMapCreated: _onMapCreated)),
          // Floating Action Button
          const FloatingButton(),
          JobListBox(
            jobs: jobs,
            screenHeight: screenHeight,
          )
        ],
      ),
    );
  }
}
