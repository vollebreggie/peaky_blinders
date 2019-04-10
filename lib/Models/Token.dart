class Token {
 String auth_token;
 DateTime expires_in;

 Token({
     this.auth_token,
     this.expires_in,
  });

 Token.fromMap(Map<String, dynamic> map): this(
    auth_token: map["auth_token"],
    expires_in: map["expires_in"],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      "auth_token": auth_token,
      "expires_in": expires_in
    };
  }
}