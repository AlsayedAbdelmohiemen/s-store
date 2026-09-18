import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/models/order_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

/// Repository class for managing Order data with Cloud Supabase and Local Storage Persistence.
class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.isRegistered<OrderRepository>()
      ? Get.find<OrderRepository>()
      : Get.put(OrderRepository());

  final _supabase = Supabase.instance.client;
  final _storage = GetStorage();

  /// Storage key based on current authenticated user ID
  String _getStorageKey() {
    final userId = AuthenticationRepository.instance.authUser?.id;
    return userId != null && userId.isNotEmpty
        ? 'USER_ORDERS_$userId'
        : 'USER_ORDERS_LOCAL';
  }

  /// Save orders to local persistent disk storage
  void _saveToLocalStorage(List<OrderModel> orders) {
    try {
      final key = _getStorageKey();
      final list = orders.map((o) => o.toJson()).toList();
      _storage.write(key, jsonEncode(list));
    } catch (_) {}
  }

  /// Read orders from local persistent disk storage
  List<OrderModel> _loadFromLocalStorage() {
    try {
      final key = _getStorageKey();
      final data = _storage.read(key);
      if (data != null) {
        final decoded = jsonDecode(data) as List<dynamic>;
        return decoded
            .map((item) => OrderModel.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  /// Fetch all user orders
  Future<List<OrderModel>> fetchUserOrders() async {
    final localOrders = _loadFromLocalStorage();

    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null || userId.isEmpty) {
        return localOrders;
      }

      final result = await _supabase
          .from('Orders')
          .select()
          .eq('userId', userId)
          .order('orderDate', ascending: false)
          .timeout(const Duration(seconds: 4));

      final remoteOrders = (result as List<dynamic>)
          .map((data) => OrderModel.fromMap(data as Map<String, dynamic>))
          .toList();

      if (remoteOrders.isNotEmpty) {
        _saveToLocalStorage(remoteOrders);
        return remoteOrders;
      } else if (localOrders.isNotEmpty) {
        return localOrders;
      }

      return [];
    } on PostgrestException catch (_) {
      return localOrders;
    } on TimeoutException catch (_) {
      return localOrders;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      return localOrders;
    }
  }

  /// Store new user order
  Future<void> saveOrder(OrderModel order, String userId) async {
    // 1. Immediately persist to local storage so it is NEVER lost on restart
    final currentList = _loadFromLocalStorage();
    currentList.insert(0, order);
    _saveToLocalStorage(currentList);

    // 2. Try saving to Cloud Supabase
    try {
      if (userId.isNotEmpty) {
        final orderData = order.toJson();
        await _supabase
            .from('Orders')
            .insert(orderData)
            .timeout(const Duration(seconds: 5));
      }
    } catch (_) {
      // Saved in local storage safely
    }
  }

  /// Delete user order from local storage and Supabase
  Future<void> deleteOrder(String orderId) async {
    // 1. Remove from local storage
    final currentList = _loadFromLocalStorage();
    currentList.removeWhere((o) => o.id == orderId);
    _saveToLocalStorage(currentList);

    // 2. Remove from Supabase
    try {
      await _supabase
          .from('Orders')
          .delete()
          .eq('id', orderId)
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // Handled or offline
    }
  }
}
