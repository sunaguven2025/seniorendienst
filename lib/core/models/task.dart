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

  // ---------------------------------------------------------
  // HASTA İMZASI
  // ---------------------------------------------------------

  final bool patientSignatureRequired;
  final String patientSignatureUrl;

  // ---------------------------------------------------------
  // BİYOMETRİK DOĞRULAMA
  // ---------------------------------------------------------

  final bool patientBiometricRequired;
  final bool patientBiometricVerified;
  final DateTime? patientBiometricVerifiedAt;

  // ---------------------------------------------------------
  // TARİHLER
  // ---------------------------------------------------------

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

    required this.patientBiometricRequired,
    required this.patientBiometricVerified,
    required this.patientBiometricVerifiedAt,

    required this.createdAt,
    required this.updatedAt,
  });

  // ---------------------------------------------------------
  // FIRESTORE -> CARETASK
  // ---------------------------------------------------------

  factory CareTask.fromMap(String id, Map<String, dynamic> map) {
    return CareTask(
      id: id,

      patientId: _stringValue(map['patientId']),

      patientName: _stringValue(map['patientName']),

      caregiverId: _stringValue(map['caregiverId']),

      caregiverName: _stringValue(map['caregiverName']),

      date: _dateValue(map['date']),

      startTime: _stringValue(map['startTime']),

      endTime: _stringValue(map['endTime']),

      type: _stringValue(map['type']),

      description: _stringValue(map['description']),

      status: _stringValue(map['status']),

      completedAt: _nullableDateValue(map['completedAt']),

      note: _stringValue(map['note']),

      // -----------------------------------------------------
      // İMZA
      // -----------------------------------------------------
      patientSignatureRequired: map['patientSignatureRequired'] == true,

      patientSignatureUrl: _stringValue(map['patientSignatureUrl']),

      // -----------------------------------------------------
      // BİYOMETRİK
      // -----------------------------------------------------
      patientBiometricRequired: map['patientBiometricRequired'] == true,

      patientBiometricVerified: map['patientBiometricVerified'] == true,

      patientBiometricVerifiedAt: _nullableDateValue(
        map['patientBiometricVerifiedAt'],
      ),

      // -----------------------------------------------------
      // TARİHLER
      // -----------------------------------------------------
      createdAt: _dateValue(map['createdAt']),

      updatedAt: _dateValue(map['updatedAt']),
    );
  }

  // ---------------------------------------------------------
  // CARETASK -> FIRESTORE
  // ---------------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,

      'caregiverId': caregiverId,
      'caregiverName': caregiverName,

      'date': date.toIso8601String(),

      'startTime': startTime,
      'endTime': endTime,

      'type': type,
      'description': description,

      'status': status,

      'completedAt': completedAt?.toIso8601String(),

      'note': note,

      // -----------------------------------------------------
      // İMZA
      // -----------------------------------------------------
      'patientSignatureRequired': patientSignatureRequired,

      'patientSignatureUrl': patientSignatureUrl,

      // -----------------------------------------------------
      // BİYOMETRİK
      // -----------------------------------------------------
      'patientBiometricRequired': patientBiometricRequired,

      'patientBiometricVerified': patientBiometricVerified,

      'patientBiometricVerifiedAt': patientBiometricVerifiedAt
          ?.toIso8601String(),

      // -----------------------------------------------------
      // TARİHLER
      // -----------------------------------------------------
      'createdAt': createdAt.toIso8601String(),

      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ---------------------------------------------------------
  // COPY WITH
  // ---------------------------------------------------------

  CareTask copyWith({
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
    bool clearCompletedAt = false,

    String? note,

    // -------------------------------------------------------
    // İMZA
    // -------------------------------------------------------
    bool? patientSignatureRequired,
    String? patientSignatureUrl,

    // -------------------------------------------------------
    // BİYOMETRİK
    // -------------------------------------------------------
    bool? patientBiometricRequired,
    bool? patientBiometricVerified,
    DateTime? patientBiometricVerifiedAt,
    bool clearPatientBiometricVerifiedAt = false,

    // -------------------------------------------------------
    // TARİH
    // -------------------------------------------------------
    DateTime? updatedAt,
  }) {
    return CareTask(
      id: id,

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

      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,

      note: note ?? this.note,

      // -------------------------------------------------------
      // İMZA
      // -------------------------------------------------------
      patientSignatureRequired:
          patientSignatureRequired ?? this.patientSignatureRequired,

      patientSignatureUrl: patientSignatureUrl ?? this.patientSignatureUrl,

      // -------------------------------------------------------
      // BİYOMETRİK
      // -------------------------------------------------------
      patientBiometricRequired:
          patientBiometricRequired ?? this.patientBiometricRequired,

      patientBiometricVerified:
          patientBiometricVerified ?? this.patientBiometricVerified,

      patientBiometricVerifiedAt: clearPatientBiometricVerifiedAt
          ? null
          : patientBiometricVerifiedAt ?? this.patientBiometricVerifiedAt,

      // -------------------------------------------------------
      // TARİH
      // -------------------------------------------------------
      createdAt: createdAt,

      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

// =========================================================
// YARDIMCI FONKSİYONLAR
// =========================================================

String _stringValue(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString();
}

// =========================================================
// TARİH
// =========================================================

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

// =========================================================
// NULLABLE TARİH
// =========================================================

DateTime? _nullableDateValue(dynamic value) {
  if (value == null) {
    return null;
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
    return DateTime.tryParse(value);
  }

  return null;
}
