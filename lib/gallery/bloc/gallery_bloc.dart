import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:gestione_immagini/gallery/gallery.dart';
import 'package:selection_api/selection_api.dart';
import 'package:tags_repository/tags_repository.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc({
    required ImgsRepository imgsRepository,
    required TagsRepository tagsRepository,
  })  : _imgsRepository = imgsRepository,
        _tagsRepository = tagsRepository,
        super(const GalleryState()) {
    on<GalleryImgsSubscriptionRequested>(_onImgsSubscriptionRequested);
    on<GalleryTagsSubscriptionRequested>(_onTagsSubscriptionRequested);
    on<GalleryImgDeleted>(_onImgDeleted);
    on<GalleryUndoDeletionRequested>(_onUndoDeletionRequested);
    on<GalleryUpdateActualIndex>(_onUpdateActualIndex);
    on<GalleryUpdateCurrentlyDraggedIndex>(_onUpdateCurrentlyDraggedIndex);
    on<GalleryUpdatePoints>(_onUpdatePoints);
    on<GalleryUpdatePoint>(_onUpdatePoint);
    on<GalleryImgSelectionStart>(_onSelectionStart);
    on<GalleryImgSelectionEnd>(_onSelectionEnd);
    on<GallerySelectionSubmitted>(_onSelectionSubmitted);
  }

  final ImgsRepository _imgsRepository;
  final TagsRepository _tagsRepository;

  Future<void> _onImgsSubscriptionRequested(
    GalleryImgsSubscriptionRequested event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: () => GalleryStatus.loading));

    await emit.forEach<List<Img>>(
      _imgsRepository.getImgs(),
      onData: (imgs) => state.copyWith(
        status: () => GalleryStatus.success,
        images: () => imgs,
      ),
      onError: (_, __) => state.copyWith(
        status: () => GalleryStatus.failure,
      ),
    );
  }

  Future<void> _onTagsSubscriptionRequested(
      GalleryTagsSubscriptionRequested event,
      Emitter<GalleryState> emit,
      ) async {
    emit(state.copyWith(status: () => GalleryStatus.loading));

    await emit.forEach<List<Tag>>(
      _tagsRepository.getTags(),
      onData: (tags) => state.copyWith(
        status: () => GalleryStatus.success,
        tags: () => tags,
      ),
      onError: (_, __) => state.copyWith(
        status: () => GalleryStatus.failure,
      ),
    );
  }

  Future<void> _onImgDeleted(
    GalleryImgDeleted event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(lastDeletedImg: () => event.img));
    await _imgsRepository.deleteImg(event.img.path);
  }

  Future<void> _onUndoDeletionRequested(
    GalleryUndoDeletionRequested event,
    Emitter<GalleryState> emit,
  ) async {
    assert(
      state.lastDeletedImg != null,
      'Last deleted img can not be null.',
    );

    final img = state.lastDeletedImg!;
    emit(state.copyWith(lastDeletedImg: () => null));
    await _imgsRepository.saveImg(img);
  }


  void _onUpdateActualIndex(
    GalleryUpdateActualIndex event,
    Emitter<GalleryState> emit,
  ) {
    emit(state.copyWith(actualIndex: () => event.index));
  }

  void _onUpdateCurrentlyDraggedIndex(
      GalleryUpdateCurrentlyDraggedIndex event,
      Emitter<GalleryState> emit,
      ) {
    emit(state.copyWith(currentlyDraggedIndex: () => event.index));
  }

  void _onUpdatePoints(
      GalleryUpdatePoints event,
      Emitter<GalleryState> emit,
      ) {
    emit(state.copyWith(points: () => event.points));
  }

  void _onUpdatePoint(
      GalleryUpdatePoint event,
      Emitter<GalleryState> emit,
      ) {
    List<Offset> tmp= List.from(event.points);
    tmp[event.index]=event.point;
    emit(state.copyWith(points: () => tmp));
  }

  void _onSelectionStart(
    GalleryImgSelectionStart event,
    Emitter<GalleryState> emit,
  ) {
    emit(state.copyWith(selecting: () => true));
  }

  void _onSelectionEnd(
    GalleryImgSelectionEnd event,
    Emitter<GalleryState> emit,
  ) {
    emit(state.copyWith(selecting: () => false));
  }

  Future<void> _onSelectionSubmitted(
    GallerySelectionSubmitted event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: () => GalleryStatus.loading));

    try {
      await _imgsRepository.saveSelection(event.path, event.selection);
      emit(state.copyWith(status: () => GalleryStatus.success));
    } catch (e) {
      emit(state.copyWith(status: () => GalleryStatus.failure));
    }
  }
}
