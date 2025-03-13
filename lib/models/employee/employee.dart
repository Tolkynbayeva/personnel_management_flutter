import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String fullName;

  @HiveField(1)
  String position;

  @HiveField(2)
  double salary;

  @HiveField(3)
  String phone;

  @HiveField(4)
  DateTime hireDate;

  @HiveField(5)
  String comment;

  Employee({
    required this.fullName,
    required this.position,
    required this.salary,
    required this.phone,
    required this.hireDate,
    required this.comment,
  });
}
