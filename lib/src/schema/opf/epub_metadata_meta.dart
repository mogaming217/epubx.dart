import 'package:quiver/core.dart';

class EpubMetadataMeta {
  String? Name;

  /// xmlの値のこと<xml>{value}</xml>
  String? Value;

  String? Content;
  String? Id;
  String? Refines;
  String? Property;
  String? Scheme;
  Map<String, String>? Attributes;

  @override
  int get hashCode => hashObjects([
        Name.hashCode,
        Value.hashCode,
        Content.hashCode,
        Id.hashCode,
        Refines.hashCode,
        Property.hashCode,
        Scheme.hashCode,
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataMeta?;
    if (otherAs == null) return false;
    return Name == otherAs.Name &&
        Value == otherAs.Value &&
        Content == otherAs.Content &&
        Id == otherAs.Id &&
        Refines == otherAs.Refines &&
        Property == otherAs.Property &&
        Scheme == otherAs.Scheme;
  }
}
