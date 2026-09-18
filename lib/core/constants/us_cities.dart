/// Placeholder city list.
///
/// The design makes City a dropdown, but there is no city source in the
/// backend yet — `users.region` was free text in v1. These are real US cities
/// so the form is usable today; swap this for a repository-provided list
/// (ideally filtered by the chosen state) once the backend exposes one.
const kUsCities = <String>[
  'Albuquerque', 'Atlanta', 'Austin', 'Baltimore', 'Boston', 'Charlotte',
  'Chicago', 'Colorado Springs', 'Columbus', 'Dallas', 'Denver', 'Detroit',
  'El Paso', 'Fort Worth', 'Fresno', 'Houston', 'Indianapolis',
  'Jacksonville', 'Kansas City', 'Las Vegas', 'Long Beach', 'Los Angeles',
  'Louisville', 'Memphis', 'Mesa', 'Miami', 'Milwaukee', 'Minneapolis',
  'Nashville', 'New Orleans', 'New York', 'Oakland', 'Oklahoma City', 'Omaha',
  'Philadelphia', 'Phoenix', 'Portland', 'Raleigh', 'Sacramento',
  'San Antonio', 'San Diego', 'San Francisco', 'San Jose', 'Seattle',
  'Tampa', 'Tucson', 'Tulsa', 'Virginia Beach', 'Washington', 'Wichita',
];
