import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'services/auth_service.dart';

void main() async {
  // Required before any async calls in main()
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase using the auto-generated options file
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DermCareApp());
}

class DermCareApp extends StatelessWidget {
  const DermCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthService is available anywhere in the app via Provider.of<AuthService>(context)
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp.router(
        title: 'DermCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        // GoRouter handles all navigation
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
