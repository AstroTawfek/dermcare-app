import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/doctor_card.dart';

class DoctorListScreen extends StatefulWidget {
  final String gender; // 'male', 'female', or 'all'
  const DoctorListScreen({super.key, required this.gender});
  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Stream<List<DoctorModel>> _getStream() {
    final ref = FirebaseFirestore.instance.collection('doctors');

    if (widget.gender == 'all') {
      return ref.snapshots().map((snap) => snap.docs
          .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
          .toList());
    } else {
      return ref.where('gender', isEqualTo: widget.gender).snapshots().map(
          (snap) => snap.docs
              .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
              .toList());
    }
  }

  String get _title {
    switch (widget.gender) {
      case 'male':
        return 'Male Doctors';
      case 'female':
        return 'Female Doctors';
      default:
        return 'All Doctors';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  setState(() => _searchQuery = v.toLowerCase().trim()),
              decoration: InputDecoration(
                hintText: 'Search by name or specialty...',
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
                        icon:
                            const Icon(Icons.clear, color: AppColors.greyText),
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
          ),
        ),
      ),
      body: StreamBuilder<List<DoctorModel>>(
        stream: _getStream(),
        builder: (context, snapshot) {
          // ── Loading ────────────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // ── Error ──────────────────────────────────────────────────
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Retry',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── No data ────────────────────────────────────────────────
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.gender == 'female'
                          ? Icons.female
                          : widget.gender == 'male'
                              ? Icons.male
                              : Icons.person_search,
                      size: 72,
                      color: AppColors.greyText,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No $_title found',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add doctors in Firebase Firestore\nwith the correct gender field',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.greyText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final allDoctors = snapshot.data!;

          // ── Filter by search ───────────────────────────────────────
          final filtered = _searchQuery.isEmpty
              ? allDoctors
              : allDoctors.where((d) {
                  return d.name.toLowerCase().contains(_searchQuery) ||
                      d.specialty.toLowerCase().contains(_searchQuery);
                }).toList();

          // ── No search results ──────────────────────────────────────
          if (filtered.isEmpty && _searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 64, color: AppColors.greyText),
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
            );
          }

          // ── Doctors list ───────────────────────────────────────────
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  '${filtered.length} doctor${filtered.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => DoctorCard(
                    doctor: filtered[i],
                    onTap: () => context.go('/doctor/${filtered[i].id}'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}
