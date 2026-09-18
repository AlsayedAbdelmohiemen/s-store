import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/shop/models/banner_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Get all active banners from Supabase Cloud
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final response = await _supabase
          .from('Banners')
          .select()
          .eq('Active', true);

      final list = (response as List<dynamic>)
          .map((banner) => BannerModel.fromJson(banner as Map<String, dynamic>))
          .toList();

      return list;
    } on PostgrestException catch (_) {
      return [];
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      return [];
    }
  }

  /// Upload dummy banners to Supabase
  Future<void> uploadDummyData(List<BannerModel> banners) async {
    try {
      final list = banners.map((b) => b.toJson()).toList();
      await _supabase.from('Banners').upsert(list);
    } on PostgrestException catch (e) {
      if (e.message.toLowerCase().contains('relation') ||
          e.message.toLowerCase().contains('not exist') ||
          e.code == '42P01') {
        throw 'Table "Banners" does not exist in Supabase yet. Please execute the SQL query in Supabase SQL Editor first.';
      }
      throw e.message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }
}
