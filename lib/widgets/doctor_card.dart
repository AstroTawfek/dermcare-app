import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/doctor_model.dart';
 
class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;
 
  const DoctorCard({super.key, required this.doctor, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
            blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Doctor photo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: doctor.imageUrl.isNotEmpty
                ? Image.network(doctor.imageUrl, width: 70, height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  const SizedBox(height: 4),
                  Text(doctor.specialty, style: const TextStyle(
                    fontSize: 13, color: AppColors.primaryLight)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${doctor.rating}', style: const TextStyle(
                      fontSize: 13, color: AppColors.bodyText)),
                    const SizedBox(width: 16),
                    const Icon(Icons.work_outline, size: 14, color: AppColors.greyText),
                    const SizedBox(width: 4),
                    Text('${doctor.experience} yrs', style: const TextStyle(
                      fontSize: 13, color: AppColors.greyText)),
                  ]),
                ],
              ),
            ),
            // Gender badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: doctor.gender == 'female' ? const Color(0xFFFCE4EC) : const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(doctor.gender == 'female' ? '♀' : '♂',
                style: TextStyle(
                  color: doctor.gender == 'female' ? Colors.pink : Colors.blue,
                  fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _placeholder() => Container(
    width: 70, height: 70, color: AppColors.inputBg,
    child: const Icon(Icons.person, size: 36, color: AppColors.greyText));
}