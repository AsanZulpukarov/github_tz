import 'package:github_app/feature/data/models/user_list_model.dart';
import 'package:github_app/feature/data/models/user_model.dart';

abstract class FeatureRemoteDataSource {
  Future<List<UserListModel>> getUsers(int page, int totalUser);
  Future<UserModel> getUser(String name);
}
