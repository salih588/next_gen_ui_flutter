import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../assets.dart';
import '../orb_shader/orb_shader_config.dart';
import '../orb_shader/orb_shader_widget.dart';
import '../styles.dart';
import 'title_screen_ui.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with SingleTickerProviderStateMixin {
  final _orbKey = GlobalKey<OrbShaderWidgetState>();

  final _minRecieveLightAmt = .35;
  final _maxRecieveLightAmt = .7;

  final _minEmitLightAmt = .5;
  final _maxEmitLightAmt = 1;

  var _mousePose = Offset.zero;

  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverride ?? _difficulty];

  int? _difficultyOverride;

  int _difficulty = 0;
  double _orbEnergy = 0;
  double _minOrbEnergy = 0;

  double get _finalRecieveLightAmt {
    final light =
        lerpDouble(_minRecieveLightAmt, _maxRecieveLightAmt, _orbEnergy) ?? 0;
    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt {
    return lerpDouble(_minEmitLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;
  }

  late final _pulseEffect = AnimationController(
      vsync: this,
      duration: _getRndPulseDuration(),
      lowerBound: -1,
      upperBound: 1);

  Duration _getRndPulseDuration() => 100.ms + 200.ms * Random().nextDouble();

  double _getMinEnergyForDifficulty(int difficulty) {
    if (difficulty == 1) {
      return .3;
    } else if (difficulty == 2) {
      return .6;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _pulseEffect.forward();
    _pulseEffect.addListener(_handlePulseEffectUpdated);
  }

  void _handlePulseEffectUpdated() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
    _bumbMinEnergy();
  }

  Future<void> _bumbMinEnergy([double amount = 0.1]) async {
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty) + amount;
    });
    await Future<void>.delayed(.2.seconds);
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
  }

  void _handleStartPressed() => _bumbMinEnergy(0.3);

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverride = value;
      if (value == null) {
        _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
      } else {
        _minOrbEnergy = _getMinEnergyForDifficulty(value);
      }
    });
  }

  void _handleMouseMove(PointerHoverEvent e) {
    setState(() {
      _mousePose = e.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _AnimatedColors(
            // Edit from here...
            orbColor: _orbColor,
            emitColor: _emitColor,
            builder: (_, orbColor, emitColor) {
              return Stack(
                children: [
                  /// Bg-Base
                  Image.asset(AssetPaths.titleBgBase),

                  /// Bg-Receive
                  _LitImage(
                      color: orbColor,
                      imgSrc: AssetPaths.titleBgReceive,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalRecieveLightAmt),

                  Positioned.fill(
                      child: Stack(
                    children: [
                      OrbShaderWidget(
                        key: _orbKey,
                        config: OrbShaderConfig(
                          ambientLightColor: orbColor,
                          materialColor: orbColor,
                          lightColor: orbColor,
                        ),
                        mousePos: _mousePose,
                        minEnergy: _minOrbEnergy,
                        onUpdate: (energy) => setState(() {
                          _orbEnergy = energy;
                        }),
                      )
                    ],
                  )),

                  /// Mg-Base
                  _LitImage(
                      color: orbColor,
                      imgSrc: AssetPaths.titleMgBase,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalRecieveLightAmt),

                  /// Mg-Receive
                  _LitImage(
                      color: orbColor,
                      imgSrc: AssetPaths.titleMgReceive,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalRecieveLightAmt),

                  /// Mg-Emit
                  _LitImage(
                      color: emitColor,
                      imgSrc: AssetPaths.titleMgEmit,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalEmitLightAmt),

                  /// Fg-Rocks
                  Image.asset(AssetPaths.titleFgBase),

                  /// Fg-Receive
                  _LitImage(
                      color: orbColor,
                      imgSrc: AssetPaths.titleFgReceive,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalRecieveLightAmt),

                  /// Fg-Emit
                  _LitImage(
                      color: emitColor,
                      imgSrc: AssetPaths.titleFgEmit,
                      pulseEffect: _pulseEffect,
                      lightAmt: _finalEmitLightAmt),

                  Positioned.fill(
                    child: TitleScreenUi(
                      difficulty: _difficulty,
                      onDifficultyPressed: _handleDifficultyPressed,
                      onDifficultyFoucused: _handleDifficultyFocused,
                      onStartPressed: _handleStartPressed,
                    ),
                  )
                ],
              ).animate().fadeIn(duration: 1.seconds, delay: .3.seconds);
            }),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  const _LitImage(
      {required this.color,
      required this.imgSrc,
      required this.pulseEffect,
      required this.lightAmt});
  final Color color;
  final String imgSrc;
  final AnimationController pulseEffect;
  final double lightAmt;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return ListenableBuilder(
        listenable: pulseEffect,
        builder: (context, child) {
          return Image.asset(
            imgSrc,
            color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
            colorBlendMode: BlendMode.modulate,
          );
        });
  }
}

class _AnimatedColors extends StatelessWidget {
  const _AnimatedColors(
      {required this.emitColor, required this.orbColor, required this.builder});

  final Color emitColor;
  final Color orbColor;

  final Widget Function(BuildContext context, Color orbColor, Color emitColor)
      builder;

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;
    return TweenAnimationBuilder(
        tween: ColorTween(
          begin: emitColor,
          end: emitColor,
        ),
        duration: duration,
        builder: (_, emitColor, __) {
          return TweenAnimationBuilder(
              tween: ColorTween(
                begin: orbColor,
                end: orbColor,
              ),
              duration: duration,
              builder: (context, orbColor, __) {
                return builder(context, emitColor!, orbColor!);
              });
        });
  }
}
