import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const Color primaryColor = Color(0xFF01410A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        children: [
          _topBar(context),
          const SizedBox(height: 28),

          _avatarSection(),
          const SizedBox(height: 28),

          _sectionTitle('Personal info'),
          _formCard([
            _textField('First name', 'Ikenna'),
            _textField('Last name', 'Ibeneme'),
            _textField('Middle name', 'Benjamin'),
          ]),

          const SizedBox(height: 20),
          _sectionTitle('Contact'),
          _formCard([
            _textField('Email', 'ibenemeikenna96@gmail.com'),
            _textField('Phone', '08120710198'),
          ]),

          const SizedBox(height: 20),
          _sectionTitle('Address'),
          _formCard([
            _textField('Street', 'No 12 Ada George Road'),
            _textField('City', 'Port Harcourt'),
            _textField('State', 'Rivers State'),
            _textField('Country', 'Nigeria'),
          ]),

          const SizedBox(height: 28),
          _saveButton(),
        ],
      ),
    );
  }

  // TOP BAR
  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // AVATAR
  Widget _avatarSection() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person, size: 48, color: Colors.black54),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // CARD
  Widget _formCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // FIELD
  Widget _textField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // SAVE BUTTON
  Widget _saveButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primaryColor.withOpacity(0.25)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Save changes',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
