import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service for communicating with FarmSphere backend API
class ApiService {
  // Base URL for the backend API
  static String get baseUrl {
    if (kIsWeb) {
      // For web, use the same origin or configure your backend URL
      final uri = Uri.base;
      final scheme = (uri.scheme == 'https') ? 'https' : 'http';
      final host = (uri.host.isEmpty) ? 'localhost' : uri.host;
      return '$scheme://$host:5000';
    } else {
      // For mobile, use localhost or your server IP
      // Change 'localhost' to your computer's IP if testing on physical device
      // e.g., 'http://192.168.1.100:5000'
      return 'http://localhost:5000';
    }
  }

  /// Check if API server is available
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          // If database is not connected, treat as unhealthy for data operations
          if (data['database_connected'] == false) {
            return false;
          }
        } catch (_) {
          // ignore json decode errors
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('API health check failed: $e');
      }
      return false;
    }
  }

  // ==================== USER ENDPOINTS ====================

  /// Create a new user
  static Future<Map<String, dynamic>> createUser({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
      rethrow;
    }
  }

  /// Get user by ID
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      return null;
    }
  }

  // ==================== POST ENDPOINTS ====================

  /// Get all posts with pagination
  static Future<Map<String, dynamic>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/posts?page=$page&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get posts: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting posts: $e');
      }
      rethrow;
    }
  }

  /// Create a new post
  static Future<Map<String, dynamic>> createPost({
    required String postId,
    required String authorId,
    required String author,
    required String content,
    required String location,
    List<String>? tags,
    String? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': postId,
          'authorId': authorId,
          'author': author,
          'content': content,
          'location': location,
          'tags': tags ?? [],
          'image': image,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating post: $e');
      }
      rethrow;
    }
  }

  /// Delete a post
  static Future<bool> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/posts/$postId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting post: $e');
      }
      return false;
    }
  }

  // ==================== COMMENT ENDPOINTS ====================

  /// Get comments for a post
  static Future<List<Map<String, dynamic>>> getComments(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['comments'] ?? []);
      } else {
        throw Exception('Failed to get comments: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting comments: $e');
      }
      return [];
    }
  }

  /// Create a comment on a post
  static Future<Map<String, dynamic>> createComment({
    required String commentId,
    required String postId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': commentId,
          'userId': userId,
          'userName': userName,
          'content': content,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create comment: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating comment: $e');
      }
      rethrow;
    }
  }

  // ==================== LIKE ENDPOINTS ====================

  /// Toggle like on a post
  static Future<Map<String, dynamic>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/like'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling like: $e');
      }
      rethrow;
    }
  }

  // ==================== SAVE POST ENDPOINTS ====================

  /// Toggle save on a post
  static Future<Map<String, dynamic>> toggleSave({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/save'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to toggle save: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling save: $e');
      }
      rethrow;
    }
  }

  /// Get saved posts for a user
  static Future<List<Map<String, dynamic>>> getSavedPosts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/saved-posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['posts'] ?? []);
      } else {
        throw Exception('Failed to get saved posts: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting saved posts: $e');
      }
      return [];
    }
  }

  // ==================== ACTIVITY ENDPOINTS ====================

  /// Get activities for a user
  static Future<List<Map<String, dynamic>>> getActivities({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/activities?page=$page&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['activities'] ?? []);
      } else {
        throw Exception('Failed to get activities: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting activities: $e');
      }
      return [];
    }
  }

  /// Create a new activity
  static Future<Map<String, dynamic>> createActivity({
    required String activityId,
    required String userId,
    required String type,
    required String crop,
    required String notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/$userId/activities'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': activityId,
          'type': type,
          'crop': crop,
          'notes': notes,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create activity: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating activity: $e');
      }
      rethrow;
    }
  }

  // ==================== CHAT ENDPOINTS ====================

  /// Get chat messages
  static Future<List<Map<String, dynamic>>> getChatMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chats/$chatId/messages?page=$page&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['messages'] ?? []);
      } else {
        throw Exception('Failed to get chat messages: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting chat messages: $e');
      }
      return [];
    }
  }

  /// Create a chat message
  static Future<Map<String, dynamic>> createChatMessage({
    required String messageId,
    required String chatId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chats/$chatId/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': messageId,
          'userId': userId,
          'userName': userName,
          'content': content,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create chat message: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating chat message: $e');
      }
      rethrow;
    }
  }

  // ==================== CROP HEALTH ENDPOINTS ====================

  /// Get crop health diagnosis history
  static Future<List<Map<String, dynamic>>> getCropHealthHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId/crop-health?page=$page&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['diagnoses'] ?? []);
      } else {
        throw Exception('Failed to get crop health history: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting crop health history: $e');
      }
      return [];
    }
  }

  /// Save a crop health diagnosis
  static Future<Map<String, dynamic>> saveCropHealthDiagnosis({
    required String diagnosisId,
    required String userId,
    String? imageUrl,
    required List<Map<String, dynamic>> results,
    String? location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/$userId/crop-health'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': diagnosisId,
          'imageUrl': imageUrl,
          'results': results,
          'location': location,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save crop health diagnosis: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving crop health diagnosis: $e');
      }
      rethrow;
    }
  }
}

