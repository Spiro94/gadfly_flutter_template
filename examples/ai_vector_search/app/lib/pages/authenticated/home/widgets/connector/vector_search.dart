import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../blocs/search/bloc.dart';
import '../../../../../blocs/search/event.dart';
import '../../../../../blocs/search/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class HomeC_VectorSearch extends StatefulWidget {
  const HomeC_VectorSearch({super.key});

  @override
  State<HomeC_VectorSearch> createState() => _HomeC_VectorSearchState();
}

class _HomeC_VectorSearchState extends State<HomeC_VectorSearch> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    searchBloc.add(
      SearchEvent_VectorSearch(
        query: controller.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.watch<SearchBloc>();
    final markdownResponse = searchBloc.state.markdownResponse;

    final hasMarkdownResponse =
        markdownResponse != null && markdownResponse.isNotEmpty;

    return hasMarkdownResponse
        ? Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Markdown(
              data: markdownResponse,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                onFieldSubmitted: (_) => _submit(context),
              ),
              SizedBox(
                height: context.spacings.medium,
              ),
              SharedD_Button(
                buttonType: SharedD_Button_Type.outlined,
                status: searchBloc.state.status == SearchStatus.loading
                    ? SharedD_Button_Status.loading
                    : controller.text.isEmpty
                        ? SharedD_Button_Status.disabled
                        : SharedD_Button_Status.enabled,
                label: context.t.home.queryDenoDocumentation,
                onPressed: () => _submit(context),
              ),
            ],
          );
  }
}
