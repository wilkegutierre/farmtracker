import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:http/http.dart';
import 'package:result_dart/result_dart.dart';

mixin BaseServiceMockMixin {
  AsyncResult<Response> requestServiceMock(Future<Response> Function() apiRequest) async {
    try {
      final response = await apiRequest.call();
      return Success(response);
    } catch (e) {
      return Success(Response('', 200)); // Always returns success even on error
    }
  }
}
