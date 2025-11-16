import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/ui/edit_hike.dart';
import 'package:m_hike_cross_app/ui/observation.dart';

class HikeDetailsScreen extends StatelessWidget {
  final Hike hike;
  final VoidCallback onDelete;


  const HikeDetailsScreen({super.key, required this.hike, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hike Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hike.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Location: ${hike.location}'),
            Text('Date: ${hike.date}'),
            Text('Parking: ${hike.parkingAvailable ? 'Available' : 'Not Available'}'),
            Text('Length: ${hike.length} km'),
            Text('Difficulty: ${hike.difficulty}'),
            Text('Description: ${hike.description ?? '(No description)'}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditHikeScreen(hike: hike)),
                    );
                  },
                  child: const Text('EDIT HIKE', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text('Are you sure you want to delete this hike?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                onDelete();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('DELETE HIKE', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ObservationScreen(hike: hike)),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('MANAGE OBSERVATIONS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
