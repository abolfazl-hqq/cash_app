import 'package:cash_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
        initPosition: GeoPoint(
            latitude: 36.32666131016086, longitude: 59.608921447481485));
  }

  void _addMarkers() async {
    List<GeoPoint> locations = [
      GeoPoint(
          latitude: 36.32479463134118, longitude: 59.59414445477839), //New York
      GeoPoint(
          latitude: 36.31487964402447, longitude: 59.63276686656515), //New York
    ];

    for (var location in locations) {
      await _mapController.addMarker(location,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 48,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _mapController.zoomIn();
            },
          ),
          const SizedBox(
            height: 12,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.remove_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              _mapController.zoomOut();
            },
          )
        ],
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _addMarkers();
            },
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'ATM Locations',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: OSMFlutter(
        controller: _mapController,
        osmOption: const OSMOption(zoomOption: ZoomOption(initZoom: 14)),
      ),
    );
  }
}
