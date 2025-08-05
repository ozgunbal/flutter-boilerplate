import '../api/generated/lib/src/api/posts_api.dart';
import '../api/generated/lib/src/model/post.dart';
import '../core/api/api_client.dart';
import '../core/api/base_repository.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts({int? userId, int? limit});
  Future<List<Post>> getPostsByUserId(int userId);
}

class PostRepository extends BaseRepository implements IPostRepository {
  late final PostsApi _postsApi;
  
  PostRepository() {
    _postsApi = PostsApi(ApiClient().client);
  }
  
  @override
  Future<List<Post>> getPosts({int? userId, int? limit}) async {
    return handleApiCall(() async {
      final response = await _postsApi.getPosts(
        userId: userId,
        limit: limit,
      );
      return extractListData<Post>(response);
    });
  }
  
  @override
  Future<List<Post>> getPostsByUserId(int userId) async {
    return getPosts(userId: userId);
  }
}