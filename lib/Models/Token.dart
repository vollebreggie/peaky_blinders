class Token {
 String auth_token, id;
 int expires_in;
 

 Token({
     this.id,
     this.auth_token,
     this.expires_in,
  });

 Token.fromMap(Map<String, dynamic> map): this(
    id: map["id"],
    auth_token: map["auth_token"],
    expires_in: map["expires_in"],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "auth_token": auth_token,
      "expires_in": expires_in
    };
  }
}