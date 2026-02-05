import 'package:flutter/material.dart';

import 'package:flussie/viewmodels/charge_details_vm.dart';

class ChargeDetailsView extends StatelessWidget {
  const ChargeDetailsView({super.key, required this.viewModel});

  final ChargeDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Charge details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${viewModel.charge.location ?? "Unknown location"}'),
            SizedBox(height: 8),
            Text('Started at: ${DateTime.fromMillisecondsSinceEpoch((viewModel.charge.startedAt ?? 0) * 1000)}'),
            SizedBox(height: 8),
            Text('Ended at: ${DateTime.fromMillisecondsSinceEpoch((viewModel.charge.endedAt ?? 0) * 1000)}'),
            SizedBox(height: 8),
            Text('Starting battery level: ${viewModel.charge.startingBattery ?? 0}%'),
            SizedBox(height: 8),
            Text('Ending battery level: ${viewModel.charge.endingBattery ?? 0}%'),
          ],
        ),
      ),
    );
  }
}
