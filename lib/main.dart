import 'package:flutter/material.dart';
import 'package:pertemuan4/api_service.dart';
import 'package:pertemuan4/article_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title : 'Berita',
      debugShowCheckedModeBanner: false,
      home: News() ,
    );
  }
}

class News extends StatefulWidget {
  const new({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late Future <List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = ApiService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Berita'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: _articlesFuture,
        builder: ((context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if(snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'),
            );
          } else if(snapshot.hasData) {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: article.urlToImage != null ? Image.network(
                      article.urlToImage!,
                      width: 80,
                      errorBuilder: (_, _, _) =>
                      const Icon(Icons.broken_image)
                    ): Icon(Icons.image),
                    title: Text(article.title),
                    subtitle: Text(article.description ?? "Tidak Ada deskripsi"),
                  ),
                );
              },
            );
          }else {
            return const Center(child: Text('Tidak ada berita yang ditemukan'),);
            
          }
        })
        ),
    );
  }
}