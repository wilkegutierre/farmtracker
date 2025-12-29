import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

import '../../errors/http_error.dart';
import '../../errors/user_error.dart';

mixin BaseServiceMixin {
  AsyncResult<Response> requestService(Future<Response> Function() apiRequest) async {
    try {
      final response = await apiRequest.call();

      if (response.statusCode == 200) {
        return Success(response);
      }
      return Failure(getHttpError(response.statusCode));
    } catch (error) {
      return Failure(LoginUserError());
    }
  }
}
