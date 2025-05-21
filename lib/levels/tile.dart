import 'package:flutter/material.dart';
import 'package:zavrsni/styles.dart';

class LessonTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget lessonPage;

  const LessonTile({
    super.key,
    required this.title,
    required this.imagePath,
    required this.lessonPage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Base scale factor from screen width
    final scaleFactor = screenWidth / 400; // Tune this value as needed

    // Limit scaleFactor to reasonable range
    final clampedScale = scaleFactor.clamp(1.0, 2.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => lessonPage),
        );
      },
      child: Container(
        height: 200 * clampedScale, // Also scales height
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Column(
            children: [
              // Title (same size for all tiles on device)
              Container(
                height: 30 * clampedScale,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Styles.customColorText(
                    context,
                    TextStyle(
                      fontSize: 16 * clampedScale, // Base font size * scale
                      fontWeight: FontWeight.bold,
                    ),
                    true,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Image (scales with screen)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Image.asset(
                      imagePath,
                      height: 64 * clampedScale, // Image scales with screen
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
