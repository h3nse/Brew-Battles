import 'package:flutter/material.dart';

class PotionView extends StatefulWidget {
  const PotionView({super.key});

  @override
  State<PotionView> createState() => _PotionViewState();
}

class _PotionViewState extends State<PotionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              print('Potion Tapped');
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.purple)),
              child: const Center(child: Text('Potion')),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    print('Scan Ingredient Tapped');
                  },
                  child: const Text('Scan Ingredient')),
              ElevatedButton(
                  onPressed: () {
                    print('Pour Potion Out Tapped');
                  },
                  child: const Text('Pour Potion Out'))
            ],
          ),
        )
      ],
    );
  }
}
