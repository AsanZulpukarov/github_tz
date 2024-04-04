import 'package:dartz/dartz.dart';
import 'package:github_app/core/error/failure.dart';
import 'package:github_app/feature/domain/entities/user_entity.dart';
import 'package:github_app/feature/domain/entities/user_list_entity.dart';

abstract class FeatureRepository {
  Future<Either<Failure, List<UserListEntity>>> getUsers(
      int page, int totalUser);
  Future<Either<Failure, UserDetailEntity>> getUser(String name);
}
