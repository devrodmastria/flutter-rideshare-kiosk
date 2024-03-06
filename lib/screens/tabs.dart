import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosk/screens/welcome.dart';
import 'package:kiosk/widgets/main_drawer.dart';
import 'package:kiosk/screens/controls.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setDrawerPage(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'controls') {
      Navigator.of(context).push(
        // pushReplacement -> replace current screen on stack - back function will close the app
        MaterialPageRoute(
          builder: (ctx) => const ControlScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const WelcomeScreen();

    if (_selectedPageIndex == 1) {
      activePage = const ControlScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyft Kiosk'),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: _setDrawerPage,
      // ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: 'Welcome'),
          // BottomNavigationBarItem(
          // icon: Icon(Icons.settings), label: 'Ride Services'),
          BottomNavigationBarItem(
              icon: Icon(Icons.speaker_notes_outlined), label: 'Suggestions'),
        ],
      ),
    );
  }
}
