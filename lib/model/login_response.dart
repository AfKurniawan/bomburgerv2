class UserResponse {

  final String status;
  final String id;
  final String storeid;
 // final List<String> user;



  UserResponse({this.status, this.id, this.storeid });

  factory UserResponse.fromJson(Map<String, dynamic> parsedJson) {
    return new UserResponse(
      status: parsedJson['status'],
      id: parsedJson['id'],
      storeid: parsedJson['store_id'],

    );
  }
}