import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher

const String apiKey = "AIzaSyAdew4XahUvC_V2PSNIFDz6BDq7aPs5V0o"; // Replace with your API key
const String baseUrl = "https://www.googleapis.com/youtube/v3/search";

class VideoSearchScreen extends StatefulWidget {
  @override
  _VideoSearchScreenState createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _videoResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchVideos(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final Uri url = Uri.parse(
        "$baseUrl?part=snippet&q=$query&type=video&maxResults=10&key=$apiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _videoResults = data['items'];
        });
      } else {
        setState(() {
          _errorMessage = "Error fetching videos. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleSearch() {
    String query = _controller.text.trim();
    if (query.isNotEmpty) {
      _searchVideos(query);
    } else {
      setState(() {
        _errorMessage = "Please enter a search term.";
      });
    }
  }

  void _openYouTube(String videoId) async {
    final url = "https://www.youtube.com/watch?v=$videoId";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not open $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CulinaryPlus")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search for a recipe (e.g., Cake)",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : _errorMessage != null
                    ? Text(_errorMessage!, style: TextStyle(color: Colors.red))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _videoResults.length,
                          itemBuilder: (context, index) {
                            var video = _videoResults[index];
                            var title = video['snippet']['title'];
                            var thumbnailUrl =
                                video['snippet']['thumbnails']['medium']['url'];
                            var videoId = video['id']['videoId'];

                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(thumbnailUrl),
                                    title: Text(title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    onTap: () {
                                      print("Selected Video ID: $videoId");
                                      // This can be used for next processing step
                                    },
                                  ),
                                  TextButton.icon(
                                    icon: Icon(Icons.video_library,
                                        color: Colors.red),
                                    label: Text("Watch on YouTube"),
                                    onPressed: () => _openYouTube(videoId),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
