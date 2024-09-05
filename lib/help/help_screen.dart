import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eaqoonsi/constants.dart';
import 'package:eaqoonsi/widget/bottom_nav_bar.dart';
import 'package:eaqoonsi/widget/text_theme.dart';
import 'package:eaqoonsi/widget/e_aqoonsi_button_widgets.dart';

final feedbackFormProvider =
    StateNotifierProvider<FeedbackFormNotifier, FeedbackFormState>(
        (ref) => FeedbackFormNotifier());

class FeedbackFormState {
  final String? category;
  final String description;

  FeedbackFormState({this.category, this.description = ''});

  FeedbackFormState copyWith({String? category, String? description}) {
    return FeedbackFormState(
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}

class FeedbackFormNotifier extends StateNotifier<FeedbackFormState> {
  FeedbackFormNotifier() : super(FeedbackFormState());

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  Future<void> submitFeedback() async {
    // Reset the form after submission
    state = FeedbackFormState();
  }
}

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final feedbackForm = ref.watch(feedbackFormProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Help & Feedback', style: TextStyle(color: kWhiteColor)),
        backgroundColor: kBlueColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: kBlueColor,
              padding: const EdgeInsets.all(24),
              child: Text(
                'We\'re here to help',
                style: EAqoonsiTheme.of(context).headlineMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: kWhiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a category:',
                    style: EAqoonsiTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 16),
                  categoryDropdown(ref),
                  const SizedBox(height: 24),
                  Text(
                    'Describe your issue:',
                    style: EAqoonsiTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 16),
                  descriptionField(ref),
                  const SizedBox(height: 32),
                  submitButton(context, ref),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget categoryDropdown(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBlueColor.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ref.watch(feedbackFormProvider).category,
          hint: const Text('Select a category'),
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: null, child: Text('Select a category')),
            DropdownMenuItem(value: 'OTP Issues', child: Text('OTP Issues')),
            DropdownMenuItem(
                value: 'Password Problems', child: Text('Password Problems')),
            DropdownMenuItem(
                value: 'ID Verification', child: Text('ID Verification')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (newValue) {
            ref.read(feedbackFormProvider.notifier).setCategory(newValue);
          },
        ),
      ),
    );
  }

  Widget descriptionField(WidgetRef ref) {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Please provide details about your issue...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kBlueColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBlueColor),
        ),
      ),
      onChanged: (value) {
        ref.read(feedbackFormProvider.notifier).setDescription(value);
        //clear the text field
      },
    );
  }

  Widget submitButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: EaqoonsiButtonWidget(
        onPressed: () async {
          if (ref.read(feedbackFormProvider).category == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a category'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          await ref.read(feedbackFormProvider.notifier).submitFeedback();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text('Thank you for your feedback!',
                    style: TextStyle(color: Colors.black)),
              ),
              backgroundColor: kYellowColor,
            ),
          );
        },
        text: 'Submit Feedback',
        options: EaqoonsiButtonOptions(
          width: double.infinity,
          height: 50,
          color: kBlueColor,
          textStyle: EAqoonsiTheme.of(context).titleSmall.override(
                fontFamily: 'Plus Jakarta Sans',
                color: kWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
