import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _GadflyLinter();

class _GadflyLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        GadflyDontUseBlocInDumbWidget(),
        GadflyConnectorWidgetsShouldntUseDumbSuffix(),
        GadflyDumbWidgetsShouldntUseConnectorSuffix(),
        GadflyDontUseBlocBuilder(),
      ];
}

class GadflyDontUseBlocInDumbWidget extends DartLintRule {
  GadflyDontUseBlocInDumbWidget() : super(code: _code);

  static const _code = LintCode(
    name: 'dont_use_bloc_in_dumb_widget',
    problemMessage: 'Dumb widgets should not depend on Bloc',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addImportDirective((node) {
      if (resolver.path.contains('dumb') &&
          (node.uri.stringValue?.contains('bloc') ?? false)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}

class GadflyConnectorWidgetsShouldntUseDumbSuffix extends DartLintRule {
  GadflyConnectorWidgetsShouldntUseDumbSuffix() : super(code: _code);

  static const _code = LintCode(
    name: 'connector_widgets_shouldnt_use_dumb_suffix',
    problemMessage:
        'This widget is in a connector directory, but is using a dumb widget annotation.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (resolver.path.contains('connector') &&
          (node.declaredElement?.name.contains(r'D_') ?? false)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}

class GadflyDumbWidgetsShouldntUseConnectorSuffix extends DartLintRule {
  GadflyDumbWidgetsShouldntUseConnectorSuffix() : super(code: _code);

  static const _code = LintCode(
    name: 'dumb_widgets_shouldnt_use_connector_suffix',
    problemMessage:
        'This widget is in a dumb directory, but is using a connector widget annotation.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      if (resolver.path.contains('dumb') &&
          (node.declaredElement?.name.contains(r'C_') ?? false)) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}

class GadflyDontUseBlocBuilder extends DartLintRule {
  GadflyDontUseBlocBuilder() : super(code: _code);

  static const _code = LintCode(
    name: 'dont_use_bloc_builder',
    problemMessage:
        '''Don't use BlocBuilder. Use context.watch or context.select instead.''',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addIdentifier((node) {
      if (node.name.contains('BlocBuilder')) {
        reporter.reportErrorForNode(code, node);
      }
    });
  }
}
