import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:niyama/navigation_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  String _status = 'Checking biometrics...';

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      bool canCheck = await _auth.isDeviceSupported();
      setState(() => _canCheckBiometrics = canCheck);

      if (canCheck) {
        _authenticate(); // Automatically start authentication
      } else {
        setState(() => _status = 'Biometric authentication not available');
      }
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationPage()),
        );
      } else {
        setState(() => _status = 'Authentication Failed');
      }
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _canCheckBiometrics
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesome.lock_solid,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Text(
                _status,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
