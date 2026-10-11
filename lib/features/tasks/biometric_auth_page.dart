import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthPage extends StatefulWidget {
  const BiometricAuthPage({super.key});

  @override
  State<BiometricAuthPage> createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _checking = true;
  bool _authenticating = false;

  bool _canCheckBiometrics = false;
  bool _isDeviceSupported = false;

  List<BiometricType> _availableBiometrics = [];

  String _message = 'Biyometrik doğrulama hazırlanıyor...';

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;

      final isSupported = await _localAuth.isDeviceSupported();

      final biometrics = await _localAuth.getAvailableBiometrics();

      if (!mounted) {
        return;
      }

      setState(() {
        _canCheckBiometrics = canCheck;
        _isDeviceSupported = isSupported;
        _availableBiometrics = biometrics;
        _checking = false;

        _message = _buildBiometricMessage(
          canCheck: canCheck,
          isSupported: isSupported,
          biometrics: biometrics,
        );
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _checking = false;
        _message = 'Biyometrik doğrulama kontrol edilemedi.';
      });
    }
  }

  String _buildBiometricMessage({
    required bool canCheck,
    required bool isSupported,
    required List<BiometricType> biometrics,
  }) {
    if (!isSupported) {
      return 'Bu cihaz biyometrik doğrulamayı desteklemiyor.';
    }

    if (!canCheck) {
      return 'Bu cihazda kullanılabilir bir biyometrik doğrulama bulunmuyor.';
    }

    if (biometrics.isEmpty) {
      return 'Cihazda kayıtlı bir biyometrik doğrulama bulunmuyor.';
    }

    if (biometrics.contains(BiometricType.face)) {
      return 'Yüz tanıma ile onay verebilirsiniz.';
    }

    if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Parmak izi ile onay verebilirsiniz.';
    }

    return 'Cihazınızın biyometrik doğrulaması ile onay verebilirsiniz.';
  }

  Future<void> _authenticate() async {
    if (_authenticating) {
      return;
    }

    setState(() {
      _authenticating = true;
    });

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason:
            'Hasta bakım görevinin tamamlandığını doğrulamak için biyometrik kimlik doğrulaması yapın.',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (!mounted) {
        return;
      }

      if (authenticated) {
        Navigator.pop(context, true);

        return;
      }

      setState(() {
        _authenticating = false;
        _message = 'Biyometrik doğrulama tamamlanmadı.';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _authenticating = false;
        _message = 'Biyometrik doğrulama başarısız oldu.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biyometrik doğrulama başarısız:\n$e')),
      );
    }
  }

  IconData _biometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    }

    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    }

    return Icons.lock;
  }

  String _biometricTitle() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Yüz Tanıma';
    }

    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Parmak İzi';
    }

    return 'Biyometrik Doğrulama';
  }

  @override
  Widget build(BuildContext context) {
    final biometricReady =
        !_checking &&
        _canCheckBiometrics &&
        _isDeviceSupported &&
        _availableBiometrics.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Biyometrik Onay')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    _biometricIcon(),
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  _checking ? 'Kontrol ediliyor...' : _biometricTitle(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 32),

                if (_checking) const CircularProgressIndicator(),

                if (!_checking && biometricReady)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _authenticating ? null : _authenticate,
                      icon: _authenticating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(_biometricIcon()),
                      label: Text(
                        _authenticating
                            ? 'Doğrulanıyor...'
                            : 'Biyometrik Doğrula',
                      ),
                    ),
                  ),

                if (!_checking && !biometricReady)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: _checkBiometricSupport,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tekrar Kontrol Et'),
                    ),
                  ),

                const SizedBox(height: 20),

                if (!_checking)
                  TextButton(
                    onPressed: _authenticating
                        ? null
                        : () {
                            Navigator.pop(context, false);
                          },
                    child: const Text('İptal'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
