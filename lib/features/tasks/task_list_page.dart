import 'package:flutter/material.dart';

import '../../core/models/task.dart';
import '../../core/services/firestore_service.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevler'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
        },
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Görev'),
      ),
      body: StreamBuilder<List<CareTask>>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Görevler yüklenirken bir hata oluştu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, size: 70, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Henüz görev bulunmuyor.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yeni görev oluşturmak için aşağıdaki + butonunu kullanın.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: tasks.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];

                return _buildTaskCard(context, task);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, CareTask task) {
    final statusColor = _statusColor(task.status);
    final statusText = _statusText(task.status);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.patientName.isEmpty
                              ? 'Hasta adı belirtilmemiş'
                              : task.patientName,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (task.type.isNotEmpty)
                          Text(
                            task.type,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _statusBadge(statusText, statusColor),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(task.date),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _timeRange(task),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (task.caregiverName.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Personel: ${task.caregiverName}')),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (task.patientSignatureRequired)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: 'Hasta imzası gerekli',
                        child: Icon(Icons.draw, color: Colors.blue),
                      ),
                    ),
                  if (task.patientBiometricRequired)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: 'Biyometrik doğrulama gerekli',
                        child: Icon(
                          Icons.fingerprint,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'tamamlandı':
        return Colors.green;

      case 'in_progress':
      case 'in-progress':
      case 'devam ediyor':
        return Colors.blue;

      case 'cancelled':
      case 'canceled':
      case 'iptal':
        return Colors.red;

      case 'pending':
      case 'bekliyor':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Tamamlandı';

      case 'in_progress':
      case 'in-progress':
        return 'Devam ediyor';

      case 'cancelled':
      case 'canceled':
        return 'İptal';

      case 'pending':
        return 'Bekliyor';

      case 'tamamlandı':
      case 'devam ediyor':
      case 'iptal':
      case 'bekliyor':
        return status;

      default:
        return status.isEmpty ? 'Belirsiz' : status;
    }
  }

  String _timeRange(CareTask task) {
    if (task.startTime.isEmpty && task.endTime.isEmpty) {
      return 'Saat belirtilmemiş';
    }

    if (task.startTime.isEmpty) {
      return task.endTime;
    }

    if (task.endTime.isEmpty) {
      return task.startTime;
    }

    return '${task.startTime} - ${task.endTime}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}
