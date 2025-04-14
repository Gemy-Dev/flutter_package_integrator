import 'package:flutter/material.dart';

class IntegrationProgress extends StatefulWidget {
  final Future<void> integrationFuture;
  final VoidCallback? onComplete;
  
  const IntegrationProgress({
    super.key,
    required this.integrationFuture,
    this.onComplete,
  });

  @override
  State<IntegrationProgress> createState() => _IntegrationProgressState();
}

class _IntegrationProgressState extends State<IntegrationProgress> {
  IntegrationStatus _status = IntegrationStatus.preparing;
  String _currentStep = '';
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _startIntegration();
  }

  Future<void> _startIntegration() async {
    try {
      await widget.integrationFuture;
      setState(() {
        _status = IntegrationStatus.complete;
        _progress = 1.0;
      });
      widget.onComplete?.call();
    } catch (e) {
      setState(() {
        _status = IntegrationStatus.failed;
        _currentStep = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.grey[200],
          color: _status == IntegrationStatus.failed 
            ? Colors.red 
            : Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          _currentStep,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (_status == IntegrationStatus.failed)
          TextButton(
            onPressed: _startIntegration,
            child: const Text('Retry'),
          ),
      ],
    );
  }
}

enum IntegrationStatus {
  preparing,
  inProgress,
  complete,
  failed,
}