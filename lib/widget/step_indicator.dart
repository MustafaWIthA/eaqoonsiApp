import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:eaqoonsi/widget/app_export.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isCurrentStep = index + 1 == currentStep;
          final isPastStep = index + 1 < currentStep;

          return Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentStep || isPastStep
                  ? EAqoonsiTheme.of(context).tertiary
                  : EAqoonsiTheme.of(context).secondaryBackground,
              border: Border.all(
                color: EAqoonsiTheme.of(context).tertiary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrentStep || isPastStep
                      ? EAqoonsiTheme.of(context).primaryBackground
                      : EAqoonsiTheme.of(context).tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
