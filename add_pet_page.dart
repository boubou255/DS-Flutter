import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('pets').add({
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'type': _typeController.text.trim(),
        'image_url': _imageUrlController.text.trim(),
        'description': _descriptionController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet added successfully!')),
      );

      Navigator.pop(context); // Go back after adding
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding pet: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _typeController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet for Adoption')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Pet Name'),
                validator: (value) => value!.isEmpty ? 'Enter pet name' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter age' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type (Dog, Cat, etc.)'),
                validator: (value) => value!.isEmpty ? 'Enter type' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPet,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
