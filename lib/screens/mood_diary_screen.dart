import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../models/mood_entry.dart';
import '../widgets/mood_button.dart';
import '../widgets/mood_choice_button.dart';
import '../widgets/slider_with_label.dart';
import 'calendar_screen.dart';

class MoodDiaryScreen extends StatefulWidget {
  @override
  _MoodDiaryScreenState createState() => _MoodDiaryScreenState();
}

class _MoodDiaryScreenState extends State<MoodDiaryScreen>
    with SingleTickerProviderStateMixin {
  double stressLevel = 5.0;
  double selfAssessment = 5.0;
  String note = '';
  final _noteController = TextEditingController();
  bool _stressLevelInteracted = false;
  bool _selfAssessmentInteracted = false;
  late TabController _tabController;

  final _stressSliderKey = GlobalKey<SliderWithLabelState>();
  final _selfAssessmentSliderKey = GlobalKey<SliderWithLabelState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      stressLevel = 5.0;
      selfAssessment = 5.0;
      note = '';
      _noteController.clear();
      _stressLevelInteracted = false;
      _selfAssessmentInteracted = false;
      _stressSliderKey.currentState?.resetInteraction();
      _selfAssessmentSliderKey.currentState?.resetInteraction();
      Provider.of<MoodProvider>(context, listen: false).resetMoodSelection();
      _tabController.index = 0; // Reset the tab index
    });
  }

  void _saveEntry() {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    final selectedMood = moodProvider.selectedMood;
    final selectedMoodChoices = moodProvider.selectedMoodChoices;
    if (selectedMood.isEmpty ||
        selectedMoodChoices.isEmpty ||
        note.isEmpty ||
        !_stressLevelInteracted ||
        !_selfAssessmentInteracted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please complete all fields.'),
      ));
      return;
    }

    final currentDate = DateTime.now();
    moodProvider.addMoodEntry(
      MoodEntry(
        date: currentDate,
        mood: selectedMood,
        moodChoices: selectedMoodChoices,
        stressLevel: stressLevel,
        selfAssessment: selfAssessment,
        note: note,
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Запись сохранена'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(builder: (context) => CalendarScreen()),
                    )
                    .then((_) =>
                        _resetForm()); // Reset the form when returning from CalendarScreen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFormCompleted =
        context.watch<MoodProvider>().selectedMood.isNotEmpty &&
            context.watch<MoodProvider>().selectedMoodChoices.isNotEmpty &&
            note.isNotEmpty &&
            _stressLevelInteracted &&
            _selfAssessmentInteracted;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<MoodProvider>(
          builder: (context, moodProvider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Что чувствуешь?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        MoodButton('Радость', 'assets/images/joy.png'),
                        MoodButton('Страх', 'assets/images/fear.png'),
                        MoodButton('Бешенство', 'assets/images/anger.png'),
                        MoodButton('Грусть', 'assets/images/sadness.png'),
                        MoodButton('Спокойствие', 'assets/images/calmness.png'),
                        MoodButton('Сила', 'assets/images/strength.png'),
                      ],
                    ),
                  ),
                  if (moodProvider.selectedMood.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: moodProvider.getMoodChoices().map((choice) {
                            return MoodChoiceButton(choice);
                          }).toList(),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  SliderWithLabel(
                    key: _stressSliderKey,
                    label: 'Уровень стресса',
                    value: stressLevel,
                    onChanged: (value) {
                      setState(() {
                        stressLevel = value;
                      });
                      _stressLevelInteracted = true;
                    },
                    minLabel: 'низкий',
                    maxLabel: 'высокий',
                  ),
                  SizedBox(height: 20),
                  SliderWithLabel(
                    key: _selfAssessmentSliderKey,
                    label: 'Самооценка',
                    value: selfAssessment,
                    onChanged: (value) {
                      setState(() {
                        selfAssessment = value;
                      });
                      _selfAssessmentInteracted = true;
                    },
                    minLabel: 'неуверенность',
                    maxLabel: 'уверенность',
                  ),
                  SizedBox(height: 20),
                  Text('Заметки',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    autofocus: false,
                    controller: _noteController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Введите заметку',
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        note = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: isFormCompleted ? _saveEntry : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            isFormCompleted ? Colors.white : Colors.grey[300],
                        backgroundColor:
                            isFormCompleted ? Colors.orange : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
