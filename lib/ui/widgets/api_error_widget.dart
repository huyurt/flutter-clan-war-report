import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/locale_key.dart';

class ApiErrorWidget extends StatefulWidget {
  const ApiErrorWidget({
    super.key,
    this.onRefresh,
    this.errorMessage,
    this.isTimeout,
    this.error,
  });

  final Future<void> Function()? onRefresh;
  final String? errorMessage;
  final bool? isTimeout;
  final Object? error;

  @override
  State<ApiErrorWidget> createState() => _ApiErrorWidgetState();
}

class _ApiErrorWidgetState extends State<ApiErrorWidget> {
  @override
  Widget build(BuildContext context) {
    bool isTimeout = widget.isTimeout ?? false;
    if (widget.error is DioError) {
      DioError error = widget.error as DioError;
      if (error.type == DioExceptionType.connectionTimeout) {
        isTimeout = true;
      }
    }

    if (isTimeout) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              AkarIcons.circle_alert,
              size: 56.0,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                tr(LocaleKey.connectionError),
                style: const TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              tr(LocaleKey.connectionErrorDetail),
              textAlign: TextAlign.center,
            ),
            Visibility(
              visible: widget.onRefresh != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Colors.amber,
                  padding: const EdgeInsets.all(16.0),
                  onPressed: widget.onRefresh,
                  child: Text(
                    tr(LocaleKey.tryAgain),
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            AkarIcons.face_sad,
            size: 56.0,
            color: Colors.amber,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                widget.errorMessage ?? tr(LocaleKey.cocApiErrorMessage),
                style: const TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
