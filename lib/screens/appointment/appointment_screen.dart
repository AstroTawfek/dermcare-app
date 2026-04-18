import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/appointment_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/bottom_nav_bar.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthService>().currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Appointments',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: StreamBuilder<List<AppointmentModel>>(
        stream: FirestoreService().getUserAppointments(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Empty state
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 20),
                      const Text('No Appointments Yet',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText)),
                      const SizedBox(height: 10),
                      const Text('Book an appointment with a dermatologist.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 14)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/doctors/all'),
                        icon: const Icon(Icons.search),
                        label: const Text('Browse Doctors'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ]),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, i) {
              final a = snapshot.data![i];
              final color = _statusColor(a.status);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a.doctorName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(a.status.toUpperCase(),
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 15, color: AppColors.greyText),
                      const SizedBox(width: 6),
                      Text(a.date,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.bodyText)),
                      const SizedBox(width: 20),
                      const Icon(Icons.access_time,
                          size: 15, color: AppColors.greyText),
                      const SizedBox(width: 6),
                      Text(a.time,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.bodyText)),
                    ]),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}
