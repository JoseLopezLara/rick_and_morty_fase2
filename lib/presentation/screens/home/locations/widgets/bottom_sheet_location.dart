import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/controller/locations_controller.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/provider/locations_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

class LocationBottomSheet extends ConsumerStatefulWidget {
  final String locationId;

  const LocationBottomSheet({
    Key? key,
    required this.locationId,
  }) : super(key: key);

  @override
  ConsumerState<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends ConsumerState<LocationBottomSheet> {
  @override
  void initState() {
    super.initState();
    // Obtener los detalles de la ubicación cuando se inicia el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationsControllerProvider).getLocationDetails(widget.locationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(locationsControllerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detalles de la Ubicación',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              switch (controller.pageState) {
                case UiState.loading:
                  return const Center(child: CircularProgressIndicator());
                case UiState.error:
                  return Center(
                    child: Text('Error: ${controller.errorMessage}'),
                  );
                case UiState.data:
                  if (controller.currentLocation != null) {
                    return _LocationDetails(location: controller.currentLocation!);
                  }
                  return const Center(child: Text('No se encontró la ubicación'));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LocationDetails extends StatelessWidget {
  final Location location;

  const _LocationDetails({required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailItem(
          icon: Icons.location_on,
          title: 'Nombre',
          value: location.name,
        ),
        const SizedBox(height: 12),
        _DetailItem(
          icon: Icons.category,
          title: 'Tipo',
          value: location.type,
        ),
        const SizedBox(height: 12),
        _DetailItem(
          icon: Icons.public,
          title: 'Dimensión',
          value: location.dimension,
        ),
        const SizedBox(height: 12),
        _DetailItem(
          icon: Icons.people,
          title: 'Número de Residentes',
          value: location.residents.length.toString(),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}