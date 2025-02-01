// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/screens/home/episodes/widgets/episode_card.dart';
import '/presentation/screens/home/episodes/provider/episode_providers.dart';

class EpisodeScreen extends ConsumerWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(episodeControllerProvider);
    final controllerNotifier = ref.read(episodeControllerProvider.notifier);

    if (controller.episodes.isEmpty && !controller.isLoading) {
      controllerNotifier.fetchEpisodes();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DIMENSION EPISODES',
          style: TextStyle(
            fontFamily: 'RickAndMortyFont',
            color: Color(0xFF00FF9D),
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(2, 2),
              )
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1A1C29), Colors.purple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF9D).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/portal_bg.jpg'), // Agrega una textura de fondo
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    controllerNotifier
                        .fetchEpisodes(); // Mostrar todos los episodios
                  } else {
                    controllerNotifier
                        .updateSearchQuery(value); // Filtrar episodios
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2D3047).withOpacity(0.8),
                  labelText: 'SCAN MULTIVERSE...',
                  labelStyle: const TextStyle(
                    color: Color(0xFF8E94B3),
                    fontFamily: 'RickAndMortyFont',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF00FF9D),
                      width: 2,
                    ),
                  ),
                  suffixIcon:
                      const Icon(Icons.search, color: Color(0xFF00FF9D)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                cursorColor: const Color(0xFF00FF9D),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controllerNotifier.fetchEpisodes(loadMore: true);
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.episodes.length,
                  itemBuilder: (context, index) {
                    final episode = controller.episodes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: EpisodeCard(episode: episode),
                    );
                  },
                ),
              ),
            ),
            if (controller.isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: const Color(0xFF00FF9D),
                  backgroundColor: Colors.purple.withOpacity(0.3),
                  strokeWidth: 5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
