import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeChanged;

  const CustomTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TextEditingController _hourController;
  late TextEditingController _minuteController;

  @override
  void initState() {
    super.initState();
    _hourController = TextEditingController(
      text: widget.selectedTime.hour.toString().padLeft(2, '0'),
    );
    _minuteController = TextEditingController(
      text: widget.selectedTime.minute.toString().padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final hour = int.tryParse(_hourController.text) ?? 0;
    final minute = int.tryParse(_minuteController.text) ?? 0;

    final validHour = hour.clamp(0, 23);
    final validMinute = minute.clamp(0, 59);

    widget.onTimeChanged(TimeOfDay(hour: validHour, minute: validMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeInput(
            controller: _hourController,
            label: '시',
            onIncrement: () {
              final current = int.parse(_hourController.text);
              final newHour = (current + 1) % 24;
              _hourController.text = newHour.toString().padLeft(2, '0');
              _updateTime();
            },
            onDecrement: () {
              final current = int.parse(_hourController.text);
              final newHour = (current - 1 + 24) % 24;
              _hourController.text = newHour.toString().padLeft(2, '0');
              _updateTime();
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          _buildTimeInput(
            controller: _minuteController,
            label: '분',
            onIncrement: () {
              final current = int.parse(_minuteController.text);
              final newMinute = (current + 1) % 60;
              _minuteController.text = newMinute.toString().padLeft(2, '0');
              _updateTime();
            },
            onDecrement: () {
              final current = int.parse(_minuteController.text);
              final newMinute = (current - 1 + 60) % 60;
              _minuteController.text = newMinute.toString().padLeft(2, '0');
              _updateTime();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput({
    required TextEditingController controller,
    required String label,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: onIncrement,
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            onChanged: (value) {
              if (value.isEmpty) return;
              
              int? number = int.tryParse(value);
              if (number == null) return;

              if (label == '시') {
                if (number > 23) {
                  controller.text = '23';
                }
              } else {
                if (number > 59) {
                  controller.text = '59';
                }
              }
              _updateTime();
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: onDecrement,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
