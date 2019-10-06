class PostResponse {


  final String status;


  PostResponse({this.status });

  factory PostResponse.fromJson(Map<String, dynamic> parsedJson) {
    return new PostResponse(
      status: parsedJson['status'],
    );
  }
}