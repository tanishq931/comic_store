// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComicAdaptor extends TypeAdapter<Comic> {
  @override
  final int typeId = 0;

  @override
  Comic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comic(
      author: fields[0] as String,
      banner: fields[1] as String,
      characters: (fields[2] as List).cast<dynamic>(),
      descEn: fields[3] as String,
      descHi: fields[4] as String,
      id: fields[5] as String,
      pages: fields[7] as int,
      pdf: fields[8] as String,
      publisher: fields[9] as String,
      language: fields[6] as String,
      ratings: fields[10] as num,
      title: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Comic obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.banner)
      ..writeByte(2)
      ..write(obj.characters)
      ..writeByte(3)
      ..write(obj.descEn)
      ..writeByte(4)
      ..write(obj.descHi)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.language)
      ..writeByte(7)
      ..write(obj.pages)
      ..writeByte(8)
      ..write(obj.pdf)
      ..writeByte(9)
      ..write(obj.publisher)
      ..writeByte(10)
      ..write(obj.ratings)
      ..writeByte(11)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComicAdaptor &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
