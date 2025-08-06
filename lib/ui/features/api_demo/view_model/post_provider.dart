import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_client/api_client.dart';
import '../../../../data/repositories/post_repository.dart';
import '../../../../data/services/api_exception.dart';

// Repository provider
final postRepositoryProvider = Provider<IPostRepository>((ref) {
  return PostRepository();
});

// Posts list state
class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final int? currentUserId;
  
  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.currentUserId,
  });
  
  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    int? currentUserId,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

// Posts notifier
class PostsNotifier extends StateNotifier<PostsState> {
  final IPostRepository _postRepository;
  
  PostsNotifier(this._postRepository) : super(const PostsState());
  
  Future<void> fetchPosts({int? userId, int? limit}) async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isLoading: true, 
      error: null,
      currentUserId: userId,
    );
    
    try {
      final posts = await _postRepository.getPosts(
        userId: userId,
        limit: limit,
      );
      state = state.copyWith(
        posts: posts,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }
  
  Future<void> fetchPostsByUserId(int userId) async {
    return fetchPosts(userId: userId);
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  void clearPosts() {
    state = const PostsState();
  }
}

// Posts provider
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostsNotifier(repository);
});

// Posts by user provider (cached)
final postsByUserProvider = FutureProvider.family<List<Post>, int>((ref, userId) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsByUserId(userId);
});