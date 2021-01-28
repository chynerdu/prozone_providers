import 'package:connectivity/connectivity.dart';
import 'package:prozone/data-models/meta-data-model.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prozone/data-models/provider-model.dart';
import 'package:prozone/utils/url.dart';

class ProviderService {
  ProviderModel _providers;
  List<ProviderModel> _allProviders = [];

  List<ProviderModel> get allProviders {
    return List.from(_allProviders);
  }

  getInstantStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivity $connectivityResult');
    return connectivityResult.toString();
  }

  Future<Map<String, dynamic>> getProviders() async {
    try {
      final connectionStatus = await getInstantStatus();
      print('connections status $connectionStatus');
      // check internet connection
      if (connectionStatus != 'ConnectivityResult.none') {
        http.Response response = await http.get('${Url.baseUrl}/providers',
            headers: Url.requestHeaders);

        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData.length > 0) {
          final dynamic providers = decodedData;

          final List<ProviderModel> tempList = [];
          print('providers $providers');
          providers.forEach((dynamic provider) {
            print('providerss $provider');
            var serialized = ProviderModel.fromJson(provider);
            _providers = ProviderModel(
                id: serialized.id,
                name: serialized.name,
                description: serialized.description,
                rating: serialized.rating,
                address: serialized.address,
                activeStatus: serialized.activeStatus,
                providerType: serialized.providerType,
                state: serialized.state,
                image: serialized.image);
            tempList.add(_providers);
          });
          print('templist $tempList');

          _allProviders = tempList;

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
      return {'success': false, 'message': "Request fail"};
    }
  }

  // Future getProviderTypes() async {
  //   try {
  //     print('getting types');
  //     final connectionStatus = await getInstantStatus();
  //     print('connections status $connectionStatus');
  //     // check internet connection
  //     if (connectionStatus != 'ConnectivityResult.none') {
  //       http.Response response = await http.get('${Url.baseUrl}/provider-types',
  //           headers: Url.requestHeaders);
  //       final dynamic decodedData = jsonDecode(response.body);

  //       if (decodedData.length > 0) {
  //         final dynamic providerTypes = decodedData;

  //         final List<ProviderTypeModel> tempList = [];

  //         providerTypes.forEach((dynamic type) {
  //           var serialized = ProviderTypeModel.fromJson(type);
  //           _providerTypes =
  //               ProviderTypeModel(id: serialized.id, label: serialized.label);
  //           tempList.add(_providerTypes);
  //         });
  //         print('templist $tempList');

  //         _allProviderTypes = tempList;

  //         return {'success': true, 'message': 'Fetched successfuly'};
  //       }
  //     } else {
  //       return {
  //         'success': false,
  //         'message': "You don't have an active internet connection"
  //       };
  //     }
  //   } catch (error) {
  //     print('errror occured $error');
  //     return {'success': false, 'message': "Unable to initialize app"};
  //   }
  // }
}
