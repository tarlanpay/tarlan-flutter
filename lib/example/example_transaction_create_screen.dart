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
            title: const Text('Tarlan Transaction Generator'),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransactionUrlProvider model) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      return Center(child: SafeArea(child: _showError(appLocalizations, model)));
    } else {
      return Center(
          child: SafeArea(
              child: Padding(padding: const EdgeInsets.all(15), child: _buildContent(appLocalizations, model))));
    }
  }

  Widget _showError(AppLocalizations appLocalizations, TransactionUrlProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${appLocalizations.error}: ${model.error}'),
        ElevatedButton(onPressed: model.clear, child: Text(appLocalizations.back)),
      ],
    );
  }

  Widget _buildContent(AppLocalizations appLocalizations, TransactionUrlProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (model.transactionLink != null)
          _buildTransactionLinkSection(appLocalizations, model)
        else
          _buildOptions(appLocalizations, model),
      ],
    );
  }

  Widget _buildTransactionLinkSection(AppLocalizations appLocalizations, TransactionUrlProvider model) {
    return Column(
      children: [
        Text('${appLocalizations.transactionLink}: ${model.transactionLink}'),
        ElevatedButton(
          onPressed: () => model.launchTarlanSDK(context, model.transactionLink!, model.currentEnvironment),
          child: Text(appLocalizations.launchTarlanSdk),
        ),
        ElevatedButton(
          onPressed: model.clear,
          child: Text(appLocalizations.back),
        ),
      ],
    );
  }

  Widget _buildOptions(AppLocalizations appLocalizations, TransactionUrlProvider model) {
    return Column(
      children: [
        Text('${appLocalizations.clientId}: ${requestData['project_client_id']}'),
        ElevatedButton(onPressed: model.generateRandomClientId, child: Text(appLocalizations.generateNewClientId)),
        Text('${appLocalizations.projectReferenceId}: ${requestData['project_reference_id']}'),
        ElevatedButton(
            onPressed: model.generateRandomReferenceId, child: Text(appLocalizations.generateNewReferenceId)),
        const SizedBox(height: 16),
        Text(appLocalizations.availableActions),
        ElevatedButton(
          onPressed: () => model.createTransaction('PayIn'),
          child: Text(appLocalizations.payIn),
        ),
        ElevatedButton(
          onPressed: () => model.createTransaction('PayOut'),
          child: Text(appLocalizations.payOut),
        ),
        ElevatedButton(
          onPressed: () => model.createTransaction('CardLink'),
          child: Text(appLocalizations.cardLink),
        ),
        const SizedBox(height: 16),
        Text('${appLocalizations.currentEnvironment} ${model.currentEnvironment.name}'),
        ElevatedButton(
          onPressed: model.switchEnvironment,
          child: Text(appLocalizations.switchEnvironment),
        ),
        const SizedBox(height: 16),
        Text('${appLocalizations.currentLocale} ${model.locale}'),
        ElevatedButton(
          onPressed: () => model.switchLocale(context),
          child: Text(appLocalizations.switchLocale),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
