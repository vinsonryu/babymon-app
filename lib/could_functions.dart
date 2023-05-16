// import 'package:babymon/data.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:librosa/librosa.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void initializeAdminApp() {
//   admin.initializeApp();
// }

// Future<void> processAudio(Change<StorageObject> object) async {
//   final fileBucket = object.bucket;
//   final filePath = object.name;

//   // Load and preprocess the audio data
//   final storage = FirebaseStorage.instance;
//   final file = storage.bucket(fileBucket).file(filePath);
//   final tempFilePath = '/tmp/$filePath'; // Temporary file path for processing
//   await file.downloadToFile(tempFilePath);

//   final audio = await librosa.load(tempFilePath, sr: 22050);
//   final mfccs = await librosa.feature.mfcc(audio[0], audio[1],
//       n_mfcc: 13, n_fft: 2048, hop_length: 512);

//   // Resize and expand dimensions of the preprocessed data
//   final resizedMfccs = np.resize(mfccs, [64, 64, 1]);
//   final expandedMfccs = np.expandDims(resizedMfccs, 0);

//   // Store the preprocessed data in Firestore
//   final db = admin.firestore();
//   final docRef = db.collection('preprocessedAudio').doc(filePath);
//   await docRef.set({'mfccs': expandedMfccs.tolist()});

//   // Delete the temporary file
//   await File(tempFilePath).delete();
// }


// Future<void> sendToTFLiteModel(
//     DocumentSnapshot<Map<String, dynamic>> snapshot, Context context) async {
//   // Get the preprocessed data from Firestore
//   final mfccs = snapshot.data()!['mfccs'];

//   // Convert the mfccs data to a format that can be input to the TFLite model
//   final inputData = mfccs.flat(); // Flatten the mfccs array

//   // Prepare the payload to send to the TFLite model
//   final payload = {'instances': [inputData]};

//   // Call the Firebase ML model API to send the payload to the TFLite model
//   final mlUrl =
//       'https://firebase.googleapis.com/v1/projects/${Firebase.app().options.projectId}/models/my_tflite_model:predict';
//   final response = await http.post(Uri.parse(mlUrl),
//       body: json.encode(payload),
//       headers: {
//         'Authorization': 'Bearer ${await getAccessToken()}',
//         'Content-Type': 'application/json'
//       });

//   // Process the response from the TFLite model
//   final predictions = json.decode(response.body)['predictions'];

//   // Do further processing with the predictions as needed

//   // Return a response to Firestore if needed
//   // e.g. return snapshot.ref.update({'predictions': predictions});
// }
