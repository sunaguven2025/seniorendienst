import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            accountName: const Text(
              "Seniorendienst Suchannek",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("Administrator"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_hospital, color: Colors.teal, size: 40),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.elderly),
            title: const Text("Hastalar"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Personeller"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text("Görevler"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text("Raporlar"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Ayarlar"),
            onTap: () {},
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Çıkış", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
