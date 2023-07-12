import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../utils/constants/app_constants.dart';

class CocApiConnector {
  static Dio get dio {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 1),
      baseUrl: dotenv.env[AppConstants.envCocBaseUrlKey]!,
      headers: {
        'Authorization':
            'Bearer ${dotenv.env[AppConstants.envCocAuthTokenKey]}',
        "Accept": "application/json",
        'Content-type': 'application/json',
      },
      responseType: ResponseType.json,
    );

    Dio dio = Dio(options);
    return dio;
  }
}
