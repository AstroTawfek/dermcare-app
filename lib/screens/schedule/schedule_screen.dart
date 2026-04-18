import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/appointment_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class ScheduleScreen extends StatefulWidget {
  final String? doctorId;
  final String? doctorName;
  const ScheduleScreen({super.key, this.doctorId, this.doctorName});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _loading = false;

  // Available time slots
  static const List<String> _timeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
  ];

  Future<void> _confirmBooking() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: AppColors.warning));
      return;
    }
    setState(() => _loading = true);
    final uid = context.read<AuthService>().currentUser?.uid ?? '';
    final appointment = AppointmentModel(
      id: '',
      userId: uid,
      doctorId: widget.doctorId ?? '',
      doctorName: widget.doctorName ?? 'Unknown Doctor',
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      time: _selectedTime!,
      status: 'pending',
    );
    await FirestoreService().bookAppointment(appointment);
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Appointment booked successfully!'),
        backgroundColor: AppColors.success));
    context.go('/payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Appointment',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop()),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info card
            if (widget.doctorName != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.primaryLight.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.person_outline, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text('Dr. ${widget.doctorName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                ]),
              ),
            const SizedBox(height: 24),
            // ── Date Picker ─────────────────────────────────────────
            const Text('Select Date',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8)
                ],
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
            ),
            const SizedBox(height: 24),
            // ── Time Slots ──────────────────────────────────────────
            const Text('Select Time',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFDEE4F0)),
                      boxShadow: isSelected
                          ? []
                          : [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4)
                            ],
                    ),
                    child: Text(time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.bodyText,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Summary
            if (_selectedTime != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.success),
                  const SizedBox(width: 10),
                  Text(
                      '${DateFormat('EEE, MMM d').format(_selectedDate)}  ·  $_selectedTime',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success)),
                ]),
              ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Confirm Booking',
              onPressed: _confirmBooking,
              isLoading: _loading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
