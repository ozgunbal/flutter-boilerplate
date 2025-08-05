import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for UsersApi
void main() {
  final instance = ApiClient().getUsersApi();

  group(UsersApi, () {
    // Create a new user
    //
    // Create a new user with the provided data
    //
    //Future<User> createUser(CreateUserRequest createUserRequest) async
    test('test createUser', () async {
      // TODO
    });

    // Delete user
    //
    // Delete a user by their ID
    //
    //Future deleteUser(int id) async
    test('test deleteUser', () async {
      // TODO
    });

    // Get user by ID
    //
    // Retrieve a specific user by their ID
    //
    //Future<User> getUserById(int id) async
    test('test getUserById', () async {
      // TODO
    });

    // Get all users
    //
    // Retrieve a list of all users
    //
    //Future<BuiltList<User>> getUsers() async
    test('test getUsers', () async {
      // TODO
    });

    // Update user
    //
    // Update an existing user's information
    //
    //Future<User> updateUser(int id, UpdateUserRequest updateUserRequest) async
    test('test updateUser', () async {
      // TODO
    });

  });
}
