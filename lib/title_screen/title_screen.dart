import 'package:flutter/material.dart';

import '../assets.dart';
import '../styles.dart';
import 'title_screen_ui.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverride ?? _difficulty];

  int? _difficultyOverride;

  int _difficulty = 0;

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
  }

  void _handleDifficultyFocused(int? value) {
    setState(() => _difficultyOverride = value);
  }

  final _finalRecieveLightAmt = 0.7;
  final _finalEmitLightAmt = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            /// Bg-Base
            Image.asset(AssetPaths.titleBgBase),

            /// Bg-Receive
            _LitImage(
                color: _orbColor,
                imgSrc: AssetPaths.titleBgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Base
            _LitImage(
                color: _orbColor,
                imgSrc: AssetPaths.titleMgBase,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Receive
            _LitImage(
                color: _orbColor,
                imgSrc: AssetPaths.titleMgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Emit
            _LitImage(
                color: _emitColor,
                imgSrc: AssetPaths.titleMgEmit,
                lightAmt: _finalEmitLightAmt),

            /// Fg-Rocks
            Image.asset(AssetPaths.titleFgBase),

            /// Fg-Receive
            _LitImage(
                color: _orbColor,
                imgSrc: AssetPaths.titleFgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Fg-Emit
            _LitImage(
                color: _emitColor,
                imgSrc: AssetPaths.titleFgEmit,
                lightAmt: _finalEmitLightAmt),

            Positioned.fill(
              child: TitleScreenUi(
                difficulty: _difficulty,
                onDifficultyPressed: _handleDifficultyPressed,
                onDifficultyFoucused: _handleDifficultyFocused,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  const _LitImage(
      {required this.color, required this.imgSrc, required this.lightAmt});
  final Color color;
  final String imgSrc;
  final double lightAmt;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return Image.asset(
      imgSrc,
      color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
      colorBlendMode: BlendMode.modulate,
    );
  }
}
