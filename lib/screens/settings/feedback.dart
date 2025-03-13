import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:personnel_management_flutter/models/feedback/feedback.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 4;
  final _feedbackController = TextEditingController();

  Future<void> _submitFeedback() async {
    final box = Hive.box<FeedbackModel>('feedbacks');
    final feedback = FeedbackModel(
      rating: _rating.round(),
      text: _feedbackController.text.trim(),
      date: DateTime.now(),
    );
    await box.add(feedback);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Спасибо за обратную связь!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Обратная связь',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Оценить приложение',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                height: 1.3,
                color: Color(0xFF252525),
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.round().toString(),
              activeColor: const Color(0xFF2253F6),
              inactiveColor: const Color(0xFFDDE0E2),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 76),
            const Text(
              'Хотите рассказать больше?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                height: 1.3,
                color: Color(0xFF252525),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Color(0xFFF2F5F7),
              child: SizedBox(
                height: 173,
                child: TextField(
                  controller: _feedbackController,
                  maxLines: null,
                  expands: false,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    hintText:
                        'Напишите нам о своих идеях или проблемах. Нам это важно, мы постараемся их решить.',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: Color(0xFF818181),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              onPressed: () {},
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF2253F6),
                    Color(0xFF9DB4FF),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Text(
                    'Оценить',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.4,
                      color: Color(0xFFF2F5F7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
