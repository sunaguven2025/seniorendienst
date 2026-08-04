import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/locale_provider.dart';
import '../../generated/app_localizations.dart';
import '../dashboard/dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool rememberMe = false;

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        actions: [
          const Icon(Icons.language, color: Colors.teal),

          const SizedBox(width: 10),

          DropdownButton<String>(
            value: locale.languageCode,
            underline: const SizedBox(),

            items: const [
              DropdownMenuItem(value: "tr", child: Text("🇹🇷 Türkçe")),

              DropdownMenuItem(value: "en", child: Text("🇬🇧 English")),

              DropdownMenuItem(value: "de", child: Text("🇩🇪 Deutsch")),
            ],

            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).changeLocale(value);
              }
            },
          ),

          const SizedBox(width: 20),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 430,

            margin: const EdgeInsets.all(25),

            padding: const EdgeInsets.all(35),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(25),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,

                  blurRadius: 18,

                  offset: Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              children: [
                Image.asset("assets/images/logo.png", height: 150),

                const SizedBox(height: 20),

                Text(
                  lang.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: usernameController,

                  decoration: InputDecoration(
                    labelText: lang.username,

                    prefixIcon: const Icon(Icons.person),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,

                  obscureText: true,

                  decoration: InputDecoration(
                    labelText: lang.password,

                    prefixIcon: const Icon(Icons.lock),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                CheckboxListTile(
                  value: rememberMe,

                  title: Text(lang.rememberMe),

                  controlAffinity: ListTileControlAffinity.leading,

                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushReplacement(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    },

                    child: Text(
                      lang.login,

                      style: const TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text("Version 1.0", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
