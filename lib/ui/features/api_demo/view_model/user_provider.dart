import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_client/api_client.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/api_exception.dart';

// Repository provider
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository();
});

// Users list state
class UsersState {
  final List<User> users;
  final bool isLoading;
  final String? error;
  
  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });
  
  UsersState copyWith({
    List<User>? users,
    bool? isLoading,
    String? error,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Users notifier
class UsersNotifier extends StateNotifier<UsersState> {
  final IUserRepository _userRepository;
  
  UsersNotifier(this._userRepository) : super(const UsersState());
  
  Future<void> fetchUsers() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final users = await _userRepository.getUsers();
      state = state.copyWith(
        users: users,
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
  
  Future<void> createUser(CreateUserRequest request) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final newUser = await _userRepository.createUser(request);
      if (newUser != null) {
        state = state.copyWith(
          users: [...state.users, newUser],
          isLoading: false,
        );
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create user',
      );
    }
  }
  
  Future<void> deleteUser(int userId) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _userRepository.deleteUser(userId);
      state = state.copyWith(
        users: state.users.where((user) => user.id != userId).toList(),
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
        error: 'Failed to delete user',
      );
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Users provider
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UsersNotifier(repository);
});

// Individual user provider
final userProvider = FutureProvider.family<User?, int>((ref, userId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
});