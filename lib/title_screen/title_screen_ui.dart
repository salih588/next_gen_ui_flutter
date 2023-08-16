import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';
import 'package:gap/gap.dart';

import '../assets.dart';
import '../common/ui_scaler.dart';
import '../styles.dart';

class TitleScreenUi extends StatelessWidget {
  const TitleScreenUi({
    super.key,
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFoucused,
  });

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFoucused;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      child: Stack(
        children: [
          ///Title Text
          const TopLeft(
            child: UiScaler(alignment: Alignment.topLeft, child: _TitleText()),
          ),
          BottomLeft(
            child: UiScaler(
              alignment: Alignment.bottomLeft,
              child: _DifficultiBtns(
                  difficulty: difficulty,
                  onDifficultyPressed: onDifficultyPressed,
                  onDifficultyFocused: onDifficultyFoucused),
            ),
          ),
          BottomRight(
            child: UiScaler(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    right: 40,
                  ),
                  child: _StartBtn(onpressed: () {}),
                )),
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(-(TextStyles.h1.letterSpacing! * .5), 0),
              child: Text(
                'OUTPOST',
                style: TextStyles.h1,
              ),
            ),
            Image.asset(
              AssetPaths.titleSelectedLeft,
              height: 65,
            ),
            Text(
              '57',
              style: TextStyles.h2,
            ),
            Image.asset(
              AssetPaths.titleSelectedRight,
              height: 65,
            ),
          ],
        ).animate().fadeIn(delay: .8.seconds, duration: .7.seconds),
        Text(
          'INTO THE UNKNOWN',
          style: TextStyles.h3,
        ).animate().fadeIn(
              delay: 1.seconds,
              duration: .7.seconds,
            )
      ],
    );
  }
}

class _DifficultiBtns extends StatelessWidget {
  const _DifficultiBtns({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
  });

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultiBtn(
          label: 'Casual',
          selected: difficulty == 0,
          onHover: (over) => onDifficultyFocused(over ? 0 : null),
          onPressed: () => onDifficultyPressed(0),
        )
            .animate()
            .fadeIn(
              delay: 1.3.seconds,
              duration: .35.seconds,
            )
            .slide(begin: const Offset(0, .2)),
        _DifficultiBtn(
          label: 'Normal',
          selected: difficulty == 1,
          onHover: (over) => onDifficultyFocused(over ? 1 : null),
          onPressed: () => onDifficultyPressed(1),
        )
            .animate()
            .fadeIn(
              delay: 1.5.seconds,
              duration: .35.seconds,
            )
            .slide(begin: const Offset(0, .2)),
        _DifficultiBtn(
          label: 'Hardcore',
          selected: difficulty == 2,
          onHover: (over) => onDifficultyFocused(over ? 2 : null),
          onPressed: () => onDifficultyPressed(2),
        )
            .animate()
            .fadeIn(
              delay: 1.7.seconds,
              duration: .35.seconds,
            )
            .slide(begin: const Offset(0, .2)),
      ],
    );
  }
}

class _DifficultiBtn extends StatelessWidget {
  const _DifficultiBtn({
    super.key,
    required this.label,
    required this.selected,
    required this.onHover,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final void Function(bool hasFocus) onHover;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        onPressed: onPressed,
        onHoverChanged: (_, state) => onHover.call(state.isHovered),
        builder: (_, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 250,
              height: 60,
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: (!selected && (state.isHovered || state.isFocused))
                        ? 1
                        : 0,
                    duration: .3.seconds,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF00D1FF).withOpacity(.1),
                          border: Border.all(color: Colors.white, width: 5)),
                    ),
                  ),
                  if (state.isHovered || state.isFocused) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D1FF).withOpacity(.1),
                      ),
                    ),
                  ],
                  if (selected) ...[
                    CenterLeft(
                      child: Image.asset(AssetPaths.titleSelectedLeft),
                    ),
                    CenterRight(
                      child: Image.asset(AssetPaths.titleSelectedRight),
                    ),
                  ],
                  Center(
                    child: Text(label.toUpperCase(), style: TextStyles.btn),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class _StartBtn extends StatefulWidget {
  const _StartBtn({required this.onpressed});
  final VoidCallback onpressed;

  @override
  State<_StartBtn> createState() => __StartBtnState();
}

class __StartBtnState extends State<_StartBtn> {
  AnimationController? _btnAnim;
  bool _wasHovered = false;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
        cursor: SystemMouseCursors.click,
        onPressed: () => widget.onpressed,
        builder: (_, state) {
          if ((state.isHovered || state.isFocused) &&
              !_wasHovered &&
              _btnAnim?.status != AnimationStatus.forward) {
            _btnAnim?.forward(from: 0);
          }
          _wasHovered = (state.isHovered || state.isFocused);
          return SizedBox(
            width: 520,
            height: 100,
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset(AssetPaths.titleStartBtn)),
                if (state.isHovered || state.isFocused) ...[
                  Positioned.fill(
                      child: Image.asset(AssetPaths.titleStartBtnHover)),
                ],
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'START MISSION',
                        style: TextStyles.btn
                            .copyWith(fontSize: 24, letterSpacing: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate(autoPlay: false, onInit: (c) => _btnAnim = c).shimmer(
                  duration: .7.seconds,
                  color: Colors.black,
                ),
          )
              .animate()
              .fadeIn(delay: 2.3.seconds)
              .slide(begin: const Offset(0, .2));
        });
  }
}
