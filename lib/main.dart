import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/mood_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/mood_diary_screen.dart';
import 'screens/statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('moodBox');
  await initializeDateFormatting('ru', null);

  runApp(MoodDiaryApp());
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
