import '../data/system_text.dart';
import '../models/models.dart';
import 'seed_catalog.dart';

/// Demo accounts shown on the login screen. Prototype credentials only.
class DemoAccount {
  const DemoAccount(this.role, this.loginId, this.password);
  final UserRole role;
  final String loginId;
  final String password;
}

const demoAccounts = <DemoAccount>[
  DemoAccount(UserRole.sales, 'sales', 'sales123'),
  DemoAccount(UserRole.backOffice, 'backoffice', 'back123'),
  DemoAccount(UserRole.vendor, 'vendor', 'vendor123'),
  DemoAccount(UserRole.customer, 'customer', 'customer123'),
  DemoAccount(UserRole.franchise, 'franchise', 'franchise123'),
  DemoAccount(UserRole.admin, 'admin', 'admin123'),
];

/// Builds the demo dataset. Every date is relative to [now] so the demo
/// always looks current, whenever it is opened or reset.
DbState buildSeed(DateTime now) {
  DateTime ago({int d = 0, int h = 0, int m = 0}) =>
      now.subtract(Duration(days: d, hours: h, minutes: m));
  DateTime ahead({int d = 0, int h = 0, int m = 0}) =>
      now.add(Duration(days: d, hours: h, minutes: m));
  DateTime dayAt(int offset, int hour, int minute) {
    final d = now.add(Duration(days: offset));
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  String ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Franchises ──────────────────────────────────────────────────────────
  final franchises = [
    Franchise(
      id: 'f_vellore',
      name: 'Vellore Territory',
      cities: const ['Vellore', 'Ranipet'],
      headUserId: 'u_franchise',
      createdAt: ago(d: 400),
    ),
    Franchise(
      id: 'f_chennai',
      name: 'Chennai Territory',
      cities: const ['Chennai'],
      headUserId: 'u_franchise_chennai',
      createdAt: ago(d: 300),
    ),
  ];

  // ── Vendors ─────────────────────────────────────────────────────────────
  VendorDocument doc(String name, DocKind kind, int daysAgo, {bool verified = true}) =>
      VendorDocument(name: name, kind: kind, uploadedAt: ago(d: daysAgo), verified: verified);

  final vendors = [
    Vendor(
      id: 'v_securevision',
      companyName: 'SecureVision Systems',
      contactPerson: 'Senthil Kumar',
      phone: '9443012345',
      email: 'sales@securevision.in',
      address: '14, Gandhi Road, Katpadi',
      city: 'Vellore',
      area: 'Katpadi',
      categoryIds: const ['cat_cctv'],
      productIds: const ['p_cctv_install', 'p_door_phone', 'p_biometric'],
      brandIds: const ['b_bosch', 'b_hikvision', 'b_cpplus'],
      serviceCities: const ['Vellore', 'Ranipet'],
      serviceAreas: const ['Katpadi', 'Sathuvachari', 'Gandhi Nagar', 'Bagayam', 'Kosapet', 'Walajapet', 'Arcot'],
      status: AccountStatus.active,
      rating: 4.6,
      responseRate: 92,
      franchiseId: 'f_vellore',
      commercialNote: 'Referral fee: 3% of order value',
      commissionPercent: 3,
      documents: [
        doc('GST certificate.pdf', DocKind.gst, 380),
        doc('Trade licence 2026.pdf', DocKind.tradeLicense, 380),
        doc('Bosch authorised dealer.pdf', DocKind.other, 200),
      ],
      joinedAt: ago(d: 380),
      gstin: '33ABCDE1234F1Z5',
      about: 'Authorised Bosch and Hikvision dealer. 12 years of CCTV installation for homes, shops and factories.',
    ),
    Vendor(
      id: 'v_eyeguard',
      companyName: 'EyeGuard CCTV',
      contactPerson: 'Arjun Mehta',
      phone: '9444098765',
      email: 'hello@eyeguard.in',
      address: '22, 2nd Avenue, Anna Nagar',
      city: 'Chennai',
      area: 'Anna Nagar',
      categoryIds: const ['cat_cctv'],
      productIds: const ['p_cctv_install', 'p_door_phone'],
      brandIds: const ['b_hikvision', 'b_cpplus'],
      serviceCities: const ['Chennai'],
      serviceAreas: const ['Anna Nagar', 'Velachery', 'T. Nagar', 'Porur'],
      status: AccountStatus.active,
      rating: 4.2,
      responseRate: 81,
      franchiseId: 'f_chennai',
      commercialNote: 'Referral fee: 2.5% of order value',
      commissionPercent: 2.5,
      documents: [doc('GST certificate.pdf', DocKind.gst, 250)],
      joinedAt: ago(d: 250),
    ),
    Vendor(
      id: 'v_coolair',
      companyName: 'CoolAir Solutions',
      contactPerson: 'Prakash Raj',
      phone: '9443055501',
      email: 'service@coolair.in',
      address: '8, Officers Line',
      city: 'Vellore',
      area: 'Kosapet',
      categoryIds: const ['cat_ac'],
      productIds: const ['p_split_ac', 'p_window_ac', 'p_ac_service'],
      brandIds: const ['b_daikin', 'b_voltas', 'b_lg'],
      serviceCities: const ['Vellore', 'Ranipet'],
      serviceAreas: const ['Katpadi', 'Sathuvachari', 'Gandhi Nagar', 'Bagayam', 'Kosapet', 'Walajapet'],
      status: AccountStatus.active,
      rating: 4.4,
      responseRate: 88,
      franchiseId: 'f_vellore',
      commercialNote: 'Fixed fee: ₹500 per won referral',
      documents: [doc('GST certificate.pdf', DocKind.gst, 300)],
      joinedAt: ago(d: 300),
    ),
    Vendor(
      id: 'v_chillzone',
      companyName: 'Chill Zone Aircon',
      contactPerson: 'Farooq Ali',
      phone: '9445077788',
      address: '51, Usman Road, T. Nagar',
      city: 'Chennai',
      area: 'T. Nagar',
      categoryIds: const ['cat_ac'],
      productIds: const ['p_split_ac', 'p_ac_service'],
      brandIds: const ['b_voltas', 'b_samsung'],
      serviceCities: const ['Chennai'],
      serviceAreas: const ['T. Nagar', 'Adyar', 'Velachery', 'Anna Nagar'],
      status: AccountStatus.active,
      rating: 4.1,
      responseRate: 76,
      franchiseId: 'f_chennai',
      commercialNote: 'Referral fee: 2% of order value',
      commissionPercent: 2,
      joinedAt: ago(d: 210),
    ),
    Vendor(
      id: 'v_sunpower',
      companyName: 'SunPower Energy',
      contactPerson: 'Rajesh Kannan',
      phone: '9443066602',
      email: 'projects@sunpower.in',
      address: '3, Arni Road, Sathuvachari',
      city: 'Vellore',
      area: 'Sathuvachari',
      categoryIds: const ['cat_solar'],
      productIds: const ['p_rooftop', 'p_solar_heater'],
      brandIds: const ['b_tatasolar', 'b_waaree'],
      serviceCities: const ['Vellore', 'Ranipet', 'Chennai'],
      serviceAreas: const [],
      status: AccountStatus.active,
      rating: 4.7,
      responseRate: 95,
      franchiseId: 'f_vellore',
      commercialNote: 'Referral fee: 2% of order value',
      commissionPercent: 2,
      documents: [
        doc('GST certificate.pdf', DocKind.gst, 420),
        doc('MNRE empanelment.pdf', DocKind.other, 420),
      ],
      joinedAt: ago(d: 420),
    ),
    Vendor(
      id: 'v_homecraft',
      companyName: 'HomeCraft Interiors',
      contactPerson: 'Nisha Thomas',
      phone: '9445011122',
      email: 'design@homecraft.in',
      address: '17, 3rd Main Road, Velachery',
      city: 'Chennai',
      area: 'Velachery',
      categoryIds: const ['cat_interior', 'cat_furniture'],
      productIds: const ['p_kitchen', 'p_full_interior', 'p_wardrobe', 'p_sofa'],
      brandIds: const ['b_godrej'],
      serviceCities: const ['Chennai'],
      status: AccountStatus.active,
      rating: 4.5,
      responseRate: 90,
      franchiseId: 'f_chennai',
      commercialNote: 'Subscription ₹2,000/month + 1.5% of order value',
      commissionPercent: 1.5,
      joinedAt: ago(d: 350),
    ),
    Vendor(
      id: 'v_tileworld',
      companyName: 'Tile World',
      contactPerson: 'Murugan S',
      phone: '9443088803',
      address: '120, Katpadi Road',
      city: 'Vellore',
      area: 'Gandhi Nagar',
      categoryIds: const ['cat_tiles'],
      productIds: const ['p_floor_tiles', 'p_wall_tiles', 'p_granite'],
      brandIds: const ['b_kajaria'],
      serviceCities: const ['Vellore', 'Ranipet', 'Chennai'],
      status: AccountStatus.active,
      rating: 4.3,
      responseRate: 84,
      franchiseId: 'f_vellore',
      commercialNote: 'Referral fee: 2% of order value',
      commissionPercent: 2,
      joinedAt: ago(d: 280),
    ),
    Vendor(
      id: 'v_lakshmi',
      companyName: 'Sri Lakshmi Jewellers',
      contactPerson: 'Venkatesh Gupta',
      phone: '9443099904',
      address: '5, Long Bazaar',
      city: 'Vellore',
      area: 'Kosapet',
      categoryIds: const ['cat_jewellery'],
      productIds: const ['p_gold', 'p_diamond', 'p_silver'],
      serviceCities: const ['Vellore', 'Ranipet'],
      status: AccountStatus.active,
      rating: 4.8,
      responseRate: 97,
      franchiseId: 'f_vellore',
      commercialNote: 'Referral fee: 1% of purchase value',
      commissionPercent: 1,
      documents: [doc('BIS hallmark licence.pdf', DocKind.tradeLicense, 500)],
      joinedAt: ago(d: 500),
    ),
    Vendor(
      id: 'v_vedic',
      companyName: 'Vedic Pooja Services',
      contactPerson: 'Sundaram Sastrigal',
      phone: '9443011205',
      address: '9, Temple Street, Bagayam',
      city: 'Vellore',
      area: 'Bagayam',
      categoryIds: const ['cat_pooja'],
      productIds: const ['p_griha', 'p_homam', 'p_wedding_priest'],
      serviceCities: const ['Vellore', 'Ranipet', 'Chennai'],
      status: AccountStatus.active,
      rating: 4.9,
      responseRate: 99,
      franchiseId: 'f_vellore',
      commercialNote: 'Fixed fee: ₹300 per booking',
      joinedAt: ago(d: 260),
    ),
    Vendor(
      id: 'v_brightpaints',
      companyName: 'Bright Paints & Co',
      contactPerson: 'Dinesh Kumar',
      phone: '9445033306',
      email: 'bright.paints@gmail.com',
      address: '44, GST Road, Tambaram',
      city: 'Chennai',
      area: 'Tambaram',
      categoryIds: const ['cat_painting'],
      productIds: const ['p_paint_in', 'p_paint_out'],
      brandIds: const ['b_asian', 'b_berger'],
      serviceCities: const ['Chennai'],
      status: AccountStatus.pending,
      documents: [
        doc('GST certificate.pdf', DocKind.gst, 1, verified: false),
        doc('Shop photo.jpg', DocKind.photo, 1, verified: false),
      ],
      joinedAt: ago(h: 20),
      about: 'Residential and commercial painting with Asian Paints and Berger.',
    ),
    Vendor(
      id: 'v_purewater',
      companyName: 'PureWater Systems',
      contactPerson: 'Bala Murali',
      phone: '9443044407',
      address: '2, Arcot Road',
      city: 'Vellore',
      area: 'Sathuvachari',
      categoryIds: const ['cat_water'],
      productIds: const ['p_ro', 'p_softener'],
      brandIds: const ['b_kent', 'b_aquaguard'],
      serviceCities: const ['Vellore'],
      status: AccountStatus.underReview,
      documents: [doc('GST certificate.pdf', DocKind.gst, 4, verified: false)],
      joinedAt: ago(d: 4),
    ),
  ];

  // ── Customers ───────────────────────────────────────────────────────────
  Customer cust(String id, String name, String phone, String city, String area,
          String pin, int daysAgo, {String? email}) =>
      Customer(
          id: id, name: name, phone: phone, email: email, city: city, area: area,
          pincode: pin, createdAt: ago(d: daysAgo));

  final customers = [
    cust('c_yuvaraj', 'Yuvaraj M', '9894012345', 'Vellore', 'Katpadi', '632007', 130,
        email: 'yuvaraj.m@gmail.com'),
    cust('c_priya', 'Priya Venkatesh', '9884023456', 'Chennai', 'Anna Nagar', '600040', 95),
    cust('c_mohan', 'Mohan Das', '9894034567', 'Vellore', 'Sathuvachari', '632009', 70),
    cust('c_anitha', 'Anitha Ravi', '9894045678', 'Vellore', 'Gandhi Nagar', '632006', 50),
    cust('c_rahim', 'Abdul Rahim', '9884056789', 'Chennai', 'Velachery', '600042', 6),
    cust('c_deepa', 'Deepa Krishnan', '9884067890', 'Chennai', 'T. Nagar', '600017', 9),
    cust('c_ganesh', 'Ganesh Iyer', '9894078901', 'Vellore', 'Bagayam', '632002', 40),
    cust('c_kavya', 'Kavya Suresh', '9894089012', 'Ranipet', 'Walajapet', '632513', 25),
    cust('c_joseph', 'Joseph Antony', '9884090123', 'Chennai', 'Tambaram', '600045', 30),
    cust('c_saranya', 'Saranya Mani', '9894001234', 'Vellore', 'Kosapet', '632001', 8),
    cust('c_imran', 'Imran Khan', '9884011234', 'Chennai', 'Adyar', '600020', 3),
    cust('c_revathi', 'Revathi Balaji', '9894021234', 'Vellore', 'Katpadi', '632007', 12),
    cust('c_bala', 'Balaji Sundaram', '9894031234', 'Ranipet', 'Arcot', '632503', 2),
    cust('c_nandhini', 'Nandhini Ramesh', '9884041234', 'Chennai', 'Porur', '600116', 0,
        email: 'nandhini.r@gmail.com'),
    cust('c_suganya', 'Suganya Prabhu', '9894051234', 'Vellore', 'Bagayam', '632002', 5),
  ];

  // ── Users ───────────────────────────────────────────────────────────────
  AppUser user(String id, String login, String pw, String name, String phone,
          UserRole role, String city,
          {String? area,
          String? franchise,
          SalesType? salesType,
          String? vendorId,
          String? customerId,
          AccountStatus status = AccountStatus.active,
          int daysAgo = 200,
          String? email,
          String? upi}) =>
      AppUser(
        id: id,
        loginId: login,
        password: pw,
        name: name,
        phone: phone,
        email: email,
        role: role,
        salesType: salesType,
        city: city,
        area: area,
        franchiseId: franchise,
        status: status,
        createdAt: ago(d: daysAgo),
        vendorId: vendorId,
        customerId: customerId,
        upiId: upi,
      );

  final users = [
    user('u_admin', 'admin', 'admin123', 'Ramesh Kumar', '9840000001', UserRole.admin, 'Chennai',
        email: 'admin@o2oboss.in', daysAgo: 500),
    user('u_bo_divya', 'backoffice', 'back123', 'Divya Shankar', '9840000002',
        UserRole.backOffice, 'Vellore', area: 'Katpadi', email: 'divya@o2oboss.in', daysAgo: 420),
    user('u_bo_suresh', 'suresh.b', 'back123', 'Suresh Babu', '9840000003', UserRole.backOffice,
        'Chennai', area: 'Anna Nagar', email: 'suresh@o2oboss.in', daysAgo: 300),
    user('u_sales_arun', 'sales', 'sales123', 'Arun Prakash', '9840000004', UserRole.sales,
        'Vellore', area: 'Katpadi', franchise: 'f_vellore', salesType: SalesType.independent,
        upi: 'arun.prakash@okaxis', daysAgo: 160),
    user('u_sales_meena', 'meena.r', 'sales123', 'Meena Rajan', '9840000005', UserRole.sales,
        'Vellore', area: 'Sathuvachari', franchise: 'f_vellore', salesType: SalesType.company,
        daysAgo: 330),
    user('u_sales_karthik', 'karthik.s', 'sales123', 'Karthik Selvam', '9840000006',
        UserRole.sales, 'Chennai', area: 'Velachery', franchise: 'f_chennai',
        salesType: SalesType.independent, daysAgo: 140),
    user('u_sales_fathima', 'fathima.b', 'sales123', 'Fathima Begum', '9840000007',
        UserRole.sales, 'Chennai', area: 'Adyar', franchise: 'f_chennai',
        salesType: SalesType.company, daysAgo: 260),
    user('u_franchise', 'franchise', 'franchise123', 'Lakshmi Narayanan', '9840000008',
        UserRole.franchise, 'Vellore', franchise: 'f_vellore', daysAgo: 400),
    user('u_franchise_chennai', 'vijay.a', 'franchise123', 'Vijay Anand', '9840000009',
        UserRole.franchise, 'Chennai', franchise: 'f_chennai', daysAgo: 300),
    user('u_customer', 'customer', 'customer123', 'Yuvaraj M', '9894012345', UserRole.customer,
        'Vellore', area: 'Katpadi', customerId: 'c_yuvaraj', daysAgo: 130,
        email: 'yuvaraj.m@gmail.com'),
    user('u_cust_nandhini', 'nandhini', 'customer123', 'Nandhini Ramesh', '9884041234',
        UserRole.customer, 'Chennai', area: 'Porur', customerId: 'c_nandhini', daysAgo: 0),
    for (final v in vendors)
      user(
        'u_${v.id}',
        switch (v.id) {
          'v_securevision' => 'vendor',
          _ => v.id.substring(2),
        },
        'vendor123',
        v.contactPerson,
        v.phone,
        UserRole.vendor,
        v.city,
        area: v.area,
        franchise: v.franchiseId,
        vendorId: v.id,
        status: v.status,
        daysAgo: now.difference(v.joinedAt).inDays,
        email: v.email,
      ),
  ];

  // ── Enquiries ───────────────────────────────────────────────────────────
  Enquiry enq({
    required String id,
    required String customer,
    required String category,
    String? product,
    String? brand,
    required String requirement,
    required EnquiryStatus status,
    String? sales,
    String? bo,
    String? franchise,
    required DateTime created,
    DateTime? updated,
    EnquirySource source = EnquirySource.sales,
    String? createdBy,
    Map<String, String> answers = const {},
    double? potential,
    double? finalValue,
    EnquiryPriority priority = EnquiryPriority.normal,
    CallOutcome? verified,
    String? lossReason,
    String? rejectReason,
    ContactPreference pref = ContactPreference.callAnytime,
    String? preferredTime,
    String internalNote = '',
    bool confirmedVisit = false,
    bool confirmedPurchase = false,
  }) {
    final c = customers.firstWhere((x) => x.id == customer);
    return Enquiry(
      id: id,
      customerId: customer,
      categoryId: category,
      productId: product,
      brandId: brand,
      city: c.city,
      area: c.area,
      pincode: c.pincode,
      requirement: requirement,
      contactPreference: pref,
      preferredTime: preferredTime,
      source: source,
      createdByUserId: createdBy ?? sales ?? 'u_bo_divya',
      salespersonId: sales,
      backOfficeId: bo,
      franchiseId: franchise,
      status: status,
      priority: priority,
      createdAt: created,
      updatedAt: updated ?? created,
      answers: answers,
      verification: verified == null || bo == null
          ? null
          : VerificationInfo(
              outcome: verified,
              at: created.add(const Duration(hours: 2)),
              byUserId: bo,
              notes: verified == CallOutcome.genuine
                  ? 'Customer confirmed the requirement.'
                  : ''),
      potentialValue: potential,
      finalValue: finalValue,
      lossReason: lossReason,
      rejectReason: rejectReason,
      internalNote: internalNote,
      customerConfirmedVisit: confirmedVisit,
      customerConfirmedPurchase: confirmedPurchase,
    );
  }

  final enquiries = [
    enq(
      id: 'ENQ-1003', customer: 'c_yuvaraj', category: 'cat_solar', product: 'p_rooftop',
      brand: 'b_tatasolar',
      requirement: '3 kW rooftop solar for a two-storey house to cut the power bill.',
      status: EnquiryStatus.commissionSettled, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 120), updated: ago(d: 70),
      answers: {'bill': '4200', 'roof': '900', 'roofType': 'Concrete', 'grid': 'On-grid', 'budget': '300000'},
      potential: 300000, verified: CallOutcome.genuine, confirmedVisit: true, confirmedPurchase: true,
    ),
    enq(
      id: 'ENQ-1006', customer: 'c_priya', category: 'cat_interior', product: 'p_kitchen',
      requirement: 'L-shaped modular kitchen with loft storage and chimney.',
      status: EnquiryStatus.paymentPending, sales: 'u_sales_karthik', bo: 'u_bo_suresh',
      franchise: 'f_chennai', created: ago(d: 92), updated: ago(d: 12),
      answers: {'sqft': '140', 'home': '3 BHK', 'scope': 'Kitchen', 'budget': '500000'},
      potential: 500000, verified: CallOutcome.genuine, confirmedVisit: true,
    ),
    enq(
      id: 'ENQ-1009', customer: 'c_mohan', category: 'cat_jewellery', product: 'p_gold',
      requirement: 'Bridal gold jewellery for daughter\'s wedding in February.',
      status: EnquiryStatus.commissionCalculated, sales: 'u_sales_meena', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 68), updated: ago(d: 9),
      answers: {'occasion': 'Wedding', 'metal': 'Gold', 'budget': '2500000'},
      potential: 2500000, verified: CallOutcome.genuine, priority: EnquiryPriority.high,
      confirmedVisit: true, confirmedPurchase: true,
    ),
    enq(
      id: 'ENQ-1012', customer: 'c_anitha', category: 'cat_cctv', product: 'p_cctv_install',
      brand: 'b_hikvision',
      requirement: '4 cameras for a textile shop — front, billing counter, stock room.',
      status: EnquiryStatus.commissionCalculated, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 48), updated: ago(d: 6),
      answers: {'cameras': '4', 'placement': 'Both', 'site': 'Shop', 'recording': '30 days', 'install': 'Yes'},
      potential: 40000, verified: CallOutcome.genuine, confirmedVisit: true, confirmedPurchase: true,
    ),
    enq(
      id: 'ENQ-1015', customer: 'c_yuvaraj', category: 'cat_ac', product: 'p_split_ac',
      brand: 'b_daikin',
      requirement: 'Two 1.5 ton inverter split ACs for bedrooms, with installation.',
      status: EnquiryStatus.projectInProgress, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 26), updated: ago(d: 1),
      answers: {'units': '2', 'tonnage': '1.5 ton', 'type': 'Split', 'install': 'Yes', 'budget': '110000'},
      potential: 110000, verified: CallOutcome.genuine, confirmedVisit: true,
    ),
    enq(
      id: 'ENQ-1018', customer: 'c_ganesh', category: 'cat_cctv', product: 'p_cctv_install',
      brand: 'b_bosch',
      requirement: '12 Bosch cameras with NVR for a small factory and its compound wall.',
      status: EnquiryStatus.projectCreated, sales: 'u_sales_meena', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 19), updated: ago(d: 2),
      answers: {'cameras': '12', 'placement': 'Both', 'site': 'Factory', 'recording': '30 days', 'install': 'Yes', 'budget': '350000'},
      potential: 350000, verified: CallOutcome.genuine, priority: EnquiryPriority.high,
      confirmedVisit: true,
    ),
    enq(
      id: 'ENQ-1021', customer: 'c_kavya', category: 'cat_painting', product: 'p_paint_in',
      requirement: 'Repainting of 2 BHK house interior.',
      status: EnquiryStatus.rejected, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 15), updated: ago(d: 14),
      verified: CallOutcome.wrongNumber, rejectReason: 'wrongNumber',
    ),
    enq(
      id: 'ENQ-1023', customer: 'c_kavya', category: 'cat_tiles', product: 'p_wall_tiles',
      brand: 'b_somany',
      requirement: 'Somany wall tiles for two bathrooms and kitchen, about 600 sq ft.',
      status: EnquiryStatus.vendorMatching, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 5), updated: ago(h: 10),
      answers: {'sqft': '600', 'finish': 'Glossy', 'laying': 'Yes', 'budget': '60000'},
      potential: 60000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1024', customer: 'c_yuvaraj', category: 'cat_cctv', product: 'p_cctv_install',
      brand: 'b_bosch',
      requirement: 'Needs 8 Bosch cameras for a two-floor house with night vision and mobile viewing.',
      status: EnquiryStatus.negotiation, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 11), updated: ago(h: 5),
      answers: {'cameras': '8', 'placement': 'Both', 'site': 'Home', 'recording': '30 days', 'install': 'Yes', 'budget': '130000', 'date': ymd(ahead(d: 12))},
      potential: 130000, verified: CallOutcome.genuine, confirmedVisit: true,
      pref: ContactPreference.callAtTime, preferredTime: 'After 6 PM',
      internalNote: 'Customer is price-sensitive. Keep installation charge low.',
    ),
    enq(
      id: 'ENQ-1025', customer: 'c_suganya', category: 'cat_interior', product: 'p_full_interior',
      requirement: 'Full interior for a new 2 BHK flat — kitchen, wardrobes and TV unit.',
      status: EnquiryStatus.verified, sales: 'u_sales_meena', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 4), updated: ago(d: 3),
      potential: 450000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1026', customer: 'c_revathi', category: 'cat_pooja', product: 'p_griha',
      requirement: 'Griha pravesam pooja for new house, about 40 guests.',
      status: EnquiryStatus.quotationSubmitted, sales: 'u_sales_meena', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 10), updated: ago(h: 3),
      answers: {'event': 'Griha pravesam', 'people': '40', 'date': ymd(ahead(d: 9)), 'venue': 'New house, 2nd Cross, Katpadi'},
      potential: 35000, verified: CallOutcome.genuine, confirmedVisit: true,
    ),
    enq(
      id: 'ENQ-1027', customer: 'c_joseph', category: 'cat_tiles', product: 'p_floor_tiles',
      brand: 'b_kajaria',
      requirement: 'Vitrified floor tiles for ground floor, 850 sq ft, with laying.',
      status: EnquiryStatus.lost, sales: 'u_sales_karthik', bo: 'u_bo_suresh',
      franchise: 'f_chennai', created: ago(d: 28), updated: ago(d: 8),
      answers: {'sqft': '850', 'finish': 'Matte', 'laying': 'Yes', 'budget': '70000'},
      potential: 70000, verified: CallOutcome.genuine,
      lossReason: 'Customer found a cheaper option nearby.',
    ),
    enq(
      id: 'ENQ-1028', customer: 'c_imran', category: 'cat_appliances', product: 'p_fridge',
      brand: 'b_lg',
      requirement: 'LG double-door fridge and a front-load washing machine.',
      status: EnquiryStatus.verificationPending, sales: 'u_sales_fathima', bo: 'u_bo_divya',
      franchise: 'f_chennai', created: ago(d: 1, h: 4), updated: ago(h: 20),
      potential: 85000,
    ),
    enq(
      id: 'ENQ-1029', customer: 'c_saranya', category: 'cat_cctv', product: 'p_cctv_install',
      brand: 'b_hikvision',
      requirement: '4 Hikvision cameras for home with mobile app viewing.',
      status: EnquiryStatus.appointmentScheduled, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 7), updated: ago(h: 6),
      answers: {'cameras': '4', 'placement': 'Both', 'site': 'Home', 'recording': '15 days', 'install': 'Yes', 'budget': '35000'},
      potential: 35000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1030', customer: 'c_deepa', category: 'cat_ac', product: 'p_split_ac',
      brand: 'b_voltas',
      requirement: 'One 1.5 ton split AC for living room.',
      status: EnquiryStatus.vendorAccepted, sales: 'u_sales_fathima', bo: 'u_bo_suresh',
      franchise: 'f_chennai', created: ago(d: 8), updated: ago(h: 14),
      answers: {'units': '1', 'tonnage': '1.5 ton', 'type': 'Split', 'install': 'Yes', 'budget': '45000'},
      potential: 45000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1031', customer: 'c_bala', category: 'cat_cctv', product: 'p_cctv_install',
      brand: 'b_cpplus',
      requirement: '6 CP Plus cameras for a hardware shop and godown.',
      status: EnquiryStatus.vendorAssigned, sales: 'u_sales_arun', bo: 'u_bo_divya',
      franchise: 'f_vellore', created: ago(d: 2), updated: ago(h: 4),
      answers: {'cameras': '6', 'placement': 'Both', 'site': 'Shop', 'recording': '30 days', 'install': 'Yes', 'budget': '55000'},
      potential: 55000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1032', customer: 'c_rahim', category: 'cat_solar', product: 'p_rooftop',
      requirement: '5 kW rooftop solar for a house with a ₹6,000 monthly bill.',
      status: EnquiryStatus.qualified, sales: 'u_sales_karthik', bo: 'u_bo_divya',
      franchise: 'f_chennai', created: ago(d: 3), updated: ago(h: 18),
      answers: {'bill': '6000', 'roof': '1200', 'roofType': 'Concrete', 'grid': 'On-grid', 'budget': '350000'},
      potential: 350000, verified: CallOutcome.genuine,
    ),
    enq(
      id: 'ENQ-1033', customer: 'c_mohan', category: 'cat_water', product: 'p_ro',
      requirement: 'RO purifier for borewell water, family of five.',
      status: EnquiryStatus.newEnquiry, sales: 'u_sales_arun',
      franchise: 'f_vellore', created: ago(m: 40), potential: 18000,
    ),
    enq(
      id: 'ENQ-1034', customer: 'c_nandhini', category: 'cat_interior', product: 'p_wardrobe',
      requirement: 'Two sliding wardrobes for bedrooms.',
      status: EnquiryStatus.newEnquiry, franchise: 'f_chennai', created: ago(h: 2),
      source: EnquirySource.customer, createdBy: 'u_cust_nandhini',
    ),
  ];

  // ── Vendor assignments ──────────────────────────────────────────────────
  var assignSeq = 0;
  VendorAssignment assign(String enquiryId, String vendorId, DateTime at,
      {AssignmentStatus status = AssignmentStatus.accepted,
      int score = 90,
      double? price,
      int? days,
      String? reason,
      String bo = 'u_bo_divya'}) {
    assignSeq++;
    return VendorAssignment(
      id: 'asg_$assignSeq',
      enquiryId: enquiryId,
      vendorId: vendorId,
      assignedAt: at,
      deadline: at.add(const Duration(hours: 24)),
      status: status,
      respondedAt: status == AssignmentStatus.pending ? null : at.add(const Duration(hours: 3)),
      expectedPrice: price,
      expectedDays: days,
      rejectReason: reason,
      matchScore: score,
      assignedByUserId: bo,
    );
  }

  final assignments = [
    assign('ENQ-1003', 'v_sunpower', ago(d: 117), price: 290000, days: 10, score: 94),
    assign('ENQ-1006', 'v_homecraft', ago(d: 89), price: 470000, days: 25, score: 91, bo: 'u_bo_suresh'),
    assign('ENQ-1009', 'v_lakshmi', ago(d: 66), price: 2500000, days: 1, score: 96),
    assign('ENQ-1012', 'v_securevision', ago(d: 46), price: 40000, days: 2, score: 93),
    assign('ENQ-1015', 'v_coolair', ago(d: 24), price: 118000, days: 3, score: 95),
    assign('ENQ-1018', 'v_securevision', ago(d: 17), price: 340000, days: 7, score: 97),
    assign('ENQ-1023', 'v_tileworld', ago(d: 3), status: AssignmentStatus.rejected, score: 71,
        reason: 'We do not stock Somany tiles at the moment.'),
    assign('ENQ-1024', 'v_securevision', ago(d: 9), price: 135000, days: 4, score: 98),
    assign('ENQ-1026', 'v_vedic', ago(d: 8), price: 35000, days: 1, score: 96),
    assign('ENQ-1027', 'v_tileworld', ago(d: 26), price: 85000, days: 6, score: 88, bo: 'u_bo_suresh'),
    assign('ENQ-1029', 'v_securevision', ago(d: 5), price: 32000, days: 2, score: 95),
    assign('ENQ-1030', 'v_chillzone', ago(d: 6), price: 42000, days: 3, score: 89, bo: 'u_bo_suresh'),
    assign('ENQ-1031', 'v_securevision', ago(h: 4), status: AssignmentStatus.pending, score: 94),
  ];

  // ── Appointments ────────────────────────────────────────────────────────
  var aptSeq = 500;
  Appointment apt(String enquiryId, String vendorId, DateTime at, AppointmentStatus status,
      {String purpose = 'Site visit', UserRole by = UserRole.vendor, bool confirmed = false}) {
    aptSeq++;
    final e = enquiries.firstWhere((x) => x.id == enquiryId);
    return Appointment(
      id: 'APT-$aptSeq',
      enquiryId: enquiryId,
      vendorId: vendorId,
      at: at,
      location: '${e.area}, ${e.city}',
      purpose: purpose,
      status: status,
      proposedByRole: by,
      createdAt: at.subtract(const Duration(days: 1)),
      customerConfirmed: confirmed,
    );
  }

  final appointments = [
    apt('ENQ-1003', 'v_sunpower', ago(d: 112), AppointmentStatus.completed, purpose: 'Roof survey', confirmed: true),
    apt('ENQ-1006', 'v_homecraft', ago(d: 85), AppointmentStatus.completed, purpose: 'Kitchen measurement', confirmed: true),
    apt('ENQ-1009', 'v_lakshmi', ago(d: 62), AppointmentStatus.completed, purpose: 'Showroom visit', by: UserRole.backOffice, confirmed: true),
    apt('ENQ-1012', 'v_securevision', ago(d: 44), AppointmentStatus.completed, confirmed: true),
    apt('ENQ-1015', 'v_coolair', ago(d: 22), AppointmentStatus.completed, confirmed: true),
    apt('ENQ-1018', 'v_securevision', ago(d: 15), AppointmentStatus.completed, purpose: 'Factory survey', confirmed: true),
    apt('ENQ-1024', 'v_securevision', ago(d: 7), AppointmentStatus.completed, purpose: 'Site survey', confirmed: true),
    apt('ENQ-1026', 'v_vedic', ago(d: 2), AppointmentStatus.completed, purpose: 'Pooja planning visit', confirmed: true),
    apt('ENQ-1027', 'v_tileworld', ago(d: 22), AppointmentStatus.completed, purpose: 'Showroom visit'),
    apt('ENQ-1029', 'v_securevision', dayAt(0, 16, 30), AppointmentStatus.confirmed),
    apt('ENQ-1030', 'v_chillzone', dayAt(1, 11, 0), AppointmentStatus.pendingConfirmation),
  ];

  // ── Quotations ──────────────────────────────────────────────────────────
  Quotation quote(String id, String number, String enquiryId, String vendorId,
      List<QuotationItem> items, QuotationStatus status, DateTime created,
      {int version = 1,
      double tax = 18,
      double installation = 0,
      double discount = 0,
      int timeline = 7,
      String? revisionNote,
      String? responseNote,
      String? signed,
      String terms = '50% advance, balance on completion. 1 year warranty on equipment.'}) {
    final sent = status == QuotationStatus.submitted || status == QuotationStatus.draft
        ? null
        : created.add(const Duration(hours: 5));
    return Quotation(
      id: id,
      number: number,
      version: version,
      enquiryId: enquiryId,
      vendorId: vendorId,
      items: items,
      taxPercent: tax,
      installation: installation,
      discount: discount,
      timelineDays: timeline,
      terms: terms,
      status: status,
      createdAt: created,
      submittedAt: status == QuotationStatus.draft ? null : created,
      sentAt: sent,
      viewedAt: status == QuotationStatus.sent || sent == null ? null : sent.add(const Duration(hours: 2)),
      respondedAt: const {
        QuotationStatus.accepted,
        QuotationStatus.rejected,
        QuotationStatus.revisionRequested,
        QuotationStatus.superseded,
      }.contains(status)
          ? created.add(const Duration(days: 1))
          : null,
      revisionNote: revisionNote,
      responseNote: responseNote,
      signedName: signed,
      approvedByUserId: sent == null ? null : 'u_bo_divya',
      adminCopySent: status != QuotationStatus.draft,
    );
  }

  QuotationItem item(String d, double qty, double price) =>
      QuotationItem(description: d, qty: qty, unitPrice: price);

  final quotations = [
    quote('q_2003', 'QT-2003', 'ENQ-1003', 'v_sunpower', [
      item('3 kW on-grid rooftop solar system (Tata Power Solar panels)', 1, 195000),
      item('3 kW grid-tie inverter', 1, 38000),
      item('Mounting structure and wiring', 1, 22000),
    ], QuotationStatus.accepted, ago(d: 110), tax: 12, installation: 10000, timeline: 10,
        signed: 'Yuvaraj M'),
    quote('q_2006', 'QT-2006', 'ENQ-1006', 'v_homecraft', [
      item('L-shaped modular kitchen, marine ply with acrylic finish', 1, 320000),
      item('Chimney and hob', 1, 45000),
      item('Loft storage units', 1, 42000),
    ], QuotationStatus.accepted, ago(d: 82), timeline: 25, signed: 'Priya Venkatesh'),
    quote('q_2009', 'QT-2009', 'ENQ-1009', 'v_lakshmi', [
      item('Bridal necklace set, 22K gold', 1, 1750000),
      item('Gold bangles, 22K (set of 6)', 1, 620000),
      item('Gold earrings, 22K', 1, 57000),
    ], QuotationStatus.accepted, ago(d: 60), tax: 3, timeline: 1,
        terms: 'Hallmarked 916 gold. Price fixed at today\'s gold rate.', signed: 'Mohan Das'),
    quote('q_2012', 'QT-2012', 'ENQ-1012', 'v_securevision', [
      item('Hikvision 2 MP dome camera', 4, 2800),
      item('4-channel DVR', 1, 6500),
      item('1 TB surveillance hard disk', 1, 4200),
      item('Cabling and accessories', 1, 6000),
    ], QuotationStatus.accepted, ago(d: 42), installation: 5000, timeline: 2, signed: 'Anitha Ravi'),
    quote('q_2015', 'QT-2015', 'ENQ-1015', 'v_coolair', [
      item('Daikin 1.5 ton 5-star inverter split AC', 2, 42500),
      item('Copper piping and outdoor stand', 2, 3000),
    ], QuotationStatus.accepted, ago(d: 20), tax: 28, installation: 3000, timeline: 3,
        signed: 'Yuvaraj M'),
    quote('q_2018', 'QT-2018', 'ENQ-1018', 'v_securevision', [
      item('Bosch 4 MP bullet camera', 12, 14500),
      item('16-channel NVR (Bosch DIVAR)', 1, 48000),
      item('4 TB surveillance hard disk', 2, 9500),
      item('PoE switch and cabling', 1, 26000),
    ], QuotationStatus.accepted, ago(d: 12), installation: 18000, timeline: 7, signed: 'Ganesh Iyer'),
    quote('q_2024_1', 'QT-2024', 'ENQ-1024', 'v_securevision', [
      item('Bosch 2 MP dome camera', 8, 9800),
      item('8-channel NVR', 1, 18500),
      item('500 GB surveillance hard disk', 1, 3200),
      item('Cabling and accessories', 1, 7500),
    ], QuotationStatus.superseded, ago(d: 6), installation: 12000, timeline: 4,
        revisionNote: 'Please include 1 TB storage and reduce the installation charge.'),
    quote('q_2024_2', 'QT-2024', 'ENQ-1024', 'v_securevision', [
      item('Bosch 2 MP dome camera', 8, 9800),
      item('8-channel NVR', 1, 18500),
      item('1 TB surveillance hard disk', 1, 4200),
      item('Cabling and accessories', 1, 7500),
    ], QuotationStatus.sent, ago(h: 9), version: 2, installation: 8000, discount: 3000, timeline: 4),
    quote('q_2026', 'QT-2026', 'ENQ-1026', 'v_vedic', [
      item('Griha pravesam pooja with 3 priests', 1, 18000),
      item('Homam materials and flowers', 1, 9500),
      item('Prasadam (per guest)', 40, 150),
    ], QuotationStatus.submitted, ago(h: 3), tax: 0, timeline: 1,
        terms: 'Booking confirmed on 30% advance.'),
    quote('q_2027', 'QT-2027', 'ENQ-1027', 'v_tileworld', [
      item('Kajaria vitrified floor tiles 2×2 ft (per sq ft)', 850, 62),
      item('Laying charges (per sq ft)', 850, 25),
    ], QuotationStatus.rejected, ago(d: 20), timeline: 6,
        responseNote: 'Found a cheaper option nearby.'),
  ];

  // ── Projects ────────────────────────────────────────────────────────────
  List<Milestone> milestones(int doneCount, DateTime start) => [
        for (var i = 0; i < MilestoneKey.values.length; i++)
          Milestone(
            key: MilestoneKey.values[i],
            done: i < doneCount,
            doneAt: i < doneCount ? start.add(Duration(days: i)) : null,
          ),
      ];

  double totalOf(String quoteId) => quotations.firstWhere((q) => q.id == quoteId).total;

  final projects = [
    Project(
      id: 'PRJ-3001', enquiryId: 'ENQ-1003', vendorId: 'v_sunpower', quotationId: 'q_2003',
      finalValue: totalOf('q_2003'), startDate: ago(d: 105), expectedCompletion: ago(d: 95),
      actualCompletion: ago(d: 96), status: ProjectStatus.completed,
      milestones: milestones(9, ago(d: 105)), createdAt: ago(d: 106),
      documents: const ['Net meter approval.pdf', 'Warranty card.pdf'],
    ),
    Project(
      id: 'PRJ-3002', enquiryId: 'ENQ-1006', vendorId: 'v_homecraft', quotationId: 'q_2006',
      finalValue: totalOf('q_2006'), startDate: ago(d: 78), expectedCompletion: ago(d: 50),
      actualCompletion: ago(d: 20), status: ProjectStatus.completed,
      milestones: milestones(8, ago(d: 78)), createdAt: ago(d: 79),
      paymentDueDate: ago(d: 5),
    ),
    Project(
      id: 'PRJ-3003', enquiryId: 'ENQ-1009', vendorId: 'v_lakshmi', quotationId: 'q_2009',
      finalValue: totalOf('q_2009'), startDate: ago(d: 58), expectedCompletion: ago(d: 57),
      actualCompletion: ago(d: 57), status: ProjectStatus.completed,
      milestones: milestones(9, ago(d: 58)), createdAt: ago(d: 59),
    ),
    Project(
      id: 'PRJ-3004', enquiryId: 'ENQ-1012', vendorId: 'v_securevision', quotationId: 'q_2012',
      finalValue: totalOf('q_2012'), startDate: ago(d: 40), expectedCompletion: ago(d: 38),
      actualCompletion: ago(d: 38), status: ProjectStatus.completed,
      milestones: milestones(9, ago(d: 40)), createdAt: ago(d: 41),
    ),
    Project(
      id: 'PRJ-3005', enquiryId: 'ENQ-1015', vendorId: 'v_coolair', quotationId: 'q_2015',
      finalValue: totalOf('q_2015'), startDate: ago(d: 4), expectedCompletion: ahead(d: 2),
      status: ProjectStatus.inProgress, milestones: milestones(4, ago(d: 4)),
      createdAt: ago(d: 5), paymentDueDate: ahead(d: 5),
    ),
    Project(
      id: 'PRJ-3006', enquiryId: 'ENQ-1018', vendorId: 'v_securevision', quotationId: 'q_2018',
      finalValue: totalOf('q_2018'), startDate: ahead(d: 1), expectedCompletion: ahead(d: 8),
      status: ProjectStatus.notStarted, milestones: milestones(1, ago(d: 2)),
      createdAt: ago(d: 2), paymentDueDate: ahead(d: 1),
    ),
  ];

  // Final values follow the accepted quotation.
  final valued = [
    for (final e in enquiries)
      switch (projects.where((p) => p.enquiryId == e.id).firstOrNull) {
        final p? => e.copyWith(finalValue: p.finalValue),
        null => e,
      },
  ];

  // ── Payments ────────────────────────────────────────────────────────────
  final payments = [
    PaymentRecord(id: 'PAY-7001', projectId: 'PRJ-3001', amount: 100000, at: ago(d: 104),
        method: PaymentMethod.bankTransfer, reference: 'NEFT 4471823', recordedByUserId: 'u_bo_divya'),
    PaymentRecord(id: 'PAY-7002', projectId: 'PRJ-3001', amount: totalOf('q_2003') - 100000,
        at: ago(d: 90), method: PaymentMethod.upi, reference: 'UPI 3029117745',
        recordedByUserId: 'u_v_sunpower'),
    PaymentRecord(id: 'PAY-7003', projectId: 'PRJ-3002', amount: 300000, at: ago(d: 77),
        method: PaymentMethod.cheque, reference: 'Cheque 000412', recordedByUserId: 'u_bo_suresh'),
    PaymentRecord(id: 'PAY-7004', projectId: 'PRJ-3003', amount: totalOf('q_2009'), at: ago(d: 57),
        method: PaymentMethod.bankTransfer, reference: 'RTGS 88120034', recordedByUserId: 'u_v_lakshmi'),
    PaymentRecord(id: 'PAY-7005', projectId: 'PRJ-3004', amount: totalOf('q_2012'), at: ago(d: 37),
        method: PaymentMethod.upi, reference: 'UPI 2210099812', recordedByUserId: 'u_v_securevision'),
    PaymentRecord(id: 'PAY-7006', projectId: 'PRJ-3005', amount: 30000, at: ago(d: 4),
        method: PaymentMethod.upi, reference: 'UPI 5518820011', recordedByUserId: 'u_v_coolair',
        notes: 'Advance'),
  ];

  // ── Commissions ─────────────────────────────────────────────────────────
  const cfg = AppConfig();
  var comSeq = 9000;
  Commission com(String enquiryId, String projectId, String userId, UserRole role,
      double value, double pct, CommissionStatus status, DateTime created) {
    comSeq++;
    return Commission(
      id: 'COM-$comSeq',
      enquiryId: enquiryId,
      projectId: projectId,
      beneficiaryUserId: userId,
      role: role,
      businessValue: value,
      percent: pct,
      amount: (value * pct / 100).roundToDouble(),
      trigger: CommissionTrigger.fullPaymentCollected,
      status: status,
      createdAt: created,
      approvedAt: status == CommissionStatus.pending ? null : created.add(const Duration(days: 2)),
      paidAt: status == CommissionStatus.paid ? created.add(const Duration(days: 6)) : null,
      reference: status == CommissionStatus.paid ? 'UPI ${comSeq}8812' : null,
    );
  }

  final v1003 = totalOf('q_2003');
  final v1009 = totalOf('q_2009');
  final v1012 = totalOf('q_2012');
  final commissions = [
    com('ENQ-1003', 'PRJ-3001', 'u_sales_arun', UserRole.sales, v1003, cfg.salesCommissionPercent, CommissionStatus.paid, ago(d: 89)),
    com('ENQ-1003', 'PRJ-3001', 'u_bo_divya', UserRole.backOffice, v1003, cfg.backOfficeCommissionPercent, CommissionStatus.paid, ago(d: 89)),
    com('ENQ-1003', 'PRJ-3001', 'u_franchise', UserRole.franchise, v1003, cfg.franchiseSharePercent, CommissionStatus.paid, ago(d: 89)),
    com('ENQ-1009', 'PRJ-3003', 'u_sales_meena', UserRole.sales, v1009, cfg.salesCommissionPercent, CommissionStatus.payable, ago(d: 10)),
    com('ENQ-1009', 'PRJ-3003', 'u_bo_divya', UserRole.backOffice, v1009, cfg.backOfficeCommissionPercent, CommissionStatus.approved, ago(d: 10)),
    com('ENQ-1009', 'PRJ-3003', 'u_franchise', UserRole.franchise, v1009, cfg.franchiseSharePercent, CommissionStatus.pending, ago(d: 10)),
    com('ENQ-1012', 'PRJ-3004', 'u_sales_arun', UserRole.sales, v1012, cfg.salesCommissionPercent, CommissionStatus.approved, ago(d: 7)),
    com('ENQ-1012', 'PRJ-3004', 'u_bo_divya', UserRole.backOffice, v1012, cfg.backOfficeCommissionPercent, CommissionStatus.pending, ago(d: 7)),
    com('ENQ-1012', 'PRJ-3004', 'u_franchise', UserRole.franchise, v1012, cfg.franchiseSharePercent, CommissionStatus.pending, ago(d: 7)),
  ];

  // ── Calls ───────────────────────────────────────────────────────────────
  var callSeq = 4000;
  CallRecord call(String enquiryId, DateTime at, int secs, CallOutcome? outcome,
      {String by = 'u_bo_divya', UserRole to = UserRole.customer, String notes = ''}) {
    callSeq++;
    final e = valued.firstWhere((x) => x.id == enquiryId);
    final name = to == UserRole.customer
        ? customers.firstWhere((c) => c.id == e.customerId).name
        : vendors
            .firstWhere((v) => v.id ==
                assignments.firstWhere((a) => a.enquiryId == enquiryId).vendorId)
            .companyName;
    return CallRecord(
      id: 'CALL-$callSeq', enquiryId: enquiryId, byUserId: by, toName: name, toRole: to,
      at: at, durationSec: secs, outcome: outcome, notes: notes, recorded: true,
    );
  }

  final calls = [
    call('ENQ-1024', ago(d: 11, h: -2), 165, CallOutcome.genuine,
        notes: 'Confirmed 8 Bosch cameras. Prefers calls after 6 PM.'),
    call('ENQ-1024', ago(d: 1), 94, null, notes: 'Explained revised quotation v2.'),
    call('ENQ-1029', ago(d: 7, h: -1), 120, CallOutcome.genuine),
    call('ENQ-1029', ago(h: 6), 70, null, to: UserRole.vendor, notes: 'Vendor confirmed 4:30 PM visit.'),
    call('ENQ-1031', ago(d: 2, h: -1), 142, CallOutcome.genuine),
    call('ENQ-1032', ago(d: 3, h: -2), 188, CallOutcome.genuine, by: 'u_bo_divya'),
    call('ENQ-1025', ago(d: 3, h: 22), 133, CallOutcome.genuine),
    call('ENQ-1021', ago(d: 14, h: 22), 25, CallOutcome.wrongNumber,
        notes: 'Number belongs to someone else.'),
    call('ENQ-1028', ago(h: 20), 48, CallOutcome.callBackLater,
        notes: 'Customer busy, asked to call back tomorrow morning.'),
    call('ENQ-1023', ago(d: 5, h: -1), 101, CallOutcome.genuine),
    call('ENQ-1026', ago(d: 10, h: -2), 115, CallOutcome.genuine),
  ];

  // ── Chat ────────────────────────────────────────────────────────────────
  var msgSeq = 0;
  ChatMessage msg(String enquiryId, String thread, DateTime at, String text,
      {String? by, UserRole? role, ChatKind kind = ChatKind.text, String? file}) {
    msgSeq++;
    return ChatMessage(
      id: 'm$msgSeq', enquiryId: enquiryId, thread: thread, senderUserId: by,
      senderRole: role, kind: by == null ? ChatKind.system : kind, text: text,
      fileName: file, at: at,
    );
  }

  const bo = UserRole.backOffice;
  const ven = UserRole.vendor;
  const cu = UserRole.customer;
  final messages = [
    msg('ENQ-1024', 'v_securevision', ago(d: 9), SystemText.encode(SystemText.newReferral, ['ENQ-1024', '24'])),
    msg('ENQ-1024', 'v_securevision', ago(d: 9, m: -5), 'Customer needs 8 Bosch cameras. Can you handle installation?', by: 'u_bo_divya', role: bo),
    msg('ENQ-1024', 'v_securevision', ago(d: 9, m: -20), 'Yes.', by: 'u_v_securevision', role: ven),
    msg('ENQ-1024', 'v_securevision', ago(d: 9, m: -25), 'Can you visit tomorrow at 3:30?', by: 'u_bo_divya', role: bo),
    msg('ENQ-1024', 'v_securevision', ago(d: 9, m: -40), 'Yes.', by: 'u_v_securevision', role: ven),
    msg('ENQ-1024', 'v_securevision', ago(d: 6), SystemText.encode(SystemText.quotationSubmitted, ['QT-2024', '1'])),
    msg('ENQ-1024', 'v_securevision', ago(d: 1, h: 4), 'Customer asked for 1 TB storage and a lower installation charge.', by: 'u_bo_divya', role: bo),
    msg('ENQ-1024', 'v_securevision', ago(h: 10), 'Done. Sending revised quotation now.', by: 'u_v_securevision', role: ven),
    msg('ENQ-1024', 'v_securevision', ago(h: 9, m: 50), 'Site photos', by: 'u_v_securevision', role: ven, kind: ChatKind.image, file: 'site_photos.jpg'),
    msg('ENQ-1024', 'v_securevision', ago(h: 9), SystemText.encode(SystemText.quotationSent, ['QT-2024', '2'])),
    msg('ENQ-1024', ChatMessage.customerThread, ago(d: 1, h: 5), 'Can the installation charge be reduced?', by: 'u_customer', role: cu),
    msg('ENQ-1024', ChatMessage.customerThread, ago(d: 1, h: 4, m: 30), 'We have asked the vendor for a revised quotation. You will get it soon.', by: 'u_bo_divya', role: bo),
    msg('ENQ-1024', ChatMessage.customerThread, ago(h: 9), 'The revised quotation is ready. Please check Quotations.', by: 'u_bo_divya', role: bo),
    msg('ENQ-1029', 'v_securevision', ago(d: 5), SystemText.encode(SystemText.newReferral, ['ENQ-1029', '24'])),
    msg('ENQ-1029', 'v_securevision', ago(h: 7), 'Customer needs 4 Hikvision cameras for home. Can you visit today?', by: 'u_bo_divya', role: bo),
    msg('ENQ-1029', 'v_securevision', ago(h: 6, m: 40), 'Yes, I can visit at 4:30 PM.', by: 'u_v_securevision', role: ven),
    msg('ENQ-1029', 'v_securevision', ago(h: 6, m: 30), SystemText.encode(SystemText.appointmentConfirmed, [dayAt(0, 16, 30).toIso8601String()])),
    msg('ENQ-1029', 'v_securevision', ago(h: 6, m: 25), 'Great, the customer has been informed.', by: 'u_bo_divya', role: bo),
    msg('ENQ-1031', 'v_securevision', ago(h: 4), SystemText.encode(SystemText.newReferral, ['ENQ-1031', '24'])),
    msg('ENQ-1018', 'v_securevision', ago(d: 2, h: 2), 'Order confirmed. Please plan material for 12 cameras.', by: 'u_bo_divya', role: bo),
    msg('ENQ-1018', 'v_securevision', ago(d: 2), 'Material ordered. Work starts tomorrow.', by: 'u_v_securevision', role: ven),
    msg('ENQ-1026', 'v_vedic', ago(h: 3), 'Quotation includes homam materials and prasadam for 40 guests.', by: 'u_v_vedic', role: ven),
    msg('ENQ-1030', 'v_chillzone', ago(h: 14), 'Can visit tomorrow 11 AM for measurement.', by: 'u_v_chillzone', role: ven),
  ];

  // ── Follow-ups ──────────────────────────────────────────────────────────
  var fuSeq = 0;
  FollowUp fu(String? enquiryId, FollowUpType type, DateTime due, String notes,
      {String user = 'u_bo_divya', bool done = false}) {
    fuSeq++;
    return FollowUp(
      id: 'fu$fuSeq', enquiryId: enquiryId, type: type, assignedUserId: user, dueAt: due,
      notes: notes, done: done, doneAt: done ? due : null,
      outcome: done ? 'Done' : null, createdAt: due.subtract(const Duration(days: 1)),
    );
  }

  final followUps = [
    fu('ENQ-1028', FollowUpType.customerCall, dayAt(0, 11, 30), 'Call back for verification.'),
    fu('ENQ-1029', FollowUpType.appointment, dayAt(0, 17, 30), 'Check that the vendor visited the customer.'),
    fu('ENQ-1018', FollowUpType.payment, ago(d: 1), 'Collect advance payment before work starts.'),
    fu('ENQ-1024', FollowUpType.quotation, dayAt(1, 10, 0), 'Ask customer about revised quotation.'),
    fu('ENQ-1015', FollowUpType.project, dayAt(2, 12, 0), 'Confirm installation of second AC.'),
    fu('ENQ-1031', FollowUpType.vendorCall, dayAt(1, 9, 30), 'Remind vendor to respond to referral.'),
    fu('ENQ-1012', FollowUpType.payment, ago(d: 38), 'Confirm final payment.', done: true),
    fu('ENQ-1006', FollowUpType.payment, ago(d: 2), 'Collect balance payment from customer.', user: 'u_bo_suresh'),
  ];

  // ── Tasks ───────────────────────────────────────────────────────────────
  var taskSeq = 0;
  TaskItem task(TaskKind kind, String? enquiryId, DateTime due,
      {String user = 'u_bo_divya', String? ref, bool done = false, String? title}) {
    taskSeq++;
    return TaskItem(
      id: 't$taskSeq', kind: kind, enquiryId: enquiryId, refId: ref, title: title,
      assignedUserId: user, dueAt: due, done: done, doneAt: done ? due : null,
      createdAt: due.subtract(const Duration(hours: 6)),
    );
  }

  final tasks = [
    task(TaskKind.verify, 'ENQ-1033', ahead(h: 4)),
    task(TaskKind.verify, 'ENQ-1034', ahead(h: 6)),
    task(TaskKind.verify, 'ENQ-1028', dayAt(0, 11, 30)),
    task(TaskKind.qualify, 'ENQ-1025', ago(h: 20)),
    task(TaskKind.assignVendor, 'ENQ-1032', ahead(h: 8)),
    task(TaskKind.assignVendor, 'ENQ-1023', ahead(h: 2)),
    task(TaskKind.reviewQuotation, 'ENQ-1026', ahead(h: 5), ref: 'q_2026'),
    task(TaskKind.collectPayment, 'ENQ-1018', ago(d: 1)),
    task(TaskKind.verify, 'ENQ-1029', ago(d: 7), done: true),
    task(TaskKind.approveVendor, null, ahead(d: 1), user: 'u_admin', ref: 'v_brightpaints'),
    task(TaskKind.approveVendor, null, ahead(d: 1), user: 'u_admin', ref: 'v_purewater'),
    task(TaskKind.approveCommission, 'ENQ-1009', ahead(d: 2), user: 'u_admin'),
  ];

  // ── Notifications ───────────────────────────────────────────────────────
  var nSeq = 0;
  AppNotification note(String userId, NotificationEvent event, DateTime at,
      {String? enquiryId, Map<String, String> params = const {}, bool read = false, String? route}) {
    nSeq++;
    return AppNotification(
      id: 'n$nSeq', userId: userId, event: event, enquiryId: enquiryId,
      params: {'id': ?enquiryId, ...params},
      createdAt: at, read: read,
      route: route ?? (enquiryId == null ? null : '/enquiry/$enquiryId'),
    );
  }

  final notifications = [
    // Sales — Arun
    note('u_sales_arun', NotificationEvent.enquirySubmitted, ago(m: 40), enquiryId: 'ENQ-1033'),
    note('u_sales_arun', NotificationEvent.vendorAssigned, ago(h: 4), enquiryId: 'ENQ-1031',
        params: {'vendor': 'SecureVision Systems'}),
    note('u_sales_arun', NotificationEvent.appointmentConfirmed, ago(h: 6), enquiryId: 'ENQ-1029'),
    note('u_sales_arun', NotificationEvent.quotationReceived, ago(h: 9), enquiryId: 'ENQ-1024', read: true),
    note('u_sales_arun', NotificationEvent.commissionUpdated, ago(d: 5), enquiryId: 'ENQ-1012',
        params: {'amount': '776'}, read: true, route: '/sales/earnings'),
    // Back office — Divya
    note('u_bo_divya', NotificationEvent.newEnquiry, ago(m: 40), enquiryId: 'ENQ-1033'),
    note('u_bo_divya', NotificationEvent.newEnquiry, ago(h: 2), enquiryId: 'ENQ-1034'),
    note('u_bo_divya', NotificationEvent.quotationSubmitted, ago(h: 3), enquiryId: 'ENQ-1026',
        params: {'vendor': 'Vedic Pooja Services', 'number': 'QT-2026'}),
    note('u_bo_divya', NotificationEvent.referralRejected, ago(h: 10), enquiryId: 'ENQ-1023',
        params: {'vendor': 'Tile World'}),
    note('u_bo_divya', NotificationEvent.followUpDue, ago(h: 1), enquiryId: 'ENQ-1028', read: true),
    // Vendor — SecureVision
    note('u_v_securevision', NotificationEvent.newReferral, ago(h: 4), enquiryId: 'ENQ-1031'),
    note('u_v_securevision', NotificationEvent.appointmentConfirmed, ago(h: 6, m: 30), enquiryId: 'ENQ-1029'),
    note('u_v_securevision', NotificationEvent.chatMessage, ago(h: 6, m: 25), enquiryId: 'ENQ-1029',
        route: '/enquiry/ENQ-1029/chat/v_securevision', read: true),
    note('u_v_securevision', NotificationEvent.projectUpdated, ago(d: 2), enquiryId: 'ENQ-1018', read: true),
    // Customer — Yuvaraj
    note('u_customer', NotificationEvent.quotationReceived, ago(h: 9), enquiryId: 'ENQ-1024',
        params: {'vendor': 'SecureVision Systems'}, route: '/quotation/q_2024_2'),
    note('u_customer', NotificationEvent.projectUpdated, ago(d: 1), enquiryId: 'ENQ-1015'),
    note('u_customer', NotificationEvent.paymentRecorded, ago(d: 4), enquiryId: 'ENQ-1015',
        params: {'amount': '30000'}, read: true),
    // Franchise — Lakshmi
    note('u_franchise', NotificationEvent.projectCreated, ago(d: 2), enquiryId: 'ENQ-1018'),
    note('u_franchise', NotificationEvent.commissionUpdated, ago(d: 10), enquiryId: 'ENQ-1009',
        params: {'amount': '24998'}, read: true, route: '/franchise/earnings'),
    // Admin
    note('u_admin', NotificationEvent.vendorRegistered, ago(h: 20),
        params: {'vendor': 'Bright Paints & Co'}, route: '/vendors/v_brightpaints'),
    note('u_admin', NotificationEvent.quotationCopy, ago(h: 3), enquiryId: 'ENQ-1026',
        params: {'number': 'QT-2026', 'vendor': 'Vedic Pooja Services'}),
    note('u_admin', NotificationEvent.enquiryWon, ago(d: 5), enquiryId: 'ENQ-1015', read: true),
  ];

  // ── Audit trail (activity timeline for each enquiry) ────────────────────
  final audit = <AuditEntry>[];
  var auditSeq = 0;
  void log(DateTime at, AuditAction action, String enquiryId,
      {String? user, UserRole? role, String? field, String? from, String? to, String? note,
      String type = 'enquiry', String? entityId}) {
    auditSeq++;
    audit.add(AuditEntry(
      id: 'a$auditSeq', at: at, userId: user, role: role, action: action, entityType: type,
      entityId: entityId ?? enquiryId, enquiryId: enquiryId, field: field, oldValue: from,
      newValue: to, note: note,
    ));
  }

  // Minor statuses are skipped in the seeded history unless they are current.
  const minor = {
    EnquiryStatus.verificationPending,
    EnquiryStatus.qualificationPending,
    EnquiryStatus.vendorMatching,
    EnquiryStatus.customerContact,
    EnquiryStatus.quotationPending,
    EnquiryStatus.paymentPending,
  };
  const mainFlow = [
    EnquiryStatus.newEnquiry,
    EnquiryStatus.verificationPending,
    EnquiryStatus.verified,
    EnquiryStatus.qualificationPending,
    EnquiryStatus.qualified,
    EnquiryStatus.vendorMatching,
    EnquiryStatus.vendorAssigned,
    EnquiryStatus.vendorAccepted,
    EnquiryStatus.customerContact,
    EnquiryStatus.appointmentScheduled,
    EnquiryStatus.appointmentCompleted,
    EnquiryStatus.quotationPending,
    EnquiryStatus.quotationSubmitted,
    EnquiryStatus.negotiation,
    EnquiryStatus.won,
    EnquiryStatus.projectCreated,
    EnquiryStatus.projectInProgress,
    EnquiryStatus.projectCompleted,
    EnquiryStatus.paymentPending,
    EnquiryStatus.paymentCollected,
    EnquiryStatus.commissionCalculated,
    EnquiryStatus.commissionSettled,
  ];

  for (final e in valued) {
    final List<EnquiryStatus> path;
    if (e.status == EnquiryStatus.rejected) {
      path = const [EnquiryStatus.newEnquiry, EnquiryStatus.rejected];
    } else if (e.status == EnquiryStatus.lost) {
      path = [
        ...mainFlow.takeWhile((s) => s != EnquiryStatus.negotiation).where((s) => !minor.contains(s)),
        EnquiryStatus.lost,
      ];
    } else {
      final end = mainFlow.indexOf(e.status);
      path = [
        for (var i = 0; i <= end; i++)
          if (!minor.contains(mainFlow[i]) || i == end) mainFlow[i],
      ];
    }
    final span = e.updatedAt.difference(e.createdAt);
    final creator = users.firstWhere((u) => u.id == e.createdByUserId);
    log(e.createdAt, AuditAction.created, e.id, user: creator.id, role: creator.role);
    for (var i = 1; i < path.length; i++) {
      final at = e.createdAt.add(span * (i / (path.length - 1)));
      final to = path[i];
      final (String? who, UserRole? role) = switch (to) {
        EnquiryStatus.vendorAccepted || EnquiryStatus.quotationSubmitted =>
          ('u_${assignments.firstWhere((a) => a.enquiryId == e.id).vendorId}', UserRole.vendor),
        EnquiryStatus.won => (users.firstWhere((u) => u.customerId == e.customerId,
                orElse: () => users.first).id, UserRole.customer),
        EnquiryStatus.commissionCalculated || EnquiryStatus.commissionSettled => (null, null),
        _ => (e.backOfficeId, UserRole.backOffice),
      };
      log(at, AuditAction.statusChanged, e.id,
          user: who, role: role, field: 'status', from: path[i - 1].name, to: to.name);
    }
  }
  // A few richer entries on the showcase enquiry.
  log(ago(d: 6), AuditAction.quotationSubmitted, 'ENQ-1024',
      user: 'u_v_securevision', role: UserRole.vendor, type: 'quotation', entityId: 'q_2024_1', note: 'QT-2024 v1');
  log(ago(d: 6), AuditAction.emailCopySent, 'ENQ-1024', type: 'quotation', entityId: 'q_2024_1',
      note: 'quotes@o2oboss.in');
  log(ago(d: 1, h: 4), AuditAction.revisionRequested, 'ENQ-1024',
      user: 'u_bo_divya', role: UserRole.backOffice, type: 'quotation', entityId: 'q_2024_1');
  log(ago(h: 10), AuditAction.quotationRevised, 'ENQ-1024',
      user: 'u_v_securevision', role: UserRole.vendor, type: 'quotation', entityId: 'q_2024_2', note: 'QT-2024 v2');
  log(ago(h: 9), AuditAction.quotationSent, 'ENQ-1024',
      user: 'u_bo_divya', role: UserRole.backOffice, type: 'quotation', entityId: 'q_2024_2');
  log(ago(h: 3), AuditAction.quotationSubmitted, 'ENQ-1026',
      user: 'u_v_vedic', role: UserRole.vendor, type: 'quotation', entityId: 'q_2026', note: 'QT-2026 v1');
  log(ago(h: 10), AuditAction.vendorRejected, 'ENQ-1023',
      user: 'u_v_tileworld', role: UserRole.vendor, type: 'assignment',
      note: 'We do not stock Somany tiles at the moment.');
  log(ago(h: 20), AuditAction.vendorApproved, 'none', user: 'u_admin', role: UserRole.admin,
      type: 'vendor', entityId: 'v_securevision', note: 'Documents verified');
  audit.sort((a, b) => a.at.compareTo(b.at));

  // ── Feedback & consent ──────────────────────────────────────────────────
  final feedback = [
    CustomerFeedback(id: 'fb1', enquiryId: 'ENQ-1003', projectId: 'PRJ-3001',
        customerId: 'c_yuvaraj', rating: 5,
        review: 'Neat installation and finished on time. The bill has come down a lot.',
        at: ago(d: 94)),
    CustomerFeedback(id: 'fb2', enquiryId: 'ENQ-1012', projectId: 'PRJ-3004',
        customerId: 'c_anitha', rating: 4, review: 'Good work. Slight delay on day one.',
        at: ago(d: 36)),
  ];
  final consents = [
    for (final u in users)
      ConsentRecord(id: 'cs_${u.id}', userId: u.id, action: ConsentAction.terms,
          policyVersion: 'v1.0', at: u.createdAt),
  ];

  return DbState(
    config: cfg,
    users: users,
    vendors: vendors,
    customers: customers,
    categories: seedCategories,
    products: seedProducts,
    brands: seedBrands,
    cities: seedCities,
    franchises: franchises,
    enquiries: valued,
    assignments: assignments,
    calls: calls,
    messages: messages,
    appointments: appointments,
    quotations: quotations,
    projects: projects,
    payments: payments,
    commissions: commissions,
    followUps: followUps,
    tasks: tasks,
    notifications: notifications,
    audit: audit,
    feedback: feedback,
    consents: consents,
    seq: {
      'enquiry': 1034,
      'quotation': 2027,
      'project': 3006,
      'appointment': aptSeq,
      'payment': 7006,
      'commission': comSeq,
      'call': callSeq,
      'msg': msgSeq,
      'notif': nSeq,
      'audit': auditSeq,
      'task': taskSeq,
      'followup': fuSeq,
      'assign': assignSeq,
      'user': 100,
      'vendor': 100,
      'customer': 100,
      'feedback': 10,
      'consent': 100,
    },
  );
}
