import 'package:hive/hive.dart';

part 'reprimand.g.dart';

@HiveType(typeId: 4)
class Reprimand extends HiveObject {
  @HiveField(0)
  final String employeeName;

  @HiveField(1)
  final String info;

  @HiveField(2)
  final String rebuke;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final double sum;

  @HiveField(5)
  final String comment;

  Reprimand({
    required this.employeeName,
    required this.info,
    required this.rebuke,
    required this.date,
    required this.sum,
    required this.comment,
  });
}