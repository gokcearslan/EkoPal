class Advertisement {
  final String advertisementName;
  final String? advertisementType;
  final String advertisementDetails;
  bool isFavorite;


  Advertisement({
    required this.advertisementName,
    required this.advertisementType,
    required this.advertisementDetails,
    this.isFavorite = false,

  });
}
