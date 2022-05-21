part of 'edit_tag_bloc.dart';

abstract class EditTagEvent extends Equatable {
  const EditTagEvent();

  @override
  List<Object> get props => [];
}

class EditTagSubscriptionRequested extends EditTagEvent {
  const EditTagSubscriptionRequested();
}

class EditTagDeleted extends EditTagEvent {
  const EditTagDeleted(this.tag);

  final Tag tag;

  @override
  List<Object> get props => [tag];
}

class EditTagUndoDeletionRequested extends EditTagEvent {
  const EditTagUndoDeletionRequested();
}

class EditTagNameChanged extends EditTagEvent {
  const EditTagNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditTagSubmitted extends EditTagEvent {
  const EditTagSubmitted();
}