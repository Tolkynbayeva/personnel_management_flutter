import 'package:hive/hive.dart';

part 'graph.g.dart';

@HiveType(typeId: 3)
class Graph extends HiveObject {
  @HiveField(0)
  String employeeName;

  @HiveField(1)
  DateTime? workStartDate;
  @HiveField(2)
  DateTime? workEndDate;

  @HiveField(3)
  String? timeStart;
  @HiveField(4)
  String? timeEnd;

  @HiveField(5)
  DateTime? offStartDate;
  @HiveField(6)
  DateTime? offEndDate;

  Graph({
    required this.employeeName,
    this.workStartDate,
    this.workEndDate,
    this.timeStart,
    this.timeEnd,
    this.offStartDate,
    this.offEndDate,
  });
}
