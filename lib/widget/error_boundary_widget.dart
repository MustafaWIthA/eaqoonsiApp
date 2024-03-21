import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorBoundaryWidget extends ConsumerWidget {
  final Widget child;

  const ErrorBoundaryWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    if (localizations != null) {
      return ErrorBoundary(
        localizations: localizations,
        child: child,
      );
    } else {
      // Fallback widget or error handling when localizations are not available
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Localizations not available')),
      );
    }
  }
}

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final AppLocalizations localizations;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.localizations,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      setState(() {
        hasError = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.localizations.errorTitle),
        ),
        body: Center(
          child: Text(widget.localizations.errorMessage),
        ),
      );
    }

    return widget.child;
  }
}
