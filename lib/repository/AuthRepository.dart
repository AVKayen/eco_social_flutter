import 'package:bson/bson.dart';

import '../model/User.dart';
import '../service/Request.dart';
import 'UserRepository.dart';

//TEMPORARY
UserRepository _userRepository = TemplateUserRepository();

abstract class AuthRepository {
  Future<User?> getUserByToken({required String token});

  Future<Token?> login({required UserForm user});

  Future<Token?> register({required UserForm user});
}

class TemplateAuthRepository implements AuthRepository {
  @override
  Future<User?> getUserByToken({required String token}) async {
    //TEMPORARY
    return _userRepository.getUserByToken(token: token);
  }

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
}
