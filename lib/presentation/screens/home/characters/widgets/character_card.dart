import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/data/models/character/character.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/locations/widgets/location_details_bottom_sheet.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    Key? key,
    required this.character,
  }) : super(key: key);

  void _showLocationBottomSheet(BuildContext context) {
    if (character.location.url.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (_, controller) => LocationDetailsBottomSheet(
          locationUrl: character.location.url,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      height: 200,
      child: Card(
        color: Colors.grey[100],
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del personaje
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                child: Image.network(
                  character.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Información del personaje
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y ID
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            character.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '#${character.id}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400],
                          ),
                        ),
                      ],
                    ),
                    // Info chips
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInfoChip(
                          icon: Icons.security,
                          label: character.status,
                          color: character.status.toLowerCase() == 'alive' 
                              ? Colors.green 
                              : character.status.toLowerCase() == 'dead' 
                                  ? Colors.red 
                                  : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoChip(
                          icon: Icons.person,
                          label: character.species,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoChip(
                          icon: Icons.transgender,
                          label: character.gender,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    // Botón de ubicación
                    GestureDetector(
                      onTap: () => _showLocationBottomSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.purple[200]!,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ubicación',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    character.location.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.purple[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}