String toLimitedLength(String string, int limit) {
  return string?.substring(0, string.length > limit ? limit : string.length);
}
