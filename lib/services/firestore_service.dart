import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Doctor Queries ───────────────────────────────────────────────────
  // Stream of all doctors (real-time updates)
  Stream<List<DoctorModel>> getDoctors() {
    return _db.collection('doctors').snapshots().map(
          (snap) => snap.docs
              .map(
                (doc) => DoctorModel.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  // Stream of doctors filtered by gender ('male' or 'female')
  Stream<List<DoctorModel>> getDoctorsByGender(String gender) {
    return _db
        .collection('doctors')
        .where('gender', isEqualTo: gender)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get a single doctor by ID
  Future<DoctorModel?> getDoctor(String id) async {
    final doc = await _db.collection('doctors').doc(id).get();
    if (doc.exists) return DoctorModel.fromMap(doc.data()!, doc.id);
    return null;
  }

  // ── Appointment Queries ──────────────────────────────────────────────
  // Book a new appointment (writes to Firestore)
  Future<void> bookAppointment(AppointmentModel appointment) async {
    await _db.collection('appointments').add(appointment.toMap());
  }

  // Stream of appointments for a specific user
  Stream<List<AppointmentModel>> getUserAppointments(String userId) {
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Cancel an appointment (update status field)
  Future<void> cancelAppointment(String appointmentId) async {
    await _db.collection('appointments').doc(appointmentId).update({
      'status': 'cancelled',
    });
  }
}
