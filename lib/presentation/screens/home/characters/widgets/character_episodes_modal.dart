import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/models/character/character.dart';
import '/data/models/episode.dart';
import '/presentation/screens/home/episodes/provider/episode_providers.dart';

class CharacterEpisodesModal extends ConsumerStatefulWidget {
  final Character character;

  const CharacterEpisodesModal({super.key, required this.character});

  @override
  ConsumerState<CharacterEpisodesModal> createState() =>
      _CharacterEpisodesModalState();
}

class _CharacterEpisodesModalState
    extends ConsumerState<CharacterEpisodesModal> {
  @override
  void initState() {
    super.initState();
    // Llama al controlador para cargar episodios del personaje
    ref.read(episodeControllerProvider.notifier).fetchCharacterEpisodes(
          widget.character.episode, // Lista de URLs de episodios
        );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(episodeControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1C29), Color(0xFF2D3047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(
          color: const Color(0xFF00FF9D).withValues(alpha: .5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF9D).withValues(alpha: .2),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'DIMENSION EPISODES',
            style: TextStyle(
              fontFamily: 'RickAndMortyFont',
              fontSize: 22,
              color: const Color(0xFF00FF9D),
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: .5),
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: controller.isLoadingCharacterEpisodes
                ? Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF00FF9D),
                      backgroundColor: Colors.purple.withValues(alpha: .3),
                    ),
                  )
                : controller.characterEpisodes.isEmpty
                    ? Center(
                        child: Text(
                          'NO MULTIVERSE DATA FOUND 🌌',
                          style: TextStyle(
                            fontFamily: 'RickAndMortyFont',
                            color:
                                const Color(0xFF00FF9D).withValues(alpha: .7),
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.characterEpisodes.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color:
                                const Color(0xFF00FF9D).withValues(alpha: .3),
                            height: 2,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final episode = controller.characterEpisodes[index];
                          return _EpisodeTile(episode: episode);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final Episode episode;

  const _EpisodeTile({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D3047).withValues(alpha: .5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF00FF9D).withValues(alpha: .3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(
            Icons.animation,
            color: Color(0xFF00FF9D),
            size: 30,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  episode.name.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'RickAndMortyFont',
                    color: Color(0xFF00FF9D),
                    fontSize: 16,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                _buildInfoRow('📅', 'AIR DATE:', episode.airDate),
                _buildInfoRow('🌀', 'EPISODE:', episode.episode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E94B3),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
