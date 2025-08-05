import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for PostsApi
void main() {
  final instance = ApiClient().getPostsApi();

  group(PostsApi, () {
    // Get all posts
    //
    // Retrieve a list of all posts with optional filtering
    //
    //Future<BuiltList<Post>> getPosts({ int userId, int limit }) async
    test('test getPosts', () async {
      // TODO
    });

  });
}
