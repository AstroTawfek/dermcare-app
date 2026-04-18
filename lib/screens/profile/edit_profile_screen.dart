import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
 
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override State<EditProfileScreen> createState() => _EditProfileScreenState();
}
 
class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading    = false;
 
  @override
  void initState() {
    super.initState();
    // Pre-fill fields with current user data
    final auth = context.read<AuthService>();
    _nameCtrl.text  = auth.displayName;
    _phoneCtrl.text = ''; // Load from Firestore if stored
    _loadPhoneFromFirestore(auth.currentUser?.uid ?? '');
  }
 
  Future<void> _loadPhoneFromFirestore(String uid) async {
    if (uid.isEmpty) return;
    final doc = await FirebaseFirestore.instance
      .collection('users').doc(uid).get();
    if (doc.exists && mounted) {
      setState(() {
        _phoneCtrl.text = doc.data()?['phone'] ?? '';
      });
    }
  }
 
  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose(); super.dispose();
  }
 
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final auth = context.read<AuthService>();
      final uid  = auth.currentUser?.uid ?? '';
      // Update Firebase Auth display name
      await auth.currentUser?.updateDisplayName(_nameCtrl.text.trim());
      // Update Firestore user document
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name':  _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success));
      context.go('/profile');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e'),
          backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/profile')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar with change photo option 
              Center(
                child: Stack(alignment: Alignment.bottomRight, children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: AppColors.skyBlue,
                    child: Icon(Icons.person, size: 55, color: AppColors.primary),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: integrate image_picker for photo upload
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Photo upload coming soon')));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt,
                        size: 18, color: Colors.white),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 8),
              const Text('Tap camera to change photo', style: TextStyle(
                fontSize: 12, color: AppColors.greyText)),
              const SizedBox(height: 28),
              // Form fields 
              CustomTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: Validators.validateName,
              ),
              CustomTextField(
                controller: _phoneCtrl,
                label: 'Phone Number',
                hint: 'e.g. +880 1234 567890',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v != null && v.isNotEmpty && v.length < 7) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              // Read-only email field 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email Address', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.darkText)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDEE4F0)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.email_outlined,
                        color: AppColors.greyText, size: 20),
                      const SizedBox(width: 12),
                      Text(context.read<AuthService>().email,
                        style: const TextStyle(
                          fontSize: 14, color: AppColors.greyText)),
                      const Spacer(),
                      const Icon(Icons.lock_outline,
                        size: 14, color: AppColors.greyText),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  const Text('Email cannot be changed here.',
                    style: TextStyle(fontSize: 11, color: AppColors.greyText)),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Save Changes',
                onPressed: _saveProfile,
                isLoading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}