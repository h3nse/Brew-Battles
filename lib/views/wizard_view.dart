import 'package:flutter/material.dart';

class WizardView extends StatefulWidget {
  const WizardView({super.key});

  @override
  State<WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<WizardView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Wizard View'));
  }
}
