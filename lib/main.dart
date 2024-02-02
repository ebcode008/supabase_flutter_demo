import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cewcezjgdcegoildkmzb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNld2NlempnZGNlZ29pbGRrbXpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY4NDA5NjksImV4cCI6MjAyMjQxNjk2OX0.ALeVuhsrZtzpVH_BBT7g5ibUCb2lgiOoNWs7V88rBZY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: ProductsPage(),
    );
  }
}
