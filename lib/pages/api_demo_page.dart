import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/providers/user_provider.dart';
import 'package:flutter_boilerplate/providers/post_provider.dart';
import 'package:api_client/src/model/user.dart';
import 'package:api_client/src/model/post.dart';

class ApiDemoPage extends ConsumerStatefulWidget {
  const ApiDemoPage({super.key});

  @override
  ConsumerState<ApiDemoPage> createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends ConsumerState<ApiDemoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersProvider.notifier).fetchUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Posts', icon: Icon(Icons.article)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
          _buildPostsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        tooltip: 'Back to Home',
        child: const Icon(Icons.home),
      ),
    );
  }

  Widget _buildUsersTab() {
    final usersState = ref.watch(usersProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(usersProvider.notifier).fetchUsers(),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (usersState.error != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        usersState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(usersProvider.notifier).clearError();
                      },
                    ),
                  ],
                ),
              ),
            
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Users (${usersState.users.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (usersState.isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ref.read(usersProvider.notifier).fetchUsers();
                    },
                  ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            Expanded(
              child: usersState.users.isEmpty && !usersState.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64.w,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No users found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(usersProvider.notifier).fetchUsers();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: usersState.users.length,
                      itemBuilder: (context, index) {
                        final user = usersState.users[index];
                        return _buildUserCard(user);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Email is always non-null
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.article_outlined),
                  onPressed: () {
                    setState(() {
                      _selectedUserId = user.id;
                    });
                    _tabController.animateTo(1);
                    ref.read(postsProvider.notifier).fetchPostsByUserId(user.id);
                  },
                  tooltip: 'View Posts',
                ),
              ],
            ),
            if (user.phone != null || user.website != null) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (user.phone != null) ...[
                    Icon(
                      Icons.phone,
                      size: 16.w,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        user.phone!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                  if (user.website != null) ...[
                    Icon(
                      Icons.language,
                      size: 16.w,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        user.website!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    final postsState = ref.watch(postsProvider);

    return RefreshIndicator(
      onRefresh: () {
        if (_selectedUserId != null) {
          return ref.read(postsProvider.notifier).fetchPostsByUserId(_selectedUserId!);
        } else {
          return ref.read(postsProvider.notifier).fetchPosts(limit: 20);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (postsState.error != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        postsState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref.read(postsProvider.notifier).clearError();
                      },
                    ),
                  ],
                ),
              ),
            
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedUserId != null
                        ? 'Posts by User $_selectedUserId (${postsState.posts.length})'
                        : 'All Posts (${postsState.posts.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (_selectedUserId != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedUserId = null;
                      });
                      ref.read(postsProvider.notifier).fetchPosts(limit: 20);
                    },
                    child: const Text('Show All'),
                  ),
                if (postsState.isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      if (_selectedUserId != null) {
                        ref.read(postsProvider.notifier).fetchPostsByUserId(_selectedUserId!);
                      } else {
                        ref.read(postsProvider.notifier).fetchPosts(limit: 20);
                      }
                    },
                  ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            Expanded(
              child: postsState.posts.isEmpty && !postsState.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64.w,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _selectedUserId != null ? 'No posts from this user' : 'No posts found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedUserId != null) {
                                ref.read(postsProvider.notifier).fetchPostsByUserId(_selectedUserId!);
                              } else {
                                ref.read(postsProvider.notifier).fetchPosts(limit: 20);
                              }
                            },
                            child: const Text('Load Posts'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: postsState.posts.length,
                      itemBuilder: (context, index) {
                        final post = postsState.posts[index];
                        return _buildPostCard(post);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'ID: $post.id',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'User: $post.userId',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              post.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              post.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}