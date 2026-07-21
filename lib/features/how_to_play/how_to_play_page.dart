import 'package:chess_room/generated/l10n.dart';
import 'package:chess_room/util/app_design.dart';
import 'package:flutter/cupertino.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return CupertinoPageScaffold(
      backgroundColor: const Color(0xff493B24),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xff24201C),
        middle: Text(strings.How_To_Play_Chess),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text(
              strings.How_To_Play_Intro,
              style: const TextStyle(fontSize: 17, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.xl),
            _RuleSection(
              title: strings.Chess_Goal_Title,
              children: [_RuleText(strings.Chess_Goal_Body)],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              title: strings.Chess_Setup_Title,
              children: [_RuleText(strings.Chess_Setup_Body)],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              key: const ValueKey('how-to-play-pieces'),
              title: strings.Chess_Pieces_Title,
              children: [
                _PieceRule(symbol: '♔', rule: strings.Chess_King_Rule),
                _PieceRule(symbol: '♕', rule: strings.Chess_Queen_Rule),
                _PieceRule(symbol: '♖', rule: strings.Chess_Rook_Rule),
                _PieceRule(symbol: '♗', rule: strings.Chess_Bishop_Rule),
                _PieceRule(symbol: '♘', rule: strings.Chess_Knight_Rule),
                _PieceRule(symbol: '♙', rule: strings.Chess_Pawn_Rule),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              key: const ValueKey('how-to-play-special-moves'),
              title: strings.Chess_Special_Moves_Title,
              children: [
                _BulletRule(strings.Chess_Castling_Rule),
                _BulletRule(strings.Chess_En_Passant_Rule),
                _BulletRule(strings.Chess_Promotion_Rule),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              title: strings.Chess_Check_Title,
              children: [_RuleText(strings.Chess_Check_Body)],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              title: strings.Chess_Draws_Title,
              children: [_RuleText(strings.Chess_Draws_Body)],
            ),
            const SizedBox(height: AppSpacing.md),
            _RuleSection(
              title: strings.Chess_Tips_Title,
              children: [_RuleText(strings.Chess_Tips_Body)],
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _RuleSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0x33000000),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _RuleText extends StatelessWidget {
  final String text;

  const _RuleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: CupertinoColors.systemGrey2,
        fontSize: 16,
        height: 1.4,
      ),
    );
  }
}

class _PieceRule extends StatelessWidget {
  final String symbol;
  final String rule;

  const _PieceRule({required this.symbol, required this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Text(
              symbol,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _RuleText(rule)),
        ],
      ),
    );
  }
}

class _BulletRule extends StatelessWidget {
  final String rule;

  const _BulletRule(this.rule);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _RuleText(rule)),
        ],
      ),
    );
  }
}
