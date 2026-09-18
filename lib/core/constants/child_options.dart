/// The two values `public.gender` accepts.
enum ChildGender {
  male('Male'),
  female('Female');

  const ChildGender(this.label);

  final String label;

  static ChildGender? fromLabel(String label) {
    for (final g in ChildGender.values) {
      if (g.label == label) return g;
    }
    return null;
  }

  /// What goes into the database column.
  String get value => name;
}

/// Shirt sizes, carried over from v1 — `children.shirt_size` is free text, so
/// this list is the only thing keeping the values consistent.
const kShirtSizes = <String>[
  'Youth Large',
  'Adult Small',
  'Adult Medium',
  'Adult Large',
  'Adult XL',
  'Adult XXL',
  'Adult XXXL',
];
