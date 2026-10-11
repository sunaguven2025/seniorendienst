import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/models/patient.dart';
import '../../core/services/firestore_service.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();

  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  final _doctorController = TextEditingController();
  final _insuranceController = TextEditingController();

  final _careLevelController = TextEditingController();

  final _diseasesController = TextEditingController();
  final _allergiesController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  DateTime? _birthDate;

  String _gender = '';

  double? _latitude;
  double? _longitude;

  bool _saving = false;
  bool _gettingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Hasta')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle('Persönliche Informationen', Icons.person),

              const SizedBox(height: 12),

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _gender.isEmpty ? null : _gender,
                decoration: const InputDecoration(
                  labelText: 'Cinsiyet',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
                  DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
                  DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value ?? '';
                  });
                },
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: _selectBirthDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Doğum tarihi',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _birthDate == null
                        ? 'Tarih seçin'
                        : _formatDate(_birthDate!),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle('Adres ve Konum', Icons.location_on),

              const SizedBox(height: 12),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  hintText: 'Örn. Musterstraße 12',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'PLZ',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Şehir',
                  border: OutlineInputBorder(),
                ),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: _gettingLocation ? null : _getCurrentLocation,
                icon: _gettingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _gettingLocation ? 'Konum alınıyor...' : 'Konumumu Al',
                ),
              ),

              const SizedBox(height: 12),

              _buildLocationStatus(),

              const SizedBox(height: 24),

              _sectionTitle('Angehöriger', Icons.people),

              const SizedBox(height: 12),

              TextFormField(
                controller: _emergencyContactController,
                decoration: const InputDecoration(
                  labelText: 'Yakının adı',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _emergencyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Yakının telefonu',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Yakınlık derecesi',
                  hintText: 'Örn. Kızı, Oğlu, Eşi',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle(
                'Medizinische Informationen',
                Icons.medical_information,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _careLevelController,
                decoration: const InputDecoration(
                  labelText: 'Pflegegrad',
                  hintText: 'Örn. Pflegegrad 3',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(
                  labelText: 'Doktor',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _insuranceController,
                decoration: const InputDecoration(
                  labelText: 'Krankenkasse',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _diseasesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Hastalıklar',
                  hintText: 'Virgülle ayırabilirsiniz',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _allergiesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Alerjiler',
                  hintText: 'Virgülle ayırabilirsiniz',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _savePatient,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_saving ? 'Kaydediliyor...' : 'Hastayı Kaydet'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    if (_latitude == null || _longitude == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.withValues(alpha: 0.10),
        ),
        child: const Row(
          children: [
            Icon(Icons.location_off),
            SizedBox(width: 10),
            Expanded(child: Text('GPS konumu henüz alınmadı.')),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green.withValues(alpha: 0.10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'GPS konumu alındı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Enlem: ${_latitude!.toStringAsFixed(6)}'),
          Text('Boylam: ${_longitude!.toStringAsFixed(6)}'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur';
    }

    return null;
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 70, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (selectedDate != null) {
      setState(() {
        _birthDate = selectedDate;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _gettingLocation = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        await _showLocationMessage(
          'Konum hizmetleri kapalı.\n\n'
          'Lütfen telefonunuzun konum/GPS özelliğini açın.',
        );

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) {
          return;
        }

        await _showLocationMessage('Konum izni verilmedi.');

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) {
          return;
        }

        await _showLocationMessage(
          'Konum izni kalıcı olarak reddedilmiş.\n\n'
          'Telefon ayarlarından uygulamaya konum izni '
          'vermeniz gerekiyor.',
        );

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS konumu başarıyla alındı.')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      await _showLocationMessage('Konum alınırken hata oluştu:\n\n$e');
    } finally {
      if (mounted) {
        setState(() {
          _gettingLocation = false;
        });
      }
    }
  }

  Future<void> _showLocationMessage(String message) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konum Bilgisi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen doğum tarihini seçin.')),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final now = DateTime.now();

      final patient = Patient(
        id: '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDate!,
        gender: _gender,
        doctor: _doctorController.text.trim(),
        insurance: _insuranceController.text.trim(),
        phone: _phoneController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
        emergencyPhone: _emergencyPhoneController.text.trim(),
        relationship: _relationshipController.text.trim(),
        careLevel: _careLevelController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        address: _addressController.text.trim(),
        latitude: _latitude ?? 0,
        longitude: _longitude ?? 0,
        photoUrl: '',
        diseases: _parseList(_diseasesController.text),
        allergies: _parseList(_allergiesController.text),
        createdAt: now,
        updatedAt: now,
      );

      await _firestoreService.addPatient(patient);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hasta başarıyla kaydedildi.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hasta kaydedilirken hata oluştu:\n$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  List<String> _parseList(String text) {
    if (text.trim().isEmpty) {
      return [];
    }

    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();

    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();

    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _relationshipController.dispose();

    _doctorController.dispose();
    _insuranceController.dispose();
    _careLevelController.dispose();

    _diseasesController.dispose();
    _allergiesController.dispose();

    super.dispose();
  }
}
