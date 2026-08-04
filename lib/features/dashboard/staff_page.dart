import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _staff = [
    {
      "name": "Ayşe Demir",
      "job": "Pflegefachkraft",
      "phone": "+49 151 12345678",
      "email": "ayse@suchannek.de",
      "active": true,
    },
    {
      "name": "Mehmet Kaya",
      "job": "Pflegehelfer",
      "phone": "+49 170 98765432",
      "email": "mehmet@suchannek.de",
      "active": true,
    },
    {
      "name": "Anna Müller",
      "job": "Hauswirtschaft",
      "phone": "+49 176 45678912",
      "email": "anna@suchannek.de",
      "active": false,
    },
  ];

  String search = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _staff.where((person) {
      return person["name"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personeller"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Personel ekleme yakında eklenecek.")),
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
                hintText: "Personel Ara",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final person = filtered[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: person["active"]
                          ? Colors.green
                          : Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),

                    title: Text(
                      person["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person["job"]),
                        Text(person["phone"]),
                        Text(person["email"]),
                      ],
                    ),

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$value seçildi")),
                        );
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: "Düzenle", child: Text("Düzenle")),
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
