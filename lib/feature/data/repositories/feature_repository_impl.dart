import 'package:dartz/dartz.dart';
import 'package:github_app/core/error/exception.dart';
import 'package:github_app/core/error/failure.dart';
import 'package:github_app/core/platform/network_info.dart';
import 'package:github_app/feature/data/datasources/feature_remote_data_source.dart';
import 'package:github_app/feature/domain/entities/user_entity.dart';
import 'package:github_app/feature/domain/entities/user_list_entity.dart';
import 'package:github_app/feature/domain/repositories/feature_repository.dart';

class FeatureRepositoryImpl extends FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  FeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserListEntity>>> getUsers(
      int page, int totalUser) async {
    print("getUsers Future");
    if (await networkInfo.isConnected) {
      try {
        print("getUsers");
        final remoteUsers = await remoteDataSource.getUsers(page, totalUser);
        return Right(remoteUsers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserDetailEntity>> getUser(String name) async {
    print("getUser Future");
    if (await networkInfo.isConnected) {
      try {
        print("getUsers");
        final remoteUser = await remoteDataSource.getUser(name);
        return Right(remoteUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
