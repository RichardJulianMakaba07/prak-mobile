/// Format tanggal sederhana tanpa package intl, contoh: "22 Sep 2026".
String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}
