import 'package:injectable/injectable.dart';
import 'package:new_project_template/domain/models/user_model.dart';

@singleton
class UserRepository {
  UserRepository();

  UserModel? _user;

  UserModel? get user => _user;

  set updateUserData(UserModel userModel) => _user = userModel;
}
