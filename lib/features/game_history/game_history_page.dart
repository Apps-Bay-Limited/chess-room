import 'package:chess_room/features/game_history/game_replay_page.dart';
import 'package:chess_room/features/game_history/saved_game.dart';
import 'package:chess_room/features/game_review/game_review_page.dart';
import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:chess_room/views/components/shared/app_page.dart';
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
  bool _loadFailed = false;
  bool _deletePending = false;
  bool _importPending = false;
  bool _messageOpen = false;
  int _loadRevision = 0;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final revision = ++_loadRevision;
    try {
      final games = await widget.store.loadGames();
      if (!mounted || revision != _loadRevision) return;
      setState(() {
        _games = games;
        _loading = false;
        _loadFailed = false;
      });
    } catch (_) {
      if (!mounted || revision != _loadRevision) return;
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  Future<void> _importPgn() async {
    if (_importPending || _deletePending) return;
    setState(() => _importPending = true);
    try {
      final pgn = await showCupertinoDialog<String>(
        context: context,
        builder: (_) => const _PgnImportDialog(),
      );
      if (pgn == null || pgn.trim().isEmpty || !mounted) return;
      await widget.store.saveGame(SavedGame.fromPgn(pgn));
      if (!mounted) return;
      await _loadGames();
      if (mounted) _showMessage(S.of(context).PGN_Imported);
    } on FormatException {
      if (mounted) _showMessage(S.of(context).PGN_Invalid);
    } catch (_) {
      if (mounted) _showMessage(S.of(context).Local_Data_Unavailable);
    } finally {
      if (mounted) setState(() => _importPending = false);
    }
  }

  Future<void> _exportPgn(SavedGame game) async {
    await Clipboard.setData(ClipboardData(text: game.pgn));
    if (mounted) _showMessage(S.of(context).PGN_Copied);
  }

  void _showMessage(String message) {
    if (_messageOpen) return;
    _messageOpen = true;
    var answered = false;
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              if (answered ||
                  !context.mounted ||
                  !(ModalRoute.of(context)?.isCurrent ?? false)) return;
              answered = true;
              Navigator.pop(context);
            },
            child: Text(S.of(context).Done),
          ),
        ],
      ),
    ).whenComplete(() => _messageOpen = false);
  }

  Future<void> _delete(SavedGame game) async {
    if (_deletePending || _importPending) return;
    setState(() => _deletePending = true);
    try {
      final strings = S.of(context);
      var answered = false;
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(strings.Delete_Game_Title),
          content: Text(strings.Delete_Game_Message),
          actions: [
            CupertinoDialogAction(
              key: const ValueKey('cancel-delete-game'),
              onPressed: () {
                if (answered ||
                    !dialogContext.mounted ||
                    !(ModalRoute.of(dialogContext)?.isCurrent ?? false)) return;
                answered = true;
                Navigator.pop(dialogContext, false);
              },
              child: Text(strings.Cancel),
            ),
            CupertinoDialogAction(
              key: const ValueKey('confirm-delete-game'),
              isDestructiveAction: true,
              onPressed: () {
                if (answered ||
                    !dialogContext.mounted ||
                    !(ModalRoute.of(dialogContext)?.isCurrent ?? false)) return;
                answered = true;
                Navigator.pop(dialogContext, true);
              },
              child: Text(strings.Delete),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await widget.store.deleteGame(game.id);
      if (mounted) {
        setState(() =>
            _games = _games.where((saved) => saved.id != game.id).toList());
        await _loadGames();
      }
    } catch (_) {
      if (mounted) _showMessage(S.of(context).Delete_Game_Failed);
    } finally {
      if (mounted) setState(() => _deletePending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return AppPage(
      title: strings.Game_History,
      trailing: Semantics(
        label: strings.Import_PGN,
        button: true,
        child: CupertinoButton(
          key: const ValueKey('import-pgn-button'),
          padding: EdgeInsets.zero,
          onPressed: _importPending || _deletePending ? null : _importPgn,
          child: const Icon(CupertinoIcons.doc_on_doc),
        ),
      ),
      child: AppContent(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : _games.isEmpty
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.doc_text,
                            size: 40, color: AppColors.accent),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                            _loadFailed
                                ? strings.Local_Data_Unavailable
                                : strings.No_Saved_Games,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textSecondary)),
                        if (_loadFailed)
                          CupertinoButton(
                              onPressed: _loadGames,
                              child: Text(strings.Retry)),
                      ],
                    ),
                  ))
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    itemCount: _games.length + (_loadFailed ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (_loadFailed && index == 0) {
                        return Column(children: [
                          Text(strings.Local_Data_Unavailable),
                          CupertinoButton(
                              onPressed: _loadGames,
                              child: Text(strings.Retry)),
                        ]);
                      }
                      final game = _games[index - (_loadFailed ? 1 : 0)];
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
                        onDelete: _deletePending || _importPending
                            ? null
                            : () => _delete(game),
                      );
                    },
                  ),
      ),
    );
  }
}

/// The controller follows the dialog route's lifetime, including its closing
/// animation. A popped dialog can still build its text field before disposal.
class _PgnImportDialog extends StatefulWidget {
  const _PgnImportDialog();

  @override
  State<_PgnImportDialog> createState() => _PgnImportDialogState();
}

class _PgnImportDialogState extends State<_PgnImportDialog> {
  final _controller = TextEditingController();
  bool _answered = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish(String? pgn) {
    if (!mounted || _answered || !(ModalRoute.of(context)?.isCurrent ?? false))
      return;
    _answered = true;
    Navigator.pop(context, pgn);
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return PopScope<String>(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _answered = true;
      },
      child: CupertinoAlertDialog(
        title: Text(strings.Import_PGN),
        content: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: CupertinoTextField(
            key: const ValueKey('pgn-import-field'),
            controller: _controller,
            minLines: 5,
            maxLines: 9,
            placeholder: strings.Paste_PGN,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            key: const ValueKey('pgn-import-cancel'),
            onPressed: () => _finish(null),
            child: Text(strings.Cancel),
          ),
          CupertinoDialogAction(
            key: const ValueKey('pgn-import-confirm'),
            onPressed: () => _finish(_controller.text),
            child: Text(strings.Import),
          ),
        ],
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
  final VoidCallback? onDelete;

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
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
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
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
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
              Semantics(
                label: strings.Delete,
                button: true,
                child: CupertinoButton(
                  key: ValueKey('delete-saved-game-${game.id}'),
                  onPressed: onDelete,
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: AppColors.error,
                  ),
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
