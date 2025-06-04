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
    final scaleFactor = (screenWidth / 400).clamp(1.0, 2.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => lessonPage),
        );
      },
      child: Container(
        height: 200 * scaleFactor,
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
              _buildTitle(context, scaleFactor),
              _buildImage(scaleFactor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, double scaleFactor) {
    return Container(
      height: 30 * scaleFactor,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Styles.customColorText(
          context,
          TextStyle(fontSize: 16 * scaleFactor, fontWeight: FontWeight.bold),
          true,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildImage(double scaleFactor) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            height: 64 * scaleFactor,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
