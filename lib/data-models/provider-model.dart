class ProviderModel {
  final String name;
  final dynamic id;
  final String description;
  final int rating;
  final String address;
  final String activeStatus;
  final String providerType;
  final String state;
  final String image;

  ProviderModel({
    this.name,
    this.id,
    this.description,
    this.rating,
    this.address,
    this.activeStatus,
    this.providerType,
    this.state,
    this.image,
  });
  ProviderModel.fromJson(Map<String, dynamic> parsedData)
      : name = parsedData == null ? 'Not Specifed' : parsedData['name'],
        id = parsedData['id'],
        description =
            parsedData == null ? 'Not Specifed' : parsedData['description'],
        rating = parsedData == null ? 1.0 : parsedData['rating'],
        address = parsedData == null ? 'Not Specifed' : parsedData['address'],
        activeStatus =
            parsedData == null ? 'Pending' : parsedData['active_status'],
        state = parsedData['state'] == null
            ? 'Not Specifed'
            : parsedData['state']['name'],
        providerType = parsedData['provider_type'] == null
            ? 'Not Specifed'
            : parsedData['provider_type']['name'],
        image = parsedData['images'].length > 0
            ? parsedData['images'][0]['url']
            : 'https://via.placeholder.com/300x150.png?text=No+provider+image';
}
