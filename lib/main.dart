// -----------------------------------Code works, displays a polyline with animation animation------------------------------------
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polyline Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapPolylinesAnimation(),
    );
  }
}

class MapPolylinesAnimation extends StatefulWidget {
  const MapPolylinesAnimation({super.key});

  @override
  State<MapPolylinesAnimation> createState() => _MapPolylinesAnimationState();
}

class _MapPolylinesAnimationState extends State<MapPolylinesAnimation>
    with SingleTickerProviderStateMixin {
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _mapController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<MapLatLng> _polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 14,
      maxZoomLevel: 17,
      focalLatLng: const MapLatLng(15.81525, 74.487765),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _loadPolylineData().then((_) {
      setState(() {}); // Trigger rebuild to show the map
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadPolylineData() async {
    final String jsonData =
        await rootBundle.loadString('assets/map_data/git-cbt.json');
    final dynamic parsedData = json.decode(jsonData);

    final List<dynamic> decodedGeometry = parsedData["decodedGeometry"];
    _polylinePoints =
        decodedGeometry.map((point) => MapLatLng(point[0], point[1])).toList();

    _animationController.forward(); // Start animation when data is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polyline Animation'),
        backgroundColor: const Color.fromARGB(255, 62, 117, 211),
      ),
      body: _polylinePoints.isEmpty // Conditional rendering
          ? const Center(child: CircularProgressIndicator())
          : SfMaps(
              layers: [
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  initialZoomLevel: 12,
                  controller: _mapController,
                  zoomPanBehavior: _zoomPanBehavior,
                  sublayers: [
                    MapPolylineLayer(
                      polylines: {
                        MapPolyline(
                            points: _polylinePoints,
                            color: Colors.red,
                            width: 5)
                      },
                      animation: _animation,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}


//-------------------------------------new stuff trial(issue with animation)-----------------------------------------------
// see Gemini conversation.
//cant generate animation
// generates polyline on hot reload.
//gives error on inital run and hot restart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Polyline Animation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MapPolylinesAnimation(),
//     );
//   }
// }

// class MapPolylinesAnimation extends StatefulWidget {
//   const MapPolylinesAnimation({super.key});

//   @override
//   State<MapPolylinesAnimation> createState() => _MapPolylinesAnimationState();
// }

// class _MapPolylinesAnimationState extends State<MapPolylinesAnimation>
//     with SingleTickerProviderStateMixin {
//   late MapZoomPanBehavior _zoomPanBehavior;
//   late MapTileLayerController _mapController;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   List<MapLatLng> _polylinePoints = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPolylineData();

//     _mapController = MapTileLayerController();
//     _zoomPanBehavior = MapZoomPanBehavior(
//       zoomLevel: 15,
//       focalLatLng: const MapLatLng(15.81525, 74.487765),
//     );

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 18),
//     );
//     _animation =
//         CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _mapController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadPolylineData() async {
//     final String jsonData =
//         await rootBundle.loadString('assets/map_data/git-cbt.json');
//     final dynamic parsedData = json.decode(jsonData);

//     // Extract coordinates from "decodedGeometry"
//     final List<dynamic> decodedGeometry = parsedData["decodedGeometry"];
//     setState(() {
//       _polylinePoints = decodedGeometry
//           .map((point) => MapLatLng(point[0], point[1]))
//           .toList();
//       print(_polylinePoints);
//       _animationController.forward(from: 0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Polyline Animation')),
//       body: SfMaps(
//         layers: [
//           MapTileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             initialZoomLevel: 6,
//             controller: _mapController,
//             zoomPanBehavior: _zoomPanBehavior,
//             sublayers: [
//               MapPolylineLayer(
//                 polylines: {
//                   MapPolyline(
//                     points: _polylinePoints.sublist(
//                         0, (_polylinePoints.length * _animation.value).toInt()),
//                     color: Colors.red,
//                     width: 5,
//                   )
//                 },
//                 //TODO : Add ToolTip to add ontap info for the polyline
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
