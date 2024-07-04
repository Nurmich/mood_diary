import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class DayDetailsScreen extends StatelessWidget {
  final DateTime date;

  DayDetailsScreen({required this.date});

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final entries = moodProvider.getEntriesForDay(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('d MMMM', 'ru').format(date)),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('HH:mm').format(entry.date),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 4.0),
                  Text('Настроение: ${entry.mood}'),
                  Text('Выбор настроения: ${entry.moodChoices.join(', ')}'),
                  Text('Уровень стресса: ${entry.stressLevel}'),
                  Text('Самооценка: ${entry.selfAssessment}'),
                  Text('Заметки: ${entry.note}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
