import 'package:flutter/material.dart';
import 'package:zavrsni/components/piece.dart';
import 'dart:io';
import 'dart:math';

import 'package:zavrsni/styles.dart';

String toChessCoords(num row, num col) {
  const files = 'abcdefgh';
  num rank = 8 - row;
  String file = files[col.toInt()];
  return '$file$rank';
}

Widget buildSectionHeader(BuildContext context, String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      title,
      style: Styles.customColorText(
        context,
        Styles.headerLarge(context).copyWith(
          fontWeight: FontWeight.bold, // Bold text
          letterSpacing: 1.5,
        ),
        true,
      ),
    ),
  );
}

class NumberPair {
  final Point pair;
  final int number;

  const NumberPair(this.pair, this.number);
}

class Goal {
  final List<NumberPair>? checkpoints;
  final int steps;

  Goal(this.checkpoints, this.steps);
}

abstract class AbstractBoard {
  final Random random = Random();
  final ChessPieceType pieceType;
  List<List<ChessPiece?>> board;

  AbstractBoard(this.pieceType)
    : board = List.generate(8, (_) => List.filled(8, null));

  Goal generateDifficulty(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 6;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty,
    );
  }
}

Goal generateCheckpointsWithDifficulty(
  List<List<ChessPiece?>> board,
  int startRow,
  int startCol,
  ChessPieceType pieceType,
  int difficulty,
) {
  List<NumberPair> numberedCheckpoints = [];
  Set<String> visited = {};
  int currentRow = startRow;
  int currentCol = startCol;
  Random random = Random();

  int maxSteps = switch (difficulty) {
    0 => 2 + random.nextInt(1),
    1 => 3 + random.nextInt(1),
    2 => 4 + random.nextInt(2),
    _ => 6 + random.nextInt(2),
  };

  visited.add('$currentRow-$currentCol');
  int step = 1;

  for (int i = 0; i < maxSteps; i++) {
    List<List<int>> possibleMoves = calculatePossibleMoves(
      board,
      currentRow,
      currentCol,
      ChessPiece(
        type: pieceType,
        isWhite: true,
        imagePath: 'assets/images/white-${pieceType.name}.png',
      ),
    );

    // Remove visited
    possibleMoves.removeWhere(
      (move) => visited.contains('${move[0]}-${move[1]}'),
    );

    if (possibleMoves.isEmpty) break;

    List<int> move = possibleMoves[random.nextInt(possibleMoves.length)];

    currentRow = move[0];
    currentCol = move[1];
    visited.add('$currentRow-$currentCol');

    numberedCheckpoints.add(NumberPair(Point(currentRow, currentCol), step));
    step++;

    if (pieceType == ChessPieceType.pawn && currentRow == 0) break;
  }

  return Goal(numberedCheckpoints, step - 1);
}

class PawnBoard extends AbstractBoard {
  PawnBoard(super.pieceType);

  @override
  Goal generateDifficulty(int difficulty) {
    print("sad sam ovdje");
    print(difficulty);
    if (difficulty <= 3)
      return super.generateDifficulty(difficulty);
    else if (difficulty <= 7) {
      return generateDifficulty2(difficulty);
    } else {
      return generateDifficulty3(difficulty);
    }
  }

  Goal generateDifficulty2(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 6;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 4,
    );
  }

  Goal generateDifficulty3(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 7;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 8,
    );
  }
}

class KnightBoard extends AbstractBoard {
  KnightBoard(super.pieceType);

  @override
  Goal generateDifficulty(int difficulty) {
    print("sad sam ovdje");
    print(difficulty);
    if (difficulty <= 3)
      return super.generateDifficulty(difficulty);
    else if (difficulty <= 7) {
      return generateDifficulty2(difficulty);
    } else {
      return generateDifficulty3(difficulty);
    }
  }

  Goal generateDifficulty2(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 6;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 4,
    );
  }

  Goal generateDifficulty3(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 7;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 8,
    );
  }
}

class BishopBoard extends AbstractBoard {
  BishopBoard(super.pieceType);

  @override
  Goal generateDifficulty(int difficulty) {
    print("sad sam ovdje");
    print(difficulty);
    if (difficulty <= 3)
      return super.generateDifficulty(difficulty);
    else if (difficulty <= 7) {
      return generateDifficulty2(difficulty);
    } else {
      return generateDifficulty3(difficulty);
    }
  }

  Goal generateDifficulty2(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 6;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 4,
    );
  }

  Goal generateDifficulty3(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 7;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 8,
    );
  }
}

class RoyalBoard extends AbstractBoard {
  RoyalBoard(super.pieceType);

  @override
  Goal generateDifficulty(int difficulty) {
    print("sad sam ovdje");
    print(difficulty);
    if (difficulty <= 3)
      return super.generateDifficulty(difficulty);
    else if (difficulty <= 7) {
      return generateDifficulty2(difficulty);
    } else {
      return generateDifficulty3(difficulty);
    }
  }

  Goal generateDifficulty2(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 6;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 4,
    );
  }

  Goal generateDifficulty3(int difficulty) {
    board = List.generate(8, (_) => List.filled(8, null));
    int whiteRow = 7;
    int whiteCol = Random().nextInt(8);
    board[whiteRow][whiteCol] = ChessPiece(
      type: pieceType,
      isWhite: true,
      imagePath: 'assets/images/white-${pieceType.name}.png',
    );

    int row1 = whiteRow - 1 - random.nextInt(4);
    int col1 = whiteCol;

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    col1 =
        (col1 == 0)
            ? 1
            : (col1 == 7)
            ? 6
            : (random.nextBool() ? col1 - 1 : col1 + 1);

    board[row1][col1] = ChessPiece(
      type: pieceType,
      isWhite: false,
      imagePath: 'assets/images/black-${pieceType.name}.png',
    );

    List<ChessPieceType> types = ChessPieceType.values;
    int placed = 3;
    while (placed < 10) {
      int r = random.nextInt(8);
      int c = random.nextInt(8);
      if (board[r][c] == null && c != whiteCol && c != col1) {
        var type = types[random.nextInt(types.length)];
        board[r][c] = ChessPiece(
          type: type,
          isWhite: false,
          imagePath: 'assets/images/black-${type.name}.png',
        );
        placed++;
      }
    }

    return generateCheckpointsWithDifficulty(
      board,
      whiteRow,
      whiteCol,
      pieceType,
      difficulty - 8,
    );
  }
}

Function isWhite = (int index) {
  return (index ~/ 8) % 2 == 0 ? index % 2 == 0 : index % 2 != 0;
};

bool isMoveInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

Future<String> ReadConfig() async {
  final path = Directory.current.path;
  final filePath = '$path/assets/data/config.json';
  return await File(filePath).readAsString();
}

void FullBoard(List<List<ChessPiece?>> board) {
  board[1] = List.generate(
    8,
    (i) => ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: false,
      imagePath: 'assets/images/black-pawn.png',
    ),
  );
  board[6] = List.generate(
    8,
    (i) => ChessPiece(
      type: ChessPieceType.pawn,
      isWhite: true,
      imagePath: 'assets/images/white-pawn.png',
    ),
  );
  board[0][0] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: false,
    imagePath: 'assets/images/black-rook.png',
  );
  board[0][1] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: false,
    imagePath: 'assets/images/black-knight.png',
  );
  board[0][2] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: false,
    imagePath: 'assets/images/black-bishop.png',
  );
  board[0][3] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: false,
    imagePath: 'assets/images/black-queen.png',
  );
  board[0][4] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: false,
    imagePath: 'assets/images/black-king.png',
  );
  board[0][5] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: false,
    imagePath: 'assets/images/black-bishop.png',
  );
  board[0][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: false,
    imagePath: 'assets/images/black-knight.png',
  );
  board[0][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: false,
    imagePath: 'assets/images/black-rook.png',
  );
  board[7][0] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: true,
    imagePath: 'assets/images/white-rook.png',
  );
  board[7][1] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: true,
    imagePath: 'assets/images/white-knight.png',
  );
  board[7][2] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: true,
    imagePath: 'assets/images/white-bishop.png',
  );
  board[7][3] = ChessPiece(
    type: ChessPieceType.queen,
    isWhite: true,
    imagePath: 'assets/images/white-queen.png',
  );
  board[7][4] = ChessPiece(
    type: ChessPieceType.king,
    isWhite: true,
    imagePath: 'assets/images/white-king.png',
  );
  board[7][5] = ChessPiece(
    type: ChessPieceType.bishop,
    isWhite: true,
    imagePath: 'assets/images/white-bishop.png',
  );
  board[7][6] = ChessPiece(
    type: ChessPieceType.knight,
    isWhite: true,
    imagePath: 'assets/images/white-knight.png',
  );
  board[7][7] = ChessPiece(
    type: ChessPieceType.rook,
    isWhite: true,
    imagePath: 'assets/images/white-rook.png',
  );
}

List<List<int>> calculatePossibleMoves(
  List<List<ChessPiece?>> board,
  int row,
  int col,
  ChessPiece? piece,
) {
  List<List<int>> moves = [];

  if (piece == null) {
    return moves;
  }

  switch (piece.type) {
    case ChessPieceType.pawn:
      int direction = piece.isWhite ? -1 : 1;
      if (isMoveInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
        moves.add([row + direction, col]);
      }
      if (isMoveInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != piece.isWhite) {
        moves.add([row + direction, col - 1]);
      }
      if (isMoveInBoard(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.isWhite != piece.isWhite) {
        moves.add([row + direction, col + 1]);
      }
      if (isMoveInBoard(row + 2 * direction, col) &&
          row == (piece.isWhite ? 6 : 1) &&
          board[row + 2 * direction][col] == null &&
          board[row + direction][col] == null) {
        moves.add([row + 2 * direction, col]);
      }
      break;
    case ChessPieceType.knight:
      List<List<int>> directions = [
        [-2, -1],
        [-2, 1],
        [-1, -2],
        [-1, 2],
        [1, -2],
        [1, 2],
        [2, -1],
        [2, 1],
      ];
      for (var direction in directions) {
        int newRow = row + direction[0];
        int newCol = col + direction[1];
        if (isMoveInBoard(newRow, newCol) &&
            (board[newRow][newCol] == null ||
                board[newRow][newCol]!.isWhite != piece.isWhite)) {
          moves.add([newRow, newCol]);
        }
      }
      break;
    case ChessPieceType.bishop ||
        ChessPieceType.rook ||
        ChessPieceType.queen ||
        ChessPieceType.king:
      List<List<int>> directions;
      switch (piece.type) {
        case ChessPieceType.bishop:
          directions = [
            [-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1],
          ];
          break;
        case ChessPieceType.rook:
          directions = [
            [-1, 0],
            [0, -1],
            [1, 0],
            [0, 1],
          ];
          break;
        case ChessPieceType.queen || ChessPieceType.king:
          directions = [
            [-1, 0],
            [0, -1],
            [1, 0],
            [0, 1],
            [-1, -1],
            [-1, 1],
            [1, -1],
            [1, 1],
          ];
          break;
        default:
          directions = [];
          break;
      }

      if (piece.type == ChessPieceType.king) {
        for (var direction in directions) {
          int newRow = row + direction[0];
          int newCol = col + direction[1];
          if (isMoveInBoard(newRow, newCol) &&
              (board[newRow][newCol] == null ||
                  board[newRow][newCol]!.isWhite != piece.isWhite)) {
            moves.add([newRow, newCol]);
          }
        }
      } else {
        for (var direction in directions) {
          int newRow = row + direction[0];
          int newCol = col + direction[1];
          while (isMoveInBoard(newRow, newCol)) {
            if (board[newRow][newCol] == null) {
              moves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                moves.add([newRow, newCol]);
              }
              break;
            }
            newRow += direction[0];
            newCol += direction[1];
          }
        }
      }
      break;
  }
  return moves;
}
