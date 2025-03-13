import 'package:hive/hive.dart';

part 'feedback.g.dart';

@HiveType(typeId: 1)
class FeedbackModel extends HiveObject {
  @HiveField(0)
  int rating;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime date;

  FeedbackModel({
    required this.rating,
    required this.text,
    required this.date,
  });
}
