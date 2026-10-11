import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;

  final String firstName;
  final String lastName;

  final DateTime birthDate;

  final String gender;

  final String doctor;
  final String insurance;

  final String phone;

  final String emergencyContact;
  final String emergencyPhone;
  final String relationship;

  final String careLevel;

  final String city;
  final String postalCode;
  final String address;

  final double latitude;
  final double longitude;

  final String photoUrl;

  final List<String> diseases;
  final List<String> allergies;

  final DateTime createdAt;
  final DateTime updatedAt;

  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.doctor,
    required this.insurance,
    required this.phone,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.relationship,
    required this.careLevel,
    required this.city,
    required this.postalCode,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
    required this.diseases,
    required this.allergies,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory Patient.fromMap(String id, Map<String, dynamic> map) {
    return Patient(
      id: id,

      firstName: _stringValue(map['firstName']),
      lastName: _stringValue(map['lastName']),

      birthDate: _dateValue(map['birthDate']),

      gender: _stringValue(map['gender']),

      doctor: _stringValue(map['doctor']),
      insurance: _stringValue(map['insurance']),

      phone: _stringValue(map['phone']),

      emergencyContact: _stringValue(map['emergencyContact']),

      emergencyPhone: _stringValue(map['emergencyPhone']),

      relationship: _stringValue(map['relationship']),

      careLevel: _stringValue(map['careLevel']),

      city: _stringValue(map['city']),

      postalCode: _stringValue(map['postalCode']),

      address: _stringValue(map['address']),

      latitude: _doubleValue(map['latitude']),

      longitude: _doubleValue(map['longitude']),

      photoUrl: _stringValue(map['photoUrl']),

      diseases: _stringList(map['diseases']),

      allergies: _stringList(map['allergies']),

      createdAt: _dateValue(map['createdAt']),

      updatedAt: _dateValue(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,

      'birthDate': birthDate.toIso8601String(),

      'gender': gender,

      'doctor': doctor,
      'insurance': insurance,

      'phone': phone,

      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'relationship': relationship,

      'careLevel': careLevel,

      'city': city,
      'postalCode': postalCode,
      'address': address,

      'latitude': latitude,
      'longitude': longitude,

      'photoUrl': photoUrl,

      'diseases': diseases,
      'allergies': allergies,

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Patient copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? doctor,
    String? insurance,
    String? phone,
    String? emergencyContact,
    String? emergencyPhone,
    String? relationship,
    String? careLevel,
    String? city,
    String? postalCode,
    String? address,
    double? latitude,
    double? longitude,
    String? photoUrl,
    List<String>? diseases,
    List<String>? allergies,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id,

      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,

      birthDate: birthDate ?? this.birthDate,

      gender: gender ?? this.gender,

      doctor: doctor ?? this.doctor,
      insurance: insurance ?? this.insurance,

      phone: phone ?? this.phone,

      emergencyContact: emergencyContact ?? this.emergencyContact,

      emergencyPhone: emergencyPhone ?? this.emergencyPhone,

      relationship: relationship ?? this.relationship,

      careLevel: careLevel ?? this.careLevel,

      city: city ?? this.city,

      postalCode: postalCode ?? this.postalCode,

      address: address ?? this.address,

      latitude: latitude ?? this.latitude,

      longitude: longitude ?? this.longitude,

      photoUrl: photoUrl ?? this.photoUrl,

      diseases: diseases ?? this.diseases,

      allergies: allergies ?? this.allergies,

      createdAt: createdAt,

      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

// ---------------------------------------------------------
// Yardımcı fonksiyonlar
// ---------------------------------------------------------

String _stringValue(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString();
}

double _doubleValue(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

List<String> _stringList(dynamic value) {
  if (value == null) {
    return [];
  }

  // Firestore'da gerçek liste olarak kayıtlıysa
  if (value is Iterable) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // Eski kayıtlarda String olarak kayıt edilmişse
  if (value is String) {
    final text = value.trim();

    if (text.isEmpty) {
      return [];
    }

    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return [];
}

DateTime _dateValue(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }

  // Firestore Timestamp
  if (value is Timestamp) {
    return value.toDate();
  }

  // DateTime
  if (value is DateTime) {
    return value;
  }

  // String
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  return DateTime.now();
}
