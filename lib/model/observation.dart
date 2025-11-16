class Observation {
  final int? id;
  final int hikeId;
  final String text;
  final String time;
  final String? comment;

  Observation({
    this.id,
    required this.hikeId,
    required this.text,
    required this.time,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hikeId': hikeId,
      'text': text,
      'time': time,
      'comment': comment,
    };
  }

  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'],
      hikeId: map['hikeId'],
      text: map['text'],
      time: map['time'],
      comment: map['comment'],
    );
  }
}
