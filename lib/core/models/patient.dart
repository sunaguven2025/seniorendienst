class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String room;
  final String doctor;
  final String insurance;
  final String phone;
  final String emergencyContact;
  final List<String> diseases;
  final List<String> allergies;

  const Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.room,
    required this.doctor,
    required this.insurance,
    required this.phone,
    required this.emergencyContact,
    required this.diseases,
    required this.allergies,
  });

  String get fullName => "$firstName $lastName";
}
