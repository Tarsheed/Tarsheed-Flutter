import 'package:dartz/dartz.dart';
import 'package:tarsheed/src/core/apis/api.dart';
import 'package:tarsheed/src/core/apis/dio_helper.dart';
import 'package:tarsheed/src/core/apis/end_points.dart';
import 'package:tarsheed/src/modules/settings/data/models/user.dart';

abstract class BaseSettingsRemoteServices {
  Future<Either<Exception, User>> getProfile();

  Future<Either<Exception, Unit>> updateProfile(User user);
  Future<Either<Exception, Unit>> deleteProfile();
}

class SettingsRemoteServices extends BaseSettingsRemoteServices {
  @override
  Future<Either<Exception, User>> getProfile() async {
    try {
      var response = await DioHelper.getData(
        path: "${EndPoints.getProfile}/${ApiManager.userId}",
      );
      return Right(User.fromJson(response.data["userData"]));
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> updateProfile(User user) async {
    try {
      await DioHelper.putData(
        path: "${EndPoints.updateProfile}/${ApiManager.userId}",
        data: user.toJson(),
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteProfile() async {
    try {
      await DioHelper.deleteData(
        path: "${EndPoints.deleteProfile}/${ApiManager.userId}",
      );
      return Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
