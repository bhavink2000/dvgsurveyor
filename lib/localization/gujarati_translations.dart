import 'package:get/get.dart';

class GujaratiTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'gu_IN': {
          'ownerName': 'માલીકનું નામ',
          'junagharNumber': 'જુનાગઢ નંબર',
          'kabjedarName': 'સ્થળ પરથી મળેલ કબજેદાર નું નામ',
          'address': 'સરનામું',
          'usageType': 'ભોગવટાનો પ્રકાર',
          'mobileNumber': 'મોબાઈલ નં',
          'propertyType': 'મિલકતનો પ્રકાર',
          //'propertyTypeResidential': 'રહેણાંક',
          //'property_type_non_residential': 'બિનરહેણાંક',
          //'property_type_public': 'સાર્વજનીક મિલ્કત',
          'propertyDescription': 'મિલકતનું વર્ણન',
          //'description_a': 'ખુલ્લો પ્લોટ, રહેણાંક',
          //'description_b': 'કો.ખુલ્લો પ્લોટ, પેટ્રોલપંપ, મોબાઈલ ટાવર, ઇન્ડસ્ટ્રીઝ, પાર્ટીપ્લોટ, બેંક, પ્રાઈવેટ સ્કુલ/કોલેજ, દુકાન, હોટેલ, ગોડાઉન, પ્રાઈવેટ હોસ્પીટલ',
          //'description_c': 'પંચાયત, સરકારી દવાખાનું, સરકારી શાળા, આંગણવાડી, મંદીર, મસ્જીદ',
          'waterConnectionNumber': 'પાણી જોડાણની સંખ્યા',
          'constructionYear': 'બાંધકામનું વર્ષ',
          'totalFloors': 'કુલ માળ',
        },
      };
}

class FormLabels {
  static const ownerName = 'ownerName';
  static const junagharNumber = 'junagharNumber';
  static const kabjedarName = 'kabjedarName';
  static const address = 'address';
  static const usageType = 'usageType';
  static const mobileNumber = 'mobileNumber';
  static const propertyType = 'propertyType';
  static const propertyDescription = 'propertyDescription';
  static const waterConnectionNumber = 'waterConnectionNumber';
  static const constructionYear = 'constructionYear';
  static const totalFloors = 'totalFloors';
}