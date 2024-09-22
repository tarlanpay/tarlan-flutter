import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'mock_data.dart';
import 'transaction_url_provider.dart';

class ExampleTransactionCreateScreen extends StatefulWidget {
  const ExampleTransactionCreateScreen({super.key});

  @override
  State<ExampleTransactionCreateScreen> createState() => _ExampleTransactionCreateScreenState();
}

class _ExampleTransactionCreateScreenState extends State<ExampleTransactionCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionUrlProvider>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.tarlanTransactionGeneratorTitle),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransactionUrlProvider model) {
    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      return Center(child: SafeArea(child: _showError(model)));
    } else {
      return Center(child: SafeArea(child: Padding(padding: const EdgeInsets.all(15), child: _buildContent(model))));
    }
  }

  Widget _showError(TransactionUrlProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: ${model.error}'),
        ElevatedButton(onPressed: model.clear, child: const Text('Back')),
      ],
    );
  }

  Widget _buildContent(TransactionUrlProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (model.transactionLink != null) _buildTransactionLinkSection(model) else _buildOptions(model),
      ],
    );
  }

  Widget _buildTransactionLinkSection(TransactionUrlProvider model) {
    return Column(
      children: [
        Text('Transaction Link: ${model.transactionLink}'),
        ElevatedButton(
          onPressed: () => model.launchTarlanSDK(context, model.transactionLink!, model.currentEnvironment),
          child: const Text('Launch Tarlan SDK'),
        ),
        ElevatedButton(
          onPressed: model.clear,
          child: const Text('Back'),
        ),
      ],
    );
  }

  Widget _buildOptions(TransactionUrlProvider model) {
    return Column(
      children: [
        Text('Client ID: ${requestData['project_client_id']}'),
        ElevatedButton(onPressed: model.generateRandomClientId, child: const Text('Generate new client ID')),
        Text('Project Reference ID: ${requestData['project_reference_id']}'),
        ElevatedButton(onPressed: model.generateRandomReferenceId, child: const Text('Generate new reference ID')),
        const SizedBox(height: 16),
        const Text('Available actions:'),
        ElevatedButton(
          onPressed: () => model.createTransaction('PayIn'),
          child: const Text('Pay In'),
        ),
        ElevatedButton(
          onPressed: () => model.createTransaction('PayOut'),
          child: const Text('Pay Out'),
        ),
        ElevatedButton(
          onPressed: () => model.createTransaction('CardLink'),
          child: const Text('Card Link'),
        ),
        const SizedBox(height: 16),
        Text('Current environment: ${model.currentEnvironment.name}'),
        ElevatedButton(
          onPressed: model.switchEnvironment,
          child: const Text('Switch Environment'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
