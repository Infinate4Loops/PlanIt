import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/grocery_list_provider.dart';
import 'providers/chat_provider.dart';
import 'screens/home_screen.dart';
import 'screens/grocery_list_screen.dart';
import 'screens/ai_chat_screen.dart';

void main() {
  runApp(const PlanItApp());
}

class PlanItApp extends StatelessWidget {
  const PlanItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GroceryListProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlanIt',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
          useMaterial3: true,
        ),
        home: const _RootScaffold(),
      ),
    );
  }
}

class _RootScaffold extends StatefulWidget {
  const _RootScaffold({super.key});

  @override
  State<_RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<_RootScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    GroceryListScreen(),
    AiChatScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Plan'),
    NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Groceries'),
    NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'AI Chat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: _destinations,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}