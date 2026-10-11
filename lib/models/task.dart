import 'package:cloud_firestore/cloud_firestore.dart';

class CareTask {
  final String id;

  final String patientId;
  final String patientName;

  final String caregiverId;
  final String caregiverName;

  final DateTime date;

  final String startTime;
  final String endTime;

  final String type;
  final String description;

  final String status;
  final DateTime? completedAt;

  final String note;

  // Hasta imzası
  final bool patientSignatureRequired;
  final String patientSignatureUrl;

  // YENİ (Storage yerine Firestore Base64)
  final String patientSignatureBase64;

  // Biyometrik
  final bool patientBiometricRequired;
  final bool patientBiometricVerified;
  final DateTime? patientBiometricVerifiedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  const CareTask({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.caregiverId,
    required this.caregiverName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.description,
    required this.status,
    required this.completedAt,
    required this.note,
    required this.patientSignatureRequired,
    required this.patientSignatureUrl,
    required this.patientSignatureBase64,
    required this.patientBiometricRequired,
    required this.patientBiometricVerified,
    required this.patientBiometricVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CareTask.fromMap(String id, Map<String, dynamic> map) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;

      if (value is Timestamp) return value.toDate();

      if (value is String) return DateTime.tryParse(value);

      return null;
    }

    return CareTask(
      id: id,
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      caregiverName: map['caregiverName'] ?? '',
      date: parseDate(map['date']) ?? DateTime.now(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      completedAt: parseDate(map['completedAt']),
      note: map['note'] ?? '',
      patientSignatureRequired: map['patientSignatureRequired'] ?? false,
      patientSignatureUrl: map['patientSignatureUrl'] ?? '',
      patientSignatureBase64: map['patientSignatureBase64'] ?? '',
      patientBiometricRequired: map['patientBiometricRequired'] ?? false,
      patientBiometricVerified: map['patientBiometricVerified'] ?? false,
      patientBiometricVerifiedAt: parseDate(map['patientBiometricVerifiedAt']),
      createdAt: parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(map['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'caregiverId': caregiverId,
      'caregiverName': caregiverName,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
      'description': description,
      'status': status,
      'completedAt': completedAt == null
          ? null
          : Timestamp.fromDate(completedAt!),
      'note': note,
      'patientSignatureRequired': patientSignatureRequired,
      'patientSignatureUrl': patientSignatureUrl,
      'patientSignatureBase64': patientSignatureBase64,
      'patientBiometricRequired': patientBiometricRequired,
      'patientBiometricVerified': patientBiometricVerified,
      'patientBiometricVerifiedAt': patientBiometricVerifiedAt == null
          ? null
          : Timestamp.fromDate(patientBiometricVerifiedAt!),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  CareTask copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? caregiverId,
    String? caregiverName,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? type,
    String? description,
    String? status,
    DateTime? completedAt,
    String? note,
    bool? patientSignatureRequired,
    String? patientSignatureUrl,
    String? patientSignatureBase64,
    bool? patientBiometricRequired,
    bool? patientBiometricVerified,
    DateTime? patientBiometricVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CareTask(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      caregiverId: caregiverId ?? this.caregiverId,
      caregiverName: caregiverName ?? this.caregiverName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      description: description ?? this.description,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      patientSignatureRequired:
          patientSignatureRequired ?? this.patientSignatureRequired,
      patientSignatureUrl: patientSignatureUrl ?? this.patientSignatureUrl,
      patientSignatureBase64:
          patientSignatureBase64 ?? this.patientSignatureBase64,
      patientBiometricRequired:
          patientBiometricRequired ?? this.patientBiometricRequired,
      patientBiometricVerified:
          patientBiometricVerified ?? this.patientBiometricVerified,
      patientBiometricVerifiedAt:
          patientBiometricVerifiedAt ?? this.patientBiometricVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
