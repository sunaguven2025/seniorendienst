import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class PatientSignaturePage extends StatefulWidget {
  const PatientSignaturePage({super.key});

  @override
  State<PatientSignaturePage> createState() => _PatientSignaturePageState();
}

class _PatientSignaturePageState extends State<PatientSignaturePage> {
  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();

    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasta İmzası')),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Column(
                children: [
                  Icon(Icons.draw, size: 42),
                  SizedBox(height: 8),
                  Text(
                    'Lütfen aşağıdaki alana imzanızı atınız.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Parmağınızı veya kalemi kullanabilirsiniz.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Signature(
                      controller: _signatureController,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearSignature,
                      icon: const Icon(Icons.clear),
                      label: const Text('Temizle'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveSignature,
                      icon: const Icon(Icons.check),
                      label: const Text('İmzayı Onayla'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearSignature() {
    _signatureController.clear();
  }

  Future<void> _saveSignature() async {
    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen önce imza atınız.')));

      return;
    }

    final Uint8List? signature = await _signatureController.toPngBytes();

    if (signature == null || signature.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İmza oluşturulamadı. Lütfen tekrar deneyin.'),
        ),
      );

      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context, signature);
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }
}
