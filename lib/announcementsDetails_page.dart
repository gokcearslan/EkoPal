import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const AnnouncementDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['duyuruName']),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center( // Aligns the container to the center of the screen
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity, // Ensures the container takes up the full width
              padding: EdgeInsets.all(24.0), // Internal padding within the container
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface, // Background color of the container
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                boxShadow: [ // Adds a subtle shadow for a lifted effect
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['duyuruName'],
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center, // Centers the title text
                  ),
                  SizedBox(height: 20), // Provides spacing between title and details
                  Text(
                    data['duyuruDetails'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
