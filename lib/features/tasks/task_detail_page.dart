import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../core/models/task.dart';
import '../../core/services/firestore_service.dart';
import 'biometric_auth_page.dart';
import 'patient_signature_page.dart';

class TaskDetailPage extends StatefulWidget {
  final CareTask task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _noteController = TextEditingController();

  bool _processing = false;
  bool _signatureCompleted = false;
  bool _biometricCompleted = false;

  @override
  void initState() {
    super.initState();

    _signatureCompleted = widget.task.patientSignatureUrl.isNotEmpty;
    _biometricCompleted = widget.task.patientBiometricVerified;

    _noteController.text = widget.task.note;
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    final bool isCompleted = task.status.toLowerCase() == 'completed';

    return Scaffold(
      appBar: AppBar(title: const Text('Görev Detayı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(context, task),

            const SizedBox(height: 16),

            _buildPatientCard(context, task),

            const SizedBox(height: 16),

            _buildTaskInformation(context, task),

            const SizedBox(height: 16),

            _buildApprovalCard(context, task, isCompleted),

            const SizedBox(height: 16),

            _buildNoteSection(isCompleted),

            const SizedBox(height: 24),

            if (!isCompleted)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _processing ? null : _completeTask,
                  icon: _processing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    _processing ? 'Kaydediliyor...' : 'Görevi Tamamla',
                  ),
                ),
              ),

            if (isCompleted)
              Card(
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bu görev tamamlandı.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DURUM
  // =========================================================

  Widget _buildStatusCard(BuildContext context, CareTask task) {
    final bool completed = task.status.toLowerCase() == 'completed';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              child: Icon(completed ? Icons.check : Icons.pending_actions),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Görev Durumu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    completed ? 'Tamamlandı' : _statusText(task.status),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: completed ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HASTA
  // =========================================================

  Widget _buildPatientCard(BuildContext context, CareTask task) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.elderly),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hasta',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                task.patientName.isEmpty
                    ? 'Hasta adı belirtilmemiş'
                    : task.patientName,
              ),
              subtitle: Text('Hasta ID: ${task.patientId}'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // GÖREV BİLGİLERİ
  // =========================================================

  Widget _buildTaskInformation(BuildContext context, CareTask task) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Görev Bilgileri',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _infoRow(Icons.category, 'Görev türü', task.type),

            _infoRow(Icons.calendar_today, 'Tarih', _formatDate(task.date)),

            _infoRow(
              Icons.access_time,
              'Saat',
              '${task.startTime} - ${task.endTime}',
            ),

            _infoRow(Icons.person_outline, 'Bakıcı', task.caregiverName),

            if (task.description.isNotEmpty)
              _infoRow(Icons.description, 'Açıklama', task.description),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ONAY KARTI
  // =========================================================

  Widget _buildApprovalCard(
    BuildContext context,
    CareTask task,
    bool isCompleted,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hasta Onayı',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _buildSignatureApproval(context, task, isCompleted),

            const SizedBox(height: 12),

            _buildBiometricApproval(context, task, isCompleted),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // İMZA
  // =========================================================

  Widget _buildSignatureApproval(
    BuildContext context,
    CareTask task,
    bool isCompleted,
  ) {
    final bool required = task.patientSignatureRequired;

    final bool completed =
        _signatureCompleted || task.patientSignatureUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: completed
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                child: Icon(
                  completed ? Icons.check : Icons.draw,
                  color: completed ? Colors.green : Colors.black87,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hasta İmzası',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completed
                          ? 'İmza alındı'
                          : required
                          ? 'İmza gerekli'
                          : 'İmza isteğe bağlı',
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!completed && !isCompleted) ...[
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _openSignaturePage,
                icon: const Icon(Icons.draw),
                label: const Text('Hasta İmzası Al'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // BİYOMETRİK
  // =========================================================

  Widget _buildBiometricApproval(
    BuildContext context,
    CareTask task,
    bool isCompleted,
  ) {
    final bool required = task.patientBiometricRequired;

    final bool completed = _biometricCompleted || task.patientBiometricVerified;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: completed
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                child: Icon(
                  completed ? Icons.check : Icons.fingerprint,
                  color: completed ? Colors.green : Colors.black87,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biyometrik Onay',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completed
                          ? 'Biyometrik doğrulama yapıldı'
                          : required
                          ? 'Biyometrik doğrulama gerekli'
                          : 'Biyometrik doğrulama isteğe bağlı',
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (!completed && !isCompleted) ...[
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _openBiometricPage,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Biyometrik Doğrulama'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // NOT
  // =========================================================

  Widget _buildNoteSection(bool isCompleted) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.note_alt),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Görev Notu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _noteController,
              maxLines: 4,
              readOnly: isCompleted,
              decoration: InputDecoration(
                hintText: 'Görevle ilgili not ekleyebilirsiniz...',
                border: const OutlineInputBorder(),
                filled: isCompleted,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // İMZA SAYFASI
  // =========================================================

  Future<void> _openSignaturePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatientSignaturePage()),
    );

    // Kullanıcı geri döndüyse
    if (result == null) return;

    // Sonucu Uint8List'e çevir
    Uint8List? signatureBytes;

    if (result is Uint8List) {
      signatureBytes = result;
    } else if (result is Uint8ListResult) {
      signatureBytes = result.bytes as Uint8List;
    }

    if (signatureBytes == null || signatureBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("İmza alınamadı."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      // Firebase Storage'a yükle
      final signatureUrl = await _firestoreService.uploadPatientSignature(
        taskId: widget.task.id,
        signatureBytes: signatureBytes,
      );

      // Firestore'da göreve kaydet
      await _firestoreService.savePatientSignature(
        taskId: widget.task.id,
        signatureUrl: signatureUrl,
      );

      if (!mounted) return;

      setState(() {
        _signatureCompleted = true;
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hasta imzası başarıyla kaydedildi."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("İmza kaydedilirken hata oluştu:\n$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =========================================================
  // BİYOMETRİK SAYFASI
  // =========================================================

  Future<void> _openBiometricPage() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const BiometricAuthPage()),
    );

    if (result != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      await _firestoreService.saveBiometricVerification(taskId: widget.task.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _biometricCompleted = true;
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biyometrik doğrulama başarıyla tamamlandı.'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Biyometrik doğrulama kaydedilirken hata oluştu:\n$e'),
        ),
      );
    }
  }

  // =========================================================
  // GÖREVİ TAMAMLA
  // =========================================================

  Future<void> _completeTask() async {
    final bool signatureRequired = widget.task.patientSignatureRequired;

    final bool biometricRequired = widget.task.patientBiometricRequired;

    final bool signatureDone =
        _signatureCompleted || widget.task.patientSignatureUrl.isNotEmpty;

    final bool biometricDone =
        _biometricCompleted || widget.task.patientBiometricVerified;

    if (signatureRequired && !signatureDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görevi tamamlamak için hasta imzası gereklidir.'),
        ),
      );

      return;
    }

    if (biometricRequired && !biometricDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Görevi tamamlamak için biyometrik doğrulama gereklidir.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      await _firestoreService.completeTaskWithPatientApproval(
  taskId: widget.task.id,
  note: _noteController.text.trim(),
);

if (!mounted) return;

setState(() {
  _processing = false;
});

final messenger = ScaffoldMessenger.of(context);

messenger.showSnackBar(
  const SnackBar(
    content: Text('Görev başarıyla tamamlandı.'),
    backgroundColor: Colors.green,
  ),
);

Navigator.of(context).pop(true);

      setState(() {
        _processing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görev tamamlanırken hata oluştu:\n$e')),
      );
    }
  }

  // =========================================================
  // BİLGİ SATIRI
  // =========================================================

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 3),

                Text(value.isEmpty ? 'Bilgi girilmemiş' : value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DURUM METNİ
  // =========================================================

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Bekliyor';

      case 'in_progress':
        return 'Devam ediyor';

      case 'completed':
        return 'Tamamlandı';

      case 'cancelled':
        return 'İptal edildi';

      default:
        return status.isEmpty ? 'Belirtilmemiş' : status;
    }
  }

  // =========================================================
  // TARİH
  // =========================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

/// Hasta imzasından dönen sonucu temsil eder.
///
/// PatientSignaturePage doğrudan Uint8List veya
/// bu yardımcı sınıfı döndürebilir.
class Uint8ListResult {
  final dynamic bytes;

  const Uint8ListResult(this.bytes);
}
