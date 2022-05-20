import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestione_immagini/app/app.dart';
import 'package:gestione_immagini/gallery/gallery.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:photo_view/photo_view.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
              final deletedImg = state.lastDeletedImg!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        "l10n.todosOverviewTodoDeletedSnackbarText(deletedTodo.title,),"),
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
            return PageView.builder(
              itemCount: state.filteredImgs.length,
              scrollDirection: Axis.vertical,
              pageSnapping: true,
              itemBuilder: (context, index) {
                final controller = CropController(
                  aspectRatio: 1,
                  defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
                );
                return Center(
                  child: CropImage(
                    controller: controller,
                    image: Image.file(
                      File(
                        state.filteredImgs.toList()[index].path,
                      ),
                      fit: BoxFit.contain,
                    ),
                    onCrop: (rect) => print(rect),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// return ListView.builder(
//   controller: ScrollController(),
//   physics: PageScrollPhysics(),
//   scrollDirection: Axis.vertical,
//   itemCount: state.filteredImgs.length,
//   itemBuilder: (context, index) {
//     return Container(
//       width: size.width,
//       height: size.height,
//       child: Image.file(
//         File(
//           state.filteredImgs.toList()[index].path,
//         ),
//         fit: BoxFit.contain,
//       ),
//     );
//   },
// );
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
