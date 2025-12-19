  import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetupSchedulingPage extends StatefulWidget {
  final String? petId;
  final String? ownerId;

  const MeetupSchedulingPage({super.key, this.petId, this.ownerId});

  @override
  State<MeetupSchedulingPage> createState() => _MeetupSchedulingPageState();
}

class _MeetupSchedulingPageState extends State<MeetupSchedulingPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _scheduleMeetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('meetups').add({
        'petId': widget.petId,
        'ownerId': widget.ownerId,
        'date': _dateController.text,
        'time': _timeController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meetup scheduled successfully!')),
      );

      Navigator.pop(context); // Go back after scheduling
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scheduling meetup: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Meetup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Pet ID: ${widget.petId ?? "N/A"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Owner ID: ${widget.ownerId ?? "N/A"}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Enter a date' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                validator: (value) => value!.isEmpty ? 'Enter a time' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _scheduleMeetup,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Schedule Meetup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

