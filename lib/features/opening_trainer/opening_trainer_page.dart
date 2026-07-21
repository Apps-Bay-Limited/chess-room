import 'package:chess_room/features/opening_trainer/opening_course.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/logic/chess_board.dart';
import 'package:chess_room/logic/chess_notation.dart';
import 'package:chess_room/logic/move_calculation/move_classes/move.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:chess_room/views/components/shared/position_board.dart';
import 'package:flutter/cupertino.dart';

class OpeningTrainerPage extends StatefulWidget {
  final OpeningProgressStore? progressStore;
  final String pieceTheme;

  const OpeningTrainerPage({
    super.key,
    this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<OpeningTrainerPage> createState() => _OpeningTrainerPageState();
}

class _OpeningTrainerPageState extends State<OpeningTrainerPage> {
  late final OpeningProgressStore _store;
  Set<String> _completed = {};

  @override
  void initState() {
    super.initState();
    _store = widget.progressStore ?? SharedPreferencesOpeningProgressStore();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _store.loadCompletedIds();
    if (mounted) setState(() => _completed = completed);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Opening_Trainer),
      ),
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: openingCourses.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  strings.Opening_Trainer_Description,
                  style: const TextStyle(fontSize: 17),
                ),
              );
            }
            final course = openingCourses[index - 1];
            final complete = _completed.contains(course.id.name);
            return CupertinoButton(
              key: ValueKey('opening-${course.id.name}'),
              padding: EdgeInsets.zero,
              onPressed: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => OpeningSessionPage(
                      course: course,
                      progressStore: _store,
                      pieceTheme: widget.pieceTheme,
                    ),
                  ),
                );
                _loadProgress();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: const Color(0x33000000),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            openingName(strings, course.id),
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            openingDescription(strings, course.id),
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      complete
                          ? CupertinoIcons.check_mark_circled_solid
                          : CupertinoIcons.chevron_forward,
                      color: complete
                          ? CupertinoColors.activeGreen
                          : CupertinoColors.systemGrey,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OpeningSessionPage extends StatefulWidget {
  final OpeningCourse course;
  final OpeningProgressStore progressStore;
  final String pieceTheme;

  const OpeningSessionPage({
    super.key,
    required this.course,
    required this.progressStore,
    this.pieceTheme = 'Classic',
  });

  @override
  State<OpeningSessionPage> createState() => _OpeningSessionPageState();
}

class _OpeningSessionPageState extends State<OpeningSessionPage> {
  ChessBoard _board = ChessBoard();
  int _moveIndex = 0;
  int? _selectedTile;
  bool _wrong = false;
  bool _complete = false;

  Move get _expectedMove => moveFromUci(widget.course.moves[_moveIndex]);

  void _onTileTap(int tile) {
    if (_complete) return;
    final player = _moveIndex.isEven ? Player.player1 : Player.player2;
    if (_selectedTile == null) {
      if (_board.tiles[tile]?.player == player) {
        setState(() {
          _selectedTile = tile;
          _wrong = false;
        });
      }
      return;
    }
    final attempt = Move(_selectedTile!, tile);
    if (attempt == _expectedMove) {
      push(_expectedMove, _board);
      final finished = _moveIndex == widget.course.moves.length - 1;
      if (finished) {
        widget.progressStore.markCompleted(widget.course.id.name);
      }
      setState(() {
        _moveIndex++;
        _selectedTile = null;
        _wrong = false;
        _complete = finished;
      });
    } else {
      setState(() {
        _selectedTile = null;
        _wrong = true;
      });
    }
  }

  void _restart() {
    setState(() {
      _board = ChessBoard();
      _moveIndex = 0;
      _selectedTile = null;
      _wrong = false;
      _complete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final player = _moveIndex.isEven ? Player.player1 : Player.player2;
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(openingName(strings, widget.course.id)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(
                openingDescription(strings, widget.course.id),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _complete
                    ? strings.Opening_Complete
                    : strings.Opening_Move_Prompt(
                        _moveIndex + 1,
                        widget.course.moves.length,
                        player == Player.player1
                            ? strings.White
                            : strings.Black,
                      ),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.lg),
              PositionBoard(
                key: ValueKey('opening-board-$_moveIndex'),
                board: _board,
                pieceTheme: widget.pieceTheme,
                selectedTile: _selectedTile,
                onTileTap: _onTileTap,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_wrong)
                Text(
                  strings.Opening_Try_Again,
                  style: const TextStyle(color: CupertinoColors.systemOrange),
                ),
              if (_complete)
                CupertinoButton.filled(
                  key: const ValueKey('restart-opening'),
                  onPressed: _restart,
                  child: Text(strings.Practice_Again),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String openingName(S strings, OpeningId id) => switch (id) {
      OpeningId.italian => strings.Opening_Italian,
      OpeningId.ruyLopez => strings.Opening_Ruy_Lopez,
      OpeningId.queensGambit => strings.Opening_Queens_Gambit,
      OpeningId.sicilian => strings.Opening_Sicilian,
      OpeningId.london => strings.Opening_London,
    };

String openingDescription(S strings, OpeningId id) => switch (id) {
      OpeningId.italian => strings.Opening_Italian_Description,
      OpeningId.ruyLopez => strings.Opening_Ruy_Lopez_Description,
      OpeningId.queensGambit => strings.Opening_Queens_Gambit_Description,
      OpeningId.sicilian => strings.Opening_Sicilian_Description,
      OpeningId.london => strings.Opening_London_Description,
    };
