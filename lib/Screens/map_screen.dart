import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_4/Models/User/location.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';
import 'package:task_4/provider/user_notifier_provider.dart';

class MapScreeen extends ConsumerStatefulWidget {
  const MapScreeen({super.key});

  @override
  ConsumerState<MapScreeen> createState() => _MapScreeenState();
}

class _MapScreeenState extends ConsumerState<MapScreeen> {
  var customMarker = <Marker>{};
  String? latitude;
  String? longitude;

  void addCustomMarker(LatLng newPoint) {
    setState(() {
      customMarker = {};

      customMarker.add(Marker(
        markerId: MarkerId(newPoint.toString()),
        position: newPoint,
      ));
      setState(() {
        latitude = newPoint.latitude.toString();
        longitude = newPoint.longitude.toString();
      });
    });
  }

  void initialMarker() {
    var user = ref.read(userModelNotifierProvider);
    customMarker.add(Marker(
        markerId: const MarkerId("User Location"),
        position: LatLng(double.parse(user.location!.coordinates!.latitude),
            double.parse(user.location!.coordinates!.longitude))));
  }

  void updateUserProfile() async {
    if (latitude != null && longitude != null) {
      var latLng = Coordinates(latitude: latitude, longitude: longitude);
      var location = Location(coordinates: latLng);
      var user = ref.read(userModelNotifierProvider);
      UserProfile newUser = user.copyWith(location: location);
      ref.read(userModelNotifierProvider.notifier).updateUser(newUser);
      // ignore: avoid_print
    }
  }

  @override
  void initState() {
    initialMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userModelNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Screen"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            updateUserProfile();
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const EditScreen(number: 0);
                }));
              }
            });
          },
          child: const Text("Done ")),
      body: SafeArea(
          child: GoogleMap(
        onTap: (latlng) {
          addCustomMarker(latlng);
        },
        markers: customMarker,
        initialCameraPosition: CameraPosition(
            zoom: 8.0,
            target: LatLng(double.parse(user.location!.coordinates!.latitude),
                double.parse(user.location!.coordinates!.longitude))),
      )),
    );
  }
}
