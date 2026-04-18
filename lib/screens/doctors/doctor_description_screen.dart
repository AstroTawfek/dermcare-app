import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';
 
class DoctorDescriptionScreen extends StatelessWidget {
  final String doctorId;
  const DoctorDescriptionScreen({super.key, required this.doctorId});
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DoctorModel?>(
      future: FirestoreService().getDoctor(doctorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
            body: const Center(child: Text('Doctor not found')));
        }
        final doctor = snapshot.data!;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => context.pop()),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(color: AppColors.primary),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white24,
                          backgroundImage: doctor.imageUrl.isNotEmpty
                            ? NetworkImage(doctor.imageUrl) : null,
                          child: doctor.imageUrl.isEmpty
                            ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
                          
                        ),
                        const SizedBox(height: 12),
                        Text(doctor.name, style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(doctor.specialty, style: const TextStyle(
                          fontSize: 14, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Stat Cards 
                      Row(children: [
                        _statCard('Experience', '${doctor.experience} Yrs', Icons.work_outline),
                        const SizedBox(width: 12),
                        _statCard('Rating', '${doctor.rating}', Icons.star_outline),
                        const SizedBox(width: 12),
                        _statCard('Gender', doctor.gender == 'female' ? 'Female' : 'Male',
                          doctor.gender == 'female' ? Icons.female : Icons.male),
                      ]),
                      const SizedBox(height: 24),

                      //  About 
                      const Text('About', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                      const SizedBox(height: 8),
                      Text(doctor.about, style: const TextStyle(
                        fontSize: 14, color: AppColors.bodyText, height: 1.6)),
                      const SizedBox(height: 24),

                      //  Available Days 
                      const Text('Available Days', style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: doctor.availableDays.map((day) =>
                          Chip(label: Text(day,
                            style: const TextStyle(color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                            backgroundColor: AppColors.paleBlue ?? const Color(0xFFE3F2FD)),
                        ).toList(),
                      ),
                      const SizedBox(height: 32),

                      //  Book Button
                      CustomButton(
                        text: 'Book Appointment',
                        onPressed: () => context.go(
                          '/schedule?doctorId=${doctor.id}&doctorName=${Uri.encodeComponent(doctor.name)}'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
 
  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05),
            blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 24),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(
              fontSize: 11, color: AppColors.greyText)),
          ],
        ),
      ),
    );
  }
}