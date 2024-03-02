import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/record_audio/bloc.dart';
import '../../blocs/recordings/bloc.dart';
import '../../effects/now/provider.dart';
import '../../effects/record_audio/effect.dart';
import '../../effects/record_audio/provider.dart';
import '../../effects/uuid/provider.dart';
import '../../repositories/audio/repository.dart';
import '../../repositories/auth/repository.dart';
import '../../shared/widgets/connector/auth_status_change_listener.dart';

@RoutePage(name: 'Authenticated_Routes')
class Authenticated_Router extends StatefulWidget {
  const Authenticated_Router({super.key});

  @override
  State<Authenticated_Router> createState() => _Authenticated_RouterState();
}

class _Authenticated_RouterState extends State<Authenticated_Router> {
  late final RecordAudioEffect recordAudioEffect;

  @override
  void initState() {
    super.initState();
    recordAudioEffect = context.read<RecordAudioEffectProvider>().getEffect();
  }

  @override
  void dispose() {
    recordAudioEffect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordingsBloc>(
          lazy: false,
          create: (context) => RecordingsBloc(
            uuidEffectProvider: context.read<UuidEffectProvider>(),
            audioRepository: context.read<AudioRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        BlocProvider<RecordAudioBloc>(
          create: (context) => RecordAudioBloc(
            audioRepository: context.read<AudioRepository>(),
            authRepository: context.read<AuthRepository>(),
            nowEffect: context.read<NowEffectProvider>().getEffect(),
          ),
        ),
      ],
      child: const SharedC_AuthStatusChangeListener(
        child: AutoRouter(),
      ),
    );
  }
}
