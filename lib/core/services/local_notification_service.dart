import 'dart:async';
import 'dart:developer';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:tasky_app/features/home/data/models/task.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  // 1.setup
  static onTap(NotificationResponse notificationResponse) {
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Create the notification channel for Android 8.0 and above
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'event_channel', // Match the channel ID used in scheduled notifications
      'Event Notifications', // Channel Name
      description: 'Notifications for upcoming events',
      importance: Importance.max, // Use max importance for better delivery
      playSound: true,
      enableVibration: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );

    // Create and register the notification channel for Android 8.0 and above
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Request permissions after initialization
    await requestPermissions();
  }

  // Request notification permissions (needed for Android 13+ and iOS)
  static Future<bool> requestPermissions() async {
    bool permissionGranted = true;

    // Request permissions for Android (API 33+)
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      permissionGranted = status.isGranted;
    }

    // For iOS, request permissions through flutter_local_notifications
    final iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Check if notifications are enabled using flutter_local_notifications
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final isEnabled = await androidImplementation.areNotificationsEnabled();
      if (isEnabled == false) {
        log('Notifications are disabled in system settings.');
        permissionGranted = false;
      }
    }

    return permissionGranted;
  }

  static void showBasicNotification({
    required String title,
    required String subtitle,
  }) async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription:
              'This channel is used for basic notifications with sound',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      subtitle,
      notificationDetails,
    );

    log('Notification displayed');
  }

  // static Future<int?> showScheduledNotification({
  //   required TaskModel task,
  // }) async {
  //   const notificationDetails = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'event_channel',
  //       'Event Notifications',
  //       channelDescription: 'Notifications for upcoming events',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       playSound: true,
  //       enableVibration: true,
  //     ),
  //     iOS: DarwinNotificationDetails(
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true,
  //     ),
  //   );
  //
  //   DateTime now = DateTime.now();
  //
  //   // Schedule notification 30 minutes before event
  //   const Duration offset = Duration(minutes: 30);
  //   final scheduledTime = task.dateTime.subtract(offset);
  //
  //   // Only schedule if the time is in the future
  //   if (scheduledTime.isAfter(now.add(const Duration(seconds: 1)))) {
  //     final id = task.hashCode;
  //
  //     try {
  //       // Try exact scheduling first
  //       await flutterLocalNotificationsPlugin.zonedSchedule(
  //         id,
  //         '⏰ ${task.name}',
  //         'Your event starts in 30 minutes',
  //         tz.TZDateTime.from(scheduledTime, tz.local),
  //         notificationDetails,
  //         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //         payload: 'event_30min_${task.hashCode}',
  //       );
  //
  //       log(
  //         'Scheduled exact notification for ${task.name} at $scheduledTime (30 minutes before)',
  //       );
  //       return id;
  //     } catch (e) {
  //       log('Exact scheduling failed: $e. Trying inexact scheduling...');
  //
  //       try {
  //         // Fallback to inexact scheduling
  //         await flutterLocalNotificationsPlugin.zonedSchedule(
  //           id,
  //           '⏰ ${task.name}',
  //           'Your event starts in 30 minutes',
  //           tz.TZDateTime.from(scheduledTime, tz.local),
  //           notificationDetails,
  //           androidScheduleMode: AndroidScheduleMode.inexact,
  //           payload: 'event_30min_${task.hashCode}',
  //         );
  //
  //         log(
  //           'Scheduled inexact notification for ${task.name} at $scheduledTime (30 minutes before)',
  //         );
  //         return id;
  //       } catch (e2) {
  //         log(
  //           'Error scheduling notification (both exact and inexact failed): $e2',
  //         );
  //         return null;
  //       }
  //     }
  //   } else {
  //     log(
  //       'Cannot schedule notification for ${task.name} - time is in the past',
  //     );
  //     return null;
  //   }
  // }

  static Future<int?> showScheduledNotification({
    required TaskModel task,
  }) async {
    log('=== Starting notification scheduling for: ${task.name} ===');

    // Get current timezone info
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(timeZoneName);

    DateTime now = DateTime.now();
    tz.TZDateTime _ = tz.TZDateTime.now(location);

    log('Current time: $now');
    log('Current timezone: $timeZoneName');
    log('Task dateTime: ${task.dateTime}');

    // Schedule notification 30 minutes before task
    const Duration offset = Duration(minutes: 30);
    final scheduledTime = task.dateTime.subtract(offset);

    log('Scheduled time (30 min before): $scheduledTime');
    log('Time difference from now: ${scheduledTime.difference(now)}');

    // Check if the scheduled time is in the future
    final isInFuture = scheduledTime.isAfter(
      now.add(const Duration(seconds: 5)),
    );
    log('Is scheduled time in future? $isInFuture');

    if (!isInFuture) {
      log(
        '❌ Cannot schedule notification for ${task.name} - time is in the past',
      );
      return null;
    }

    // Convert to TZDateTime properly
    final scheduledTimeTZ = tz.TZDateTime.from(scheduledTime, location);
    log('Scheduled TZDateTime: $scheduledTimeTZ');

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'event_channel',
        'Event Notifications',
        channelDescription: 'Notifications for upcoming events',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        showWhen: true,
        when: null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final id = task.hashCode;
    log('Using notification ID: $id');

    try {
      // First check if we have exact alarm permission
      bool hasExactAlarmPermission = true;

      if (await Permission.scheduleExactAlarm.isDenied) {
        log('⚠️ Exact alarm permission not granted, trying to request...');
        final status = await Permission.scheduleExactAlarm.request();
        hasExactAlarmPermission = status.isGranted;
        log('Exact alarm permission granted: $hasExactAlarmPermission');
      }

      AndroidScheduleMode scheduleMode = hasExactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact;

      log('Using schedule mode: $scheduleMode');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        '⏰ ${task.name}',
        'Your task starts in 30 minutes',
        scheduledTimeTZ,
        notificationDetails,
        androidScheduleMode: scheduleMode,
        payload: 'task_30min_${task.hashCode}',
        matchDateTimeComponents: null,
      );

      log('✅ Notification scheduled successfully for ${task.name}');

      // Verify the notification was scheduled
      await _verifyNotificationScheduled(id, task.name);

      return id;
    } catch (e) {
      log('❌ Error scheduling notification: $e');
      log('Error type: ${e.runtimeType}');

      // Try alternative approach - schedule with inexact mode
      try {
        log('Trying fallback with inexact scheduling...');

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id + 1000, // Different ID for fallback
          '⏰ ${task.name}',
          'Your task starts in 30 minutes (approximate time)',
          scheduledTimeTZ,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexact,
          payload: 'task_30min_fallback_${task.hashCode}',
        );

        log('✅ Fallback notification scheduled');
        return id + 1000;
      } catch (e2) {
        log('❌ Fallback scheduling also failed: $e2');
        return null;
      }
    }
  }

  // Helper method to verify notification was scheduled
  static Future<void> _verifyNotificationScheduled(
    int id,
    String taskName,
  ) async {
    try {
      final pending = await getPendingNotifications();
      final ourNotifications = pending
          .where((n) => n.id == id || n.id == id + 1000)
          .toList();

      log(
        'Verification: Found ${ourNotifications.length} pending notifications for task: $taskName',
      );

      for (var notification in ourNotifications) {
        log('- ID: ${notification.id}, Title: ${notification.title}');
      }

      if (ourNotifications.isEmpty) {
        log(
          '⚠️ Warning: Notification was scheduled but not found in pending list',
        );
      }
    } catch (e) {
      log('Error verifying notification: $e');
    }
  }

  // Add this helper method for testing
  static Future<void> scheduleTestNotification() async {
    log('=== Scheduling test notification (1 minute from now) ===');

    final testTask = TaskModel(
      name: 'Test Task',
      dateTime: DateTime.now().add(const Duration(minutes: 31)),
      priority: 1, // 31 min so notification shows in 1 min
      // Add other required TaskModel fields here
    );

    final result = await showScheduledNotification(task: testTask);

    if (result != null) {
      log('✅ Test notification scheduled with ID: $result');
    } else {
      log('❌ Failed to schedule test notification');
    }

    // Show all pending notifications
    await debugAllPendingNotifications();
  }

  // Debug method to show all pending notifications
  static Future<void> debugAllPendingNotifications() async {
    final pending = await getPendingNotifications();

    log('=== ALL PENDING NOTIFICATIONS ===');
    log('Total: ${pending.length}');

    if (pending.isEmpty) {
      log('No pending notifications found');
      return;
    }

    for (var notification in pending) {
      log('ID: ${notification.id}');
      log('Title: ${notification.title}');
      log('Body: ${notification.body}');
      log('Payload: ${notification.payload}');
      log('---');
    }
  }

  static Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    log('Cancelled notification with ID: $id');
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    log('Cancelled all notifications');
  }

  // Get all pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      return await androidImplementation.areNotificationsEnabled() ?? false;
    }

    return true; // Assume enabled for iOS
  }
}
