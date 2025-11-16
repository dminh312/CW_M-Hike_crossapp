class Hike {
  final int? id;
  final String name;
  final String location;
  final String date;
  final bool parkingAvailable;
  final double length;
  final String difficulty;
  final String? description;
  final String? equipmentNeeded;
  final String? estimatedDuration;

  Hike({
    this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parkingAvailable,
    required this.length,
    required this.difficulty,
    this.description,
    this.equipmentNeeded,
    this.estimatedDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'parkingAvailable': parkingAvailable ? 1 : 0,
      'length': length,
      'difficulty': difficulty,
      'description': description,
      'equipmentNeeded': equipmentNeeded,
      'estimatedDuration': estimatedDuration,
    };
  }

  factory Hike.fromMap(Map<String, dynamic> map) {
    return Hike(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      parkingAvailable: map['parkingAvailable'] == 1,
      length: map['length'],
      difficulty: map['difficulty'],
      description: map['description'],
      equipmentNeeded: map['equipmentNeeded'],
      estimatedDuration: map['estimatedDuration'],
    );
  }
}
