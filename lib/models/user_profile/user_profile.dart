import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 2)
class UserProfile extends HiveObject {
  @HiveField(0)
  String avatarPath;

  @HiveField(1)
  String name;

  @HiveField(2)
  String surname;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  UserProfile({
    required this.avatarPath,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
  });
}
