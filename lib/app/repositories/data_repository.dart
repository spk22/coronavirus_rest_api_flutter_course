import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  String _accessToken;

  DataRepository({@required this.apiService});

  // get data from a given endpoint
  Future<int> getEndpointData(Endpoint endpoint) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: endpoint,
      );
    } on Response catch (response) {
      // if request is unauthorized, get new accessToken
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(
          accessToken: _accessToken,
          endpoint: endpoint,
        );
      }
      // otherwise rethrow response to calling side widget, to present a generic error
      rethrow;
    }
  }
}
