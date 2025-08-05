# api_client.api.PostsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *https://jsonplaceholder.typicode.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPosts**](PostsApi.md#getposts) | **GET** /posts | Get all posts


# **getPosts**
> BuiltList<Post> getPosts(userId, limit)

Get all posts

Retrieve a list of all posts with optional filtering

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPostsApi();
final int userId = 789; // int | Filter posts by user ID
final int limit = 56; // int | Maximum number of posts to return

try {
    final response = api.getPosts(userId, limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling PostsApi->getPosts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **int**| Filter posts by user ID | [optional] 
 **limit** | **int**| Maximum number of posts to return | [optional] [default to 10]

### Return type

[**BuiltList&lt;Post&gt;**](Post.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

