import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Service dedicated to database operations on the 'Users' table.
class UserDataService {
  final SupabaseClient _supabase;

  UserDataService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Function to save or upsert user data to Supabase database.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _supabase.from('Users').upsert(user.toJson());
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      if (userId.isEmpty) return UserModel.empty();

      final response = await _supabase
          .from('Users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      } else {
        return UserModel.empty();
      }
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update entire user model in Supabase.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _supabase
          .from('Users')
          .update(updatedUser.toJson())
          .eq('id', updatedUser.id);
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Update specific field in Users table for a given user.
  Future<void> updateSingleField(
    String userId,
    Map<String, dynamic> json,
  ) async {
    try {
      if (userId.isEmpty) throw 'User not authenticated';

      await _supabase.from('Users').update(json).eq('id', userId);
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to remove user record completely from Supabase (Auth + Tables).
  Future<void> removeUserRecord(String userId) async {
    try {
      // 1. Call delete_user RPC function which deletes from auth.users and all related tables
      try {
        await _supabase.rpc('delete_user');
        return;
      } catch (rpcError) {
        final errorStr = rpcError.toString().toLowerCase();
        final isMissingRpc = errorStr.contains('delete_user') ||
            errorStr.contains('schema cache') ||
            errorStr.contains('pgrst202') ||
            errorStr.contains('not found');

        // Delete from public tables as fallback
        try {
          await _supabase.from('Addresses').delete().eq('userId', userId);
        } catch (_) {}

        try {
          await _supabase.from('Orders').delete().eq('userId', userId);
        } catch (_) {}

        try {
          await _supabase.from('Users').delete().eq('id', userId);
        } catch (_) {}

        if (isMissingRpc) {
          throw 'Please run the "supabase_delete_user.sql" script in Supabase SQL Editor to allow deleting the account from Authentication -> Users.';
        } else {
          rethrow;
        }
      }
    } on PostgrestException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong. Please try again: $e';
    }
  }
}
