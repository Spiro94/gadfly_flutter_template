import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/event.dart';
import '../../../../../effects/now/effect.dart';
import '../../../../../effects/now/provider.dart';
import '../../../../../i18n/translations.g.dart';

class HomeC_SignedInAtText extends StatefulWidget {
  const HomeC_SignedInAtText({super.key});

  @override
  State<HomeC_SignedInAtText> createState() => _HomeC_SignedInAtTextState();
}

class _HomeC_SignedInAtTextState extends State<HomeC_SignedInAtText> {
  late NowEffect nowEffect;
  final _dateFormatter = DateFormat.yMd();

  @override
  void initState() {
    nowEffect = context.read<NowEffectProvider>().getEffect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = nowEffect.now();
    return Text(
      context.t.home.signedInAt(now: _dateFormatter.format(now)),
      style: context.theme.typographies.headlineMedium,
    );
  }
}
