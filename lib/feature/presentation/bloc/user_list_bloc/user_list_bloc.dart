import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/core/error/failure.dart';
import 'package:github_app/feature/domain/usecases/get_users.dart';
import 'package:github_app/feature/presentation/bloc/user_list_bloc/user_list_event.dart';
import 'package:github_app/feature/presentation/bloc/user_list_bloc/user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsers getUsers;

  int page = 1;
  final int _totalUser = 10;
  UserListBloc({required this.getUsers}) : super(UserListLoading()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(UserListLoading());
      final failureOrUsers = await getUsers.getUsers(page, _totalUser);

      emit(failureOrUsers.fold(
          (failure) => UserListError(message: _mapFailureToMessage(failure)),
          (users) => UserListLoaded(users: users)));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Ошибка сервера";
      case InternetFailure:
        return "Интернет не работает";
      default:
        return 'Неизвестная ошибка';
    }
  }
}
