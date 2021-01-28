class StateModel {
  final String label;
  final dynamic id;

  StateModel({this.label, this.id});
  StateModel.fromJson(Map<String, dynamic> parsedData)
      : label = parsedData['name'],
        id = parsedData['id'];
}

class ProviderTypeModel {
  final String label;
  final dynamic id;

  ProviderTypeModel({this.label, this.id});
  ProviderTypeModel.fromJson(Map<String, dynamic> parsedData)
      : label = parsedData['name'],
        id = parsedData['id'];
}
