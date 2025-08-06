import 'package:api_client/api_client.dart';
import '../services/api_client.dart' as core_api_client;
import '../services/base_repository.dart';

abstract class IUserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
  Future<User?> createUser(CreateUserRequest request);
  Future<User?> updateUser(int id, UpdateUserRequest request);
  Future<void> deleteUser(int id);
}

class UserRepository extends BaseRepository implements IUserRepository {
  late final UsersApi _usersApi;
  
  UserRepository() {
    _usersApi = UsersApi(core_api_client.ApiClient().client.dio, core_api_client.ApiClient().client.serializers);
  }
  
  @override
  Future<List<User>> getUsers() async {
    return handleApiCall(() async {
      final response = await _usersApi.getUsers();
      return extractListData<User>(response);
    });
  }
  
  @override
  Future<User?> getUserById(int id) async {
    return handleApiCall(() async {
      final response = await _usersApi.getUserById(id: id);
      return extractData<User>(response);
    });
  }
  
  @override
  Future<User?> createUser(CreateUserRequest request) async {
    return handleApiCall(() async {
      final response = await _usersApi.createUser(createUserRequest: request);
      return extractData<User>(response);
    });
  }
  
  @override
  Future<User?> updateUser(int id, UpdateUserRequest request) async {
    return handleApiCall(() async {
      final response = await _usersApi.updateUser(
        id: id, 
        updateUserRequest: request,
      );
      return extractData<User>(response);
    });
  }
  
  @override
  Future<void> deleteUser(int id) async {
    return handleApiCall(() async {
      await _usersApi.deleteUser(id: id);
    });
  }
}