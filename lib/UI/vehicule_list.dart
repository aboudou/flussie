import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flussie/UI/token_setter.dart';

class VehiculeList extends StatelessWidget {
  const VehiculeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const VehiculeListSfw(),
      )
    );
  }
}

class VehiculeListSfw extends StatefulWidget {
  const VehiculeListSfw({super.key});

  @override
  State<VehiculeListSfw> createState() => _VehiculeListSfwState();
}

class _VehiculeListSfwState extends State<VehiculeListSfw> {
  String _token = '';

  Future<void> _checkForToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token') ?? '';
    });
  }

  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      _token = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    _checkForToken(); 

    if (_token.isEmpty) {

      // No token found, show button to set token
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your vehicules'),
        ),

        body: Center(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const Text('No Tessie API Token is set.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Set API token'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const TokenSetter(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

    } else {

      // Token found, show vehicule list (placeholder for now)
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your vehicules'),
          actions: [
            _logoutIcon(context),
          ],
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _vehiculeList(context),
          ),
        ),
      );

    }
  }

  // Logout icon button to clear the token
  Widget _logoutIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Clear API token',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Do you want to clear the API token?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Clear'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;

        _deleteToken();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API token cleared')),
        );
        setState(() {});
      },
    );    
  }

  // Vehicule list
  Widget _vehiculeList(BuildContext context) {
    return Column(
      children: [
        Text('Tessie API Token: $_token'),
        const SizedBox(height: 20),
        const Text('Vehicule list would be shown here'),
      ],
    );
  }
}