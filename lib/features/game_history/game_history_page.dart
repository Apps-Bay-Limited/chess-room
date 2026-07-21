import 'package:chess_room/features/game_history/game_replay_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GameHistoryPage extends StatefulWidget {
  final GameHistoryStore store;
  final String pieceTheme;

  const GameHistoryPage({
    super.key,
    required this.store,
    this.pieceTheme = 'Classic',
  });

  @override
  State<GameHistoryPage> createState() => _GameHistoryPageState();
}

class _GameHistoryPageState extends State<GameHistoryPage> {
  List<SavedGame> _games = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final games = await widget.store.loadGames();
    if (!mounted) return;
    setState(() {
      _games = games;
      _loading = false;
    });
  }

  Future<void> _importPgn() async {
    final controller = TextEditingController();
    final pgn = await showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(S.of(context).Import_PGN),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: CupertinoTextField(
            key: const ValueKey('pgn-import-field'),
            controller: controller,
            minLines: 5,
            maxLines: 9,
            placeholder: S.of(context).Paste_PGN,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).Cancel),
          ),
          CupertinoDialogAction(
            key: const ValueKey('pgn-import-confirm'),
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(S.of(context).Import),
          ),
        ],
      ),
    );
    controller.dispose();
    if (pgn == null || pgn.trim().isEmpty || !mounted) return;
    try {
      await widget.store.saveGame(SavedGame.fromPgn(pgn));
      await _loadGames();
      if (mounted) _showMessage(S.of(context).PGN_Imported);
    } on FormatException {
      if (mounted) _showMessage(S.of(context).PGN_Invalid);
    }
  }

  Future<void> _exportPgn(SavedGame game) async {
    await Clipboard.setData(ClipboardData(text: game.pgn));
    if (mounted) _showMessage(S.of(context).PGN_Copied);
  }

  void _showMessage(String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).Done),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(SavedGame game) async {
    await widget.store.deleteGame(game.id);
    await _loadGames();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.Game_History),
        trailing: CupertinoButton(
          key: const ValueKey('import-pgn-button'),
          padding: EdgeInsets.zero,
          onPressed: _importPgn,
          child: const Icon(CupertinoIcons.doc_on_doc),
        ),
      ),
      child: SafeArea(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : _games.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      child: Text(
                        strings.No_Saved_Games,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    itemCount: _games.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      return _GameHistoryCard(
                        game: game,
                        result: _localizedResult(strings, game.result),
                        onReplay: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => GameReplayPage(
                              game: game,
                              pieceTheme: widget.pieceTheme,
                            ),
                          ),
                        ),
                        onReview: game.reviews.isEmpty
                            ? null
                            : () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => GameReviewPage(
                                      records: game.reviews,
                                      pieceTheme: widget.pieceTheme,
                                    ),
                                  ),
                                ),
                        onExport: () => _exportPgn(game),
                        onDelete: () => _delete(game),
                      );
                    },
                  ),
      ),
    );
  }
}

class _GameHistoryCard extends StatelessWidget {
  final SavedGame game;
  final String result;
  final VoidCallback onReplay;
  final VoidCallback? onReview;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  const _GameHistoryCard({
    required this.game,
    required this.result,
    required this.onReplay,
    required this.onReview,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Container(
      key: ValueKey('saved-game-${game.id}'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0x33000000),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${DateFormat.yMMMd().add_jm().format(game.playedAt)} · '
            '${strings.Move_Count((game.moves.length / 2).ceil())}',
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              CupertinoButton.tinted(
                onPressed: onReplay,
                child: Text(strings.Replay),
              ),
              if (onReview != null)
                CupertinoButton.tinted(
                  onPressed: onReview,
                  child: Text(strings.Review_Game),
                ),
              CupertinoButton(
                onPressed: onExport,
                child: Text(strings.Export_PGN),
              ),
              CupertinoButton(
                onPressed: onDelete,
                child: const Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.systemRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _localizedResult(S strings, SavedGameResult result) => switch (result) {
      SavedGameResult.whiteWin => strings.White_Wins,
      SavedGameResult.blackWin => strings.Black_Wins,
      SavedGameResult.draw => strings.Draw,
      SavedGameResult.unfinished => strings.Unfinished,
    };
