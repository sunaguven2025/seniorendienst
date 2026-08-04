import 'package:flutter/material.dart';

class Patient {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String birthDate;
  final bool active;

  const Patient({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.active,
  });

  String get fullName => "$firstName $lastName";
}

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Patient> _patients = [
    const Patient(
      firstName: "Maria",
      lastName: "Schneider",
      phone: "0151 23456789",
      address: "Dortmund",
      birthDate: "12.04.1948",
      active: true,
    ),
    const Patient(
      firstName: "Hans",
      lastName: "Müller",
      phone: "0176 98765432",
      address: "Schwerte",
      birthDate: "22.09.1942",
      active: true,
    ),
    const Patient(
      firstName: "Erika",
      lastName: "Becker",
      phone: "0163 45678912",
      address: "Hagen",
      birthDate: "03.01.1939",
      active: false,
    ),
  ];

  String _searchText = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Patient> get _filteredPatients {
    if (_searchText.isEmpty) {
      return _patients;
    }

    return _patients.where((patient) {
      final text = _searchText.toLowerCase();

      return patient.fullName.toLowerCase().contains(text) ||
          patient.phone.toLowerCase().contains(text) ||
          patient.address.toLowerCase().contains(text);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final patients = _filteredPatients;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hastalar"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Yeni Hasta sayfası daha sonra eklenecek."),
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Hasta ara...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _searchText = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: patients.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.elderly, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Hasta bulunamadı",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.teal,
                                    child: Icon(
                                      Icons.elderly,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      patient.fullName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    backgroundColor: patient.active
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    label: Text(
                                      patient.active ? "Aktif" : "Pasif",
                                      style: TextStyle(
                                        color: patient.active
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 8),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.phone),
                                title: Text(patient.phone),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.location_on),
                                title: Text(patient.address),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.cake),
                                title: Text(patient.birthDate),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${patient.fullName} detay sayfası daha sonra eklenecek.",
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.visibility),
                                    label: const Text("Detay"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${patient.fullName} düzenleme sayfası daha sonra eklenecek.",
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Düzenle"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
