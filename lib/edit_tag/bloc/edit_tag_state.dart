part of 'edit_tag_bloc.dart';

enum EditTagStatus { initial, loading, success, failure }

// extension EditTagStatusX on EditTagStatus {
//   bool get isLoadingOrSuccess => [
//     EditTagStatus.loading,
//     EditTagStatus.success,
//   ].contains(this);
// }

class EditTagState extends Equatable {
  const EditTagState({
    this.status = EditTagStatus.initial,
    this.tags=const [],
    this.lastDeletedTag,
  });

  final EditTagStatus status;
  final List<Tag> tags;
  final Tag? lastDeletedTag;

  EditTagState copyWith({
    EditTagStatus Function()? status,
    List<Tag> Function()? tags,
    Tag? Function()? lastDeletedTag,
  }) {
    return EditTagState(
      status: status != null ? status() : this.status,
      tags: tags != null ? tags() : this.tags,
      lastDeletedTag:
      lastDeletedTag != null ? lastDeletedTag() : this.lastDeletedTag,
    );
  }

  @override
  List<Object?> get props => [status, tags, lastDeletedTag];
}