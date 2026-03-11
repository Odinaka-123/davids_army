import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  final picker = ImagePicker();

  File? imageFile;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    final data = doc.data()!;

    firstName.text = data["firstName"] ?? "";
    lastName.text = data["lastName"] ?? "";
    phone.text = data["phone"] ?? "";
    city.text = data["city"] ?? "";
    state.text = data["state"] ?? "";
    country.text = data["country"] ?? "";
    photoUrl = data["photo"];

    setState(() {});
  }

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);

                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (picked != null) {
                    setState(() {
                      imageFile = File(picked.path);
                    });
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Upload from Gallery"),
                onTap: () async {
                  Navigator.pop(context);

                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (picked != null) {
                    setState(() {
                      imageFile = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// GET INITIALS
  String getInitials() {
    String f = firstName.text.isNotEmpty ? firstName.text[0] : "";
    String l = lastName.text.isNotEmpty ? lastName.text[0] : "";
    return (f + l).toUpperCase();
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
      "firstName": firstName.text,
      "lastName": lastName.text,
      "phone": phone.text,
      "city": city.text,
      "state": state.text,
      "country": country.text,
    });

    context.pop();
  }

  /// AVATAR
  Widget avatar() {
    if (imageFile != null) {
      return CircleAvatar(radius: 48, backgroundImage: FileImage(imageFile!));
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(radius: 48, backgroundImage: NetworkImage(photoUrl!));
    }

    return CircleAvatar(
      radius: 48,
      backgroundColor: const Color(0xFFE8F5E9),
      child: Text(
        getInitials(),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// AVATAR SECTION
          Center(
            child: Stack(
              children: [
                avatar(),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF01410A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          TextField(
            controller: firstName,
            decoration: const InputDecoration(labelText: "First name"),
          ),

          TextField(
            controller: lastName,
            decoration: const InputDecoration(labelText: "Last name"),
          ),

          TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: "Phone"),
          ),

          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: "City"),
          ),

          TextField(
            controller: state,
            decoration: const InputDecoration(labelText: "State"),
          ),

          TextField(
            controller: country,
            decoration: const InputDecoration(labelText: "Country"),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: saveProfile,
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
