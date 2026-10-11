import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/patient.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================================================
  // HASTALAR
  // =========================================================

  CollectionReference<Map<String, dynamic>> get _patientsCollection =>
      _firestore.collection('patients');

  Stream<List<Patient>> getPatients() {
    return _patientsCollection.orderBy('firstName').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Patient.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<Patient?> getPatient(String patientId) async {
    final document = await _patientsCollection.doc(patientId).get();

    if (!document.exists) return null;

    final data = document.data();

    if (data == null) return null;

    return Patient.fromMap(document.id, data);
  }

  Future<String> addPatient(Patient patient) async {
    final document = await _patientsCollection.add(patient.toMap());

    return document.id;
  }

  Future<void> updatePatient(Patient patient) async {
    await _patientsCollection.doc(patient.id).update(patient.toMap());
  }

  Future<void> deletePatient(String patientId) async {
    await _patientsCollection.doc(patientId).delete();
  }

  // =========================================================
  // GÖREVLER
  // =========================================================

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  Stream<List<CareTask>> getTasks() {
    return _tasksCollection.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CareTask.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<CareTask?> getTask(String taskId) async {
    final document = await _tasksCollection.doc(taskId).get();

    if (!document.exists) return null;

    final data = document.data();

    if (data == null) return null;

    return CareTask.fromMap(document.id, data);
  }

  Future<String> addTask(CareTask task) async {
    final document = await _tasksCollection.add(task.toMap());

    return document.id;
  }

  Future<void> updateTask(CareTask task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // =========================================================
  // GÖREV DURUMU
  // =========================================================

  Future<void> updateTaskStatus({
    required String taskId,
    required String status,
    String note = '',
  }) async {
    final now = DateTime.now();

    final data = <String, dynamic>{
      'status': status,
      'note': note,
      'updatedAt': Timestamp.fromDate(now),
    };

    if (status == 'completed') {
      data['completedAt'] = Timestamp.fromDate(now);
    } else {
      data['completedAt'] = null;
    }

    await _tasksCollection.doc(taskId).update(data);
  }

  // =========================================================
  // HASTA İMZASI (FIRESTORE BASE64)
  // =========================================================

  Future<String> uploadPatientSignature({
    required String taskId,
    required Uint8List signatureBytes,
  }) async {
    if (taskId.trim().isEmpty) {
      throw Exception('Görev ID bulunamadı.');
    }

    if (signatureBytes.isEmpty) {
      throw Exception('İmza boş.');
    }

    // Firebase Storage yerine Base64 döndür.
    return base64Encode(signatureBytes);
  }

  // =========================================================
  // İMZAYI GÖREVE KAYDET
  // =========================================================

  Future<void> savePatientSignature({
    required String taskId,
    required String signatureUrl,
  }) async {
    await _tasksCollection.doc(taskId).update({
      'patientSignatureRequired': true,

      // Eski alan boş bırakılıyor.
      'patientSignatureUrl': '',

      // Yeni alan
      'patientSignatureBase64': signatureUrl,

      'updatedAt': Timestamp.now(),
    });
  }

  // =========================================================
  // BİYOMETRİK ONAY
  // =========================================================

  Future<void> saveBiometricVerification({required String taskId}) async {
    final now = Timestamp.now();

    await _tasksCollection.doc(taskId).update({
      'patientBiometricVerified': true,
      'patientBiometricVerifiedAt': now,
      'updatedAt': now,
    });
  }

  // =========================================================
  // GÖREVİ TAMAMLA
  // =========================================================

  Future<void> completeTaskWithPatientApproval({
    required String taskId,
    String note = '',
  }) async {
    final now = Timestamp.now();

    await _tasksCollection.doc(taskId).update({
      'status': 'completed',
      'note': note,
      'completedAt': now,
      'updatedAt': now,
    });
  }

  // =========================================================
  // GÖREV NOTU
  // =========================================================

  Future<void> saveTaskNote({
    required String taskId,
    required String note,
  }) async {
    await _tasksCollection.doc(taskId).update({
      'note': note,
      'updatedAt': Timestamp.now(),
    });
  }
}
