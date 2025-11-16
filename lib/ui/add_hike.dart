import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/ui/confirm_hike.dart';

class AddHikeScreen extends StatefulWidget {
  const AddHikeScreen({super.key});

  @override
  State<AddHikeScreen> createState() => _AddHikeScreenState();
}

class _AddHikeScreenState extends State<AddHikeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  String? _name, _location, _description, _equipment, _duration;
  bool _parkingAvailable = false;
  String _difficulty = 'Easy';
  double? _length;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Hike'),
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
                decoration: const InputDecoration(labelText: 'Hike Name *'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location *'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                onSaved: (value) => _location = value,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (dd/MM/yyyy) *',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter a date' : null,
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
                decoration: const InputDecoration(labelText: 'Length (km) *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the length';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _length = double.tryParse(value!),
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
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onSaved: (value) => _description = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Equipment Needed'),
                onSaved: (value) => _equipment = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Estimated Duration (hours)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _duration = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newHike = Hike(
                      name: _name!,
                      location: _location!,
                      date: _dateController.text,
                      parkingAvailable: _parkingAvailable,
                      length: _length!,
                      difficulty: _difficulty,
                      description: _description,
                      equipmentNeeded: _equipment,
                      estimatedDuration: _duration,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmHikeScreen(hike: newHike),
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
