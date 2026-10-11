import 'package:flutter/material.dart';

import '../../core/models/patient.dart';
import '../../core/services/firestore_service.dart';
import '../patients/add_patient_page.dart';
import '../patients/patient_detail_page.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final TextEditingController _searchController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hastalar')),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPatientPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Patient>>(
        stream: _firestoreService.getPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Hastalar yüklenirken hata oluştu:\n\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final allPatients = snapshot.data ?? [];

          final patients = allPatients.where((patient) {
            final search = _search.trim().toLowerCase();

            if (search.isEmpty) {
              return true;
            }

            return patient.fullName.toLowerCase().contains(search) ||
                patient.phone.toLowerCase().contains(search) ||
                patient.city.toLowerCase().contains(search);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Hasta Ara',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();

                              setState(() {
                                _search = '';
                              });
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: patients.isEmpty
                    ? const Center(
                        child: Text(
                          'Hasta bulunamadı',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: patient.photoUrl.isNotEmpty
                                    ? NetworkImage(patient.photoUrl)
                                    : null,
                                child: patient.photoUrl.isEmpty
                                    ? const Icon(Icons.elderly)
                                    : null,
                              ),

                              title: Text(
                                patient.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (patient.address.isNotEmpty)
                                    Text(
                                      '${patient.address}, '
                                      '${patient.postalCode} '
                                      '${patient.city}',
                                    ),

                                  if (patient.phone.isNotEmpty)
                                    Text(
                                      'Telefon: '
                                      '${patient.phone}',
                                    ),

                                  if (patient.careLevel.isNotEmpty)
                                    Text(
                                      'Pflegegrad: '
                                      '${patient.careLevel}',
                                    ),
                                ],
                              ),

                              trailing: const Icon(Icons.chevron_right),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PatientDetailPage(patient: patient),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
