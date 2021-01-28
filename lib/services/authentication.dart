import 'package:prozone/utils/url.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class Authentication {
  Future<Map<String, dynamic>> addProvider(
      {name, description, rating, address, state, providerType}) async {
    try {
      var registrationPayload = {
        "name": name.trim(),
        "description": description,
        "rating": rating,
        "address": address,
        "state": state,
        "provider_type": providerType,
        "active_status": "Pending"
      };
      print('payload $registrationPayload');
      http.Response response = await http.post('${Url.baseUrl}/providers',
          body: json.encode(registrationPayload), headers: Url.requestHeaders);
      print('response body ${response.body}');

      if (response.statusCode != 302) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        print('response body ${decodedResponse['statusCode']}');
        if (decodedResponse['statusCode'] == 200 ||
            decodedResponse['statusCode'] == 201) {
          return {'success': true, 'message': decodedResponse['message']};
        } else {
          return {'success': false, 'message': decodedResponse['message']};
        }
      } else {
        return {'success': false, 'message': 'Unable to reach the server'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error occured'};
    }
  }
}
