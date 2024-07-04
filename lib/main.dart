import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/mood_entry.dart';
import 'providers/mood_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/mood_diary_screen.dart';
import 'screens/statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('moodBox');
  await initializeDateFormatting('ru', null);
  // final moodBox = Hive.box('moodBox');
  // await moodBox.clear();
  runApp(MoodDiaryApp());

  // await generateEntriesForPast29Days();
}

class MoodDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoodProvider(),
      child: MaterialApp(
        title: 'Mood Diary',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            elevation: 0,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Builder(
                builder: (context) {
                  final currentDate = DateTime.now();
                  final formattedDate =
                      DateFormat('d MMMM HH:mm', 'ru').format(currentDate);
                  return Center(
                    child: Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.calendar_month, color: Colors.grey),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalendarScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(style: BorderStyle.none)),
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      indicator: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(style: BorderStyle.none)),
                      labelPadding: EdgeInsets.symmetric(horizontal: 0),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/diary.png'),
                                size: 12.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Дневник настроения',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/statistics.png'),
                                size: 12.0,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Статистика',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      MoodDiaryScreen(),
                      StatisticsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> generateEntriesForPast29Days() async {
//   final moodBox = Hive.box('moodBox');
//   final random = Random();
//   final now = DateTime.now();

//   for (int i = 0; i < 29; i++) {
//     final date = now.subtract(Duration(days: i));
//     final mood = _getRandomMood();
//     final moodChoices = _getMoodChoices(mood);
//     final stressLevel = (random.nextDouble() * 10).round().toDouble();
//     final selfAssessment = (random.nextDouble() * 10).round().toDouble();
//     final note = 'Запись по дате: ${DateFormat('d MMMM', 'ru').format(date)}';

//     final entry = MoodEntry(
//       date: date,
//       mood: mood,
//       moodChoices: moodChoices,
//       stressLevel: stressLevel,
//       selfAssessment: selfAssessment,
//       note: note,
//     );

//     moodBox.add(entry.toJson());
//   }
// }

// String _getRandomMood() {
//   const moods = [
//     'Радость',
//     'Страх',
//     'Бешенство',
//     'Грусть',
//     'Спокойствие',
//     'Сила',
//   ];
//   return moods[Random().nextInt(moods.length)];
// }

// List<String> _getMoodChoices(String mood) {
//   switch (mood) {
//     case 'Радость':
//       return [
//         'Счастье',
//         'Восторг',
//         'Веселье',
//         'Радость',
//         'Эйфория',
//         'Вдохновение',
//         'Благодарность',
//         'Наслаждение',
//         'Восхищение',
//         'Удовольствие'
//       ];
//     case 'Страх':
//       return [
//         'Тревога',
//         'Ужас',
//         'Паника',
//         'Беспокойство',
//         'Страх',
//         'Опасение',
//         'Испуг',
//         'Нервозность',
//         'Неуверенность',
//         'Тревожность'
//       ];
//     case 'Бешенство':
//       return [
//         'Гнев',
//         'Раздражение',
//         'Ярость',
//         'Злость',
//         'Возмущение',
//         'Негодование',
//         'Злоба',
//         'Фрустрация',
//         'Огорчение',
//         'Недовольство'
//       ];
//     case 'Грусть':
//       return [
//         'Печаль',
//         'Уныние',
//         'Тоска',
//         'Скорбь',
//         'Депрессия',
//         'Грусть',
//         'Разочарование',
//         'Огорчение',
//         'Печальное настроение',
//         'Удрученность'
//       ];
//     case 'Спокойствие':
//       return [
//         'Расслабление',
//         'Удовлетворение',
//         'Комфорт',
//         'Умиротворение',
//         'Покой',
//         'Безмятежность',
//         'Спокойствие',
//         'Баланс',
//         'Стабильность',
//         'Миролюбие'
//       ];
//     case 'Сила':
//       return [
//         'Уверенность',
//         'Энергичность',
//         'Вдохновение',
//         'Мотивация',
//         'Энтузиазм',
//         'Детерминация',
//         'Сила воли',
//         'Решимость',
//         'Дерзость',
//         'Самоутверждение'
//       ];
//     default:
//       return [];
//   }
// }
