import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AR Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to AR Navigation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to AR Navigation App',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacilitiesScreen()),
                );
              },
              child: Text('View Facilities'),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilitiesScreen extends StatelessWidget {
  final List<Map<String, String>> facilities = [
    {"name": "Restroom", "description": "Located near Platform 1"},
    {"name": "Waiting Hall", "description": "Available on both ends of the station"},
    {"name": "Ticket Counter", "description": "Near the main entrance"},
    {"name": "Food Court", "description": "Beside Platform 2"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facilities"),
      ),
      body: ListView.builder(
        itemCount: facilities.length,
        itemBuilder: (context, index) {
          final facility = facilities[index];
          return ListTile(
            title: Text(facility["name"]!),
            subtitle: Text(facility["description"]!),
            trailing: Icon(Icons.location_pin),
            onTap: () {
              // Navigate to map with facility details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    facilityName: facility["name"]!,
                    description: facility["description"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final String facilityName;
  final String description;

  // Constructor to pass the facility name and description
  MapScreen({required this.facilityName, required this.description});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Replace this with the actual coordinates of the facility
  final LatLng _facilityLocation = LatLng(37.7749, -122.4194); // Example coordinates (San Francisco)

  // This function is called when the map is created
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.facilityName),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _facilityLocation,
          zoom: 16.0,
        ),
        markers: {
          // Create a marker for the facility
          Marker(
            markerId: MarkerId(widget.facilityName),
            position: _facilityLocation,
            infoWindow: InfoWindow(
              title: widget.facilityName,
              snippet: widget.description,
            ),
          ),
        },
      ),
    );
  }
}
