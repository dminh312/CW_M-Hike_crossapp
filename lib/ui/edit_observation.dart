
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m_hike_cross_app/model/observation.dart';

class EditObservationScreen extends StatefulWidget {
  final Observation observation;
  final Function(Observation) onSave;
  final VoidCallback onDelete;

  const EditObservationScreen({
    super.key,
    required this.observation,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditObservationScreen> createState() => _EditObservationScreenState();
}

class _EditObservationScreenState extends State<EditObservationScreen> {
  late TextEditingController _observationController;
  late TextEditingController _timeController;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _observationController = TextEditingController(text: widget.observation.text);
    _timeController = TextEditingController(text: widget.observation.time);
    _commentController = TextEditingController(text: widget.observation.comment);
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
    setState(() {
      _timeController.text = formattedTime;
    });
  }

  void _saveObservation() {
    if (_formKey.currentState!.validate()) {
      final updatedObservation = Observation(
        id: widget.observation.id,
        hikeId: widget.observation.hikeId,
        text: _observationController.text,
        time: _timeController.text,
        comment: _commentController.text,
      );
      widget.onSave(updatedObservation);
      Navigator.pop(context);
    }
  }

  void _deleteObservation() {
    widget.onDelete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Observation'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text('Are you sure you want to delete this observation?'),
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
                          Navigator.of(context).pop();
                          _deleteObservation();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _observationController,
                decoration: const InputDecoration(labelText: 'Observation *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an observation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (dd/MM/yyyy HH:mm) *'),
                readOnly: true,
                onTap: _updateTime, // Update time when the field is tapped
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Comment (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveObservation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
