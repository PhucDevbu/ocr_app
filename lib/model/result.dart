class Result {
  final String text;
  final String url;
  final String createAt;
  final String uId;

  Result(
      {required this.text,
      required this.url,
      required this.createAt,
      required this.uId});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'url': url,
      'createAt': createAt,
      'uId': uId,
    };
  }

  static Result fromMap(Map<String, dynamic> map) {
    return Result(
        text: map['text'],
        url: map['url'],
        createAt: map['createAt'],
        uId: map['uId']);
  }
}
