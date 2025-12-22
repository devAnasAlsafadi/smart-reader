import 'package:equatable/equatable.dart';
import '../../../../../core/enum/user_filter_type.dart';
import '../../../domain/entities/user_entity.dart';



class UserState extends Equatable{
  final bool isLoadingGet;
  final bool isLoadingAdd;
  final bool isLoadingDelete;
  final bool isLoadingSync;
  final List<UserEntity> allUsers;
  final List<UserEntity> filteredUsers;
  final String searchText;
  final UserFilterType filterType ;
  final bool showFilterChip;
  final String? getError;
  final String? addError;
  final String? deleteError;
  final String? syncError;

  final bool addSuccess;
  final bool deleteSuccess;

  const UserState({
    this.isLoadingGet = false,
    this.isLoadingAdd = false,
    this.isLoadingDelete = false,
    this.isLoadingSync = false,
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.searchText = "",
    this.filterType = UserFilterType.name,
    this.showFilterChip = false,
    this.getError,
    this.addError,
    this.deleteError,
    this.syncError,
    this.addSuccess = false,
    this.deleteSuccess = false,
  });

  UserState copyWith({
    bool? isLoadingGet,
    bool? isLoadingAdd,
    bool? isLoadingDelete,
    bool? isLoadingSync,
    List<UserEntity>? allUsers,
    List<UserEntity>? filteredUsers,
    String? searchText,
    UserFilterType? filterType,
    bool? showFilterChip,
    String? getError,
    String? addError,
    String? deleteError,
    String? syncError,
    bool? addSuccess,
    bool? deleteSuccess,
  }) {
    return UserState(

      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingAdd: isLoadingAdd ?? this.isLoadingAdd,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete,
      isLoadingSync: isLoadingSync ?? this.isLoadingSync,
      showFilterChip: showFilterChip ?? this.showFilterChip,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchText: searchText ?? this.searchText,
      filterType: filterType ?? this.filterType,
      getError: getError,
      addError: addError,
      deleteError: deleteError,
      syncError: syncError,
      addSuccess: addSuccess ?? false,
      deleteSuccess: deleteSuccess ?? false,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
  [
    isLoadingGet,
    isLoadingAdd,
    isLoadingDelete,
    isLoadingSync,
    allUsers,
    filteredUsers,
    searchText,
    filterType,
    getError,
    addError,
    deleteError,
    syncError,
    showFilterChip,
    addSuccess,
    deleteSuccess,
  ];
}
