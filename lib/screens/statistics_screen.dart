import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'day';

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final now = DateTime.now();
    double averageStressLevel;
    double averageSelfAssessment;

    switch (_selectedPeriod) {
      case 'week':
        averageStressLevel = moodProvider.getAverageStressLevelForPeriod(
          now.subtract(Duration(days: 6)),
          now,
        );
        averageSelfAssessment = moodProvider.getAverageSelfAssessmentForPeriod(
          now.subtract(Duration(days: 6)),
          now,
        );
        break;
      case 'month':
        averageStressLevel = moodProvider.getAverageStressLevelForPeriod(
          now.subtract(Duration(days: 29)),
          now,
        );
        averageSelfAssessment = moodProvider.getAverageSelfAssessmentForPeriod(
          now.subtract(Duration(days: 29)),
          now,
        );
        break;
      case 'day':
      default:
        averageStressLevel = moodProvider.getAverageStressLevelForDay(now);
        averageSelfAssessment =
            moodProvider.getAverageSelfAssessmentForDay(now);
        break;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('День'),
                  selected: _selectedPeriod == 'day',
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color:
                        _selectedPeriod == 'day' ? Colors.white : Colors.black,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = 'day';
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Неделя'),
                  selected: _selectedPeriod == 'week',
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color:
                        _selectedPeriod == 'week' ? Colors.white : Colors.black,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = 'week';
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Месяц'),
                  selected: _selectedPeriod == 'month',
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: _selectedPeriod == 'month'
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = 'month';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Средний уровень стресса: ${averageStressLevel.toStringAsFixed(1)} (${_getStressLevelDescription(averageStressLevel)})',
                    style: TextStyle(
                      color: _getStressLevelColor(averageStressLevel),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Средняя самооценка: ${averageSelfAssessment.toStringAsFixed(1)} (${_getSelfAssessmentDescription(averageSelfAssessment)})',
                    style: TextStyle(
                      color: _getSelfAssessmentColor(averageSelfAssessment),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (averageStressLevel > 6)
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Рекомендуется отдых',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getStressLevelDescription(double level) {
    if (level < 4) return 'ниже среднего';
    if (level < 7) return 'средний';
    return 'выше среднего';
  }

  Color _getStressLevelColor(double level) {
    if (level < 4) return Colors.green;
    if (level < 7) return Colors.orange;
    return Colors.red;
  }

  String _getSelfAssessmentDescription(double level) {
    if (level < 4) return 'низкая';
    if (level < 7) return 'средняя';
    return 'высокая';
  }

  Color _getSelfAssessmentColor(double level) {
    if (level < 4) return Colors.red;
    if (level < 7) return Colors.orange;
    return Colors.green;
  }
}
