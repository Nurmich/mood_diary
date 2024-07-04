import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class MoodChoiceButton extends StatelessWidget {
  final String choice;

  MoodChoiceButton(this.choice);

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return GestureDetector(
      onTap: () {
        moodProvider.selectMoodChoice(choice);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: moodProvider.selectedMoodChoices.contains(choice)
              ? Colors.orange
              : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          choice,
          style: TextStyle(
            color: moodProvider.selectedMoodChoices.contains(choice)
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
