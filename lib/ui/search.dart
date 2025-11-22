import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/model/hike.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Hike> _searchResults = [];

  void _performSearch(String query) {
    // Dummy search logic
    setState(() {
      if (query.toLowerCase() == 'tot') {
        _searchResults = [
          Hike(id: 1, name: 'tot', location: 'Hanoi', date: '16/11/2025', parkingAvailable: true, length: 100.0, difficulty: 'Easy'),
        ];
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hikes'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Basic Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Search by name'),
              onChanged: _performSearch,
            ),
            ElevatedButton(
              onPressed: () { /* Search logic is already triggered by onChanged */ },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Search'),
            ),
            const Divider(height: 40),
            const Text('Advanced Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Hike Name *'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Location *'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Length (km) *'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Date (dd/MM/yyyy) *'),
            ),
            ElevatedButton(
              onPressed: () { /* TODO: Implement advanced search */ },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('ADVANCED SEARCH'),
            ),
            const SizedBox(height: 20),
            if (_searchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final hike = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(hike.name),
                      subtitle: Text('\${hike.location}\n\${hike.date}'),
                      trailing: ElevatedButton(
                        onPressed: () { /* TODO: Implement delete */ },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Delete Hike'),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
