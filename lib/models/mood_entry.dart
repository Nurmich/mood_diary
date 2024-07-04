class MoodEntry {
  final DateTime date;
  final String mood;
  final List<String> moodChoices;
  final double stressLevel;
  final double selfAssessment;
  final String note;

  MoodEntry({
    required this.date,
    required this.mood,
    required this.moodChoices,
    required this.stressLevel,
    required this.selfAssessment,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
      'moodChoices': moodChoices,
      'stressLevel': stressLevel,
      'selfAssessment': selfAssessment,
      'note': note,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      date: DateTime.parse(json['date']),
      mood: json['mood'],
      moodChoices: List<String>.from(json['moodChoices']),
      stressLevel: json['stressLevel'],
      selfAssessment: json['selfAssessment'],
      note: json['note'],
    );
  }
}
