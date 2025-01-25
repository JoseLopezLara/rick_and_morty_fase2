import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/provider/locations_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/provider/locations_state.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key});

  @override
  ConsumerState<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      ref.read(locationsProvider.notifier).loadMoreLocations();
    }
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(locationsProvider.notifier).searchLocations(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationsProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar ubicaciones...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildLocationsList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsList(LocationsState state) {
    switch (state.uiState) {
      case UiState.loading:
        if (state.locations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        break;
      case UiState.error:
        if (state.locations.isEmpty) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        }
        break;
      case UiState.data:
        break;
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.locations.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.locations.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final location = state.locations[index];
        return _LocationCard(location: location);
      },
    );
  }
}

class _LocationCard extends StatelessWidget {
  final Location location;

  const _LocationCard({
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${location.type}'),
            Text('Dimensión: ${location.dimension}'),
            Text('Residentes: ${location.residents.length}'),
          ],
        ),
      ),
    );
  }
}