import 'dart:async';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/src/surveyor_form/controller/surveyor_form_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';

class LocationPickerScreen extends GetWidget<SurveyorFormScreenController> {
  const LocationPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initAndHookMap(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        return Obx(() {
          final selected = controller.selectedLocation.value;
          final current = controller.currentLocation.value;

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // MAP
                FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: selected,
                    initialZoom: 16,
                    // We lock the pin at center; selection is updated via map event listener
                    interactionOptions: const InteractionOptions(
                      flags: ~InteractiveFlag
                          .rotate, // disable rotation for Uber-like feel
                    ),
                  ),
                  children: [
                    // Normal / Satellite
                    TileLayer(
                      urlTemplate: controller.satelliteMode.value
                          ? "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
                          : "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.dvgsurveyor",
                    ),

                    // ROUTE (current -> selected)
                    if (controller.workerPicked.value)
                      PolylineLayer(
                        polylines: [
                          // base bold line
                          Polyline(
                            points: [current, selected],
                            strokeWidth: 7,
                            color: Colors.blue.shade600.withOpacity(0.85),
                          ),
                          // subtle highlight “glow”
                          Polyline(
                            points: [current, selected],
                            strokeWidth: 11,
                            color: Colors.blue.shade200.withOpacity(0.25),
                          ),
                        ],
                      ),

                    // CURRENT LOCATION DOT (3D raised)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: current,
                          width: 44,
                          height: 44,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x55000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 3),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // CENTER-LOCKED PIN (like Uber/Rapido)
                IgnorePointer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 2),
                        Icon(
                          Icons.location_pin,
                          size: 56,
                          color: controller.satelliteMode.value
                              ? Colors.orangeAccent
                              : Colors.redAccent,
                          shadows: const [
                            Shadow(
                              blurRadius: 12,
                              color: Colors.black54,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        // tiny shadow “anchor”
                        Container(
                          width: 14,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // TOP BAR (sheet-like)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        _glassButton(
                          icon: Icons.arrow_back,
                          onTap: () => Get.back(),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 58.h,
                          width: 220.w,
                          child: _pillInfoBar(
                            title: "Move map to place pin",
                            subtitle:
                                "${selected.latitude.toStringAsFixed(6)}, ${selected.longitude.toStringAsFixed(6)}",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RIGHT SIDE CONTROLS (zoom, my location, layer)
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _floatingRail(
                        children: [
                          _railButton(
                            icon: Icons.add,
                            onTap: () {
                              final cam = controller.mapController.camera;
                              controller.mapController
                                  .move(cam.center, cam.zoom + 1);
                            },
                          ),
                          _railButton(
                            icon: Icons.remove,
                            onTap: () {
                              final cam = controller.mapController.camera;
                              controller.mapController
                                  .move(cam.center, cam.zoom - 1);
                            },
                          ),
                          _railButton(
                            icon: Icons.my_location,
                            onTap: () async {
                              final loc =
                                  await LocationHelper().getCurrentPosition();
                              final my = LatLng(loc.latitude!, loc.longitude!);
                              controller.currentLocation.value = my;
                              controller.workerPicked.value =
                                  true; // show route
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                controller.mapController.move(my, 17);
                              });
                            },
                          ),
                          _railButton(
                            icon: controller.satelliteMode.value
                                ? Icons.map
                                : Icons.satellite_alt,
                            onTap: () {
                              controller.satelliteMode.value =
                                  !controller.satelliteMode.value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // BOTTOM SHEET (distance + confirm) – glossy, 3D, responsive
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // distance card
                          Row(
                            children: [
                              _badgeDot(color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _distanceLabel(current, selected),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              _chipMode(controller.satelliteMode.value),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // confirm button
                          GestureDetector(
                            onTap: () {
                              final loc =
                                  controller.mapController.camera.center;
                              controller.selectedLocation.value = loc;
                              controller.workerPicked.value = true;

                              controller.locationMap['loc'] = LocationMap(
                                lag: loc.latitude.toString(),
                                lug: loc.longitude.toString(),
                              );

                              Get.back();
                              AppSnackbar.showSnackbar(
                                title: "Location Confirmed",
                                message:
                                    "Coordinate: ${loc.latitude.toStringAsFixed(5)}, ${loc.longitude.toStringAsFixed(5)}",
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.indigo.shade600,
                                  ],
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x552969F0),
                                    blurRadius: 18,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_rounded,
                                      color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Confirm Location",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  /// Get current position, center the camera *after* first frame,
  /// and attach a one-time map event listener that keeps the pin “center-locked”.
  Future<void> _initAndHookMap(BuildContext context) async {
    // 1) current location
    final loc = await LocationHelper().getCurrentPosition();
    final initial = LatLng(loc.latitude!, loc.longitude!);

    controller.currentLocation.value = initial;
    controller.selectedLocation.value = initial;
    controller.workerPicked.value = false;

    // 2) move camera AFTER first frame (prevents controller not-ready error)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.mapController.move(initial, 16);
    });

    // 3) hook map events ONCE to track camera center as "picked" point
    if (!controller.hooksAttached.value) {
      controller.hooksAttached.value = true;

      controller.mapEventSub =
          controller.mapController.mapEventStream.listen((event) {
        // on any move end/fling end, set selection to camera center
        if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
          final center = controller.mapController.camera.center;
          controller.selectedLocation.value = center;
          controller.workerPicked.value = true;
        }
      });
    }

    // 4) persist initial into your map
    controller.locationMap['loc'] = LocationMap(
      lag: initial.latitude.toString(),
      lug: initial.longitude.toString(),
    );
  }

  // === UI helpers ===

  Widget _glassButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _pillInfoBar({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.place_outlined, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _floatingRail({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            children.expand((w) => [w, const SizedBox(height: 8)]).toList()
              ..removeLast(),
      ),
    );
  }

  Widget _railButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _badgeDot({required Color color}) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _chipMode(bool isSat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSat ? Colors.black : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSat ? Colors.white24 : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSat ? Icons.satellite_alt : Icons.map,
            size: 14,
            color: isSat ? Colors.white : Colors.blue.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            isSat ? "Satellite" : "Normal",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSat ? Colors.white : Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  String _distanceLabel(LatLng a, LatLng b) {
    final d = Distance().as(LengthUnit.Meter, a, b);
    if (d < 1000) return "Distance: ${d.toStringAsFixed(0)} m";
    return "Distance: ${(d / 1000).toStringAsFixed(2)} km";
  }
}
