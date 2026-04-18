import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_button.dart';
 
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override State<SettingsScreen> createState() => _SettingsScreenState();
}
 
class _SettingsScreenState extends State<SettingsScreen> {
  bool   _darkMode        = false;
  String _selectedLanguage = 'English';
  bool   _showRatings      = true;
  bool   _loading          = false;
 
  final List<String> _languages = [
    'English', 'বাংলা (Bengali)', 'हिन्दी (Hindi)', 'العربية (Arabic)',
  ];
 
  @override
  void initState() { super.initState(); _loadSettings(); }
 
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode         = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _showRatings      = prefs.getBool('show_ratings') ?? true;
    });
  }
 
  Future<void> _saveSettings() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setBool('show_ratings', _showRatings);
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved!'),
        backgroundColor: AppColors.success));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/profile')),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance
            _groupLabel('Appearance'),
            _switchTile('Dark Mode',
              'Switch between light and dark theme',
              Icons.dark_mode_outlined, _darkMode,
              (v) => setState(() => _darkMode = v)),
            const SizedBox(height: 12),
            // Language
            _groupLabel('Language'),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                  blurRadius: 6)],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primary),
                  items: _languages.map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang, style: const TextStyle(fontSize: 14)),
                  )).toList(),
                  onChanged: (val) =>
                    setState(() => _selectedLanguage = val ?? 'English'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Display
            _groupLabel('Display'),
            _switchTile('Show Doctor Ratings',
              'Display star ratings on doctor cards',
              Icons.star_outline, _showRatings,
              (v) => setState(() => _showRatings = v)),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Settings',
              onPressed: _saveSettings,
              isLoading: _loading,
            ),
            const SizedBox(height: 16),
            // App version info
            const Center(child: Text('DermCare v1.0.0',
              style: TextStyle(fontSize: 12, color: AppColors.greyText))),
          ],
        ),
      ),
    );
  }
 
  Widget _groupLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
    child: Text(label, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold,
      color: AppColors.greyText, letterSpacing: 1.1)),
  );
 
  Widget _switchTile(String title, String subtitle, IconData icon,
      bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
          blurRadius: 6)],
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(
          fontSize: 12, color: AppColors.greyText)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}