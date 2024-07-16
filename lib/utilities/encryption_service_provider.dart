import 'package:eaqoonsi/utilities/encryption_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final encryptionServiceProvider =
    Provider<EncryptionService>((ref) => EncryptionService());
