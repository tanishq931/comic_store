import 'package:comic_store/Screens/AddScreen.dart';
import 'package:comic_store/Screens/DetailsScreen.dart';
import 'package:comic_store/Screens/HomeScreen.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return ChangeNotifierProvider(
      create: (context)=>Comicprovider() ,
      child: MaterialApp(
         theme: ThemeData(
           scaffoldBackgroundColor: Colors.black
         ),
        routes: {
          '/': (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        //
      ),
    );
  }
}
