import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{

  final _randomWordsList = <WordPair>[];
  final _favouriteWordsSet = Set<WordPair>();

  Widget _buildList(){
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          final index = item ~/ 2;
          if (index >= _randomWordsList.length){
            _randomWordsList.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordsList[index]);

        }

    );
  }

  Widget _buildRow(WordPair pair) {
    final isInFavourites = _favouriteWordsSet.contains(pair);

    return ListTile(title : Text(pair.asCamelCase, style : TextStyle(fontSize: 18.0)),
    trailing: Icon(isInFavourites  ? Icons.favorite : Icons.favorite_border,
                  color: isInFavourites ? Colors.red : null,),
                  onTap: (){
                      setState(() {
                        if (isInFavourites){
                          _favouriteWordsSet.remove(pair);
                        }else{
                          _favouriteWordsSet.add(pair);
                        }
                      });
                  },);
  }

  void _showFavourites(){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)
      {
        final Iterable<ListTile> tiles = _favouriteWordsSet.map((WordPair pair)
        {
          return ListTile(title: Text(pair.asCamelCase, style: TextStyle(fontSize: 18, color: Colors.green),));

        });

        final List<Widget> divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Favourites', style: TextStyle(fontSize: 18),),),
          body: ListView(children: divided),
        );

      }
      ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
          title: Text('Word pair gen'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed: _showFavourites)]
      ),
      body: _buildList(),

    );
  }

}
