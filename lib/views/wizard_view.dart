import 'package:flutter/material.dart';

class WizardView extends StatefulWidget {
  const WizardView({super.key});

  @override
  State<WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<WizardView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            print('Left Wizard Tapped');
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.purple)),
              child: const Center(child: Text('Left Wizard')),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            print('Right Wizard Tapped');
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.purple)),
              child: const Center(child: Text('Right Wizard')),
            ),
          ),
        )
      ],
    );
  }
}
