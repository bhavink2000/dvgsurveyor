import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';

class LocationViewWidget extends StatefulWidget {
  const LocationViewWidget({super.key});

  @override
  State<LocationViewWidget> createState() => _LocationViewWidgetState();
}

class _LocationViewWidgetState extends State<LocationViewWidget> {
  final locationHelper = LocationHelper();
  String _mapMode = "normal"; // default

  /// Different map providers
  String _getMapUrl() {
    switch (_mapMode) {
      case "satellite":
        return "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
      case "terrain":
        return "https://tile.opentopomap.org/{z}/{x}/{y}.png";
      case "dark":
        return "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png";
      default: // normal
        return "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final SurveyModel survey = Get.arguments['surveyData'];

    return Scaffold(
      body: Stack(
        children: [
          /// MAP VIEW
          FutureBuilder<LocationData>(
            future: locationHelper.getCurrentPosition(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final userLoc =
                  LatLng(snapshot.data!.latitude!, snapshot.data!.longitude!);

              final loc = survey.locationMap?['loc'];
              final surveyLat = double.tryParse(loc?.lag ?? "0") ?? 0.0;
              final surveyLng = double.tryParse(loc?.lug ?? "0") ?? 0.0;
              final surveyLoc = LatLng(surveyLat, surveyLng);

              return FlutterMap(
                options: MapOptions(
                  initialCenter: surveyLoc,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: _getMapUrl(),
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: "com.dvgsurveyor.app",
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLoc,
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.my_location,
                            color: Colors.blue, size: 38),
                      ),
                      Marker(
                        point: surveyLoc,
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [userLoc, surveyLoc],
                        strokeWidth: 4,
                        color: Colors.teal.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          /// BACK BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),

          /// MAP MODE SWITCHER
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.layers, color: Colors.black),
                    onSelected: (mode) {
                      setState(() => _mapMode = mode);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: "normal", child: Text("Normal")),
                      PopupMenuItem(
                          value: "satellite", child: Text("Satellite")),
                      PopupMenuItem(value: "terrain", child: Text("Terrain")),
                      PopupMenuItem(value: "dark", child: Text("Dark")),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Owner Name
                  Text(
                    survey.ownerName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// Address
                  Text(
                    survey.address,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const Divider(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
