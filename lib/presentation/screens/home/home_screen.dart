import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/characters/characters_screen.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/episodes/episodes_screen.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/locations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PROPIEDADES DE WIDGETS
  // ----------------------------------
  int page = 0;
  final pageController = PageController();
  final pages = [
    const CharactersScreen(),
    const LocationsScreen(),
    const EpisodesScreen()
  ];

  // LOGICA DE WIDGETS
  // ----------------------------------
  void changePage(int index) {
    setState(() {
      page = index;
      pageController.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: changePage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        onTap: changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Ubicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Episodios',
          ),
        ],
      ),
    );
  }
}
