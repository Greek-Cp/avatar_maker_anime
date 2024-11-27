import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class TextFieldEmail extends StatefulWidget {
  final TextEditingController controller;

  const TextFieldEmail({
    super.key,
    required this.controller,
  });

  @override
  State<TextFieldEmail> createState() => _TextFieldEmailState();
}

class _TextFieldEmailState extends State<TextFieldEmail> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff0e3e2),
        hintText: 'Email',
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan controller dibersihkan ketika widget dihapus
    widget.controller.dispose();
    super.dispose();
  }
}

class TextFieldUsername extends StatefulWidget {
  final TextEditingController controller;

  const TextFieldUsername({
    super.key,
    required this.controller,
  });

  @override
  State<TextFieldUsername> createState() => _TextFieldUsernameState();
}

class _TextFieldUsernameState extends State<TextFieldUsername> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff0e3e2),
        hintText: 'Username',
        prefixIcon: Icon(
          FluentIcons.person_24_filled,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan controller dibersihkan ketika widget dihapus
    widget.controller.dispose();
    super.dispose();
  }
}

class TextFieldPassword extends StatefulWidget {
  final TextEditingController controller;

  const TextFieldPassword({
    super.key,
    required this.controller,
  });

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _hidePassword,
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff0e3e2),
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _hidePassword
                ? FluentIcons.eye_off_24_regular
                : FluentIcons.eye_24_regular,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan controller dibersihkan ketika widget dihapus
    widget.controller.dispose();
    super.dispose();
  }
}
