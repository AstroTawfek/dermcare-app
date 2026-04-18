import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
 
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupScreenState();
}
 
class _SignupScreenState extends State<SignupScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _nameCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passCtrl       = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool _loading          = false;
  bool _obscurePass      = true;
  bool _obscureConfirm   = true;
 
  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }
 
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final error = await context.read<AuthService>().signUp(
      name: _nameCtrl.text, email: _emailCtrl.text, password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (error == null) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.go('/welcome'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Create Account', style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                const SizedBox(height: 6),
                const Text('Join DermCare and find your specialist',
                  style: TextStyle(fontSize: 14, color: AppColors.greyText)),
                const SizedBox(height: 36),
                CustomTextField(controller: _nameCtrl, label: 'Full Name',
                  hint: 'Enter your full name', icon: Icons.person_outline,
                  validator: Validators.validateName),
                CustomTextField(controller: _emailCtrl, label: 'Email',
                  hint: 'Enter your email', icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail),
                CustomTextField(controller: _passCtrl, label: 'Password',
                  hint: 'Min. 6 characters', icon: Icons.lock_outline,
                  obscureText: _obscurePass,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.greyText),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass))),
                CustomTextField(controller: _confirmCtrl, label: 'Confirm Password',
                  hint: 'Re-enter password', icon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  validator: (v) => Validators.validateConfirmPassword(v, _passCtrl.text),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.greyText),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm))),
                const SizedBox(height: 8),
                CustomButton(text: 'Create Account', onPressed: _signup, isLoading: _loading),
                const SizedBox(height: 20),
                Center(child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: RichText(text: const TextSpan(children: [
                    TextSpan(text: 'Already have an account? ',
                      style: TextStyle(color: AppColors.greyText, fontSize: 14)),
                    TextSpan(text: 'Login',
                      style: TextStyle(color: AppColors.primary,
                        fontWeight: FontWeight.bold, fontSize: 14)),
                  ])),
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}