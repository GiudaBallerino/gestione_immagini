import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:gestione_immagini/gallery/gallery.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc({
    required ImgsRepository imgsRepository,
  })  : _imgsRepository = imgsRepository,
        super(const GalleryState()) {
    on<GallerySubscriptionRequested>(_onSubscriptionRequested);
    on<GalleryImgDeleted>(_onImgDeleted);
    on<GalleryUndoDeletionRequested>(_onUndoDeletionRequested);
    on<GalleryFilterChanged>(_onFilterChanged);
  }

  final ImgsRepository _imgsRepository;

  Future<void> _onSubscriptionRequested(
    GallerySubscriptionRequested event,
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

  void _onFilterChanged(
    GalleryFilterChanged event,
    Emitter<GalleryState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }
}
