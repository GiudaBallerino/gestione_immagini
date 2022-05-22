import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tags_repository/tags_repository.dart';

part 'edit_tag_event.dart';
part 'edit_tag_state.dart';

class EditTagBloc extends Bloc<EditTagEvent, EditTagState> {
  EditTagBloc({
    required TagsRepository tagsRepository,
  })  : _tagsRepository = tagsRepository,
        super(const EditTagState(),) {
    on<EditTagSubscriptionRequested>(_onSubscriptionRequested);
    on<EditTagDeleted>(_onTagDeleted);
    on<EditTagUndoDeletionRequested>(_onUndoDeletionRequested);
    //on<EditTagNameChanged>(_onNameChanged);
    on<EditTagSubmitted>(_onSubmitted);
  }

  final TagsRepository _tagsRepository;

  Future<void> _onSubscriptionRequested(
      EditTagSubscriptionRequested event,
      Emitter<EditTagState> emit,
      ) async {
    emit(state.copyWith(status: () => EditTagStatus.loading));

    await emit.forEach<List<Tag>>(
      _tagsRepository.getTags(),
      onData: (tags) => state.copyWith(
        status: () => EditTagStatus.success,
        tags: () => tags,
      ),
      onError: (_, __) => state.copyWith(
        status: () => EditTagStatus.failure,
      ),
    );
  }

  Future<void> _onTagDeleted(
      EditTagDeleted event,
      Emitter<EditTagState> emit,
      ) async {
    emit(state.copyWith(lastDeletedTag: () => event.tag));
    await _tagsRepository.deleteTag(event.tag.id);
  }

  Future<void> _onUndoDeletionRequested(
      EditTagUndoDeletionRequested event,
      Emitter<EditTagState> emit,
      ) async {
    assert(
    state.lastDeletedTag != null,
    'Last deleted tag can not be null.',
    );

    final tag = state.lastDeletedTag!;
    emit(state.copyWith(lastDeletedTag: () => null));
    await _tagsRepository.saveTag(tag);
  }


  // void _onNameChanged(
  //     EditTagNameChanged event,
  //     Emitter<EditTagState> emit,
  //     ) {
  //   emit(state.copyWith(name: event.name));
  // }
  //
  Future<void> _onSubmitted(
      EditTagSubmitted event,
      Emitter<EditTagState> emit,
      ) async {
    emit(state.copyWith(status: ()=> EditTagStatus.loading));

    try {
      await _tagsRepository.saveTag(event.tag);
      emit(state.copyWith(status: ()=> EditTagStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ()=> EditTagStatus.failure));
    }
  }
}