import 'package:hive/hive.dart';

part 'bonus.g.dart';

@HiveType(typeId: 5)
class Bonus extends HiveObject {
  @HiveField(0)
  final String employeeName;

  @HiveField(1)
  final String info;

  @HiveField(2)
  final String bonus;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final double sum;

  @HiveField(5)
  final String comment;

  Bonus({
    required this.employeeName,
    required this.info,
    required this.bonus,
    required this.date,
    required this.sum,
    required this.comment,
  });
}
