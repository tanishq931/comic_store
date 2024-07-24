import 'package:comic_store/Screens/HomeScreen.dart';
import 'package:comic_store/Screens/LoginScreen.dart';
import 'package:comic_store/Screens/SplashScreen.dart';
import 'package:comic_store/provider/AuthProvider.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/service/LocalStorage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await LocalStorage.initHive();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Comicprovider()),
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child: MaterialApp(
          theme: ThemeData(scaffoldBackgroundColor: Colors.black),
          routes: {
            '/': (context) => const Splashscreen(),
            '/loginScreen': (context) => const LoginScreen(),
            '/homeScreen': (context) => const HomeScreen(),
          },
          debugShowCheckedModeBanner: false,
        ));
  }
}
