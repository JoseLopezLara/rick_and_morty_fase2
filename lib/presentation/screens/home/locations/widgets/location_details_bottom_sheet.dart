import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/models/location/location.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/provider/locations_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/controller/locations_controller.dart';

class LocationDetailsBottomSheet extends ConsumerStatefulWidget {
  final String locationUrl;

  const LocationDetailsBottomSheet({
    Key? key,
    required this.locationUrl,
  }) : super(key: key);

  @override
  ConsumerState<LocationDetailsBottomSheet> createState() => _LocationDetailsBottomSheetState();
}

class _LocationDetailsBottomSheetState extends ConsumerState<LocationDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationsControllerProvider).getLocationDetails(widget.locationUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(locationsControllerProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple[50]!,
            Colors.white,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle para arrastrar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detalles de la Ubicación',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.purple[400],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildContent(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LocationsController controller) {
    if (controller.pageState == UiState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.pageState == UiState.error) {
      return Center(
        child: Text('Error: ${controller.errorMessage}'),
      );
    } else {
      return controller.currentLocation == null
          ? const Center(child: Text('No hay datos disponibles'))
          : _LocationDetails(location: controller.currentLocation!);
    }
  }
}

class _LocationDetails extends StatelessWidget {
  final Location location;

  const _LocationDetails({required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailItem(
          icon: Icons.location_on,
          title: 'Nombre',
          value: location.name,
          color: Colors.purple[700]!,
          backgroundColor: Colors.purple[50]!,
        ),
        const SizedBox(height: 16),
        _DetailItem(
          icon: Icons.category,
          title: 'Tipo',
          value: location.type,
          color: Colors.blue[700]!,
          backgroundColor: Colors.blue[50]!,
        ),
        const SizedBox(height: 16),
        _DetailItem(
          icon: Icons.public,
          title: 'Dimensión',
          value: location.dimension,
          color: Colors.green[700]!,
          backgroundColor: Colors.green[50]!,
        ),
        const SizedBox(height: 16),
        _DetailItem(
          icon: Icons.people,
          title: 'Número de Residentes',
          value: '${location.residents.length} habitantes',
          color: Colors.orange[700]!,
          backgroundColor: Colors.orange[50]!,
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}