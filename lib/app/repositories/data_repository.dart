import 'package:coronavirus_rest_api_flutter_course/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  String _accessToken;

  DataRepository({@required this.apiService});

  // get data from a given endpoint
  Future<int> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<int>(
        onGetData: () {
          return apiService.getEndpointData(
              accessToken: _accessToken, endpoint: endpoint);
        },
      );
  // try {
  //   if (_accessToken == null) {
  //     _accessToken = await apiService.getAccessToken();
  //   }
  //   return await apiService.getEndpointData(
  //     accessToken: _accessToken,
  //     endpoint: endpoint,
  //   );
  // } on Response catch (response) {
  //   // if request is unauthorized, get new accessToken
  //   if (response.statusCode == 401) {
  //     _accessToken = await apiService.getAccessToken();
  //     return await apiService.getEndpointData(
  //       accessToken: _accessToken,
  //       endpoint: endpoint,
  //     );
  //   }
  //   // otherwise rethrow response to calling side widget, to present a generic error
  //   rethrow;
  // }

  Future<EndpointsData> getAllEndpointsData() async =>
      await _getDataRefreshingToken<EndpointsData>(
          onGetData: _getAllEndpointsData);

  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      // if request is unauthorized, get new accessToken
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      // otherwise rethrow response to calling side widget, to present a generic error
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    // all futures in the list of Future.wait get executed in parallel
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered)
    ]);
    // Map endpoints to values
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesConfirmed: values[1],
      Endpoint.casesSuspected: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4]
    });
  }
}
