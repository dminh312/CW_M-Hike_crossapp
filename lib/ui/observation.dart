import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/model/observation.dart';
import 'package:m_hike_cross_app/ui/edit_observation.dart';

class ObservationScreen extends StatefulWidget {
  final Hike hike;

  const ObservationScreen({super.key, required this.hike});

  @override
  State<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends State<ObservationScreen> {
  final List<Observation> _observations = [];
  final _observationController = TextEditingController();
  late TextEditingController _timeController;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _timeController = TextEditingController(text: DateFormat('dd/MM/yyyy HH:mm').format(now));
  }

  @override
  void dispose() {
    _observationController.dispose();
    _timeController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(now);
    _timeController.text = formattedTime;
  }

  void _addObservation() {
    if (_observationController.text.isNotEmpty) {
      final newObservation = Observation(
        hikeId: widget.hike.id ?? 0,
        text: _observationController.text,
        time: _timeController.text,
        comment: _commentController.text,
      );

      setState(() {
        _observations.insert(0, newObservation);
        _observationController.clear();
        _commentController.clear();
        _updateTime();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Observation added'),
            ],
          ),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Observations for ${widget.hike.name}'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _observationController,
              decoration: const InputDecoration(labelText: 'Observation *'),
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time (dd/MM/yyyy HH:mm) *'),
              readOnly: true,
            ),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment (optional)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addObservation,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Add Observation'),
            ),
            const SizedBox(height: 20),
            _observations.isEmpty
                ? const Chip(
                    avatar: Icon(Icons.info_outline, color: Colors.green),
                    label: Text('No observations yet. Add your first one!'),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _observations.length,
                      itemBuilder: (context, index) {
                        final observation = _observations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(observation.text),
                            subtitle: Text('${observation.time}\n${observation.comment}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditObservationScreen(
                                          observation: observation,
                                          onSave: (updatedObservation) {
                                            setState(() {
                                              _observations[index] = updatedObservation;
                                            });
                                          },
                                          onDelete: () {
                                            setState(() {
                                              _observations.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit', style: TextStyle(color: Colors.green)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _observations.removeAt(index);
                                    });
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
