class ImageData {
  late String date;
  late String explanation;
  late String hdurl;
  late String mediaType;
  late  String serviceVersion;
  late String title;
  late  String url;

  ImageData();

  ImageData.fromMap(Map<dynamic, dynamic> map) {
  //  date = map['date'];
  //  explanation = map['explanation'];
    //hdurl = map['hdurl'];
    //mediaType = map['media_type'];
    //serviceVersion = map['service_version'];
   // title = map['title'];
    url = map['url'];
  }
}