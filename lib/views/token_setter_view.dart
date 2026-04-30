import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flussie/providers/storage/storage_provider.dart';
import 'package:flussie/viewmodels/token_setter_vm.dart';

class TokenSetterView extends StatelessWidget {
  final StorageProvider _storageProvider;

  const TokenSetterView({super.key, required StorageProvider storageProvider})
      : _storageProvider = storageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('token_setter_title'.tr)),
      body: Center(
        child: TokenSetterViewSfw(storageProvider: _storageProvider),
      )
    );
  }
}

class TokenSetterViewSfw extends StatefulWidget {
  final StorageProvider _storageProvider;

  const TokenSetterViewSfw({super.key, required StorageProvider storageProvider})
      : _storageProvider = storageProvider;

  @override
  State<TokenSetterViewSfw> createState() => _TokenSetterViewSfwState();
}

class _TokenSetterViewSfwState extends State<TokenSetterViewSfw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final tokenEditingCtrl = TextEditingController();
  late final StorageProvider _storageProvider;

  @override
  void initState() {
    super.initState();
    _storageProvider = widget._storageProvider;
  }

  late final tokenSetterViewModel = TokenSetterViewModel(storageProvider: _storageProvider);

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
              decoration: InputDecoration(hintText: 'token_setter_hint'.tr),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'token_setter_validation'.tr;
                }
                return null;
              },
              controller: tokenEditingCtrl,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('token_setter_demo_hint'.tr),
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
                child: Text('token_setter_submit'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
