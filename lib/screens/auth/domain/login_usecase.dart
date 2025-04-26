import 'package:awee/screens/auth/data/auth_repositery.dart';

import 'user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> login(String email, String password) {
    return repository.login(email, password);
  }
}
