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
          children: [
            Expanded(
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
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      final i = index + 1;
                      final isGray = i > _rating;

                      return SizedBox(
                        width: 40,
                        height: 40,
                        child: ColorFiltered(
                          colorFilter: isGray
                              ? const ColorFilter.matrix([
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ])
                              : const ColorFilter.mode(
                                  Colors.transparent, BlendMode.saturation),
                          child: Image.asset(
                            'assets/images/emoji$i.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
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
                  const SizedBox(height: 40),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
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
                ],
              ),
            ),
            ButtonSave(
              title: 'Оценить',
              onPressed: _submitFeedback,
            )
          ],
        ),
      ),
    );
  }
}
