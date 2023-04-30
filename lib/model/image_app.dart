class ImageApp {
  final String title;
  final String url;
  final String createAt;
  final String uId;

  ImageApp(
      {required this.title,
      required this.url,
      required this.createAt,
      required this.uId});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'createAt': createAt,
      'uId': uId,
    };
  }

  static ImageApp fromMap(Map<String, dynamic> map) {
    return ImageApp(
        title: map['title'],
        url: map['url'],
        createAt: map['createAt'],
        uId: map['uId']);
  }
}
