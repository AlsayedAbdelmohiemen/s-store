import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/models/product_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Service dedicated to seeding and uploading product data to Supabase.
class ProductSeedingService {
  final SupabaseClient _supabase;

  ProductSeedingService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Upload dummy products to Supabase 'Products' table
  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      final list = products.map((e) => e.toJson()).toList();
      await _supabase.from('Products').upsert(list);
    } on PostgrestException catch (e) {
      if (e.message.toLowerCase().contains('relation') ||
          e.message.toLowerCase().contains('not exist') ||
          e.code == '42P01') {
        throw 'Table "Products" does not exist in Supabase yet. Please execute the SQL query in Supabase SQL Editor first.';
      }
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }
}
