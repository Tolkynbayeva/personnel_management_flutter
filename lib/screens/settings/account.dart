import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/user_profile/user_profile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _avatarPath = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final box = Hive.box<UserProfile>('user_profile');
    if (box.isNotEmpty) {
      final user = box.getAt(0);
      if (user != null) {
        setState(() {
          _avatarPath = user.avatarPath;
          _nameController.text = user.name;
          _surnameController.text = user.surname;
          _emailController.text = user.email;
          _phoneController.text = user.phone;
        });
      }
    }
  }

  Future<void> _saveUserProfile() async {
    final box = Hive.box<UserProfile>('user_profile');
    if (box.isNotEmpty) {
      final user = UserProfile(
        avatarPath: _avatarPath,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      await box.add(user);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Профиль сохранён')));
  }

  void _pickAvatar() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки профиля',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 110,
              width: 110,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    // backgroundColor: Color(0xFFF2F5F7),
                    backgroundColor: Colors.red,
                    backgroundImage: _avatarPath.isNotEmpty
                        ? AssetImage(_avatarPath)
                        : AssetImage(
                            'assets/images/default_avatar.png',
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickAvatar,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF2F5F7),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/svg/edit-icon.svg',
                          width: 13,
                          height: 13,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 60),
            _buildTextField(
              controller: _nameController,
              label: 'Имя',
            ),
            _buildTextField(
              controller: _surnameController,
              label: 'Фамилия',
            ),
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
            ),
            _buildTextField(
              controller: _phoneController,
              label: 'Номер телефона',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.amber,
        //color: Color(0xFFF2F5F7),
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle:
              TextStyle(fontSize: 16, height: 1.4, color: Color(0xFF818181)),
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
