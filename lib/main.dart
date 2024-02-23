import 'package:brew_battles/Managers/game_manager.dart';
import 'package:brew_battles/Pages/front_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  const supabaseUrl = 'https://jcwxzybnrickofvzkgge.supabase.co';
  final supabaseKey = dotenv.env['SUPABASE_KEY']!;

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => GameManager())],
    child: const MainApp(),
  )); // Might impact performance? Move further down the tree.
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrewBattlesApp();
  }
}

class BrewBattlesApp extends StatelessWidget {
  const BrewBattlesApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 103, 0, 151),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromARGB(255, 255, 0, 0),
          onSecondary: Color.fromARGB(255, 255, 0, 0),
          error: Color.fromARGB(255, 255, 0, 0),
          onError: Color.fromARGB(255, 255, 0, 0),
          background: Color.fromARGB(255, 255, 255, 255),
          onBackground: Color.fromARGB(255, 0, 0, 0),
          surface: Color.fromARGB(255, 255, 255, 255),
          onSurface: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: const FrontPage(),
    );
  }
}
