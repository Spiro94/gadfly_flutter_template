import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../blocs/image_generation/bloc.dart';
import '../../../../../blocs/image_generation/event.dart';
import '../../../../../blocs/image_generation/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class HomeC_Avatar extends StatefulWidget {
  const HomeC_Avatar({super.key});

  @override
  State<HomeC_Avatar> createState() => _HomeC_AvatarState();
}

class _HomeC_AvatarState extends State<HomeC_Avatar> {
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

  @override
  Widget build(BuildContext context) {
    final imageGenerationBloc = context.watch<ImageGenerationBloc>();
    final avatarUrl = imageGenerationBloc.state.avatarUrl;

    return avatarUrl != null && avatarUrl.isNotEmpty
        ? SizedBox(
            height: 200,
            width: 200,
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
            ),
          )
        : Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text(context.t.home.describeYourAvatarInWords),
                ),
                controller: controller,
              ),
              SizedBox(
                height: context.spacings.medium,
              ),
              SharedD_Button(
                label: context.t.home.submit,
                status: controller.text.isEmpty
                    ? SharedD_Button_Status.disabled
                    : (imageGenerationBloc.state.status ==
                            ImageGenerationStatus.loading
                        ? SharedD_Button_Status.loading
                        : SharedD_Button_Status.enabled),
                onPressed: () {
                  imageGenerationBloc.add(
                    ImageGenerationEvent_CreateAvatarImage(
                      input: controller.text,
                    ),
                  );
                },
              ),
            ],
          );
  }
}
