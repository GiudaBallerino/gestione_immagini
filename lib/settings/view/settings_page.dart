import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestione_immagini/settings/settings.dart';
import 'package:gestione_immagini/settings/widgets/tag_list_section.dart';
import 'package:img_api/img_api.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:tags_repository/tags_repository.dart';

import '../widgets/img_list_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        tagsRepository: context.read<TagsRepository>(),
        imgsRepository: context.read<ImgsRepository>(),
      )
        ..add(const TagSubscriptionRequested())
        ..add(const ImgSubscriptionRequested()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == SettingsStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("l10n.todosOverviewErrorSnackbarText"),
                    ),
                  );
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTag != current.lastDeletedTag &&
                current.lastDeletedTag != null,
            listener: (context, state) {
              final deletedTag = state.lastDeletedTag!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content:
                        Text("il tag ${deletedTag.name} è stato eliminato"),
                    action: SnackBarAction(
                      label: "undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<SettingsBloc>()
                            .add(const TagUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedImg != current.lastDeletedImg &&
                current.lastDeletedImg != null,
            listener: (context, state) {
              final deletedImg = state.lastDeletedImg!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        "l'immagine ${deletedImg.path.split("\\").last} è stata eliminata"),
                    action: SnackBarAction(
                      label: "undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<SettingsBloc>()
                            .add(const ImgUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state.tags.isEmpty) {
              if (state.status == SettingsStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != SettingsStatus.success) {
                return const SizedBox();
              } else {
                ScrollController _tagScrollController=ScrollController();
                ScrollController _imgScrollController=ScrollController();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.5 - 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Lista dei tag:',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _tagScrollController,
                                child: TagListSection(
                                  tags: state.tags,
                                  onDeleted: (tag) {
                                    context.read<SettingsBloc>().add(
                                      TagDeleted(tag),
                                    );
                                  },
                                  onSubmit: (name) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(TagSubmitted(Tag(name: name)));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Lista delle immagini:',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _imgScrollController,
                                child: ImgListSection(
                                  imgs: state.imgs,
                                  onDeleted: (img) {
                                    context.read<SettingsBloc>().add(
                                      ImgDeleted(img),
                                    );
                                  },
                                  onSubmit: (path) {
                                    context.read<SettingsBloc>().add(ImgSubmitted(
                                        Img(path: path, selections: [])));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            ScrollController _tagScrollController=ScrollController();
            ScrollController _imgScrollController=ScrollController();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.5 - 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Lista dei tag:',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _tagScrollController,
                            child: TagListSection(
                              tags: state.tags,
                              onDeleted: (tag) {
                                context.read<SettingsBloc>().add(
                                      TagDeleted(tag),
                                    );
                              },
                              onSubmit: (name) {
                                context
                                    .read<SettingsBloc>()
                                    .add(TagSubmitted(Tag(name: name)));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Lista delle immagini:',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _imgScrollController,
                            child: ImgListSection(
                              imgs: state.imgs,
                              onDeleted: (img) {
                                context.read<SettingsBloc>().add(
                                      ImgDeleted(img),
                                    );
                              },
                              onSubmit: (path) {
                                context.read<SettingsBloc>().add(ImgSubmitted(
                                    Img(path: path, selections: [])));
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
