class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String gender; // 'male' or 'female'
  final String imageUrl;
  final String about;
  final double rating;
  final int experience; // years
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
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      gender: map['gender'] ?? 'male',
      imageUrl: map['imageUrl'] ?? '',
      about: map['about'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      experience: map['experience'] ?? 0,
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
