import 'package:flutter/material.dart';

class AlbumHomeScreen extends StatelessWidget {
  const AlbumHomeScreen({super.key});

  static const _sampleColors = [
    Color(0xFFE8C8B8),
    Color(0xFFD7B49E),
    Color(0xFFF0DDD2),
    Color(0xFFCFA58D),
    Color(0xFFE5CFC3),
    Color(0xFFBE8F75),
  ];

  int _calculateColumnCount(double width) {
    if (width >= 1000) {
      return 5;
    }

    if (width >= 600) {
      return 4;
    }

    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = _calculateColumnCount(constraints.maxWidth);

        return GridView.builder(
          itemCount: 18,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            return ColoredBox(
              color: _sampleColors[index % _sampleColors.length],
              child: Center(
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
