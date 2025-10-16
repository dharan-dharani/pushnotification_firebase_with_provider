
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification_items.dart';
import '../notification_provider.dart';

class EditScreen extends StatefulWidget {
  final NotificationItem item;
  const EditScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late bool _read;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _bodyController = TextEditingController(text: widget.item.body);
    _read = widget.item.read;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: _bodyController, decoration: const InputDecoration(labelText: 'Body')),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: _read, onChanged: (v) => setState(() => _read = v ?? false)),
                const Text('Read')
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await provider.updateNotification(widget.item.id, title: _titleController.text, body: _bodyController.text, read: _read);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}