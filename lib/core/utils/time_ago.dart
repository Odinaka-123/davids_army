String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return "now";
  if (diff.inMinutes < 60) return "${diff.inMinutes}m";
  if (diff.inHours < 24) return "${diff.inHours}h";
  if (diff.inDays < 7) return "${diff.inDays}d";
  return "${(diff.inDays / 7).floor()}w";
}
