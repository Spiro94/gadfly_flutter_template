// coverage:ignore-file
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/bloc.dart';
import '../../router.dart';

class AppC_DeepLinksListener extends StatefulWidget {
  const AppC_DeepLinksListener({
    required this.appRouter,
    required this.child,
    required this.deepLinksStream,
    super.key,
  });

  final AppRouter appRouter;
  final Widget child;
  final Stream<Uri> deepLinksStream;

  @override
  State<AppC_DeepLinksListener> createState() => _AppC_DeepLinksListenerState();
}

class _AppC_DeepLinksListenerState extends State<AppC_DeepLinksListener> {
  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.deepLinksStream.listen((uri) async {
      final handledDeepLink = await handleDeepLink(
        uri: uri,
        path: uri.path,
        authBloc: context.read<AuthBloc>(),
      );

      if (handledDeepLink != null) {
        await widget.appRouter.pushNamed(
          handledDeepLink,
          includePrefixMatches: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
