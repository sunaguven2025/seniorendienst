import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/patient.dart';

class PatientDetailPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(patient.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPatientHeader(context),

            const SizedBox(height: 16),

            _buildPersonalInformation(context),

            const SizedBox(height: 16),

            _buildContactInformation(context),

            const SizedBox(height: 16),

            _buildAddressInformation(context),

            const SizedBox(height: 16),

            _buildMedicalInformation(context),

            const SizedBox(height: 16),

            _buildEmergencyContact(context),

            const SizedBox(height: 16),

            _buildAllergiesAndDiseases(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundImage: patient.photoUrl.isNotEmpty
                  ? NetworkImage(patient.photoUrl)
                  : null,
              child: patient.photoUrl.isEmpty
                  ? const Icon(Icons.elderly, size: 42)
                  : null,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.fullName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (patient.careLevel.isNotEmpty)
                    Text(
                      patient.careLevel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformation(BuildContext context) {
    return _buildSection(
      context,
      title: 'Persönliche Informationen',
      icon: Icons.person,
      children: [
        _buildInfoTile(
          icon: Icons.cake,
          title: 'Doğum tarihi',
          value: _formatDate(patient.birthDate),
        ),
        _buildInfoTile(
          icon: Icons.wc,
          title: 'Cinsiyet',
          value: patient.gender,
        ),
      ],
    );
  }

  Widget _buildContactInformation(BuildContext context) {
    return _buildSection(
      context,
      title: 'İletişim',
      icon: Icons.phone,
      children: [
        _buildInfoTile(
          icon: Icons.phone,
          title: 'Telefon',
          value: patient.phone,
          trailing: patient.phone.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.call),
                  tooltip: 'Ara',
                  onPressed: () => _callNumber(patient.phone),
                ),
        ),
      ],
    );
  }

  Widget _buildAddressInformation(BuildContext context) {
    final hasAddress =
        patient.address.isNotEmpty ||
        patient.postalCode.isNotEmpty ||
        patient.city.isNotEmpty;

    final hasCoordinates = patient.latitude != 0 && patient.longitude != 0;

    return _buildSection(
      context,
      title: 'Adres ve Konum',
      icon: Icons.location_on,
      children: [
        if (patient.address.isNotEmpty)
          _buildInfoTile(
            icon: Icons.home,
            title: 'Adres',
            value: patient.address,
          ),

        if (patient.postalCode.isNotEmpty)
          _buildInfoTile(
            icon: Icons.markunread_mailbox,
            title: 'PLZ',
            value: patient.postalCode,
          ),

        if (patient.city.isNotEmpty)
          _buildInfoTile(
            icon: Icons.location_city,
            title: 'Şehir',
            value: patient.city,
          ),

        if (!hasAddress)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Adres bilgisi bulunmuyor.'),
          ),

        if (hasCoordinates)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.gps_fixed),
                          SizedBox(width: 8),
                          Text(
                            'GPS Konumu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enlem: '
                        '${patient.latitude.toStringAsFixed(6)}',
                      ),
                      Text(
                        'Boylam: '
                        '${patient.longitude.toStringAsFixed(6)}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: _openNavigation,
                  icon: const Icon(Icons.directions),
                  label: const Text('Yol Tarifi Al'),
                ),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: _openMap,
                  icon: const Icon(Icons.map),
                  label: const Text('Haritada Göster'),
                ),
              ],
            ),
          ),

        if (!hasCoordinates)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Icon(Icons.location_off, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Bu hasta için GPS konumu kayıtlı değil.'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalInformation(BuildContext context) {
    return _buildSection(
      context,
      title: 'Medizinische Informationen',
      icon: Icons.medical_information,
      children: [
        _buildInfoTile(
          icon: Icons.health_and_safety,
          title: 'Pflegegrad',
          value: patient.careLevel,
        ),
        _buildInfoTile(
          icon: Icons.local_hospital,
          title: 'Doktor',
          value: patient.doctor,
        ),
        _buildInfoTile(
          icon: Icons.card_membership,
          title: 'Krankenkasse',
          value: patient.insurance,
        ),
      ],
    );
  }

  Widget _buildEmergencyContact(BuildContext context) {
    return _buildSection(
      context,
      title: 'Angehöriger',
      icon: Icons.people,
      children: [
        _buildInfoTile(
          icon: Icons.person,
          title: 'Yakını',
          value: patient.emergencyContact,
        ),
        _buildInfoTile(
          icon: Icons.family_restroom,
          title: 'Yakınlık derecesi',
          value: patient.relationship,
        ),
        _buildInfoTile(
          icon: Icons.phone,
          title: 'Yakının telefonu',
          value: patient.emergencyPhone,
          trailing: patient.emergencyPhone.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.call),
                  tooltip: 'Yakını ara',
                  onPressed: () => _callNumber(patient.emergencyPhone),
                ),
        ),
      ],
    );
  }

  Widget _buildAllergiesAndDiseases(BuildContext context) {
    return _buildSection(
      context,
      title: 'Hastalıklar ve Alerjiler',
      icon: Icons.warning_amber,
      children: [
        _buildListInformation(
          title: 'Hastalıklar',
          icon: Icons.sick,
          items: patient.diseases,
        ),
        _buildListInformation(
          title: 'Alerjiler',
          icon: Icons.warning,
          items: patient.allergies,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value.isEmpty ? 'Bilgi girilmemiş' : value),
      trailing: trailing,
    );
  }

  Widget _buildListInformation({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    if (items.isEmpty) {
      return ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: const Text('Kayıt bulunmuyor'),
      );
    }

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Chip(label: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _callNumber(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Future<void> _openNavigation() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination='
      '${patient.latitude},'
      '${patient.longitude}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query='
      '${patient.latitude},'
      '${patient.longitude}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}
