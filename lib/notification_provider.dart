import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification_firebase_with_provider/models/notification_items.dart';

class NotificationProvider extends ChangeNotifier{
  final CollectionReference _collection = FirebaseFirestore.instance.collection('notification');
  List<NotificationItem> _notifications=[];
  List<NotificationItem> get notifications=>_notifications;
  
}