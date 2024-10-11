import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class InfoSlider extends StatefulWidget {
  InfoSlider({super.key});

  final List<Map<String, String>> items = [
    {
      'title': 'Digital Credential',
      'description':
          'eAqoonsi provides a verifiable, legal identification credential with the same weight as the National ID card.',
    },
    {
      'title': 'Online & Offline Use',
      'description':
          'Use your digital ID for both online and offline identification needs across various services.',
    },
    {
      'title': 'Secure System',
      'description':
          'eAqoonsi ensures secure online registration using facial recognition, basic information, and OTP verification. Access your account safely with username and password, and utilize QR codes for easy verification.',
    },
  ];

  @override
  State<InfoSlider> createState() => _InfoSliderState();
}

class _InfoSliderState extends State<InfoSlider> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: EAqoonsiTheme.of(context).primaryBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.items[index]['title']!,
                    style: EAqoonsiTheme.of(context).titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.items[index]['description']!,
                    style: EAqoonsiTheme.of(context).bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? EAqoonsiTheme.of(context).primary
                      : EAqoonsiTheme.of(context).secondaryText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
