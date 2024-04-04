import 'package:dartz/dartz.dart';
import 'package:github_app/core/error/failure.dart';
import 'package:github_app/feature/domain/entities/user_entity.dart';
import 'package:github_app/feature/domain/entities/user_list_entity.dart';

import '../repositories/feature_repository.dart';

class GetUsers {
  final FeatureRepository featureRepository;

  GetUsers(this.featureRepository);

  Future<Either<Failure, List<UserListEntity>>> getUsers(
      int page, int totalUser) async {
    print("featureRepository.getUsers()");
    return await featureRepository.getUsers(page, totalUser);
  }

  Future<Either<Failure, UserDetailEntity>> getUser(String name) async {
    print("featureRepository.getUser()");
    return await featureRepository.getUser(name);
  }
}
