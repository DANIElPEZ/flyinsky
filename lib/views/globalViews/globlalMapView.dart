import 'package:flutter/material.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class mapView extends StatefulWidget {
  @override
  State<mapView> createState() => _mapViewState();
}

class _mapViewState extends State<mapView> {
  final MapController mapController = MapController();
  LatLng? initialCenter;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    findYourPosition();
  }

  Future<void> findYourPosition() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permiso cerrado.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permiso cerrado.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        initialCenter = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      print("Error obteniendo ubicación: $e");
      setState(() {
        initialCenter = LatLng(7.065612, -73.863979);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette['light blue'],
        child:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: colorsPalette['arrow blue'],
                  ),
                )
                : FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: initialCenter!,
                    initialZoom: 12,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.dnv.flyinsky',
                    ),
                    TileLayer(
                      urlTemplate:
                          'https://api.tiles.openaip.net/api/data/openaip/{z}/{x}/{y}.png?apiKey=${dotenv.env['GLOBAL_MAP_KEY']??''}',
                      userAgentPackageName: 'com.dnv.flyinsky',
                    )
                  ]
                )
      )
    );
  }
}
