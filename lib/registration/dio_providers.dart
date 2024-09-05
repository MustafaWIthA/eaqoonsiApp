import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProviders = Provider<Dio>((ref) => Dio());
