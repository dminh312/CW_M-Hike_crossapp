import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/database/app_database.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/ui/show_all_hike.dart';

class ConfirmHikeScreen extends StatelessWidget {
  final Hike hike;

  const ConfirmHikeScreen({super.key, required this.hike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Hike Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Hike Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Name: ${hike.name}'),
            Text('Location: ${hike.location}'),
            Text('Date: ${hike.date}'),
            Text('Parking: ${hike.parkingAvailable ? "Available" : "Not Available"}'),
            Text('Length: ${hike.length} km'),
            Text('Difficulty: ${hike.difficulty}'),
            if (hike.description != null && hike.description!.isNotEmpty)
              Text('Description: ${hike.description}'),
            if (hike.equipmentNeeded != null && hike.equipmentNeeded!.isNotEmpty)
              Text('Equipment Needed: ${hike.equipmentNeeded}'),
            if (hike.estimatedDuration != null && hike.estimatedDuration!.isNotEmpty)
              Text('Estimated Duration: ${hike.estimatedDuration} hours'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('BACK TO EDIT'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (hike.id != null) {
                      await DatabaseHelper.instance.updateHike(hike);
                    } else {
                      await DatabaseHelper.instance.insertHike(hike);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hike saved successfully!')),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const ShowAllHikeScreen()),
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('SAVE HIKE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
