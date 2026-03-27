import 'package:flutter/material.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/components/appBar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flyinsky/components/custom_input_text.dart';

class mapView extends StatefulWidget {
  @override
  State<mapView> createState() => _mapViewState();
}

class _mapViewState extends State<mapView> {
  final MapController mapController = MapController();
  LatLng? initialCenter;
  bool isLoading = true;
  String? departure;
  String? arrival;
  List<RoutePoint> routePoints = [];

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

  Future<void> searchRoute(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: colorsPalette['card blue'],
            title: Text(
              'Route',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorsPalette['title'],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputText(
                  hintText: 'Departure',
                  onChanged: (value) => setState(() => departure = value),
                ),
                SizedBox(height: 15),
                InputText(
                  hintText: 'Arrival',
                  onChanged: (value) => setState(() => arrival = value),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: colorsPalette['input'],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    Navigator.pop(context);
                    List<RoutePoint> points = await getFlightPlan(
                      departure!,
                      arrival!,
                    );

                    setState(() {
                      routePoints = points;
                      if (routePoints.isNotEmpty) {
                        mapController.move(routePoints[0].position, 9);
                      }
                    });
                  } catch (e) {
                    print("Error al obtener ruta: $e");
                  }
                },
                child: Text(
                  'Accept',
                  style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: colorsPalette['input'],
                ),
              ),
            ],
          ),
    );
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
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      subdomains: ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.dnv.flyinsky',
                    ),
                    TileLayer(
                      urlTemplate:
                          'https://api.tiles.openaip.net/api/data/openaip/{z}/{x}/{y}.png?apiKey=${dotenv.env['GLOBAL_MAP_KEY'] ?? ''}',
                      userAgentPackageName: 'com.dnv.flyinsky',
                    ),
                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints.map((p) => p.position).toList(),
                            color: Colors.blue.withAlpha(250),
                            strokeWidth: 5.0,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      rotate: true,
                      markers:
                          routePoints
                              .map(
                                (p) => Marker(
                                  point: p.position,
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          p.ident,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          searchRoute(context);
        },
        backgroundColor: colorsPalette['input'],
        child: Icon(Icons.route_outlined, color: Colors.white, size: 30),
      ),
    );
  }
}

class RoutePoint {
  final LatLng position;
  final String ident;

  RoutePoint({required this.position, required this.ident});
}

Future<List<RoutePoint>> getFlightPlan(String from, String to) async {
  String apiKey = dotenv.env['FLIGHT_PLAN_API_KEY'] ?? '';
  final searchResponse = await http.get(
    Uri.parse(
      'https://api.flightplandatabase.com/search/plans?fromICAO=${from.toUpperCase()}&toICAO=${to.toUpperCase()}',
    ),
    headers: {'Authorization': 'Basic $apiKey', 'Accept': 'application/json'},
  );

  if (searchResponse.statusCode != 200) {
    throw Exception('Error buscando planes: ${searchResponse.statusCode}');
  }

  final List<dynamic> plans = json.decode(searchResponse.body);

  if (plans.isEmpty) {
    throw Exception('No se encontraron rutas para $from → $to');
  }

  final bestPlan = plans.reduce(
    (a, b) => (a['waypoints'] as int) >= (b['waypoints'] as int) ? a : b,
  );
  final int bestId = bestPlan['id'];

  final planResponse = await http.get(
    Uri.parse('https://api.flightplandatabase.com/plan/$bestId'),
    headers: {'Authorization': 'Basic $apiKey', 'Accept': 'application/json'},
  );

  if (planResponse.statusCode != 200) {
    throw Exception(
      'Error obteniendo plan $bestId: ${planResponse.statusCode}',
    );
  }

  final planData = json.decode(planResponse.body);
  List<RoutePoint> points = [];

  if (planData['route']?['nodes'] != null) {
    for (var node in planData['route']['nodes']) {
      points.add(RoutePoint(
        position: LatLng(node['lat'], node['lon']),
        ident: node['ident'] ?? '',
      ));
    }
  }

  return points;
}
