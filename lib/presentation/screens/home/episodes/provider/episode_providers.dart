// lib/providers/episode_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/api/episode_api.dart';
import '/data/repository/episode_repository.dart';
import '/presentation/screens/home/episodes/controller/episode_controller.dart';

final episodeApiProvider = Provider((ref) => EpisodeApi());

final episodeRepositoryProvider = Provider(
  (ref) => EpisodeRepository(api: ref.watch(episodeApiProvider)),
);

final episodeControllerProvider = ChangeNotifierProvider(
  (ref) => EpisodeController(repository: ref.watch(episodeRepositoryProvider)),
);
