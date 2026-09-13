import '../models/models.dart';

export 'seed_products.dart';

/// Master data: categories, products, brands and locations for the demo.
/// Admin can edit all of it; nothing here is hard-coded business logic.

const seedCategories = <ServiceCategory>[
  ServiceCategory(
    id: 'cat_cctv',
    name: 'CCTV & Security',
    icon: 'cctv',
    description: 'Cameras, video door phones and access control',
    questions: [
      QualificationQuestion(
          id: 'cameras', label: 'Number of cameras', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'placement',
          label: 'Indoor or outdoor',
          type: QuestionType.choice,
          options: ['Indoor', 'Outdoor', 'Both'],
          required: true),
      QualificationQuestion(
          id: 'site',
          label: 'Site type',
          type: QuestionType.choice,
          options: ['Home', 'Shop', 'Office', 'Factory']),
      QualificationQuestion(
          id: 'recording',
          label: 'Recording days needed',
          type: QuestionType.choice,
          options: ['7 days', '15 days', '30 days']),
      QualificationQuestion(
          id: 'install', label: 'Installation needed', type: QuestionType.yesNo),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
      QualificationQuestion(id: 'date', label: 'Required by', type: QuestionType.date),
    ],
  ),
  ServiceCategory(
    id: 'cat_ac',
    name: 'Air Conditioners',
    icon: 'ac',
    description: 'Sales, installation and service',
    questions: [
      QualificationQuestion(
          id: 'units', label: 'Number of ACs', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'tonnage',
          label: 'Capacity',
          type: QuestionType.choice,
          options: ['1 ton', '1.5 ton', '2 ton', 'Not sure']),
      QualificationQuestion(
          id: 'type',
          label: 'AC type',
          type: QuestionType.choice,
          options: ['Split', 'Window', 'Cassette']),
      QualificationQuestion(
          id: 'install', label: 'Installation needed', type: QuestionType.yesNo),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
      QualificationQuestion(id: 'date', label: 'Required by', type: QuestionType.date),
    ],
  ),
  ServiceCategory(
    id: 'cat_solar',
    name: 'Solar Power',
    icon: 'solar',
    description: 'Rooftop solar and solar water heaters',
    questions: [
      QualificationQuestion(
          id: 'bill', label: 'Monthly electricity bill (₹)', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'roof', label: 'Roof area (sq ft)', type: QuestionType.number),
      QualificationQuestion(
          id: 'roofType',
          label: 'Roof type',
          type: QuestionType.choice,
          options: ['Concrete', 'Metal sheet', 'Tiled']),
      QualificationQuestion(
          id: 'grid',
          label: 'System type',
          type: QuestionType.choice,
          options: ['On-grid', 'Off-grid', 'Hybrid', 'Not sure']),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
  ServiceCategory(
    id: 'cat_interior',
    name: 'Home Interiors',
    icon: 'interior',
    description: 'Kitchens, wardrobes and full-home interiors',
    questions: [
      QualificationQuestion(
          id: 'sqft', label: 'Area (sq ft)', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'home',
          label: 'Home size',
          type: QuestionType.choice,
          options: ['1 BHK', '2 BHK', '3 BHK', 'Villa']),
      QualificationQuestion(
          id: 'scope',
          label: 'Work needed',
          type: QuestionType.choice,
          options: ['Kitchen', 'Wardrobes', 'Full home']),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
      QualificationQuestion(id: 'date', label: 'Start date', type: QuestionType.date),
    ],
  ),
  ServiceCategory(
    id: 'cat_tiles',
    name: 'Tiles & Flooring',
    icon: 'tiles',
    description: 'Floor tiles, wall tiles, granite and marble',
    questions: [
      QualificationQuestion(
          id: 'sqft', label: 'Area (sq ft)', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'finish',
          label: 'Finish',
          type: QuestionType.choice,
          options: ['Glossy', 'Matte', 'Wooden look']),
      QualificationQuestion(
          id: 'laying', label: 'Laying work needed', type: QuestionType.yesNo),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
  ServiceCategory(
    id: 'cat_jewellery',
    name: 'Jewellery',
    icon: 'jewellery',
    description: 'Gold, diamond and silver jewellery',
    questions: [
      QualificationQuestion(
          id: 'occasion',
          label: 'Occasion',
          type: QuestionType.choice,
          options: ['Wedding', 'Festival', 'Gift', 'Other'],
          required: true),
      QualificationQuestion(
          id: 'metal',
          label: 'Metal',
          type: QuestionType.choice,
          options: ['Gold', 'Diamond', 'Silver']),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
      QualificationQuestion(id: 'date', label: 'Shop visit date', type: QuestionType.date),
    ],
  ),
  ServiceCategory(
    id: 'cat_pooja',
    name: 'Pooja & Events',
    icon: 'pooja',
    description: 'Priests, homams and event services',
    questions: [
      QualificationQuestion(
          id: 'event',
          label: 'Event',
          type: QuestionType.choice,
          options: ['Griha pravesam', 'Ganapathi homam', 'Wedding', 'Other'],
          required: true),
      QualificationQuestion(
          id: 'people', label: 'Number of people', type: QuestionType.number),
      QualificationQuestion(id: 'date', label: 'Event date', type: QuestionType.date),
      QualificationQuestion(id: 'venue', label: 'Venue details', type: QuestionType.text),
    ],
  ),
  ServiceCategory(
    id: 'cat_appliances',
    name: 'Home Appliances',
    icon: 'appliance',
    description: 'Fridges, washing machines and TVs',
    questions: [
      QualificationQuestion(
          id: 'items', label: 'Appliances needed', type: QuestionType.text, required: true),
      QualificationQuestion(id: 'qty', label: 'Quantity', type: QuestionType.number),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
  ServiceCategory(
    id: 'cat_painting',
    name: 'Painting',
    icon: 'painting',
    description: 'Interior and exterior painting',
    questions: [
      QualificationQuestion(
          id: 'sqft', label: 'Area (sq ft)', type: QuestionType.number, required: true),
      QualificationQuestion(
          id: 'side',
          label: 'Interior or exterior',
          type: QuestionType.choice,
          options: ['Interior', 'Exterior', 'Both']),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
  ServiceCategory(
    id: 'cat_water',
    name: 'Water Purifiers',
    icon: 'water',
    description: 'RO purifiers and water softeners',
    questions: [
      QualificationQuestion(
          id: 'source',
          label: 'Water source',
          type: QuestionType.choice,
          options: ['Borewell', 'Corporation', 'Tanker'],
          required: true),
      QualificationQuestion(
          id: 'family', label: 'Family members', type: QuestionType.number),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
  ServiceCategory(
    id: 'cat_electrical',
    name: 'Electrical & Plumbing',
    icon: 'electrical',
    description: 'Wiring, repairs and plumbing work',
    questions: [
      QualificationQuestion(
          id: 'work', label: 'Work needed', type: QuestionType.text, required: true),
      QualificationQuestion(
          id: 'urgency',
          label: 'How soon',
          type: QuestionType.choice,
          options: ['Today', 'This week', 'This month']),
    ],
  ),
  ServiceCategory(
    id: 'cat_furniture',
    name: 'Furniture',
    icon: 'furniture',
    description: 'Home and office furniture',
    questions: [
      QualificationQuestion(
          id: 'items', label: 'Items needed', type: QuestionType.text, required: true),
      QualificationQuestion(id: 'budget', label: 'Budget (₹)', type: QuestionType.number),
    ],
  ),
];

const seedBrands = <Brand>[
  Brand(id: 'b_bosch', name: 'Bosch', categoryIds: ['cat_cctv', 'cat_appliances']),
  Brand(id: 'b_hikvision', name: 'Hikvision', categoryIds: ['cat_cctv']),
  Brand(id: 'b_cpplus', name: 'CP Plus', categoryIds: ['cat_cctv']),
  Brand(id: 'b_daikin', name: 'Daikin', categoryIds: ['cat_ac']),
  Brand(id: 'b_voltas', name: 'Voltas', categoryIds: ['cat_ac']),
  Brand(id: 'b_lg', name: 'LG', categoryIds: ['cat_ac', 'cat_appliances']),
  Brand(id: 'b_samsung', name: 'Samsung', categoryIds: ['cat_ac', 'cat_appliances']),
  Brand(id: 'b_tatasolar', name: 'Tata Power Solar', categoryIds: ['cat_solar']),
  Brand(id: 'b_waaree', name: 'Waaree', categoryIds: ['cat_solar']),
  Brand(id: 'b_kajaria', name: 'Kajaria', categoryIds: ['cat_tiles']),
  Brand(id: 'b_somany', name: 'Somany', categoryIds: ['cat_tiles']),
  Brand(id: 'b_asian', name: 'Asian Paints', categoryIds: ['cat_painting']),
  Brand(id: 'b_berger', name: 'Berger', categoryIds: ['cat_painting']),
  Brand(id: 'b_kent', name: 'Kent', categoryIds: ['cat_water']),
  Brand(id: 'b_aquaguard', name: 'Aquaguard', categoryIds: ['cat_water']),
  Brand(id: 'b_godrej', name: 'Godrej', categoryIds: ['cat_furniture', 'cat_appliances']),
];

const seedCities = <City>[
  City(id: 'city_vellore', name: 'Vellore', state: 'Tamil Nadu', areas: [
    Area(name: 'Katpadi', pincode: '632007'),
    Area(name: 'Sathuvachari', pincode: '632009'),
    Area(name: 'Gandhi Nagar', pincode: '632006'),
    Area(name: 'Bagayam', pincode: '632002'),
    Area(name: 'Kosapet', pincode: '632001'),
  ]),
  City(id: 'city_ranipet', name: 'Ranipet', state: 'Tamil Nadu', areas: [
    Area(name: 'Walajapet', pincode: '632513'),
    Area(name: 'Arcot', pincode: '632503'),
    Area(name: 'Ranipet Town', pincode: '632401'),
  ]),
  City(id: 'city_chennai', name: 'Chennai', state: 'Tamil Nadu', areas: [
    Area(name: 'Anna Nagar', pincode: '600040'),
    Area(name: 'Velachery', pincode: '600042'),
    Area(name: 'T. Nagar', pincode: '600017'),
    Area(name: 'Tambaram', pincode: '600045'),
    Area(name: 'Adyar', pincode: '600020'),
    Area(name: 'Porur', pincode: '600116'),
  ]),
  City(id: 'city_bengaluru', name: 'Bengaluru', state: 'Karnataka', areas: [
    Area(name: 'Whitefield', pincode: '560066'),
    Area(name: 'Indiranagar', pincode: '560038'),
    Area(name: 'Jayanagar', pincode: '560041'),
  ]),
];
