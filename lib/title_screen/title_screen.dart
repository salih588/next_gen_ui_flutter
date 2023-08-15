import 'package:flutter/material.dart';

import '../assets.dart';
import '../styles.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  final _finalRecieveLightAmt = 0.7;
  final _finalEmitLightAmt = 0.5;

  @override
  Widget build(BuildContext context) {
    final orbColor = AppColors.orbColors[0];
    final emitColor = AppColors.emitColors[0];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            /// Bg-Base
            Image.asset(AssetPaths.titleBgBase),

            /// Bg-Receive
            _LitImage(
                color: orbColor,
                imgSrc: AssetPaths.titleBgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Base
            _LitImage(
                color: orbColor,
                imgSrc: AssetPaths.titleMgBase,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Receive
            _LitImage(
                color: orbColor,
                imgSrc: AssetPaths.titleMgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Mg-Emit
            _LitImage(
                color: emitColor,
                imgSrc: AssetPaths.titleMgEmit,
                lightAmt: _finalEmitLightAmt),

            /// Fg-Rocks
            Image.asset(AssetPaths.titleFgBase),

            /// Fg-Receive
            _LitImage(
                color: orbColor,
                imgSrc: AssetPaths.titleFgReceive,
                lightAmt: _finalRecieveLightAmt),

            /// Fg-Emit
            _LitImage(
                color: emitColor,
                imgSrc: AssetPaths.titleFgEmit,
                lightAmt: _finalEmitLightAmt),
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
