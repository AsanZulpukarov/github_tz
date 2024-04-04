import 'package:github_app/feature/domain/entities/user_list_entity.dart';

class UserListModel extends UserListEntity {
  const UserListModel({
    required login,
    required id,
    required avatarUrl,
  }) : super(
          login: login,
          id: id,
          avatarUrl: avatarUrl,
        );
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      login: json['login'],
      id: json['id'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['id'] = id;
    data['avatar_url'] = avatarUrl;
    return data;
  }
}
