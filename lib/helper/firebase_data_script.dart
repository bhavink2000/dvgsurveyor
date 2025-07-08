// Future<void> createPropertyTypeCollection() async {
//     final now = FieldValue.serverTimestamp();
//     final collection = FirebaseFirestore.instance.collection('propertyType');

//     final data = [
//       {
//         'id': 'residential',
//         'name': 'રહેણાંક',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//       {
//         'id': 'nonResidential',
//         'name': 'બિનરહેણાંક',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//       {
//         'id': 'public',
//         'name': 'સાર્વજનીક મિલ્કત',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//     ];

//     for (var item in data) {
//       await collection.doc(item['id'].toString()).set(item);
//     }
//   }

//   Future<void> createPropertyDescriptions() async {
//     final now = FieldValue.serverTimestamp();
//     final descriptions = <Map<String, dynamic>>[];

//     // Residential
//     const residentialList = {
//       'open_plot': 'ખુલ્લો પ્લોટ',
//       'residential': 'રહેણાંક',
//     };

//     residentialList.forEach((id, name) {
//       descriptions.add({
//         'id': id,
//         'name': name,
//         'propertyTypeId': 'residential',
//         'isActive': true,
//         'createdAt': now,
//         'updatedAt': now,
//       });
//     });

//     // Non-Residential
//     const nonResidentialList = {
//       'co_open_plot': 'કો.ખુલ્લો પ્લોટ',
//       'petrol_pump': 'પેટ્રોલપંપ',
//       'mobile_tower': 'મોબાઈલ ટાવર',
//       'industries': 'ઇન્ડસ્ટ્રીઝ',
//       'party_plot': 'પાર્ટીપ્લોટ',
//       'bank': 'બેંક',
//       'private_school_college': 'પ્રાઈવેટ સ્કુલ/કોલેજ',
//       'shop': 'દુકાન',
//       'hotel': 'હોટેલ',
//       'godown': 'ગોડાઉન',
//       'private_hospital': 'પ્રાઈવેટ હોસ્પીટલ',
//     };

//     nonResidentialList.forEach((id, name) {
//       descriptions.add({
//         'id': id,
//         'name': name,
//         'propertyTypeId': 'nonResidential',
//         'isActive': true,
//         'createdAt': now,
//         'updatedAt': now,
//       });
//     });

//     // Public
//     const publicList = {
//       'panchayat': 'પંચાયત',
//       'govt_clinic': 'સરકારી દવાખાનું',
//       'govt_school': 'સરકારી શાળા',
//       'anganwadi': 'આંગણવાડી',
//       'temple': 'મંદીર',
//       'mosque': 'મસ્જીદ',
//     };

//     publicList.forEach((id, name) {
//       descriptions.add({
//         'id': id,
//         'name': name,
//         'propertyTypeId': 'public',
//         'isActive': true,
//         'createdAt': now,
//         'updatedAt': now,
//       });
//     });

//     final collection =
//         FirebaseFirestore.instance.collection('propertyDescription');

//     for (var desc in descriptions) {
//       await collection.doc(desc['id']).set(desc);
//     }

//     print("✅ Property descriptions added with English document IDs.");
//   }
// Future<void> createUsageTypeCollection() async {
//     final now = FieldValue.serverTimestamp();
//     final collection = FirebaseFirestore.instance.collection('usageType');

//     final data = [
//       {
//         'id': 'owner',
//         'name': 'માલિકી',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//       {
//         'id': 'rented',
//         'name': 'ભાડે પર આપવામાં આવેલ',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//       {
//         'id': 'both',
//         'name': 'બન્ને',
//         'createdAt': now,
//         'updatedAt': now,
//         'isActive': true,
//       },
//     ];

//     for (var item in data) {
//       await collection.doc(item['id'].toString()).set(item);
//     }

//     print("✅ usageType collection added to Firestore.");
//   }