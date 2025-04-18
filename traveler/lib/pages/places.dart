import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:traveler/models/my_place_model.dart';
import 'package:traveler/models/userId_model.dart';
import 'package:traveler/services/supabase_api_service.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {

  late Future<List<MyPlaceModel>> _locationsFuture;

  @override
  void initState() {
    super.initState();
    _initializePlaces();

    log("Made it to the places page");
  }

  Future<void> _initializePlaces() async {

    final userId = UserIdModel(
      userId: Supabase.instance.client.auth.currentUser?.id ?? ''
    );

    log('User Id: ${userId.userId}');

    // Fetching the saved locations
    try{
      _locationsFuture = SupabaseApiService().fetchSavedLocations(userId);
      log("Fetched saved locations");
    }catch(e){
      log("Error fetching saved locations: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching saved locations: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MyPlaceModel>>(
        future: _locationsFuture,
        builder: (context, snapshot) {

          log("Building the places page");

          if (snapshot.connectionState == ConnectionState.waiting) {
            log("Waiting for the future to complete");
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log("Error: ${snapshot.error}");
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          
          final locationList = snapshot.data!;
          if (locationList.isEmpty) {
            return const Center(
              child: Text('No saved locations yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: locationList.length,
            itemBuilder: (context, index){
              final location = locationList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDate(location.createdAt),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Place ID: ${location.placeId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        location.info,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ]
                  )
                )
              );
            },
          );
        }
      )
    );
  }
}