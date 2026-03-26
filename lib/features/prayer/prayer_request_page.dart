import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrayerRequestPage extends StatefulWidget {
  const PrayerRequestPage({super.key});

  @override
  State<PrayerRequestPage> createState() => _PrayerRequestPageState();
}

class _PrayerRequestPageState extends State<PrayerRequestPage> {
  final TextEditingController _prayerController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isAnonymous = false;
  bool isLoading = false;

  void _submit() async {
    final text = _prayerController.text.trim();
    final name = _nameController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write your prayer request")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('prayers').add({
        "text": text,
        "name": isAnonymous ? null : name,
        "anonymous": isAnonymous,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _prayerController.clear();
      _nameController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your prayer has been received ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: [
            _topBar(context),

            const SizedBox(height: 24),

            Text(
              "We’re here to pray with you.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              "Share your request and our team will stand in faith with you.",
              style: TextStyle(color: colors.onSurfaceVariant),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _prayerController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your prayer request...",
                filled: true,
                fillColor: colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (!isAnonymous)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Your name (optional)",
                  filled: true,
                  fillColor: colors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            Row(
              children: [
                Switch(
                  value: isAnonymous,
                  onChanged: (val) {
                    setState(() => isAnonymous = val);
                  },
                ),
                const SizedBox(width: 8),
                const Text("Submit anonymously"),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Text(
                        "Submit Prayer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.onBackground),
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: 4),
        Text(
          "Prayer Request",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onBackground,
          ),
        ),
      ],
    );
  }
}
