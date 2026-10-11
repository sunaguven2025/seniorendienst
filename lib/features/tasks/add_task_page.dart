import 'package:flutter/material.dart';

import '../../core/models/patient.dart';
import '../../core/models/task.dart';
import '../../core/services/firestore_service.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  List<Patient> _patients = [];

  Patient? _selectedPatient;

  DateTime _selectedDate = DateTime.now();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String _taskType = 'Grundpflege';

  bool _patientSignatureRequired = true;
  bool _patientBiometricRequired = true;

  bool _loadingPatients = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _loadPatients();
  }

  // =========================================================
  // HASTALARI YÜKLE
  // =========================================================

  Future<void> _loadPatients() async {
    try {
      final patients = await _firestoreService.getPatients().first;

      if (!mounted) {
        return;
      }

      setState(() {
        _patients = patients;
        _loadingPatients = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingPatients = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hastalar yüklenirken hata oluştu:\n$e')),
      );
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Görev')),
      body: _loadingPatients
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final double availableWidth = constraints.maxWidth;

                final double contentWidth = availableWidth > 850
                    ? 850
                    : availableWidth;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionTitle('Görev Bilgileri', Icons.assignment),

                            const SizedBox(height: 16),

                            _buildPatientDropdown(),

                            const SizedBox(height: 16),

                            _buildTaskTypeDropdown(),

                            const SizedBox(height: 16),

                            _buildDatePicker(),

                            const SizedBox(height: 16),

                            _buildTimeSection(),

                            const SizedBox(height: 16),

                            _buildDescriptionField(),

                            const SizedBox(height: 16),

                            _buildNoteField(),

                            const SizedBox(height: 24),

                            _sectionTitle(
                              'Hasta Doğrulama',
                              Icons.verified_user,
                            ),

                            const SizedBox(height: 8),

                            _buildVerificationCard(),

                            const SizedBox(height: 30),

                            _buildSaveButton(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // =========================================================
  // BÖLÜM BAŞLIĞI
  // =========================================================

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // HASTA SEÇİMİ
  // =========================================================

  Widget _buildPatientDropdown() {
    return DropdownButtonFormField<Patient>(
      initialValue: _selectedPatient,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Hasta',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.elderly),
      ),
      validator: (value) {
        if (value == null) {
          return 'Lütfen hasta seçin.';
        }

        return null;
      },
      items: _patients.map((patient) {
        return DropdownMenuItem<Patient>(
          value: patient,
          child: Text(patient.fullName, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (patient) {
        setState(() {
          _selectedPatient = patient;
        });
      },
    );
  }

  // =========================================================
  // GÖREV TÜRÜ
  // =========================================================

  Widget _buildTaskTypeDropdown() {
    const taskTypes = [
      'Grundpflege',
      'Körperpflege',
      'Medikamentengabe',
      'Hauswirtschaft',
      'Begleitung',
      'Einkauf',
      'Arztbesuch',
      'Sonstiges',
    ];

    return DropdownButtonFormField<String>(
      initialValue: _taskType,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Görev Türü',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: taskTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }

        setState(() {
          _taskType = value;
        });
      },
    );
  }

  // =========================================================
  // TARİH
  // =========================================================

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Tarih',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(_formatDate(_selectedDate)),
      ),
    );
  }

  // =========================================================
  // SAATLER
  // =========================================================

  Widget _buildTimeSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        if (width < 500) {
          return Column(
            children: [
              _buildStartTimePicker(),

              const SizedBox(height: 16),

              _buildEndTimePicker(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: _buildStartTimePicker()),

            const SizedBox(width: 12),

            Expanded(child: _buildEndTimePicker()),
          ],
        );
      },
    );
  }

  // =========================================================
  // BAŞLANGIÇ SAATİ
  // =========================================================

  Widget _buildStartTimePicker() {
    return InkWell(
      onTap: () => _selectTime(isStartTime: true),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Başlangıç',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(_startTime == null ? 'Seçiniz' : _formatTime(_startTime!)),
      ),
    );
  }

  // =========================================================
  // BİTİŞ SAATİ
  // =========================================================

  Widget _buildEndTimePicker() {
    return InkWell(
      onTap: () => _selectTime(isStartTime: false),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Bitiş',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time_filled),
        ),
        child: Text(_endTime == null ? 'Seçiniz' : _formatTime(_endTime!)),
      ),
    );
  }

  // =========================================================
  // AÇIKLAMA
  // =========================================================

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Açıklama',
        hintText: 'Görev hakkında açıklama...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
    );
  }

  // =========================================================
  // NOT
  // =========================================================

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Not',
        hintText: 'Eklemek istediğiniz not...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
        alignLabelWithHint: true,
      ),
    );
  }

  // =========================================================
  // DOĞRULAMA KARTI
  // =========================================================

  Widget _buildVerificationCard() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.draw),
            title: const Text('Hasta imzası gerekli'),
            subtitle: const Text('Görev tamamlanırken hasta imzası alınır.'),
            value: _patientSignatureRequired,
            onChanged: (value) {
              setState(() {
                _patientSignatureRequired = value;
              });
            },
          ),

          const Divider(height: 1),

          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Biyometrik doğrulama gerekli'),
            subtitle: const Text(
              'Görev tamamlanırken biyometrik doğrulama yapılır.',
            ),
            value: _patientBiometricRequired,
            onChanged: (value) {
              setState(() {
                _patientBiometricRequired = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // KAYDET BUTONU
  // =========================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _saving ? null : _saveTask,
        icon: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(_saving ? 'Kaydediliyor...' : 'Görevi Kaydet'),
      ),
    );
  }

  // =========================================================
  // TARİH SEÇ
  // =========================================================

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  // =========================================================
  // SAAT SEÇ
  // =========================================================

  Future<void> _selectTime({required bool isStartTime}) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    setState(() {
      if (isStartTime) {
        _startTime = selectedTime;
      } else {
        _endTime = selectedTime;
      }
    });
  }

  // =========================================================
  // GÖREVİ KAYDET
  // =========================================================

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startTime == null) {
      _showMessage('Lütfen başlangıç saatini seçin.');
      return;
    }

    if (_endTime == null) {
      _showMessage('Lütfen bitiş saatini seçin.');
      return;
    }

    if (!_isEndTimeAfterStartTime()) {
      _showMessage('Bitiş saati başlangıç saatinden sonra olmalıdır.');
      return;
    }

    final patient = _selectedPatient;

    if (patient == null) {
      _showMessage('Lütfen hasta seçin.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final now = DateTime.now();

      final task = CareTask(
        id: '',
        patientId: patient.id,
        patientName: patient.fullName,
        caregiverId: '',
        caregiverName: '',
        date: _selectedDate,
        startTime: _formatTime(_startTime!),
        endTime: _formatTime(_endTime!),
        type: _taskType,
        description: _descriptionController.text.trim(),
        status: 'pending',
        completedAt: null,
        note: _noteController.text.trim(),
        patientSignatureRequired: _patientSignatureRequired,
        patientSignatureUrl: '',
        patientBiometricRequired: _patientBiometricRequired,
        patientBiometricVerified: false,
        patientBiometricVerifiedAt: null,
        createdAt: now,
        updatedAt: now,
      );

      await _firestoreService.addTask(task);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Görev başarıyla oluşturuldu.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Görev kaydedilirken hata oluştu:\n$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // =========================================================
  // SAAT KONTROLÜ
  // =========================================================

  bool _isEndTimeAfterStartTime() {
    if (_startTime == null || _endTime == null) {
      return false;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;

    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    return endMinutes > startMinutes;
  }

  // =========================================================
  // MESAJ
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // =========================================================
  // TARİH FORMAT
  // =========================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  // =========================================================
  // SAAT FORMAT
  // =========================================================

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _descriptionController.dispose();
    _noteController.dispose();

    super.dispose();
  }
}
