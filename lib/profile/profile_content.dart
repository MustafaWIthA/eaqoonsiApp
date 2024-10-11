import 'package:eaqoonsi/widget/app_export.dart';
import 'package:eaqoonsi/widget/text_theme.dart';

class ProfileContent extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cardResponseDTO = profile['cardResponseDTO'];
    final userStatus = profile['userStatus'];

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const AutoSizeText(
          'Digital ID Card',
          maxFontSize: 24,
          minFontSize: 16,
          style: TextStyle(
            color: kBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (cardResponseDTO != null && cardResponseDTO['mobileIDPdf'] != null)
          ClickablePDFPreview(
            base64Pdf: cardResponseDTO['mobileIDPdf'],
            height: 250,
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: EAqoonsiTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              userStatus == 'ACTIVE'
                  ? 'Digital ID card not available'
                  : 'Digital ID card is: $userStatus',
              textAlign: TextAlign.center,
              style: EAqoonsiTheme.of(context).bodyMedium,
            ),
          ),
        Container(
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
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SubmitButtonWidget(
                  backgroundColor: EAqoonsiTheme.of(context).primaryText,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ShowQrCode(),
                      ),
                    );
                  },
                  buttonText: 'Show QR Code',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                SubmitButtonWidget(
                  isEnabled: cardResponseDTO != null &&
                      cardResponseDTO['mobileIDPdf'] != null,
                  backgroundColor: kYellowColor,
                  textColor: kBlueColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => LandscapePDFViewer(
                                base64Pdf: cardResponseDTO['mobileIDPdf'],
                              )),
                    );
                  },
                  buttonText: 'View Card',
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        const AutoSizeText(
          'Useful Information',
          maxFontSize: 24,
          minFontSize: 16,
          style: TextStyle(
            color: kBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: InfoSlider(),
        ),
      ],
    );
  }
}
