import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:personnel_management_flutter/models/user_profile/user_profile.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _avatarPath = '';
  bool _profileExists = false;

  final phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final box = Hive.box<UserProfile>('user_profile');
    if (box.containsKey('user_profile')) {
      final user = box.get('user_profile');
      if (user != null) {
        setState(() {
          _profileExists = true;
          _avatarPath = user.avatarPath;
          _nameController.text = user.name;
          _surnameController.text = user.surname;
          _emailController.text = user.email;
          _phoneController.text = user.phone;
        });
      }
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarPath = image.path;
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final box = Hive.box<UserProfile>('user_profile');
    final user = UserProfile(
      avatarPath: _avatarPath,
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    await box.put('user_profile', user);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Профиль сохранён')));
    Navigator.pop(context);
  }

  void _confirmDeleteUserProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2F5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Удалить профиль пользователя?'),
        content: const Text('Вы уверены, что хотите удалить этот профиль?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Отмена',
              style: TextStyle(color: Color(0xFF252525)),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteUserProfile(context);
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Color(0xFFFF3B30)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUserProfile(BuildContext context) async {
    final box = Hive.box<UserProfile>('user_profile');
    await box.delete('user_profile');
    Navigator.pop(context);
    Navigator.pop(context, true);
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildAvatar(),
                      SizedBox(height: 60),
                      ErrorTextFormField(
                        controller: _nameController,
                        hintText: 'Имя',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _surnameController,
                        hintText: 'Фамилия',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _emailController,
                        hintText: 'E-mail',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _phoneController,
                        hintText: 'Номер телефона',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMask],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _profileExists
                ? TextButton(
                    onPressed: () {
                      _confirmDeleteUserProfile(context);
                    },
                    child: Text(
                      'Удалить аккаунт',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                  )
                : ButtonSave(onPressed: _saveUserProfile)
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final imageProvider = _avatarPath.isNotEmpty
        ? FileImage(File(_avatarPath))
        : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Color(0xFFF2F5F7),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        InkWell(
          onTap: _pickAvatar,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF2F5F7),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              'assets/svg/edit-icon.svg',
              width: 13,
              height: 13,
            ),
          ),
        ),
      ],
    );
  }
}
