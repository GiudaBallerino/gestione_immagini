import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestione_immagini/gallery/gallery.dart';
import 'package:imgs_repository/imgs_repository.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryBloc(
        imgsRepository: context.read<ImgsRepository>(),
      )..add(const GallerySubscriptionRequested()),
      child: const GalleryView(),
    );
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("l10n.todosOverviewAppBarTitle"),
        actions: const [
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GalleryBloc, GalleryState>(
            listenWhen: (previous, current) =>
            previous.status != current.status,
            listener: (context, state) {
              if (state.status == GalleryStatus.failure) {
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
          BlocListener<GalleryBloc, GalleryState>(
            listenWhen: (previous, current) =>
            previous.lastDeletedImg != current.lastDeletedImg &&
                current.lastDeletedImg != null,
            listener: (context, state) {
              final deletedImg= state.lastDeletedImg!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        "l10n.todosOverviewTodoDeletedSnackbarText(deletedTodo.title,),"
                    ),
                    action: SnackBarAction(
                      label: "l10n.todosOverviewUndoDeletionButtonText",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<GalleryBloc>()
                            .add(const GalleryUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            if (state.images.isEmpty) {
              if (state.status == GalleryStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != GalleryStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    "l10n.todosOverviewEmptyText",
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }
            return CupertinoScrollbar(
              child: ListView(
                children: [

                  for(int i=0;i<10;i++)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.red,
                    ),
                  //for (final img in state.filteredImgs)
                  // TodoListTile(
                  //   todo: todo,
                  //   onToggleCompleted: (isCompleted) {
                  //     context.read<TodosOverviewBloc>().add(
                  //       TodosOverviewTodoCompletionToggled(
                  //         todo: todo,
                  //         isCompleted: isCompleted,
                  //       ),
                  //     );
                  //   },
                  //   onDismissed: (_) {
                  //     context
                  //         .read<TodosOverviewBloc>()
                  //         .add(TodosOverviewTodoDeleted(todo));
                  //   },
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //       EditTodoPage.route(initialTodo: todo),
                  //     );
                  //   },
                  // ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}