import 'package:flutter/material.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _patients = [
    {
      "name": "Maria Schmidt",
      "address": "Berlin",
      "phone": "0151 12345678",
      "careLevel": "Pflegegrad 3",
    },
    {
      "name": "Hans Müller",
      "address": "Hamburg",
      "phone": "0176 98765432",
      "careLevel": "Pflegegrad 2",
    },
    {
      "name": "Anna Becker",
      "address": "München",
      "phone": "0160 5554433",
      "careLevel": "Pflegegrad 4",
    },
  ];

  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredPatients = _patients.where((patient) {
      return patient["name"]!.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hastalar"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Yeni hasta ekleme yakında eklenecek."),
            ),
          );
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Hasta Ara...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
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
            child: filteredPatients.isEmpty
                ? const Center(
                    child: Text(
                      "Kayıt bulunamadı",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.elderly, color: Colors.white),
                          ),

                          title: Text(
                            patient["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(patient["address"]!),
                              Text(patient["phone"]!),
                              Text(patient["careLevel"]!),
                            ],
                          ),

                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$value seçildi")),
                              );
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: "Düzenle",
                                child: Text("Düzenle"),
                              ),
                              PopupMenuItem(value: "Sil", child: Text("Sil")),
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
