import 'package:quiver/core.dart';

class EpubMetadataMeta {
  String? Name;
  String? Value;
  String? Id;
  String? Refines;
  String? Property;
  String? Scheme;
  Map<String, String>? Attributes;

  @override
  int get hashCode => hashObjects([Name.hashCode, Value.hashCode, Id.hashCode, Refines.hashCode, Property.hashCode, Scheme.hashCode]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataMeta?;
    if (otherAs == null) return false;
    return Name == otherAs.Name &&
        Value == otherAs.Value &&
        Id == otherAs.Id &&
        Refines == otherAs.Refines &&
        Property == otherAs.Property &&
        Scheme == otherAs.Scheme;
  }
}
