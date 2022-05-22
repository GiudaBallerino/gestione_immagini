part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

extension SettingsStatusX on SettingsStatus {
  bool get isLoadingOrSuccess => [
    SettingsStatus.loading,
    SettingsStatus.success,
  ].contains(this);
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.tags=const [],
    this.imgs=const [],
    this.lastDeletedTag,
    this.lastDeletedImg,
  });

  final SettingsStatus status;
  final List<Tag> tags;
  final List<Img> imgs;
  final Tag? lastDeletedTag;
  final Img? lastDeletedImg;

  SettingsState copyWith({
    SettingsStatus Function()? status,
    List<Tag> Function()? tags,
    List<Img> Function()? imgs,
    Tag? Function()? lastDeletedTag,
    Img? Function()? lastDeletedImg,
  }) {
    return SettingsState(
      status: status != null ? status() : this.status,
      tags: tags != null ? tags() : this.tags,
      imgs: imgs != null ? imgs() : this.imgs,
      lastDeletedTag: lastDeletedTag != null ? lastDeletedTag() : this.lastDeletedTag,
      lastDeletedImg: lastDeletedImg != null ? lastDeletedImg() : this.lastDeletedImg,
    );
  }

  @override
  List<Object?> get props => [status, tags, imgs, lastDeletedTag, lastDeletedImg];
}