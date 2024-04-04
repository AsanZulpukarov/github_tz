import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_app/feature/domain/entities/user_list_entity.dart';
import 'package:github_app/feature/presentation/bloc/user_list_bloc/user_list_bloc.dart';
import 'package:github_app/feature/presentation/bloc/user_list_bloc/user_list_event.dart';
import 'package:github_app/feature/presentation/bloc/user_list_bloc/user_list_state.dart';
import 'package:github_app/feature/presentation/screens/user_detail_screen.dart';
import 'package:github_app/feature/presentation/widget/pagination_continer_widget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/platform/network_info.dart';
import '../../data/datasources/feature_remote_data_source_impl.dart';
import '../../data/repositories/feature_repository_impl.dart';
import '../../domain/usecases/get_users.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UserListBloc(
            getUsers: GetUsers(FeatureRepositoryImpl(
          remoteDataSource: FeatureRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
        )))
          ..add(LoadUsersEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Список пользователей"),
          centerTitle: true,
        ),
        body: const UserListWidget(),
      ),
    );
  }
}

class UserListWidget extends StatelessWidget {
  const UserListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userListBloc = BlocProvider.of<UserListBloc>(context);
    return RefreshIndicator(
      onRefresh: () async {
        userListBloc.add(LoadUsersEvent());
      },
      child: SingleChildScrollView(
        child:
            BlocBuilder<UserListBloc, UserListState>(builder: (context, state) {
          List<UserListEntity> listUser = [];
          if (state is UserListLoading) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is UserListLoaded) {
            listUser = state.users;
          } else if (state is UserListError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(state.message),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    userListBloc.add(LoadUsersEvent());
                  },
                  child: Text("Обновить"),
                ),
              ],
            );
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PaginationContainerWidget(
                    onTap: () {
                      userListBloc.page--;
                      userListBloc.add(LoadUsersEvent());
                    },
                    isEnable: userListBloc.page > 1 ? true : false,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: userListBloc.page > 1
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                  PaginationContainerWidget(
                      child: Text(
                    userListBloc.page.toString(),
                    style: const TextStyle(fontSize: 20),
                  )),
                  PaginationContainerWidget(
                    onTap: () {
                      userListBloc.page++;
                      userListBloc.add(LoadUsersEvent());
                    },
                    isEnable: userListBloc.page < 10 ? true : false,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: userListBloc.page < 10
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(
                            login: listUser.elementAt(index).login ?? "",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    listUser.elementAt(index).avatarUrl ?? "")),
                          ),
                        ),
                        title: Text(listUser.elementAt(index).login ?? "login"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: listUser.length,
              ),
            ],
          );
        }),
      ),
    );
  }
}
