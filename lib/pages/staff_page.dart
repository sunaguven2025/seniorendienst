import 'package:flutter/material.dart';

class Staff {
  final String firstName;
  final String lastName;
  final String profession;
  final String phone;
  final bool active;

  const Staff({
    required this.firstName,
    required this.lastName,
    required this.profession,
    required this.phone,
    required this.active,
  });

  String get fullName => "$firstName $lastName";
}

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Staff> _staffList = [
    const Staff(
      firstName: "Anna",
      lastName: "Schmidt",
      profession: "Pflegefachkraft",
      phone: "0151 11111111",
      active: true,
    ),
    const Staff(
      firstName: "Thomas",
      lastName: "Becker",
      profession: "Pflegehelfer",
      phone: "0176 22222222",
      active: true,
    ),
    const Staff(
      firstName: "Julia",
      lastName: "Koch",
      profession: "Hauswirtschaft",
      phone: "0163 33333333",
      active: false,
    ),
  ];

  String _searchText = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Staff> get _filteredStaff {
    if (_searchText.isEmpty) {
      return _staffList;
    }

    return _staffList.where((staff) {
      final search = _searchText.toLowerCase();

      return staff.fullName.toLowerCase().contains(search) ||
          staff.profession.toLowerCase().contains(search) ||
          staff.phone.contains(search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final staff = _filteredStaff;

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
            const SnackBar(
              content: Text("Yeni Personel sayfası daha sonra eklenecek."),
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
                hintText: "Personel ara...",
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
            child: staff.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Personel bulunamadı",
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
                    itemCount: staff.length,
                    itemBuilder: (context, index) {
                      final employee = staff[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.teal,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          employee.fullName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          employee.profession,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Chip(
                                    backgroundColor: employee.active
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    label: Text(
                                      employee.active ? "Aktif" : "Pasif",
                                      style: TextStyle(
                                        color: employee.active
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 30),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.phone),
                                title: Text(employee.phone),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.visibility),
                                    label: const Text("Detay"),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${employee.fullName} detay sayfası daha sonra eklenecek.",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                    ),
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Düzenle"),
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${employee.fullName} düzenleme sayfası daha sonra eklenecek.",
                                          ),
                                        ),
                                      );
                                    },
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
