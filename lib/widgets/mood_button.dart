import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class MoodButton extends StatelessWidget {
  final String mood;
  final String imagePath;

  MoodButton(this.mood, this.imagePath);

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return GestureDetector(
      onTap: () {
        moodProvider.selectMood(mood);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        padding: EdgeInsets.all(10.0),
        width: 90,
        height: 120,
        decoration: BoxDecoration(
          color:
              moodProvider.selectedMood == mood ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            SizedBox(height: 5.0),
            Text(
              mood,
              style: TextStyle(
                color: moodProvider.selectedMood == mood
                    ? Colors.white
                    : Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
