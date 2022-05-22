import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestione_immagini/edit_tag/edit_tag.dart';
import 'package:gestione_immagini/edit_tag/widgets/tag_list_section.dart';
import 'package:tags_repository/tags_repository.dart';

class EditTagPage extends StatelessWidget {
  const EditTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTagBloc(
        tagsRepository: context.read<TagsRepository>(),
      )..add(const EditTagSubscriptionRequested()),
      child: const EditTagView(),
    );
  }
}

class EditTagView extends StatelessWidget {
  const EditTagView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<EditTagBloc, EditTagState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == EditTagStatus.failure) {
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
          BlocListener<EditTagBloc, EditTagState>(
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
                    content: Text(
                        "il tag ${deletedTag.name} è stato eliminato"),
                    action: SnackBarAction(
                      label: "undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<EditTagBloc>()
                            .add(const EditTagUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<EditTagBloc, EditTagState>(
          builder: (context, state) {
            if (state.tags.isEmpty) {
              if (state.status == EditTagStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != EditTagStatus.success) {
                return const SizedBox();
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TagListSection(
                    tags: state.tags,
                    onDeleted: (tag) {
                      context.read<EditTagBloc>().add(
                        EditTagDeleted(tag),
                      );
                    },
                    onSubmit: (name){
                      context.read<EditTagBloc>().add(
                          EditTagSubmitted(Tag(name: name))
                      );
                    },
                  ),
                );
              }
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TagListSection(
                tags: state.tags,
                onDeleted: (tag) {
                  context.read<EditTagBloc>().add(
                        EditTagDeleted(tag),
                      );
                },
                onSubmit: (name){
                  context.read<EditTagBloc>().add(
                      EditTagSubmitted(Tag(name: name))
                  );
                },
              ),
            );
            // return CupertinoScrollbar(
            //   child: ListView(
            //     children: [
            //       for (final tag in state.tags)
            //         InputChip(
            //           label: Text(tag.name),
            //           onDeleted: (){},
            //         ),
            //     ],
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
