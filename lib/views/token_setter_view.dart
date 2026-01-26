import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/viewmodels/token_setter_vm.dart';

class TokenSetterView extends StatelessWidget {
  const TokenSetterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tessie API Token')),
      body: Center(
        child: const TokenSetterViewSfw(),
      )
    );
  }
}

class TokenSetterViewSfw extends StatefulWidget {
  const TokenSetterViewSfw({super.key});

  @override
  State<TokenSetterViewSfw> createState() => _TokenSetterViewSfwState();
}

class _TokenSetterViewSfwState extends State<TokenSetterViewSfw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final tokenEditingCtrl = TextEditingController();
  final tokenSetterViewModel = TokenSetterViewModel();

  void saveToken() {
    tokenSetterViewModel.saveToken(tokenEditingCtrl.text);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tokenEditingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(hintText: 'Enter your API token'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: tokenEditingCtrl,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveToken();
                    Get.back();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
