import 'package:flutter/material.dart';
import 'package:zavrsni/components/piece.dart';
import 'package:zavrsni/styles.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final bool isValidMove;
  final bool isGoal;
  final bool isCheckpoint;

  final ChessPiece? piece;
  final bool isSelected;
  final int row;
  final int col;
  final int? stepNumber;

  final void Function() onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
    required this.row,
    required this.col,
    required this.isGoal,
    required this.isCheckpoint,
    this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected) {
      squareColor = Colors.yellow[600];
    } else if (isValidMove && piece != null) {
      squareColor = Colors.red[400];
    } else if (isGoal) {
      squareColor = const Color.fromARGB(255, 30, 83, 229);
    } else if (isCheckpoint) {
      squareColor = Colors.lightBlue[200];
    } else {
      squareColor = isWhite ? Colors.white : Styles.backgroundColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: squareColor),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (piece != null)
              Container(
                padding: EdgeInsets.all(0),
                child: Image.asset(piece!.imagePath, fit: BoxFit.contain),
              ),

            if (row == 7)
              Positioned(
                bottom: 2,
                left: 2,
                child: Text(
                  String.fromCharCode(97 + col),
                  style: Styles.boardText(context, isWhite),
                ),
              ),

            if (col == 7)
              Positioned(
                top: 2,
                right: 2,
                child: Text(
                  (8 - row).toString(),
                  style: Styles.boardText(context, isWhite),
                ),
              ),

            if (isValidMove && piece == null)
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow[400],
                ),
              ),

            if (isCheckpoint || isGoal)
              Positioned(
                bottom: 2,
                right: 2,
                child: Text(
                  // Choose the number from your logic (pass it via props)
                  '${stepNumber ?? ''}',

                  style: Styles.textDefault(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
