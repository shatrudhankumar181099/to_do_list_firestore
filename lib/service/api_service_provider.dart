import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/exports.dart';
import 'api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final titleNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final descNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final updateTitleNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final updateDescNameControllerProvider = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

