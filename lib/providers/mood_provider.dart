import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import 'package:hive/hive.dart';

class MoodProvider extends ChangeNotifier {
  String _selectedMood = '';
  List<String> _selectedMoodChoices = [];

  List<MoodEntry> _entries = [];

  MoodProvider() {
    _loadEntries();
  }

  String get selectedMood => _selectedMood;
  List<String> get selectedMoodChoices => _selectedMoodChoices;

  void _loadEntries() {
    final box = Hive.box('moodBox');
    _entries = box.values
        .map((e) => MoodEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    notifyListeners();
  }

  void _saveEntries() {
    final box = Hive.box('moodBox');
    box.putAll(Map.fromIterable(_entries,
        key: (e) => e.date.toString(), value: (e) => e.toJson()));
  }

  double getAverageStressLevelForDay(DateTime day) {
    final dayEntries = getEntriesForDay(day);
    if (dayEntries.isEmpty) return 0;
    return dayEntries
            .map((entry) => entry.stressLevel)
            .reduce((a, b) => a + b) /
        dayEntries.length;
  }

  double getAverageSelfAssessmentForDay(DateTime day) {
    final dayEntries = getEntriesForDay(day);
    if (dayEntries.isEmpty) return 0;
    return dayEntries
            .map((entry) => entry.selfAssessment)
            .reduce((a, b) => a + b) /
        dayEntries.length;
  }

  List<MoodEntry> getEntriesForPeriod(DateTime start, DateTime end) {
    return _entries
        .where((entry) =>
            entry.date.isAfter(start.subtract(Duration(days: 1))) &&
            entry.date.isBefore(end.add(Duration(days: 1))))
        .toList();
  }

  double getAverageStressLevelForPeriod(DateTime start, DateTime end) {
    final periodEntries = getEntriesForPeriod(start, end);
    if (periodEntries.isEmpty) return 0;
    return periodEntries
            .map((entry) => entry.stressLevel)
            .reduce((a, b) => a + b) /
        periodEntries.length;
  }

  double getAverageSelfAssessmentForPeriod(DateTime start, DateTime end) {
    final periodEntries = getEntriesForPeriod(start, end);
    if (periodEntries.isEmpty) return 0;
    return periodEntries
            .map((entry) => entry.selfAssessment)
            .reduce((a, b) => a + b) /
        periodEntries.length;
  }

  void selectMood(String mood) {
    _selectedMood = mood;
    _selectedMoodChoices = [];
    notifyListeners();
  }

  void selectMoodChoice(String choice) {
    if (_selectedMoodChoices.contains(choice)) {
      _selectedMoodChoices.remove(choice);
    } else {
      _selectedMoodChoices.add(choice);
    }
    notifyListeners();
  }

  void resetMoodSelection() {
    _selectedMood = '';
    _selectedMoodChoices = [];
    notifyListeners();
  }

  void addMoodEntry(MoodEntry entry) {
    final box = Hive.box('moodBox');
    box.add(entry.toJson());
    notifyListeners();
  }

  void loadEntries() {
    var box = Hive.box('moodBox');
    var entries = box.get('entries', defaultValue: []);
    _entries =
        entries.map<MoodEntry>((entry) => MoodEntry.fromJson(entry)).toList();
    notifyListeners();
  }

  List<MoodEntry> getEntriesForDay(DateTime date) {
    final box = Hive.box('moodBox');
    final entries = box.values
        .where((e) => e is Map) // Filter out non-map entries
        .map((e) => MoodEntry.fromJson(Map<String, dynamic>.from(e)))
        .where((entry) =>
            entry.date.year == date.year &&
            entry.date.month == date.month &&
            entry.date.day == date.day)
        .toList();
    return entries;
  }

  List<String> getMoodChoices() {
    switch (_selectedMood) {
      case 'Радость':
        return [
          'Счастье',
          'Восторг',
          'Веселье',
          'Радость',
          'Эйфория',
          'Вдохновение',
          'Благодарность',
          'Наслаждение',
          'Восхищение',
          'Удовольствие'
        ];
      case 'Страх':
        return [
          'Тревога',
          'Ужас',
          'Паника',
          'Беспокойство',
          'Страх',
          'Опасение',
          'Испуг',
          'Нервозность',
          'Неуверенность',
          'Тревожность'
        ];
      case 'Бешенство':
        return [
          'Гнев',
          'Раздражение',
          'Ярость',
          'Злость',
          'Возмущение',
          'Негодование',
          'Злоба',
          'Фрустрация',
          'Огорчение',
          'Недовольство'
        ];
      case 'Грусть':
        return [
          'Печаль',
          'Уныние',
          'Тоска',
          'Скорбь',
          'Депрессия',
          'Грусть',
          'Разочарование',
          'Огорчение',
          'Печальное настроение',
          'Удрученность'
        ];
      case 'Спокойствие':
        return [
          'Расслабление',
          'Удовлетворение',
          'Комфорт',
          'Умиротворение',
          'Покой',
          'Безмятежность',
          'Спокойствие',
          'Баланс',
          'Стабильность',
          'Миролюбие'
        ];
      case 'Сила':
        return [
          'Уверенность',
          'Энергичность',
          'Вдохновение',
          'Мотивация',
          'Энтузиазм',
          'Детерминация',
          'Сила воли',
          'Решимость',
          'Дерзость',
          'Самоутверждение'
        ];
      default:
        return [];
    }
  }
}
