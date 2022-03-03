import 'package:dio/dio.dart';

import '../model/login_request_model.dart';
import '../model/login_response_model.dart';

abstract class ILoginService {
  final Dio dio;

  ILoginService(this.dio);
  final loginPath = ILoginServicePath.login.rawValue;

  Future<LoginResponseModel?> postUserData(LoginRequestModel model);
}

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResponseModel?> postUserData(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}

enum ILoginServicePath { login }

extension IloginServicePAthExtension on ILoginServicePath {
  String get rawValue {
    switch (this) {
      case ILoginServicePath.login:
        return '/login';
    }
  }
}
