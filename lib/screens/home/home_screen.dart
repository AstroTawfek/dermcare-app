import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/doctor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Stream<List<DoctorModel>> _getDoctors() {
    return FirebaseFirestore.instance.collection('doctors').snapshots().map(
        (snap) => snap.docs
            .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${authService.displayName} 👋',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Find your dermatologist',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Search Bar ──────────────────────────────────
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) =>
                        setState(() => _searchQuery = v.toLowerCase().trim()),
                    decoration: InputDecoration(
                      hintText: 'Search doctor name or specialty...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primaryLight,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AppColors.greyText),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<List<DoctorModel>>(
                stream: _getDoctors(),
                builder: (context, snapshot) {
                  // ── Loading ──────────────────────────────────────
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // ── Error ────────────────────────────────────────
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 60, color: AppColors.error),
                            const SizedBox(height: 16),
                            const Text(
                              'Failed to load doctors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.greyText,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ── No data ──────────────────────────────────────
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search,
                              size: 64, color: AppColors.greyText),
                          SizedBox(height: 16),
                          Text(
                            'No doctors found in database',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.greyText,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add doctors in Firebase Firestore',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final allDoctors = snapshot.data!;

                  // ── Filter by search ─────────────────────────────
                  final filteredDoctors = _searchQuery.isEmpty
                      ? allDoctors
                      : allDoctors.where((d) {
                          return d.name.toLowerCase().contains(_searchQuery) ||
                              d.specialty
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              d.gender.toLowerCase().contains(_searchQuery);
                        }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Browse by Gender ─────────────────────
                        if (_searchQuery.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Browse by',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _genderCard(
                                    context,
                                    'Male Doctors',
                                    Icons.male,
                                    const Color(0xFFE3F2FD),
                                    Colors.blue,
                                    '/doctors/male',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _genderCard(
                                    context,
                                    'Female Doctors',
                                    Icons.female,
                                    const Color(0xFFFCE4EC),
                                    Colors.pink,
                                    '/doctors/female',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ── Doctors List Header ──────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Available Doctors (${allDoctors.length})'
                                    : 'Search Results (${filteredDoctors.length})',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkText,
                                ),
                              ),
                              if (_searchQuery.isEmpty)
                                GestureDetector(
                                  onTap: () => context.go('/doctors/all'),
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // ── No search results ────────────────────
                        if (filteredDoctors.isEmpty && _searchQuery.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off,
                                      size: 60, color: AppColors.greyText),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No results for "$_searchQuery"',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // ── Doctors List ─────────────────────────
                        ...filteredDoctors.map(
                          (doctor) => DoctorCard(
                            doctor: doctor,
                            onTap: () => context.go('/doctor/${doctor.id}'),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
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

  Widget _genderCard(
    BuildContext context,
    String label,
    IconData icon,
    Color bg,
    Color iconColor,
    String route,
  ) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
