import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/screens/home/episodes/controller/episode_controller.dart';
import '/presentation/shared/provider/repository_provider.dart';

final episodeControllerProvider = ChangeNotifierProvider(
  (ref) => EpisodeController(
      repository: ref.watch(repositoryProvider).episodeRepository),
);
