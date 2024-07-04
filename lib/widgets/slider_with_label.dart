import 'package:flutter/material.dart';
import 'custom_slider_thumb_shape.dart';

class SliderWithLabel extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String minLabel;
  final String maxLabel;

  const SliderWithLabel({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.minLabel,
    required this.maxLabel,
  }) : super(key: key);

  @override
  SliderWithLabelState createState() => SliderWithLabelState();
}

class SliderWithLabelState extends State<SliderWithLabel> {
  bool _isInteracted = false;

  void _handleInteraction(double value) {
    if (!_isInteracted) {
      setState(() {
        _isInteracted = true;
      });
    }
    widget.onChanged(value);
  }

  void resetInteraction() {
    setState(() {
      _isInteracted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor:
                        _isInteracted ? Colors.orange : Colors.grey[300],
                    inactiveTrackColor: Colors.grey[300],
                    thumbColor: _isInteracted ? Colors.orange : Colors.white,
                    thumbShape: CustomSliderThumbShape(),
                    overlayColor: Colors.orange.withAlpha(32),
                    trackHeight: 8.0,
                  ),
                  child: Slider(
                    value: widget.value,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: widget.value.round().toString(),
                    onChanged: _handleInteraction,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.minLabel, style: TextStyle(color: Colors.grey)),
                    Text(widget.maxLabel, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
