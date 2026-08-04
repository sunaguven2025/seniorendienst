import 'package:flutter/material.dart';

import 'patient_list_page.dart';

import 'staff_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seniorendienst Suchannek"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _menuCard(
              context: context,
              icon: Icons.elderly,
              title: "Hastalar",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientListPage()),
                );
              },
            ),
            _menuCard(
              context: context,
              icon: Icons.people,
              title: "Personeller",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StaffPage()),
                );
              },
            ),
            _menuCard(
              context: context,
              icon: Icons.calendar_month,
              title: "Görevler",
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Görevler modülü yakında eklenecek."),
                  ),
                );
              },
            ),
            _menuCard(
              context: context,
              icon: Icons.description,
              title: "Raporlar",
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Raporlar modülü yakında eklenecek."),
                  ),
                );
              },
            ),
            _menuCard(
              context: context,
              icon: Icons.settings,
              title: "Ayarlar",
              color: Colors.grey,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ayarlar sayfası yakında eklenecek."),
                  ),
                );
              },
            ),
            _menuCard(
              context: context,
              icon: Icons.logout,
              title: "Çıkış",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
