import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final String doctorName;
  final String date;
  final String time;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final Timestamp? createdAt;

  const AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.status,
    this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      userId: map['userId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'date': date,
        'time': time,
        'status': status,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };
}
