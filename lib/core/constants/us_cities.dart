/// Cities the sign-up form offers, keyed by the state they are in.
///
/// The keys match [kUsStates] exactly — City is filtered by the chosen State,
/// so a mismatched key would leave that state with no cities at all.
///
/// ⚠️ This is a curated placeholder: roughly the ten to fifteen largest
/// places in each state, plus the capital. It is not exhaustive, so a family
/// in a smaller town will not find themselves here. Replace it with a
/// repository-provided list once the backend can serve one — `users.region`
/// was free text in v1, so there is no city table yet.
const kCitiesByState = <String, List<String>>{
  'Alabama': [
    'Auburn', 'Birmingham', 'Decatur', 'Dothan', 'Hoover', 'Huntsville',
    'Madison', 'Mobile', 'Montgomery', 'Tuscaloosa',
  ],
  'Alaska': [
    'Anchorage', 'Bethel', 'Fairbanks', 'Juneau', 'Kenai', 'Ketchikan',
    'Kodiak', 'Palmer', 'Sitka', 'Wasilla',
  ],
  'Arizona': [
    'Chandler', 'Flagstaff', 'Gilbert', 'Glendale', 'Mesa', 'Peoria',
    'Phoenix', 'Scottsdale', 'Surprise', 'Tempe', 'Tucson', 'Yuma',
  ],
  'Arkansas': [
    'Bentonville', 'Conway', 'Fayetteville', 'Fort Smith', 'Jonesboro',
    'Little Rock', 'North Little Rock', 'Pine Bluff', 'Rogers', 'Springdale',
  ],
  'California': [
    'Anaheim', 'Bakersfield', 'Chula Vista', 'Fresno', 'Irvine', 'Long Beach',
    'Los Angeles', 'Oakland', 'Riverside', 'Sacramento', 'San Diego',
    'San Francisco', 'San Jose', 'Santa Ana', 'Stockton',
  ],
  'Colorado': [
    'Arvada', 'Aurora', 'Boulder', 'Colorado Springs', 'Denver',
    'Fort Collins', 'Lakewood', 'Pueblo', 'Thornton', 'Westminster',
  ],
  'Connecticut': [
    'Bridgeport', 'Bristol', 'Danbury', 'Hartford', 'Meriden', 'New Britain',
    'New Haven', 'Norwalk', 'Stamford', 'Waterbury',
  ],
  'Delaware': [
    'Dover', 'Elsmere', 'Georgetown', 'Middletown', 'Milford', 'New Castle',
    'Newark', 'Seaford', 'Smyrna', 'Wilmington',
  ],
  'District of Columbia': ['Washington'],
  'Florida': [
    'Cape Coral', 'Fort Lauderdale', 'Gainesville', 'Hialeah', 'Hollywood',
    'Jacksonville', 'Miami', 'Orlando', 'Pembroke Pines', 'Port St. Lucie',
    'St. Petersburg', 'Tallahassee', 'Tampa',
  ],
  'Georgia': [
    'Alpharetta', 'Athens', 'Atlanta', 'Augusta', 'Columbus', 'Macon',
    'Marietta', 'Roswell', 'Sandy Springs', 'Savannah', 'Valdosta',
    'Warner Robins',
  ],
  'Hawaii': [
    'East Honolulu', 'Ewa Gentry', 'Hilo', 'Honolulu', 'Kahului', 'Kailua',
    'Kaneohe', 'Mililani Town', 'Pearl City', 'Waipahu',
  ],
  'Idaho': [
    'Boise', 'Caldwell', "Coeur d'Alene", 'Idaho Falls', 'Lewiston',
    'Meridian', 'Nampa', 'Pocatello', 'Post Falls', 'Twin Falls',
  ],
  'Illinois': [
    'Aurora', 'Bloomington', 'Champaign', 'Chicago', 'Cicero', 'Elgin',
    'Joliet', 'Naperville', 'Peoria', 'Rockford', 'Springfield', 'Waukegan',
  ],
  'Indiana': [
    'Bloomington', 'Carmel', 'Evansville', 'Fishers', 'Fort Wayne', 'Gary',
    'Hammond', 'Indianapolis', 'Lafayette', 'Muncie', 'South Bend',
    'Terre Haute',
  ],
  'Iowa': [
    'Ames', 'Cedar Rapids', 'Council Bluffs', 'Davenport', 'Des Moines',
    'Dubuque', 'Iowa City', 'Sioux City', 'Waterloo', 'West Des Moines',
  ],
  'Kansas': [
    'Kansas City', 'Lawrence', 'Lenexa', 'Manhattan', 'Olathe',
    'Overland Park', 'Salina', 'Shawnee', 'Topeka', 'Wichita',
  ],
  'Kentucky': [
    'Bowling Green', 'Covington', 'Elizabethtown', 'Florence', 'Frankfort',
    'Georgetown', 'Hopkinsville', 'Lexington', 'Louisville', 'Owensboro',
    'Richmond',
  ],
  'Louisiana': [
    'Alexandria', 'Baton Rouge', 'Bossier City', 'Houma', 'Kenner',
    'Lafayette', 'Lake Charles', 'Monroe', 'New Orleans', 'Shreveport',
  ],
  'Maine': [
    'Auburn', 'Augusta', 'Bangor', 'Biddeford', 'Lewiston', 'Portland',
    'Saco', 'Sanford', 'South Portland', 'Westbrook',
  ],
  'Maryland': [
    'Annapolis', 'Baltimore', 'Columbia', 'Dundalk', 'Ellicott City',
    'Frederick', 'Gaithersburg', 'Germantown', 'Glen Burnie', 'Rockville',
    'Silver Spring', 'Waldorf',
  ],
  'Massachusetts': [
    'Boston', 'Brockton', 'Cambridge', 'Fall River', 'Lowell', 'Lynn',
    'New Bedford', 'Newton', 'Quincy', 'Somerville', 'Springfield',
    'Worcester',
  ],
  'Michigan': [
    'Ann Arbor', 'Dearborn', 'Detroit', 'Flint', 'Grand Rapids', 'Kalamazoo',
    'Lansing', 'Livonia', 'Sterling Heights', 'Troy', 'Warren', 'Westland',
  ],
  'Minnesota': [
    'Bloomington', 'Brooklyn Park', 'Duluth', 'Eagan', 'Eden Prairie',
    'Maple Grove', 'Minneapolis', 'Plymouth', 'Rochester', 'Saint Paul',
    'St. Cloud', 'Woodbury',
  ],
  'Mississippi': [
    'Biloxi', 'Greenville', 'Gulfport', 'Hattiesburg', 'Horn Lake', 'Jackson',
    'Meridian', 'Olive Branch', 'Southaven', 'Tupelo',
  ],
  'Missouri': [
    'Blue Springs', 'Columbia', 'Independence', 'Jefferson City',
    'Kansas City', "Lee's Summit", "O'Fallon", 'Springfield', 'St. Charles',
    'St. Joseph', 'St. Louis',
  ],
  'Montana': [
    'Anaconda', 'Billings', 'Bozeman', 'Butte', 'Great Falls', 'Havre',
    'Helena', 'Kalispell', 'Miles City', 'Missoula',
  ],
  'Nebraska': [
    'Bellevue', 'Fremont', 'Grand Island', 'Hastings', 'Kearney', 'Lincoln',
    'Norfolk', 'North Platte', 'Omaha', 'Papillion',
  ],
  'Nevada': [
    'Boulder City', 'Carson City', 'Elko', 'Fernley', 'Henderson',
    'Las Vegas', 'Mesquite', 'North Las Vegas', 'Reno', 'Sparks',
  ],
  'New Hampshire': [
    'Concord', 'Derry', 'Dover', 'Keene', 'Londonderry', 'Manchester',
    'Merrimack', 'Nashua', 'Rochester', 'Salem',
  ],
  'New Jersey': [
    'Camden', 'Clifton', 'Edison', 'Elizabeth', 'Hamilton', 'Jersey City',
    'Lakewood', 'Newark', 'Paterson', 'Toms River', 'Trenton', 'Woodbridge',
  ],
  'New Mexico': [
    'Alamogordo', 'Albuquerque', 'Carlsbad', 'Clovis', 'Farmington', 'Hobbs',
    'Las Cruces', 'Rio Rancho', 'Roswell', 'Santa Fe',
  ],
  'New York': [
    'Albany', 'Buffalo', 'Mount Vernon', 'New Rochelle', 'New York',
    'Rochester', 'Schenectady', 'Syracuse', 'Troy', 'Utica', 'White Plains',
    'Yonkers',
  ],
  'North Carolina': [
    'Asheville', 'Cary', 'Charlotte', 'Concord', 'Durham', 'Fayetteville',
    'Greensboro', 'Greenville', 'High Point', 'Raleigh', 'Wilmington',
    'Winston-Salem',
  ],
  'North Dakota': [
    'Bismarck', 'Dickinson', 'Fargo', 'Grand Forks', 'Jamestown', 'Mandan',
    'Minot', 'Wahpeton', 'West Fargo', 'Williston',
  ],
  'Ohio': [
    'Akron', 'Canton', 'Cincinnati', 'Cleveland', 'Columbus', 'Dayton',
    'Hamilton', 'Lorain', 'Parma', 'Springfield', 'Toledo', 'Youngstown',
  ],
  'Oklahoma': [
    'Broken Arrow', 'Edmond', 'Enid', 'Lawton', 'Midwest City', 'Moore',
    'Norman', 'Oklahoma City', 'Stillwater', 'Tulsa',
  ],
  'Oregon': [
    'Bend', 'Beaverton', 'Corvallis', 'Eugene', 'Gresham', 'Hillsboro',
    'Medford', 'Portland', 'Salem', 'Springfield',
  ],
  'Pennsylvania': [
    'Allentown', 'Altoona', 'Bethlehem', 'Erie', 'Harrisburg', 'Lancaster',
    'Philadelphia', 'Pittsburgh', 'Reading', 'Scranton', 'State College',
    'York',
  ],
  'Rhode Island': [
    'Bristol', 'Central Falls', 'Cranston', 'East Providence', 'Newport',
    'Pawtucket', 'Providence', 'Warwick', 'Westerly', 'Woonsocket',
  ],
  'South Carolina': [
    'Charleston', 'Columbia', 'Goose Creek', 'Greenville', 'Mount Pleasant',
    'Myrtle Beach', 'North Charleston', 'Rock Hill', 'Summerville', 'Sumter',
  ],
  'South Dakota': [
    'Aberdeen', 'Brookings', 'Huron', 'Mitchell', 'Pierre', 'Rapid City',
    'Sioux Falls', 'Vermillion', 'Watertown', 'Yankton',
  ],
  'Tennessee': [
    'Bartlett', 'Chattanooga', 'Clarksville', 'Franklin', 'Hendersonville',
    'Jackson', 'Johnson City', 'Kingsport', 'Knoxville', 'Memphis',
    'Murfreesboro', 'Nashville',
  ],
  'Texas': [
    'Amarillo', 'Arlington', 'Austin', 'Brownsville', 'Corpus Christi',
    'Dallas', 'El Paso', 'Fort Worth', 'Garland', 'Houston', 'Irving',
    'Laredo', 'Lubbock', 'Plano', 'San Antonio',
  ],
  'Utah': [
    'Layton', 'Logan', 'Ogden', 'Orem', 'Provo', 'Salt Lake City', 'Sandy',
    'St. George', 'West Jordan', 'West Valley City',
  ],
  'Vermont': [
    'Barre', 'Burlington', 'Essex Junction', 'Montpelier', 'Newport',
    'Rutland', 'South Burlington', 'St. Albans', 'Vergennes', 'Winooski',
  ],
  'Virginia': [
    'Alexandria', 'Charlottesville', 'Chesapeake', 'Hampton', 'Lynchburg',
    'Newport News', 'Norfolk', 'Portsmouth', 'Richmond', 'Roanoke', 'Suffolk',
    'Virginia Beach',
  ],
  'Washington': [
    'Bellevue', 'Bellingham', 'Everett', 'Federal Way', 'Kent', 'Olympia',
    'Renton', 'Seattle', 'Spokane', 'Tacoma', 'Vancouver', 'Yakima',
  ],
  'West Virginia': [
    'Beckley', 'Charleston', 'Clarksburg', 'Fairmont', 'Huntington',
    'Martinsburg', 'Morgantown', 'Parkersburg', 'Weirton', 'Wheeling',
  ],
  'Wisconsin': [
    'Appleton', 'Eau Claire', 'Green Bay', 'Janesville', 'Kenosha',
    'La Crosse', 'Madison', 'Milwaukee', 'Oshkosh', 'Racine', 'Waukesha',
    'West Allis',
  ],
  'Wyoming': [
    'Casper', 'Cheyenne', 'Evanston', 'Gillette', 'Green River', 'Jackson',
    'Laramie', 'Riverton', 'Rock Springs', 'Sheridan',
  ],
};

/// The cities offered for [state], or an empty list when no state is chosen.
List<String> citiesIn(String? state) =>
    state == null ? const [] : kCitiesByState[state] ?? const [];
