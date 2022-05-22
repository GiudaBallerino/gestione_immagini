part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class TagSubscriptionRequested extends SettingsEvent {
  const TagSubscriptionRequested();
}

class ImgSubscriptionRequested extends SettingsEvent {
  const ImgSubscriptionRequested();
}

class TagDeleted extends SettingsEvent {
  const TagDeleted(this.tag);

  final Tag tag;

  @override
  List<Object> get props => [tag];
}

class ImgDeleted extends SettingsEvent {
  const ImgDeleted(this.img);

  final Img img;

  @override
  List<Object> get props => [img];
}

class TagUndoDeletionRequested extends SettingsEvent {
  const TagUndoDeletionRequested();
}

class ImgUndoDeletionRequested extends SettingsEvent {
  const ImgUndoDeletionRequested();
}

class TagNameChanged extends SettingsEvent {
  const TagNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class TagSubmitted extends SettingsEvent {
  const TagSubmitted(this.tag);

  final Tag tag;

  @override
  List<Object> get props => [tag];
}

class ImgSubmitted extends SettingsEvent {
  const ImgSubmitted(this.img);

  final Img img;

  @override
  List<Object> get props => [img];
}