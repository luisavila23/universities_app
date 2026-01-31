class University {
  final String id; 
  final String name;
  final String country;
  final String alphaTwoCode;
  final String? stateProvince;
  final List<String> domains;
  final List<String> webPages;

  const University({
    required this.id,
    required this.name,
    required this.country,
    required this.alphaTwoCode,
    required this.stateProvince,
    required this.domains,
    required this.webPages,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();
    final country = (json['country'] ?? '').toString();
    final domains = (json['domains'] as List? ?? []).map((e) => e.toString()).toList();

    final id = '${name.trim()}|${country.trim()}|${domains.isNotEmpty ? domains.first : ''}';

    return University(
      id: id,
      name: name,
      country: country,
      alphaTwoCode: (json['alpha_two_code'] ?? '').toString(),
      stateProvince: json['state-province']?.toString(),
      domains: domains,
      webPages: (json['web_pages'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
