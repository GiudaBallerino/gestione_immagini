import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestione_immagini/gallery/gallery.dart';
import 'package:gestione_immagini/gallery/widgets/rect_painter.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:selection_api/selection_api.dart';
import 'package:tags_repository/tags_repository.dart';

import '../widgets/selection_painter.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryBloc(
        imgsRepository: context.read<ImgsRepository>(),
        tagsRepository: context.read<TagsRepository>(),
      )
        ..add(
          const GalleryImgsSubscriptionRequested(),
        )
        ..add(
          const GalleryTagsSubscriptionRequested(),
        ),
      child: GalleryView(),
    );
  }
}

class GalleryView extends StatelessWidget {
  GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              state.selecting ? FloatingActionButtonLocation.endFloat : null,
          floatingActionButton: state.selecting
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: FloatingActionButton(
                        child: Icon(Icons.clear),
                        onPressed: () {
                          context.read<GalleryBloc>().add(
                                GalleryImgSelectionEnd(),
                              );
                        },
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.done),
                      onPressed: () {
                        context.read<GalleryBloc>().add(
                              GallerySelectionSubmitted(
                                state.images[state.actualIndex].path,
                                Selection(
                                  tag: state.tags.first,
                                  points: state.points,
                                ),
                              ),
                            );
                        context.read<GalleryBloc>().add(
                              GalleryImgSelectionEnd(),
                            );
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return SimpleDialog(
                        //         title: Text('Scegli il tag'),
                        //         children: <Widget>[
                        //           for (final tag in state.tags)
                        //             SimpleDialogOption(
                        //               onPressed: () {
                        //                 context.read<GalleryBloc>().add(
                        //                       GallerySelectionSubmitted(
                        //                         state.images[state.actualIndex]
                        //                             .path,
                        //                         Selection(
                        //                           tag: tag,
                        //                           right: state.actualSelection!.right,
                        //                           left:  state.actualSelection!.left,
                        //                           bottom:  state.actualSelection!.bottom,
                        //                           top:  state.actualSelection!.top,
                        //                         ),
                        //                       ),
                        //                     );
                        //               },
                        //               child: Text(tag.name),
                        //             ),
                        //         ],
                        //       );
                        //     });
                      },
                    )
                  ],
                )
              : null,
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
                final pageController = PageController();
                final _animationDuration = Duration(milliseconds: 500);
                final _curve = Curves.easeIn;

                return Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (pointerSignal.scrollDelta.dy > 0) {
                        context.read<GalleryBloc>().add(
                              GalleryImgSelectionEnd(),
                            );
                        context.read<GalleryBloc>().add(
                              GalleryUpdateActualIndex(
                                  pageController.page!.toInt()),
                            );
                        pageController.nextPage(
                            curve: _curve, duration: _animationDuration);
                      } else {
                        context.read<GalleryBloc>().add(
                              GalleryImgSelectionEnd(),
                            );
                        context.read<GalleryBloc>().add(
                              GalleryUpdateActualIndex(
                                  pageController.page!.toInt()),
                            );
                        pageController.page;
                        pageController.previousPage(
                            duration: _animationDuration, curve: _curve);
                      }
                    }
                  },
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount: state.images.length,
                    scrollDirection: Axis.vertical,
                    pageSnapping: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: !state.selecting
                            ? () {
                                context.read<GalleryBloc>().add(
                                      GalleryImgSelectionStart(),
                                    );
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                File(
                                  state.images[index].path,
                                ),
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          child: Stack(
                            children: [
                              for (final selection
                                  in state.images[index].selections)
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: SizedBox(
                                    width: size.width,
                                    height: size.height,
                                    child: CustomPaint(
                                      painter: RectPainter(
                                        points: selection.points,
                                        clear: false,
                                      ),
                                    ),
                                  ),
                                ),
                              if (state.selecting) ...[
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: GestureDetector(
                                    onPanStart: (DragStartDetails details) {
                                      // get distance from points to check if is in circle
                                      int indexMatch = -1;
                                      for (int i = 0;
                                          i < state.points.length;
                                          i++) {
                                        double distance = sqrt(pow(
                                                details.localPosition.dx -
                                                    state.points[i].dx,
                                                2) +
                                            pow(
                                                details.localPosition.dy -
                                                    state.points[i].dy,
                                                2));
                                        if (distance <= 30) {
                                          indexMatch = i;
                                          break;
                                        }
                                      }
                                      if (indexMatch != -1) {
                                        context.read<GalleryBloc>().add(
                                              GalleryUpdateCurrentlyDraggedIndex(
                                                  indexMatch),
                                            );
                                      }
                                    },
                                    onPanUpdate: (DragUpdateDetails details) {
                                      if (state.currentlyDraggedIndex != -1) {
                                        context.read<GalleryBloc>().add(
                                              GalleryUpdatePoints(
                                                  List.from(state.points)),
                                            );

                                        context.read<GalleryBloc>().add(
                                              GalleryUpdatePoint(
                                                  state.points,
                                                  state.currentlyDraggedIndex,
                                                  details.localPosition),
                                            );
                                      }
                                    },
                                    onPanEnd: (_) {
                                      context.read<GalleryBloc>().add(
                                            GalleryUpdateCurrentlyDraggedIndex(
                                                -1),
                                          );
                                    },
                                    child: SizedBox(
                                      width: size.width,
                                      height: size.height,
                                      child: CustomPaint(
                                        painter: SelectionPainter(
                                          points: state.points,
                                          clear: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
