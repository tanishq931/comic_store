import 'package:hive/hive.dart';

part 'Comic.g.dart';

@HiveType(typeId: 0,adapterName: 'ComicAdaptor')
class Comic {
  @HiveField(0)
  String author;

  @HiveField(1)
  String banner;

  @HiveField(2)
  List characters;

  @HiveField(3)
  String descEn;

  @HiveField(4)
  String descHi;

  @HiveField(5)
  String id;

  @HiveField(6)
  String language;

  @HiveField(7)
  int pages;

  @HiveField(8)
  String pdf;

  @HiveField(9)
  String publisher;

  @HiveField(10)
  num ratings;

  @HiveField(11)
  String title;

  Comic({
    required this.author,
    required this.banner,
    required this.characters,
    required this.descEn,
    required this.descHi,
    required this.id,
    required this.pages,
    required this.pdf,
    required this.publisher,
    required this.language,
    this.ratings = 0,
    required this.title,
  });

  factory Comic.fromSnapshot(
      Map<String, dynamic> data, String pdfPath, String banner) {
    return Comic(
        author: data['author'],
        banner: banner,
        characters: data['characters'],
        descEn: data['descEn'],
        descHi: data['descHi'],
        id: data['id'],
        pages: data['pages'],
        pdf: pdfPath,
        publisher: data['publisher'],
        title: data['title'],
        language: data['language'],
        ratings: data['ratings']);
  }

  factory Comic.copyComic(
      Comic comic, String pdfPath, String banner) {
    return Comic(
        author: comic.author,
        banner: banner,
        characters: comic.characters,
        descEn: comic.descEn,
        descHi: comic.descHi,
        id: comic.id,
        pages:comic.pages,
        pdf: pdfPath,
        publisher:comic.publisher,
        title: comic.title,
        language: comic.language,
        ratings:comic.ratings );
  }


  static List<Comic> getComicList(List list) {
    List<Comic> comics = [];
    for (var val in list) {
      comics.add(Comic.fromSnapshot(val.data(), val['pdf'], val['banner']));
    }
    return comics;
  }
}
