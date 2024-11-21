// import 'package:bloc/bloc.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:injectable/injectable.dart';
// import 'package:flutter_structure/core/services/firebase_notification.dart';

// part 'notification_state.dart';

// @injectable
// class NotificationCubit extends Cubit<NotificationState> {
//   final NotificationService _notificationService;
//   NotificationCubit()
//       : _notificationService = NotificationService(),
//         super(NotificationState());

//   // Initialize the notification service
//   Future<void> initializeNotifications() async {
//     await _notificationService.requestPermission();
//     _notificationService.getToken(); // Retrieve the token

//     // Listen for messages in foreground
//     _notificationService.listenToForegroundMessages((RemoteMessage message) {
//       final RemoteNotification? notification = message.notification;
//       if (notification != null) {
//         emit(NotificationState(
//           title: notification.title,
//           body: notification.body,
//         ));
//       }
//     });

//     // Handle background or terminated state notifications
//     _notificationService
//         .handleBackgroundAndTerminatedMessages((RemoteMessage message) {
//       final RemoteNotification? notification = message.notification;
//       if (notification != null) {
//         emit(NotificationState(
//           title: notification.title,
//           body: notification.body,
//         ));
//       }
//     });
//   }
// }
