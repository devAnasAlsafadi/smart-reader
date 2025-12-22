import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enum/user_filter_type.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/add_user_usercase.dart';
import '../../../domain/usecases/sync_offline_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../../domain/usecases/get_users_usecase.dart';
import '../../../domain/usecases/delete_user_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  final AddUserUseCase addUser;
  final GetUsersUseCase getUsers;
  final DeleteUserUseCase deleteUser;
  final SyncOfflineUsersUseCase syncUsers;

  UserBloc({
    required this.addUser,
    required this.getUsers,
    required this.deleteUser,
    required this.syncUsers,
  }): super( UserState()) {


    // 🔵 Add User ---------------------------------------------------------
    on<AddUserEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAdd: true));
      try {
        await addUser(event.userEntity);
        emit(state.copyWith(isLoadingAdd: false,addSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoadingAdd: false,addError: e.toString()));
      }
    });



    // 🔵 Load Users -------------------------------------------------------
    on<LoadUsersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingGet: true));
      try {
        final all = await getUsers(event.userId);
        final filtered = applyFilter(all, state.searchText, state.filterType);
        emit(state.copyWith(isLoadingGet: false,allUsers: all,filteredUsers: filtered));
      } catch (e) {
        emit(state.copyWith(
          isLoadingGet: false,
          getError: e.toString(),
        ));
      }
    });


    // 🔵 Delete User ------------------------------------------------------
    on<DeleteUserEvent>((event, emit) async {
      emit(state.copyWith(isLoadingDelete: true));

      try {
        await deleteUser(event.userId);
        emit(state.copyWith(isLoadingDelete: false,deleteSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoadingDelete: false,deleteError: e.toString()));

      }
    });


    // 🔵 Change Filter --------------------------------------------------------
    on<ChangeFilterEvent>((event, emit) {
      final filtered = applyFilter(state.allUsers, state.searchText, event.type);
      final isNone = event.type == UserFilterType.none;
      emit(state.copyWith(
        filterType: event.type,
        filteredUsers: filtered,
        showFilterChip: !isNone,
      ));
    },);


    on<ResetFilterEvent>((event, emit) {
      emit(state.copyWith(
        filterType: UserFilterType.name,
        showFilterChip: false,
        searchText: "",
        filteredUsers: state.allUsers,
      ));
    });


    // 🔵 Search ---------------------------------------------------------------
    on<SearchUserEvent>((event, emit) {
      final filtered = applyFilter(
        state.allUsers,
        event.text,
        state.filterType,
      );
      emit(state.copyWith(searchText: event.text,filteredUsers: filtered));
    },);



    // 🔵 Sync Offline ---------------------------------------------------------
    on<SyncOfflineUsersEvent>((event, emit) async {
      await syncUsers(event.userId);
    });
  }


  // 🔍 Filtering Logic --------------------------------------------------------
  List<UserEntity> applyFilter(
      List<UserEntity> Users,
      String search,
      UserFilterType filter,
      ) {
    if (search.isEmpty) return Users;

    final query = search.toLowerCase();

    return Users.where((c) {
      if (filter == UserFilterType.name) {
        return c.name.toLowerCase().contains(query);
      } else if(filter == UserFilterType.street) {
        return c.street.toLowerCase().contains(query);
      }
      return false;
    }).toList();
  }
}





