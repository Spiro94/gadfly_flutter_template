import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../shared/mixins/logging.dart';
import '../blocs/auth/bloc.dart';
import '../blocs/auth/events.dart';

class Routes_DeepLinkHandler with SharedMixin_Logging {
  const Routes_DeepLinkHandler({
    required this.appNavigatorKey,
    required this.authBloc,
    required this.foruiThemeData,
  });

  final GlobalKey<NavigatorState> appNavigatorKey;
  final Auth_Bloc authBloc;
  final FThemeData foruiThemeData;

  Future<DeepLink> handleDeepLink({
    required PlatformDeepLink deepLink,
    required String? deepLinkFragmentOverride,
  }) async {
    final uri = deepLink.uri;
    log.info('incoming deep link uri: $uri');

    final fragment = _getFragmentFromUri(
      uri: uri,
      deepLinkFragmentOverride: deepLinkFragmentOverride,
    );
    log.fine('deep link fragment: $fragment');

    await _authenticateUserIfPossible(
      uri: uri,
      deepLinkFragmentOverride: deepLinkFragmentOverride,
    );

    switch (fragment) {
      case '/deep/reset-password/':
        return const DeepLink.path(
          '/home/reset-password/',
          includePrefixMatches: true,
        );
      case '/deep/verify-email/':
        return const DeepLink.path(
          '/home/',
          includePrefixMatches: true,
        );
      default:
        return deepLink;
    }
  }

  String _getFragmentFromUri({
    required Uri uri,
    required String? deepLinkFragmentOverride,
  }) {
    if (deepLinkFragmentOverride != null) {
      log.fine('deep link fragment override: $deepLinkFragmentOverride');
    }

    late final String fragmentRaw;
    if (deepLinkFragmentOverride != null &&
        deepLinkFragmentOverride.isNotEmpty) {
      fragmentRaw = deepLinkFragmentOverride;
    }

    if (kIsWeb) {
      if (uri.hasFragment) {
        fragmentRaw = uri.fragment;
      } else if (uri.path.startsWith('/')) {
        fragmentRaw = uri.path;
      } else {
        fragmentRaw = '/';
      }
    } else {
      fragmentRaw = deepLinkFragmentOverride ?? uri.fragment;
    }

    final fragment = _sanitizeFragment(fragmentRaw: fragmentRaw);
    return fragment;
  }

  Map<String, String> _getQueryParamsFromUri({
    required Uri uri,
    required String? deepLinkFragmentOverride,
  }) {
    final queryParams = <String, String>{};

    if (uri.hasQuery) {
      queryParams.addAll(uri.queryParameters);
    }

    final path = uri.path;
    if (uri.path.contains('=')) {
      final tempUri = Uri.tryParse('?$path');
      if (tempUri?.hasQuery ?? false) {
        queryParams.addAll(tempUri!.queryParameters);
      }
    }

    final fragment = _getFragmentFromUri(
      uri: uri,
      deepLinkFragmentOverride: deepLinkFragmentOverride,
    );
    if (fragment.contains('=')) {
      final tempUri = Uri.tryParse('?$fragment');
      if (tempUri?.hasQuery ?? false) {
        queryParams.addAll(tempUri!.queryParameters);
      }
    }

    if (fragment.contains('%23')) {
      final tempUri = Uri.tryParse('?${fragment.split('%23').last}');
      if (tempUri?.hasQuery ?? false) {
        queryParams.addAll(tempUri!.queryParameters);
      }
    }

    return queryParams;
  }

  String _sanitizeFragment({required String fragmentRaw}) {
    if (fragmentRaw.endsWith('/')) {
      return fragmentRaw;
    }

    return '$fragmentRaw/';
  }

  /// We may be receiving deep links from supabase auth that contain enough
  /// information to authenticate the user. In these situations, lets
  /// authenticate the user before handling the deep link.
  ///
  /// Behind the scenes, supabase client has its own listener for deep links and
  /// will authenticate as well. However, the timing of that doesn't always
  /// account for our use cases acress web and mobile, so we are handling it
  /// ourselves at the moment we actually need it to avoid a race condition.
  Future<void> _authenticateUserIfPossible({
    required Uri uri,
    required String? deepLinkFragmentOverride,
  }) async {
    final queryParams = _getQueryParamsFromUri(
      uri: uri,
      deepLinkFragmentOverride: deepLinkFragmentOverride,
    );
    final errorDescription = queryParams['error_description'];
    if (errorDescription != null && errorDescription.isNotEmpty) {
      _displayErrorMessageInSnackBar(errorMessage: errorDescription);
      return;
    }

    final code = queryParams['code'];
    final accessToken = queryParams['access_token'];
    final refreshToken = queryParams['refresh_token'];

    if (code != null || accessToken != null || refreshToken != null) {
      final errorMessageCompleter = Completer<String?>();

      authBloc.add(
        Auth_Event_GetAccessTokenFromUri(
          errorMessageCompleter: errorMessageCompleter,
          uri: uri,
          code: code,
          refreshToken: refreshToken,
        ),
      );

      final errorMessage = await errorMessageCompleter.future;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        _displayErrorMessageInSnackBar(errorMessage: errorMessage);
        return;
      }
    }
  }

  /// Display an error message in an snack bar.
  void _displayErrorMessageInSnackBar({required String errorMessage}) {
    log.warning(errorMessage);
    try {
      final scaffoldBackgroundColor =
          foruiThemeData.scaffoldStyle.backgroundColor;
      Future.delayed(const Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(appNavigatorKey.currentContext!).showSnackBar(
          SnackBar(
            backgroundColor: scaffoldBackgroundColor,
            content: FAlert(
              title: Text(errorMessage),
              style: FAlertStyle.destructive,
            ),
          ),
        );
      });
    } catch (e) {
      log.warning(e);
    }
  }
}
