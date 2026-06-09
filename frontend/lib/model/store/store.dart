class StoreModel {
  final String? storeId;
  final String? storeName;
  final String? ownerName;
  final String? location;
  final String? gstNumber;
  final String? area;
  final String? beat;
  final String? address;
  final String? mobileNum;

  StoreModel({
    this.storeId,
    this.storeName,
    this.ownerName,
    this.location,
    this.gstNumber,
    this.area,
    this.beat,
    this.address,
    this.mobileNum,
  });

  // Factory constructor to create a Store object from JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json['storeId'],
      storeName: json['storeName'],
      ownerName: json['ownerName'],
      location: json['location'],
      gstNumber: json['gstNumber'],
      area: json['area'],
      beat: json['beat'],
      address: json['address'],
      mobileNum: json['mobileNum'],
    );
  }

  // Method to convert Store object to JSON
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'ownerName': ownerName,
      'location': location,
      'gstNumber': gstNumber,
      'area': area,
      'beat': beat,
      'address': address,
      'mobileNum': mobileNum,
    };
  }
}
