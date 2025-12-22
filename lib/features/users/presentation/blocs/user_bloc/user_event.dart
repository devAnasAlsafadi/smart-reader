
import 'package:equatable/equatable.dart';
import '../../../../../core/enum/user_filter_type.dart';
import '../../../domain/entities/user_entity.dart';


abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}


class AddUserEvent extends UserEvent{
  final UserEntity userEntity;
  const AddUserEvent(this.userEntity);
  @override
  List<Object?> get props => [userEntity];
}

class LoadUsersEvent extends UserEvent {
  final String userId;
  const LoadUsersEvent(this.userId);
  @override
  List<Object?> get props => [userId];

}

class ChangeFilterEvent extends UserEvent {
  final UserFilterType type;
  const ChangeFilterEvent(this.type);
  @override
  List<Object?> get props => [type];

}

class SearchUserEvent extends UserEvent {
  final String text;
  const SearchUserEvent(this.text);
  @override
  List<Object?> get props => [text];

}

class ResetFilterEvent extends UserEvent {}


class DeleteUserEvent extends UserEvent{
  final String userId;
  const DeleteUserEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class SyncOfflineUsersEvent extends UserEvent{
  final String userId;
  const SyncOfflineUsersEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

