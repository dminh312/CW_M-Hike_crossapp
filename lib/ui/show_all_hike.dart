import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/database/app_database.dart';
import 'package:m_hike_cross_app/model/hike.dart';
import 'package:m_hike_cross_app/ui/add_hike.dart';
import 'package:m_hike_cross_app/ui/hike_details.dart';
import 'package:m_hike_cross_app/ui/main_screen.dart';

class ShowAllHikeScreen extends StatefulWidget {
  const ShowAllHikeScreen({super.key});

  @override
  State<ShowAllHikeScreen> createState() => _ShowAllHikeScreenState();
}

class _ShowAllHikeScreenState extends State<ShowAllHikeScreen> {
  List<Hike> _hikes = [];
  List<Hike> _filteredHikes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshHikes();
    _searchController.addListener(_filterHikes);
  }

  Future<void> _refreshHikes() async {
    final hikes = await DatabaseHelper.instance.getAllHikes();
    setState(() {
      _hikes = hikes;
      _filteredHikes = hikes;
    });
  }

  void _filterHikes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHikes = _hikes.where((hike) {
        return hike.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _clearAllData() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete all hikes?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await DatabaseHelper.instance.deleteAllHikes();
                _refreshHikes();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Hikes'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: _clearAllData,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredHikes.length,
              itemBuilder: (context, index) {
                final hike = _filteredHikes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(hike.name),
                    subtitle: Text('${hike.location}\n${hike.date}'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteHike(hike.id!);
                        _refreshHikes();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(10.0)),
                      child: const Text('DELETE HIKE'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HikeDetailsScreen(hike: hike, onDelete: () async {
                          await DatabaseHelper.instance.deleteHike(hike.id!);
                          _refreshHikes();
                        })),
                      ).then((_) => _refreshHikes());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHikeScreen()),
          ).then((_) => _refreshHikes());
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
