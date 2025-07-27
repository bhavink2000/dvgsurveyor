import 'package:get/get.dart';

class GujaratiTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'gu_IN': {
          FormLabels.ownerName: 'માલીકનું નામ',
          FormLabels.junagharNumber: 'જૂના ઘર નંબર',
          FormLabels.kabjedarName: 'સ્થળ પરથી મળેલ કબજેદાર નું નામ',
          FormLabels.address: 'સરનામું',
          FormLabels.usageType: 'ભોગવટાનો પ્રકાર',
          FormLabels.mobileNumber: 'મોબાઈલ નં',
          FormLabels.propertyType: 'મિલકતનો પ્રકાર',
          FormLabels.propertyDescription: 'મિલકતનું વર્ણન',
          FormLabels.waterConnectionNumber: 'પાણી જોડાણની સંખ્યા',
          FormLabels.constructionYear: 'બાંધકામનું વર્ષ',
          FormLabels.totalFloors: 'કુલ માળ',
          FormLabels.slab: 'સ્લેબ',
          FormLabels.papda: 'પાપડા',
          FormLabels.patara: 'પતરા',
          FormLabels.nadiya: 'નળીયા',
          FormLabels.khulu: 'ખુલ્લુ',
          FormLabels.surveyNumber: 'સરવે નંબર',
          FormLabels.remarks: 'ટિપ્પણીઓ',
          FormLabels.daban: 'દબાણ',

          // Optional: Additional translations (uncomment and use as needed)
          // 'propertyTypeResidential': 'રહેણાંક',
          // 'property_type_non_residential': 'બિનરહેણાંક',
          // 'property_type_public': 'સાર્વજનિક મિલ્કત',
          // 'description_a': 'ખુલ્લો પ્લોટ, રહેણાંક',
          // 'description_b': 'કો.ખુલ્લો પ્લોટ, પેટ્રોલપંપ, મોબાઈલ ટાવર, ઇન્ડસ્ટ્રીઝ, પાર્ટીપ્લોટ, બેંક, પ્રાઈવેટ સ્કુલ/કોલેજ, દુકાન, હોટેલ, ગોડાઉન, પ્રાઈવેટ હોસ્પીટલ',
          // 'description_c': 'પંચાયત, સરકારી દવાખાનું, સરકારી શાળા, આંગણવાડી, મંદીર, મસ્જીદ',
        },
      };
}

class FormLabels {
  static const String ownerName = 'ownerName';
  static const String junagharNumber = 'junagharNumber';
  static const String kabjedarName = 'kabjedarName';
  static const String address = 'address';
  static const String usageType = 'usageType';
  static const String mobileNumber = 'mobileNumber';
  static const String propertyType = 'propertyType';
  static const String propertyDescription = 'propertyDescription';
  static const String waterConnectionNumber = 'waterConnectionNumber';
  static const String constructionYear = 'constructionYear';
  static const String totalFloors = 'totalFloors';
  static const String slab = 'slab';
  static const String papda = 'papda';
  static const String patara = 'patara';
  static const String nadiya = 'nadiya';
  static const String khulu = 'khulu';
  static const String surveyNumber = 'surveyNumber';
  static const String remarks = 'remarks';
  static const String daban = 'daban';
}
