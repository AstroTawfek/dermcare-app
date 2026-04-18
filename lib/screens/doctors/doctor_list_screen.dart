import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/doctor_card.dart';
 
class DoctorListScreen extends StatelessWidget {
  final String gender; 
  const DoctorListScreen({super.key, required this.gender});
 
  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    final stream = gender == 'all'
      ? service.getDoctors()
      : service.getDoctorsByGender(gender);
    final title = gender == 'male' ? 'Male Doctors'
      : gender == 'female' ? 'Female Doctors' : 'All Doctors';
 
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/home')),
        elevation: 0,
      ),
      body: StreamBuilder<List<DoctorModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(gender == 'female' ? Icons.female : Icons.male,
                  size: 64, color: AppColors.greyText),
                const SizedBox(height: 16),
                Text('No $title found', style: const TextStyle(
                  fontSize: 16, color: AppColors.greyText)),
                const SizedBox(height: 8),
                const Text('Add doctors in Firebase Firestore',
                  style: TextStyle(fontSize: 13, color: AppColors.greyText)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, i) {
              final doc = snapshot.data![i];
              return DoctorCard(
                doctor: doc,
                onTap: () => context.go('/doctor/${doc.id}'),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }
}