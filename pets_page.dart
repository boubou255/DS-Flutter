import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Listing"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pets by name or type',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          // Filter pets by search query
          final pets = snapshot.data!.docs.where((doc) {
            final data = doc.data();
            final name = (data['name'] ?? '').toString().toLowerCase();
            final type = (data['type'] ?? '').toString().toLowerCase();
            return name.contains(_searchQuery) || type.contains(_searchQuery);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // trigger rebuild to refresh stream
            },
            child: pets.isEmpty
                ? const Center(child: Text('No pets found'))
                : ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index].data();
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: pet['image_url'] != null && pet['image_url'].isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    pet['image_url'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset('assets/images/pet_placeholder.png',
                                            width: 60, height: 60),
                                  ),
                                )
                              : Image.asset('assets/images/pet_placeholder.png',
                                  width: 60, height: 60),
                          title: Text(pet['name'] ?? 'No name'),
                          subtitle: Text(
                              "${pet['type'] ?? 'Unknown'}, Age: ${pet['age'] ?? '?'} years"),
                          onTap: () {
                            Navigator.pushNamed(context, '/pet_details', arguments: pets[index].id);
                          },
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_pet'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
