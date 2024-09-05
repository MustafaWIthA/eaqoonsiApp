import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:eaqoonsi/constants.dart';

class DigitalIDCard extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const DigitalIDCard({super.key, required this.profileData});

  @override
  State<DigitalIDCard> createState() => _DigitalIDCardState();
}

class _DigitalIDCardState extends State<DigitalIDCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.profileData['userStatus'] != 'ACTIVE' ||
        widget.profileData['cardResponseDTO'] == null) {
      return Container(
        decoration: BoxDecoration(
          color: kBlueColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text(
            'Digital ID Card is in progress',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );

      // const Center(
      //   child: Text(
      //     'Digital ID not available',
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      // );
    }
    final cardData = widget.profileData['cardResponseDTO'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(cardData),
          _buildBody(cardData),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> cardData) {
    return ClipRRect(
      // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kBlueColor, kBlueColor.withOpacity(0.7)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Image.asset(
                logoWhite,
                height: 60,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'profilePhoto',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              MemoryImage(base64Decode(cardData['photograph'])),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cardData['idNumber'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black26,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AutoSizeText(
                      maxLines: 1,
                      cardData['fullName'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> cardData) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kBlueColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.cake, 'Date of Birth', cardData['dateOfBirth']),
          _buildInfoRow(Icons.flag, 'Nationality', cardData['nationality']),
          _buildInfoRow(
              Icons.calendar_today, 'Issue Date', cardData['issueDate']),
          _buildInfoRow(Icons.event, 'Expiry Date',
              _calculateExpiryDate(cardData['issueDate'])),
          _buildInfoRow(Icons.home, 'Address', cardData['permanentAddress']),
        ],
      ),
    );
  }

  String _calculateExpiryDate(String issueDate) {
    List<String> dateParts = issueDate.split('-');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    DateTime parsedDate = DateTime(year, month, day);
    DateTime expiryDate =
        DateTime(parsedDate.year + 10, parsedDate.month, parsedDate.day);
    return '${expiryDate.day.toString().padLeft(2, '0')}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.year}';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kBlueColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: kBlueColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
