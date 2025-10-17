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
  bool _isAuthenticating = false;
  String _status = 'Checking biometrics...';

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  /// Initialize authentication capability
  Future<void> _initAuth() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      if (!mounted) return;

      if (isSupported && canCheck) {
        setState(() {
          _canCheckBiometrics = true;
          _status = 'Ready to authenticate';
        });

        // Small delay so UI renders before auth prompt
        await Future.delayed(const Duration(milliseconds: 400));

        if (mounted) _authenticate();
      } else {
        setState(() => _status = 'Biometric authentication not available');
      }
    } catch (e) {
      if (mounted) setState(() => _status = 'Error: $e');
    }
  }

  /// Perform biometric authentication
  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _status = 'Authenticating...';
    });

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() => _status = 'Authenticated successfully');
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const NavigationPage()),
          );
        }
      } else {
        setState(() => _status = 'Authentication cancelled or failed');
      }
    } catch (e) {
      if (mounted) setState(() => _status = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(_status),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesome.lock_solid,
                size: 52,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Loading indicator when authenticating
              if (_isAuthenticating)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),

              // Retry button when not authenticating and biometrics supported
              if (!_isAuthenticating && _canCheckBiometrics)
                ElevatedButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Authenticate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              // Show retry only on errors
              if (_status.startsWith('Error'))
                TextButton(onPressed: _initAuth, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
