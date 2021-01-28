import 'package:connectivity/connectivity.dart';
import 'package:prozone/data-models/meta-data-model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prozone/utils/url.dart';

class MetaDataService {
  StateModel _states;
  List<StateModel> _allStates = [];
  ProviderTypeModel _providerTypes;
  List<ProviderTypeModel> _allProviderTypes = [];

  List<StateModel> get allStates {
    return List.from(_allStates);
  }

  List<ProviderTypeModel> get allProviderTypes {
    return List.from(_allProviderTypes);
  }

  getInstantStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivity $connectivityResult');
    return connectivityResult.toString();
  }

  Future getStates() async {
    try {
      final connectionStatus = await getInstantStatus();
      print('connections status $connectionStatus');
      // check internet connection
      if (connectionStatus != 'ConnectivityResult.none') {
        http.Response response = await http.get('${Url.baseUrl}/states',
            headers: Url.requestHeaders);

        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData.length > 0) {
          final dynamic states = decodedData;

          final List<StateModel> tempList = [];

          states.forEach((dynamic state) {
            var serialized = StateModel.fromJson(state);
            _states = StateModel(id: serialized.id, label: serialized.label);
            tempList.add(_states);
          });
          print('templist $tempList');

          _allStates = tempList;

          return {'success': true, 'message': 'Fetched successfuly'};
        }
      } else {
        return {
          'success': false,
          'message': "You don't have an active internet connection"
        };
      }
    } catch (error) {
      print('errror occured $error');
      return {'success': false, 'message': "Unable to initialize app"};
    }
  }

  Future getProviderTypes() async {
    try {
      print('getting types');
      final connectionStatus = await getInstantStatus();
      print('connections status $connectionStatus');
      // check internet connection
      if (connectionStatus != 'ConnectivityResult.none') {
        http.Response response = await http.get('${Url.baseUrl}/provider-types',
            headers: Url.requestHeaders);
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData.length > 0) {
          final dynamic providerTypes = decodedData;

          final List<ProviderTypeModel> tempList = [];

          providerTypes.forEach((dynamic type) {
            var serialized = ProviderTypeModel.fromJson(type);
            _providerTypes =
                ProviderTypeModel(id: serialized.id, label: serialized.label);
            tempList.add(_providerTypes);
          });
          print('templist $tempList');

          _allProviderTypes = tempList;

          return {'success': true, 'message': 'Fetched successfuly'};
        }
      } else {
        return {
          'success': false,
          'message': "You don't have an active internet connection"
        };
      }
    } catch (error) {
      print('errror occured $error');
      return {'success': false, 'message': "Unable to initialize app"};
    }
  }
}
