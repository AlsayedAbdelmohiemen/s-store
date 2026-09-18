import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/personalization/models/address_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for managing Address data with Cloud Supabase and Local Storage Persistence.
class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;
  final _storage = GetStorage();

  /// Storage key based on current authenticated user ID
  String _getStorageKey() {
    final userId = AuthenticationRepository.instance.authUser?.id;
    return userId != null && userId.isNotEmpty
        ? 'USER_ADDRESSES_$userId'
        : 'USER_ADDRESSES_LOCAL';
  }

  /// Save addresses to local persistent disk storage
  void _saveToLocalStorage(List<AddressModel> addresses) {
    try {
      final key = _getStorageKey();
      final list = addresses.map((a) => a.toJson()).toList();
      _storage.write(key, jsonEncode(list));
    } catch (_) {}
  }

  /// Read addresses from local persistent disk storage
  List<AddressModel> _loadFromLocalStorage() {
    try {
      final key = _getStorageKey();
      final data = _storage.read(key);
      if (data != null) {
        final decoded = jsonDecode(data) as List<dynamic>;
        return decoded
            .map((item) => AddressModel.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// Fetch all addresses (first from local storage, then sync with Cloud Supabase)
  Future<List<AddressModel>> fetchUserAddresses() async {
    final localList = _loadFromLocalStorage();

    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null || userId.isEmpty) {
        return localList;
      }

      final result = await _supabase
          .from('Addresses')
          .select()
          .eq('UserId', userId)
          .order('SelectedAddress', ascending: false)
          .timeout(const Duration(seconds: 4));

      final remoteAddresses = (result as List<dynamic>)
          .map((data) => AddressModel.fromMap(data as Map<String, dynamic>))
          .toList();

      if (remoteAddresses.isNotEmpty) {
        _saveToLocalStorage(remoteAddresses);
        return remoteAddresses;
      } else if (localList.isNotEmpty) {
        // Sync existing local addresses to Supabase if remote was empty
        for (var addr in localList) {
          try {
            final data = addr.toJson();
            data['UserId'] = userId;
            data.remove('id');
            await _supabase.from('Addresses').insert(data);
          } catch (_) {}
        }
        return localList;
      }

      return [];
    } on PostgrestException catch (_) {
      // Table may not exist yet or column difference; return local disk data
      return localList;
    } on TimeoutException catch (_) {
      return localList;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      return localList;
    }
  }

  /// Update the "SelectedAddress" field for an address
  Future<void> updateSelectedField(String addressId, bool selected) async {
    // 1. Update in local storage immediately
    final currentList = _loadFromLocalStorage();
    for (var addr in currentList) {
      if (addr.id == addressId) {
        addr.selectedAddress = selected;
      } else if (selected) {
        addr.selectedAddress = false;
      }
    }
    _saveToLocalStorage(currentList);

    // 2. Persist to Cloud Supabase
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null || userId.isEmpty) return;

      await _supabase
          .from('Addresses')
          .update({'SelectedAddress': selected})
          .eq('id', addressId)
          .eq('UserId', userId)
          .timeout(const Duration(seconds: 4));
    } on PostgrestException catch (_) {
      // If table uses PascalCase 'Id', retry with 'Id'
      try {
        final currentUserId = AuthenticationRepository.instance.authUser?.id;
        if (currentUserId != null && currentUserId.isNotEmpty) {
          await _supabase
              .from('Addresses')
              .update({'SelectedAddress': selected})
              .eq('Id', addressId)
              .eq('UserId', currentUserId)
              .timeout(const Duration(seconds: 4));
        }
      } catch (_) {}
    } catch (_) {}
  }

  /// Insert a new address into Local Storage and Cloud Supabase
  Future<String> addAddress(AddressModel address) async {
    final localId = DateTime.now().millisecondsSinceEpoch.toString();
    if (address.id.isEmpty) {
      address.id = localId;
    }

    // 1. Immediately save to persistent disk storage so it is NEVER lost
    final currentList = _loadFromLocalStorage();
    if (address.selectedAddress) {
      for (var a in currentList) {
        a.selectedAddress = false;
      }
    }
    currentList.insert(0, address);
    _saveToLocalStorage(currentList);

    // 2. Try inserting into Cloud Supabase
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId != null && userId.isNotEmpty) {
        final addressData = address.toJson();
        addressData['UserId'] = userId;
        addressData.remove('id'); // Allow Supabase to generate uuid or sequence

        final response = await _supabase
            .from('Addresses')
            .insert(addressData)
            .select()
            .single()
            .timeout(const Duration(seconds: 5));

        final remoteId =
            response['id']?.toString() ?? response['Id']?.toString();
        if (remoteId != null && remoteId.isNotEmpty) {
          address.id = remoteId;
          _saveToLocalStorage(currentList);
          return remoteId;
        }
      }
    } catch (_) {
      // Saved to local persistent storage; safe from app restarts
    }

    return address.id;
  }
}
