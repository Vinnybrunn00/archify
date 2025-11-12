final imageExtensions = RegExp(
  r'\.(jpe?g|png|gif|bmp|webp|tiff?|svg|heic|heif)$',
  caseSensitive: false,
);

final pdfExtRegex = RegExp(r'\.pdf$', caseSensitive: false);

final videoExtRegex = RegExp(
  r'\.(mp4|m4v|mov|avi|wmv|flv|webm|mkv|3gp|mpeg|mpg|ogv)$',
  caseSensitive: false,
);

final textExtRegex = RegExp(
  r'\.(txt|md|rtf|log|csv|json|xml|yaml|yml)$',
  caseSensitive: false,
);

final audioExtRegex = RegExp(
  r'\.(mp3|wav|ogg|m4a|flac|aac|aiff?|wma|opus)$',
  caseSensitive: false,
);

final codeExtRegex = RegExp(
  r'\.(dart|js|jsx|ts|tsx|java|kt|kts|swift|m|h|cpp|cxx|cc|c|cs|php|rb|py|go|rs|scala|sh|bat|pl|lua|r|sql|html|htm|css|scss|sass|json|xml|yaml|yml|ini|toml|md)$',
  caseSensitive: false,
);

final wordExtRegex = RegExp(
  r'\.(doc|docx|dot|dotx|rtf)$',
  caseSensitive: false,
);

