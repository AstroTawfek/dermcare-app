class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String gender;
  final String imageUrl;
  final String about;
  final double rating;
  final int experience;
  final List<String> availableDays;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.gender,
    required this.imageUrl,
    required this.about,
    required this.rating,
    required this.experience,
    required this.availableDays,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> map, String id) {
    return DoctorModel(
      id: id,
      name: map['name']?.toString() ?? '',
      specialty: map['specialty']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'male',
      imageUrl: map['imageUrl']?.toString() ?? '',
      about: map['about']?.toString() ?? '',
      // Fix: handles both int and double from Firestore
      rating: (map['rating'] ?? 0).toDouble(),
      // Fix: handles both int and double from Firestore
      experience: (map['experience'] ?? 0).toInt(),
      availableDays: List<String>.from(map['availableDays'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'specialty': specialty,
        'gender': gender,
        'imageUrl': imageUrl,
        'about': about,
        'rating': rating,
        'experience': experience,
        'availableDays': availableDays,
      };
}
