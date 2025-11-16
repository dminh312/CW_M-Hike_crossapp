import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/ui/confirm_hike.dart';

class EditHikeScreen extends StatefulWidget {
  final Hike hike;

  const EditHikeScreen({super.key, required this.hike});

  @override
  State<EditHikeScreen> createState() => _EditHikeScreenState();
}

class _EditHikeScreenState extends State<EditHikeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _location, _date, _difficulty;
  late bool _parkingAvailable;
  late double _length;
  String? _description, _equipment, _duration;

  @override
  void initState() {
    super.initState();
    _name = widget.hike.name;
    _location = widget.hike.location;
    _date = widget.hike.date;
    _parkingAvailable = widget.hike.parkingAvailable;
    _length = widget.hike.length;
    _difficulty = widget.hike.difficulty;
    _description = widget.hike.description;
    _equipment = widget.hike.equipmentNeeded;
    _duration = widget.hike.estimatedDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hike'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Hike Name *'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location *'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                onSaved: (value) => _location = value!,
              ),
              TextFormField(
                initialValue: _date,
                decoration: const InputDecoration(labelText: 'Date (dd/MM/yyyy) *'),
                validator: (value) => value!.isEmpty ? 'Please enter a date' : null,
                onSaved: (value) => _date = value!,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _parkingAvailable,
                    onChanged: (value) => setState(() => _parkingAvailable = value!),
                  ),
                  const Text('Parking Available'),
                ],
              ),
              TextFormField(
                initialValue: _length.toString(),
                decoration: const InputDecoration(labelText: 'Length (km) *'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the length' : null,
                onSaved: (value) => _length = double.parse(value!),
              ),
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: ['Easy', 'Medium', 'Hard', 'Expert'].map((difficulty) {
                  return DropdownMenuItem(value: difficulty, child: Text(difficulty));
                }).toList(),
                onChanged: (value) => setState(() => _difficulty = value!),
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                initialValue: _equipment,
                decoration: const InputDecoration(labelText: 'Equipment Needed'),
                onSaved: (value) => _equipment = value,
              ),
              TextFormField(
                initialValue: _duration,
                decoration: const InputDecoration(labelText: 'Estimated Duration (hours)'),
                onSaved: (value) => _duration = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final updatedHike = Hike(
                      id: widget.hike.id,
                      name: _name,
                      location: _location,
                      date: _date,
                      parkingAvailable: _parkingAvailable,
                      length: _length,
                      difficulty: _difficulty,
                      description: _description,
                      equipmentNeeded: _equipment,
                      estimatedDuration: _duration,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmHikeScreen(hike: updatedHike),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('CONFIRM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
