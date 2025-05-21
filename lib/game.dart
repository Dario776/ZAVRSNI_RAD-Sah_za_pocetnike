import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsni/components/piece.dart';
import 'package:zavrsni/components/square.dart';
import 'package:zavrsni/helper/help.dart';
import 'package:zavrsni/helper/helper.dart';
import 'package:zavrsni/settings/settings.dart';
import 'package:zavrsni/styles.dart';
import 'package:audioplayers/audioplayers.dart';

class Game extends StatefulWidget {
  final AbstractBoard boardObject;
  final String lessonTitle;
  final List<String> lessonSubtitle;
  final List<String> lessonDescription;

  const Game({
    super.key,
    required this.boardObject,
    required this.lessonTitle,
    required this.lessonSubtitle,
    required this.lessonDescription,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isSound = true;
  int gameDifficulty = 0;
  Goal goal = Goal([], 0);
  List<List<ChessPiece?>> board = List.generate(8, (_) => List.filled(8, null));

  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> possibleMoves = [];

  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;
  String? _resetMessage;

  Timer? _successTimer;
  Timer? _errorTimer;
  Timer? _resetTimer;

  double boardMaxSize = 500;
  late double boardSize = boardMaxSize;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  Future<void> _initializeBoard() async {
    final prefs = await SharedPreferences.getInstance();
    isSound = prefs.getBool('Sound') ?? true;
    gameDifficulty =
        prefs.getInt('gameDifficulty${widget.boardObject.pieceType}') ?? 0;
    if (gameDifficulty == 0x7FFFFFFFFFFFFFFF) {
      gameDifficulty = 0;
    }
    goal = widget.boardObject.generateDifficulty(gameDifficulty);
    board = widget.boardObject.board;
    setState(() {});
  }

  Future<void> pieceSelected(int row, int col) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      ChessPiece? tappedPiece = board[row][col];

      if (tappedPiece != null && tappedPiece.isWhite) {
        // Select a piece
        setState(() {
          selectedPiece = tappedPiece;
          selectedRow = row;
          selectedCol = col;
          possibleMoves = calculatePossibleMoves(board, row, col, tappedPiece);
        });
      } else if (selectedPiece != null &&
          possibleMoves.any((e) => e[0] == row && e[1] == col)) {
        // Valid move
        await movePiece(row, col);
      } else if (selectedPiece != null) {
        // Invalid move when piece is selected
        await playSound('error.ogg');
        showError('Nedozvoljen potez!');
        selectedPiece = null;
        selectedRow = -1;
        selectedCol = -1;
        possibleMoves = [];
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> movePiece(int row, int col) async {
    if (selectedPiece == null) return;

    setState(() {
      board[row][col] = selectedPiece;
      board[selectedRow][selectedCol] = null;

      // Checkpoint logic (if needed for goal tracking)
      if (goal.checkpoints!.isNotEmpty &&
          row == goal.checkpoints!.first.pair.x &&
          col == goal.checkpoints!.first.pair.y) {
        goal.checkpoints?.removeAt(0);
      }

      if (goal.checkpoints!.isEmpty) {
        selectedPiece = null;
        selectedRow = -1;
        selectedCol = -1;
        possibleMoves = [];
      } else {
        selectedRow = row;
        selectedCol = col;
        possibleMoves = calculatePossibleMoves(board, row, col, selectedPiece);
      }
    });

    await playSound('small_win.wav');

    if (goal.checkpoints!.isEmpty) {
      await playSound('big_win.wav');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'gameDifficulty${widget.boardObject.pieceType}',
        ++gameDifficulty,
      );
      showSuccess('Bravo! Sljedeća razina!');
      await _initializeBoard();
    }
  }

  void resetSelection() {
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      possibleMoves = [];
    });
  }

  Future<void> playSound(String name) async {
    if (isSound) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/$name'));
    }
  }

  void showError(String message) {
    _errorTimer?.cancel(); // Cancel previous timer if any
    setState(() => _errorMessage = message);
    _errorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _errorMessage = null);
    });
  }

  void showSuccess(String message) {
    _successTimer?.cancel(); // Cancel previous timer if any
    setState(() => _successMessage = message);
    _successTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _successMessage = null);
    });
  }

  void showReset(String message) {
    _resetTimer?.cancel(); // Cancel previous timer if any
    setState(() => _resetMessage = message);
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _resetMessage = null);
    });
  }

  Widget _buildGameButton(
    String text,
    VoidCallback onPressed,
    double buttonSize,
  ) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize / 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          textStyle: Styles.customColorText(
            context,
            Styles.textDefault(context),
            true,
          ).copyWith(fontWeight: FontWeight.bold),

          shadowColor: Colors.black,
          elevation: 10,
        ),
        onPressed:
            _successMessage == null &&
                    _errorMessage == null &&
                    _resetMessage == null
                ? onPressed
                : null,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildOverlayMessage(String message, Color backgroundColor) {
    return Positioned.fill(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBoardAndButtons() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: boardSize,
                height: boardSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Styles.primaryTextColor, width: 2),
                ),
                child: GridView.builder(
                  itemCount: 64,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;

                    bool isSelected = selectedRow == row && selectedCol == col;
                    bool isValidMove = possibleMoves.any(
                      (e) => e[0] == row && e[1] == col,
                    );
                    bool isCheckpoint = goal.checkpoints!.any(
                      (cp) => cp.pair.x == row && cp.pair.y == col,
                    );
                    bool isGoal =
                        goal.checkpoints!.isNotEmpty &&
                        goal.checkpoints!.first.pair.x == row &&
                        goal.checkpoints!.first.pair.y == col;

                    return Square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => pieceSelected(row, col),
                      row: row,
                      col: col,
                      isGoal: isGoal,
                      isCheckpoint: isCheckpoint,
                      stepNumber:
                          goal.checkpoints != null
                              ? goal.checkpoints!.indexWhere(
                                    (cp) =>
                                        cp.pair.x == row && cp.pair.y == col,
                                  ) +
                                  1
                              : null,
                    );
                  },
                ),
              ),
              if (_resetMessage != null)
                _buildOverlayMessage(_resetMessage!, Colors.lightBlue),
              if (_successMessage != null)
                _buildOverlayMessage(_successMessage!, Colors.green),
              if (_errorMessage != null)
                _buildOverlayMessage(_errorMessage!, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildGameButton('Resetiraj', () async {
                await playSound('reset.wav');
                showReset('Razina resetirana!');
                resetSelection();
                _initializeBoard();
              }, (boardSize - 48) / 3),
              _buildGameButton('Upute', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              }, (boardSize - 48) / 3),
              _buildGameButton('Preskoči', () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(
                  'gameDifficulty${widget.boardObject.pieceType}',
                  ++gameDifficulty,
                );
                await playSound('big_win.wav');
                showSuccess('Razina preskočena!');
                resetSelection();
                await _initializeBoard();
              }, (boardSize - 48) / 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnChildren(
    BuildContext context,
    List<String> lessonSubtitle,
    List<String> lessonDescription,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < lessonSubtitle.length; i++) ...[
          buildSectionHeader(context, lessonSubtitle[i]),
          const SizedBox(height: 12),
          Text(
            lessonDescription[i],
            style: Styles.customColorText(
              context,
              Styles.textDefault(context),
              false,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isTall = screenHeight >= 1000;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lessonTitle,
          style: Styles.customColorText(
            context,
            Styles.navBarTitle(context),
            false,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              final prefs = await SharedPreferences.getInstance();
              isSound = prefs.getBool('Sound') ?? true;
              gameDifficulty =
                  prefs.getInt(
                    'gameDifficulty${widget.boardObject.pieceType}',
                  ) ??
                  0;
              if (gameDifficulty == 0) {
                resetSelection();
                _initializeBoard();
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          boardSize =
              constraints.maxWidth < boardMaxSize
                  ? constraints.maxWidth
                  : boardMaxSize;

          if (isTall) {
            // Tall layout with sticky bottom board + buttons
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: boardSize),
                          child: _buildColumnChildren(
                            context,
                            widget.lessonSubtitle,
                            widget.lessonDescription,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: boardSize,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: Styles.customColorText(
                        context,
                        Styles.headerLarge(context),
                        false,
                      ).copyWith(fontWeight: FontWeight.w600),
                      children: [
                        const TextSpan(text: 'Razina: '),
                        TextSpan(
                          text: '${gameDifficulty + 1}',
                          style: TextStyle(
                            fontSize:
                                Styles.headerLarge(context).fontSize! *
                                1.4, // 40% larger
                            fontWeight: FontWeight.bold,
                            color: Styles.accentColor, // Highlight color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Container(
                  width: boardSize,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: Styles.customColorText(
                        context,
                        Styles.headerLarge(context),
                        false,
                      ).copyWith(fontWeight: FontWeight.w600),
                      children: [
                        const TextSpan(text: 'Trenutni cilj: '),
                        TextSpan(
                          text:
                              '${goal.checkpoints!.isNotEmpty ? toChessCoords(goal.checkpoints!.first.pair.x, goal.checkpoints!.first.pair.y) : 'bravo!'}',
                          style: TextStyle(
                            fontSize:
                                Styles.headerLarge(context).fontSize! *
                                1.4, // 40% larger
                            fontWeight: FontWeight.bold,
                            color: Styles.accentColor, // Highlight color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildBoardAndButtons(),
                const SizedBox(height: 36),
              ],
            );
          } else {
            // Short layout with everything scrollable
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: boardSize),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildColumnChildren(
                          context,
                          widget.lessonSubtitle,
                          widget.lessonDescription,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: boardSize,
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: Styles.customColorText(
                          context,
                          Styles.headerLarge(context),
                          false,
                        ).copyWith(fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(text: 'Razina: '),
                          TextSpan(
                            text: '${gameDifficulty + 1}',
                            style: TextStyle(
                              fontSize:
                                  Styles.headerLarge(context).fontSize! *
                                  1.4, // 40% larger
                              fontWeight: FontWeight.bold,
                              color: Styles.accentColor, // Highlight color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: boardSize,
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: Styles.customColorText(
                          context,
                          Styles.headerLarge(context),
                          false,
                        ).copyWith(fontWeight: FontWeight.w600),
                        children: [
                          const TextSpan(text: 'Trenutni cilj: '),
                          TextSpan(
                            text:
                                '${goal.checkpoints!.isNotEmpty ? toChessCoords(goal.checkpoints!.first.pair.x, goal.checkpoints!.first.pair.y) : 'bravo!'}',
                            style: TextStyle(
                              fontSize:
                                  Styles.headerLarge(context).fontSize! *
                                  1.4, // 40% larger
                              fontWeight: FontWeight.bold,
                              color: Styles.accentColor, // Highlight color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildBoardAndButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
