import 'package:bson/bson.dart';

import '../model/User.dart';
import '../service/Request.dart';

abstract class AuthRepository {
  Future<Token?> login({required UserForm user});

  Future<Token?> register({required UserForm user});

  Future<User> logout({required ObjectId id});
}

class TemplateAuthRepository implements AuthRepository {
  @override
  Future<Token?> login({required UserForm user}) async {
    final Token token = Token(
      token: '672748d470e4e2a12d6cd21b',
      tokenType: 'Bearer',
    );

    return token;
  }

  @override
  Future<Token?> register({required UserForm user}) async {
    return login(user: user);
  }

  @override
  Future<User> logout({required ObjectId id}) async {
    throw UnimplementedError();
  }
}
