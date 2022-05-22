import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:tags_repository/tags_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required TagsRepository tagsRepository,
    required ImgsRepository imgsRepository,
  })  : _tagsRepository = tagsRepository, _imgsRepository = imgsRepository,
        super(const SettingsState(),) {
    on<TagSubscriptionRequested>(_onTagSubscriptionRequested);
    on<ImgSubscriptionRequested>(_onImgSubscriptionRequested);
    on<TagDeleted>(_onTagDeleted);
    on<ImgDeleted>(_onImgDeleted);
    on<TagUndoDeletionRequested>(_onUndoTagDeletionRequested);
    on<ImgUndoDeletionRequested>(_onUndoImgDeletionRequested);
    on<TagSubmitted>(_onTagSubmitted);
    on<ImgSubmitted>(_onImgSubmitted);
    //on<EditTagNameChanged>(_onNameChanged);
  }

  final TagsRepository _tagsRepository;
  final ImgsRepository _imgsRepository;

  Future<void> _onTagSubscriptionRequested(
      TagSubscriptionRequested event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(status: () => SettingsStatus.loading));

    await emit.forEach<List<Tag>>(
      _tagsRepository.getTags(),
      onData: (tags) => state.copyWith(
        status: () => SettingsStatus.success,
        tags: () => tags,
      ),
      onError: (_, __) => state.copyWith(
        status: () => SettingsStatus.failure,
      ),
    );
  }

  Future<void> _onImgSubscriptionRequested(
      ImgSubscriptionRequested event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(status: () => SettingsStatus.loading));

    await emit.forEach<List<Img>>(
      _imgsRepository.getImgs(),
      onData: (imgs) => state.copyWith(
        status: () => SettingsStatus.success,
        imgs: () => imgs,
      ),
      onError: (_, __) => state.copyWith(
        status: () => SettingsStatus.failure,
      ),
    );
  }

  Future<void> _onTagDeleted(
      TagDeleted event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(lastDeletedTag: () => event.tag));
    await _tagsRepository.deleteTag(event.tag.id);
  }

  Future<void> _onImgDeleted(
      ImgDeleted event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(lastDeletedImg: () => event.img));
    await _imgsRepository.deleteImg(event.img.path);
  }

  Future<void> _onUndoTagDeletionRequested(
      TagUndoDeletionRequested event,
      Emitter<SettingsState> emit,
      ) async {
    assert(
    state.lastDeletedTag != null,
    'Last deleted tag can not be null.',
    );

    final tag = state.lastDeletedTag!;
    emit(state.copyWith(lastDeletedTag: () => null));
    await _tagsRepository.saveTag(tag);
  }

  Future<void> _onUndoImgDeletionRequested(
      ImgUndoDeletionRequested event,
      Emitter<SettingsState> emit,
      ) async {
    assert(
    state.lastDeletedImg != null,
    'Last deleted img can not be null.',
    );

    final img = state.lastDeletedImg!;
    emit(state.copyWith(lastDeletedImg: () => null));
    await _imgsRepository.saveImg(img);
  }


  Future<void> _onTagSubmitted(
      TagSubmitted event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(status: ()=> SettingsStatus.loading));

    try {
      await _tagsRepository.saveTag(event.tag);
      emit(state.copyWith(status: ()=> SettingsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ()=> SettingsStatus.failure));
    }
  }

  Future<void> _onImgSubmitted(
      ImgSubmitted event,
      Emitter<SettingsState> emit,
      ) async {
    emit(state.copyWith(status: ()=> SettingsStatus.loading));

    try {
      await _imgsRepository.saveImg(event.img);
      emit(state.copyWith(status: ()=> SettingsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ()=> SettingsStatus.failure));
    }
  }

// void _onNameChanged(
//     EditTagNameChanged event,
//     Emitter<EditTagState> emit,
//     ) {
//   emit(state.copyWith(name: event.name));
// }
//
}