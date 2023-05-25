import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  static Future<Uint8List?> readBookCover(EpubBookRef bookRef) async {
    EpubManifestItem? coverManifestItem;

    final manifestItems = bookRef.Schema?.Package?.Manifest?.Items ?? [];
    coverManifestItem = manifestItems.firstWhereOrNull((element) => element.Properties == 'cover-image');

    EpubMetadataMeta? coverMetaItem;
    if (coverManifestItem == null) {
      var metaItems = bookRef.Schema!.Package!.Metadata!.MetaItems;
      if (metaItems == null || metaItems.isEmpty) {
        return null;
      }

      coverMetaItem = metaItems.firstWhereOrNull(
        (EpubMetadataMeta metaItem) => metaItem.Name != null && metaItem.Name!.toLowerCase() == 'cover',
      );

      if (coverMetaItem != null) {
        if (coverMetaItem.Value != null && coverMetaItem.Value!.isNotEmpty) {
          coverManifestItem = bookRef.Schema!.Package!.Manifest!.Items!.firstWhereOrNull(
            (EpubManifestItem manifestItem) => manifestItem.Id!.toLowerCase() == coverMetaItem!.Value!.toLowerCase(),
          );
        } else if (coverMetaItem.Content?.isNotEmpty == true) {
          coverManifestItem = manifestItems.firstWhereOrNull((e) => e.Id?.toLowerCase() == coverMetaItem?.Content?.toLowerCase());
        }
      }
    }

    if (coverManifestItem == null) {
      throw Exception('Incorrect EPUB manifest: item with ID = \"${coverMetaItem?.Value}\" is missing.');
    }

    EpubByteContentFileRef? coverImageContentFileRef;
    if (!bookRef.Content!.Images!.containsKey(coverManifestItem.Href)) {
      throw Exception('Incorrect EPUB manifest: item with href = \"${coverManifestItem.Href}\" is missing.');
    }

    coverImageContentFileRef = bookRef.Content!.Images![coverManifestItem.Href];
    var coverImageContent = await coverImageContentFileRef!.readContentAsBytes();
    return Uint8List.fromList(coverImageContent);
  }
}
