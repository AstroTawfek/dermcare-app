import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/doctor_card.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
 
  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }
 
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            // Header 
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Hello, ${authService.displayName} 👋',
                          style: const TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Find your dermatologist',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ]),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  //  Search bar 
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search doctor name or specialty...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryLight),
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),

            // Browse by Gender 
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Browse by', style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _genderCard('Male Doctors', Icons.male,
                      AppColors.maleBg, Colors.blue, '/doctors/male')),
                    const SizedBox(width: 12),
                    Expanded(child: _genderCard('Female Doctors', Icons.female,
                      AppColors.femaleBg, Colors.pink, '/doctors/female')),
                  ]),
                ],
              ),
            ),

            // Doctors List 
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available Doctors', style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  GestureDetector(
                    onTap: () => context.go('/doctors/all'),
                    child: const Text('See all', style: TextStyle(
                      color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<DoctorModel>>(
                stream: _firestoreService.getDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No doctors found in database.'));
                  }
                  // Applying search filter
                  final doctors = snapshot.data!.where((d) =>
                    d.name.toLowerCase().contains(_searchQuery) ||
                    d.specialty.toLowerCase().contains(_searchQuery)
                  ).toList();
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (_, i) => DoctorCard(
                      doctor: doctors[i],
                      onTap: () => context.go('/doctor/${doctors[i].id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
 
  Widget _genderCard(String label, IconData icon, Color bg, Color iconColor, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(14),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: iconColor,
            fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
      ),
    );
  }
}