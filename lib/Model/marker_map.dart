class MarkerMap{
  int? id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  MarkerMap({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
});

  factory MarkerMap.fromMap(Map<String, dynamic> map) =>
      MarkerMap(
          id: map['Id'],
          title: map['Title'],
          description: map['Description'],
          latitude: map['Latitude'],
          longitude: map['Longitude']
      );
  Map<String, dynamic> toMap(){
    return {
      'Id': id,
      'Title' : title,
      'Description' : description,
      'Latitude' : latitude,
      'Longitude' : longitude
    };
  }
}