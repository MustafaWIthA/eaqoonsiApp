import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

class _SoMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _SoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'so' && locale.countryCode == 'SO';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = 'so_SO';

    return SynchronousFuture<MaterialLocalizations>(
      SoMaterialLocalizations(
        localeName: localeName,
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d', localeName),
        decimalFormat: intl.NumberFormat('#,##0.###', localeName),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', localeName),
      ),
    );
  }

  @override
  bool shouldReload(_SoMaterialLocalizationsDelegate old) => false;
}

class SoMaterialLocalizations extends GlobalMaterialLocalizations {
  const SoMaterialLocalizations({
    String localeName = 'so',
    required intl.DateFormat fullYearFormat,
    required intl.DateFormat compactDateFormat,
    required intl.DateFormat shortDateFormat,
    required intl.DateFormat mediumDateFormat,
    required intl.DateFormat longDateFormat,
    required intl.DateFormat yearMonthFormat,
    required intl.DateFormat shortMonthDayFormat,
    required intl.NumberFormat decimalFormat,
    required intl.NumberFormat twoDigitZeroPaddedFormat,
  }) : super(
          localeName: localeName,
          fullYearFormat: fullYearFormat,
          compactDateFormat: compactDateFormat,
          shortDateFormat: shortDateFormat,
          mediumDateFormat: mediumDateFormat,
          longDateFormat: longDateFormat,
          yearMonthFormat: yearMonthFormat,
          shortMonthDayFormat: shortMonthDayFormat,
          decimalFormat: decimalFormat,
          twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
        );

  @override
  String get moreButtonTooltip => 'Wax badan';

  @override
  String get aboutListTileTitleRaw => r'Ku saabsan $applicationName';

  @override
  String get alertDialogLabel => 'Digniin';

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get backButtonTooltip => 'Dib';

  @override
  String get cancelButtonLabel => 'JOOJI';

  @override
  String get closeButtonLabel => 'XIR';

  @override
  String get closeButtonTooltip => 'Xir';

  @override
  String get collapsedIconTapHint => 'Ballaari';

  @override
  String get continueButtonLabel => 'SII WAD';

  @override
  String get copyButtonLabel => 'KOOBIYEE';

  @override
  String get cutButtonLabel => 'JAR';

  @override
  String get deleteButtonTooltip => 'Tirtir';

  @override
  String get dialogLabel => 'Dialog';

  @override
  String get drawerLabel => 'Menu-ga socdaalka';

  @override
  String get expandedIconTapHint => 'Laali';

  @override
  String get firstPageTooltip => 'Bogga hore';

  @override
  String get hideAccountsLabel => 'Qari xisaabaadka';

  @override
  String get lastPageTooltip => 'Bogga dambe';

  @override
  String get licensesPageTitle => 'Laisansyo';

  @override
  String get modalBarrierDismissLabel => 'Xir';

  @override
  String get nextMonthTooltip => 'Bisha xigta';

  @override
  String get nextPageTooltip => 'Bogga xiga';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get openAppDrawerTooltip => 'Fur menu-ga socdaalka';

  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow ee $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow ee qiyaastii $rowCount';

  @override
  String get pasteButtonLabel => 'DHAJI';

  @override
  String get popupMenuLabel => 'Menu-ga soo-baxa';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get previousMonthTooltip => 'Bisha hore';

  @override
  String get previousPageTooltip => 'Bogga hore';

  @override
  String get refreshIndicatorSemanticLabel => 'Cusboonaysii';

  @override
  String get remainingTextFieldCharacterCountOne => '1 xaraf ayaa haray';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount xaraf ayaa haray';

  @override
  String get reorderItemDown => 'Hoos u soco';

  @override
  String get reorderItemLeft => 'Bidix u soco';

  @override
  String get reorderItemRight => 'Midig u soco';

  @override
  String get reorderItemToEnd => 'Gee dhammaadka';

  @override
  String get reorderItemToStart => 'Gee bilowga';

  @override
  String get reorderItemUp => 'Kor u soco';

  @override
  String get rowsPerPageTitle => 'Safaf halkii bog:';

  @override
  String get saveButtonLabel => 'KAYDI';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => 'Raadi';

  @override
  String get selectAllButtonLabel => 'DOORO DHAMAAN';

  @override
  String get selectYearSemanticsLabel => 'Dooro sanadka';

  @override
  String get selectedRowCountTitleOne => '1 shay ayaa la doortay';

  @override
  String get selectedRowCountTitleOther =>
      r'$selectedRowCount shay ayaa la doortay';

  @override
  String get showAccountsLabel => 'Tus xisaabaadka';

  @override
  String get showMenuTooltip => 'Tus menu-ga';

  @override
  String get signedInLabel => 'La soo galay';

  @override
  String get tabLabelRaw => r'Tab $tabIndex ee $tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => 'Dooro saacadaha';

  @override
  String get timePickerMinuteModeAnnouncement => 'Dooro daqiiqadaha';

  @override
  String get viewLicensesButtonLabel => 'ARAG LAISANSYADA';

  @override
  List<String> get narrowWeekdays =>
      const <String>['A', 'I', 'T', 'A', 'K', 'J', 'S'];

  @override
  int get firstDayOfWeekIndex => 0; // Sunday

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _SoMaterialLocalizationsDelegate();

  @override
  String get calendarModeButtonLabel => 'U bedel habka taariikhda';

  @override
  String get dateHelpText => 'bb/mm/ssss';

  @override
  String get dateInputLabel => 'Gali Taariikhda';

  @override
  String get dateOutOfRangeLabel =>
      'Waqtiga la codsaday waa mid aan la heli karin.';

  @override
  String get datePickerHelpText => 'DOORO TAARIIKHDA';

  @override
  String get dateRangeEndDateSemanticLabelRaw =>
      r'Taariikhda dhammaadka $fullDate';

  @override
  String get dateRangeEndLabel => 'Taariikhda Dhammaadka';

  @override
  String get dateRangePickerHelpText => 'DOORO MUDDADA';

  @override
  String get dateRangeStartDateSemanticLabelRaw =>
      r'Taariikhda bilowga $fullDate';

  @override
  String get dateRangeStartLabel => 'Taariikhda Bilowga';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'U bedel habka doorashada saacadda';

  @override
  String get inputDateModeButtonLabel => 'U bedel qoraalka';

  @override
  String get inputTimeModeButtonLabel => 'U bedel habka gelinta qoraalka';

  @override
  String get invalidDateFormatLabel => 'Qaab aan sax ahayn.';

  @override
  String get invalidDateRangeLabel => 'Muddo aan sax ahayn.';

  @override
  String get invalidTimeLabel => 'Geli waqti sax ah';

  @override
  String get licensesPackageDetailTextOther => r'$licenseCount laisans';

  @override
  String get timePickerDialHelpText => 'DOORO WAQTIGA';

  @override
  String get timePickerHourLabel => 'Saacad';

  @override
  String get timePickerInputHelpText => 'GELI WAQTIGA';

  @override
  String get timePickerMinuteLabel => 'Daqiiqad';

  @override
  String get unspecifiedDate => 'Taariikh';

  @override
  String get unspecifiedDateRange => 'Muddo';

  @override
  String get bottomSheetLabel => 'Warqadda hoose';

  @override
  String get collapsedHint => 'La ballaariyey';

  @override
  String get currentDateLabel => 'Maanta';

  @override
  String get expandedHint => 'La yareeyey';

  @override
  String get expansionTileCollapsedHint => 'Riix labo jeer si aad u ballaariso';

  @override
  String get expansionTileCollapsedTapHint =>
      'Ballaari si aad u hesho faahfaahin dheeraad ah';

  @override
  String get expansionTileExpandedHint => 'Riix labo jeer si aad u yarayso';

  @override
  String get expansionTileExpandedTapHint => 'Yaree';

  @override
  String get keyboardKeyAlt => 'Alt';

  @override
  String get keyboardKeyAltGraph => 'AltGr';

  @override
  String get keyboardKeyBackspace => 'Backspace';

  @override
  String get keyboardKeyCapsLock => 'Caps Lock';

  @override
  String get keyboardKeyChannelDown => 'Channel Hoos';

  @override
  String get keyboardKeyChannelUp => 'Channel Kor';

  @override
  String get keyboardKeyControl => 'Ctrl';

  @override
  String get keyboardKeyDelete => 'Delete';

  @override
  String get keyboardKeyEject => 'Eject';

  @override
  String get keyboardKeyEnd => 'End';

  @override
  String get keyboardKeyEscape => 'Escape';

  @override
  String get keyboardKeyFn => 'Fn';

  @override
  String get keyboardKeyHome => 'Home';

  @override
  String get keyboardKeyInsert => 'Insert';

  @override
  String get keyboardKeyMeta => 'Meta';

  @override
  String get keyboardKeyMetaMacOs => 'Command';

  @override
  String get keyboardKeyMetaWindows => 'Win';

  @override
  String get keyboardKeyNumLock => 'Num Lock';

  @override
  String get keyboardKeyNumpad0 => 'Num 0';

  @override
  String get keyboardKeyNumpad1 => 'Num 1';

  @override
  String get keyboardKeyNumpad2 => 'Num 2';

  @override
  String get keyboardKeyNumpad3 => 'Num 3';

  @override
  String get keyboardKeyNumpad4 => 'Num 4';

  @override
  String get keyboardKeyNumpad5 => 'Num 5';

  @override
  String get keyboardKeyNumpad6 => 'Num 6';

  @override
  String get keyboardKeyNumpad7 => 'Num 7';

  @override
  String get keyboardKeyNumpad8 => 'Num 8';

  @override
  String get keyboardKeyNumpad9 => 'Num 9';

  @override
  String get keyboardKeyNumpadAdd => 'Num +';

  @override
  String get keyboardKeyNumpadComma => 'Num ,';

  @override
  String get keyboardKeyNumpadDecimal => 'Num .';

  @override
  String get keyboardKeyNumpadDivide => 'Num /';

  @override
  String get keyboardKeyNumpadEnter => 'Num Enter';

  @override
  String get keyboardKeyNumpadEqual => 'Num =';

  @override
  String get keyboardKeyNumpadMultiply => 'Num *';

  @override
  String get keyboardKeyNumpadParenLeft => 'Num (';

  @override
  String get keyboardKeyNumpadParenRight => 'Num )';

  @override
  String get keyboardKeyNumpadSubtract => 'Num -';

  @override
  String get keyboardKeyPageDown => 'Page Down';

  @override
  String get keyboardKeyPageUp => 'Page Up';

  @override
  String get keyboardKeyPower => 'Power';

  @override
  String get keyboardKeyPowerOff => 'Power Off';

  @override
  String get keyboardKeyPrintScreen => 'Print Screen';

  @override
  String get keyboardKeyScrollLock => 'Scroll Lock';

  @override
  String get keyboardKeySelect => 'Select';

  @override
  String get keyboardKeyShift => 'Shift';

  @override
  String get keyboardKeySpace => 'Space';

  @override
  String get lookUpButtonLabel => 'Raadi';

  @override
  String get menuBarMenuLabel => 'Menu Bar Label';

  @override
  String get menuDismissLabel => 'Xir menu-ga';

  @override
  String get scanTextButtonLabel => 'koobi qoraalka';

  @override
  String get scrimLabel => 'Scrim';

  @override
  String get scrimOnTapHintRaw => r'Xir $modalRouteContentName';

  @override
  String get searchWebButtonLabel => 'Raadi internetka';

  @override
  String get shareButtonLabel => 'Wadaag';
}
