import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  // Selected image
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthService>();
    _nameCtrl.text = auth.displayName;
    _loadPhoneFromFirestore(auth.currentUser?.uid ?? '');
  }

  Future<void> _loadPhoneFromFirestore(String uid) async {
    if (uid.isEmpty) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && mounted) {
      setState(() {
        _phoneCtrl.text = doc.data()?['phone'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // ── Show photo picker bottom sheet ────────────────────────────
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Profile Photo',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 20),

            // Camera option
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'Take a Photo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Use your camera',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Gallery option
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: Colors.purple,
                ),
              ),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Pick from your photos',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ),
            ),

            // Remove photo option (only if photo selected)
            if (_pickedImage != null) ...[
              const SizedBox(height: 4),
              ListTile(
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _pickedImage = null);
                },
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Pick image from camera or gallery ─────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _pickedImage = image);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ── Save profile ───────────────────────────────────────────────
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final auth = context.read<AuthService>();
      final uid = auth.currentUser?.uid ?? '';

      // Update Firebase Auth display name
      await auth.currentUser?.updateDisplayName(
        _nameCtrl.text.trim(),
      );

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
      });

      if (!mounted) return;
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/profile');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ── Build avatar with selected image ──────────────────────────
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Avatar circle
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.15),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _pickedImage != null
                  ? kIsWeb
                      // Web: use Image.network with object URL
                      ? Image.network(
                          _pickedImage!.path,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _defaultAvatar(),
                        )
                      // Mobile: use File
                      : Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                        )
                  : _defaultAvatar(),
            ),
          ),

          // Camera button overlay
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.primary.withOpacity(0.15),
      child: const Icon(
        Icons.person,
        size: 55,
        color: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/profile'),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Avatar ──────────────────────────────────────
              _buildAvatar(),
              const SizedBox(height: 8),
              const Text(
                'Tap to change photo',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ),
              const SizedBox(height: 28),

              // ── Name field ──────────────────────────────────
              CustomTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                validator: Validators.validateName,
              ),

              // ── Phone field ─────────────────────────────────
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

              // ── Read-only email ─────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECEFF1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFDEE4F0),
                      ),
                    ),
                    child: Row(children: [
                      const Icon(
                        Icons.email_outlined,
                        color: AppColors.greyText,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.read<AuthService>().email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.greyText,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: AppColors.greyText,
                      ),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Email cannot be changed here.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

              const SizedBox(height: 8),

              // ── Save button ─────────────────────────────────
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
