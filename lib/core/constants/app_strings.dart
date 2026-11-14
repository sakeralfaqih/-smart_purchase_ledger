/// نصوص ثابتة ومعلومات المشتري الثابتة.
class AppStrings {
  AppStrings._();

  static const String appName = 'حساب المورد';
  static const String appNameEn = 'Hisab Al-Mawrid';

  /// المشتري الثابت (صاحب المحل) — لا يُستخدم أبداً كاسم مورد.
  static const String ownerName = 'أبو ردمان أحمد عبده علي';
  static const List<String> ownerAliases = [
    'ابوردمان احمد عبده علي',
    'ابو ردمان احمد عبده علي',
    'ردمان احمد عبد علي',
    'أبو ردمان أحمد عبده علي',
    'ابو ردمان',
    'الزواقر',
  ];

  static const String currency = 'YER';
  static const String currencySymbol = 'ريال';

  // تسميات عامة
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String confirm = 'اعتماد';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String search = 'بحث';
  static const String retry = 'إعادة المحاولة';
  static const String loading = 'جارٍ التحميل...';

  // الشاشة الرئيسية
  static const String home = 'الرئيسية';
  static const String totalSupplierDebts = 'إجمالي الديون المستحقة للموردين';
  static const String mismatchedSuppliers = 'موردون لديهم فرق رصيد';
  static const String recentPriceAlerts = 'أحدث تنبيهات ارتفاع الأسعار';
  static const String scanPurchaseInvoice = 'تصوير فاتورة مشتريات';
  static const String scanReceiptVoucher = 'تصوير سند قبض / سداد';
  static const String globalSearchHint = 'ابحث في الأصناف، الموردين، أرقام الفواتير...';

  // المسح والمراجعة
  static const String reviewTitle = 'مراجعة البيانات المستخرجة';
  static const String supplier = 'المورد';
  static const String invoiceDate = 'التاريخ';
  static const String paymentType = 'نوع الدفع';
  static const String credit = 'آجل';
  static const String cash = 'نقدي';
  static const String partial = 'جزئي';
  static const String items = 'الأصناف';
  static const String lineNo = 'م';
  static const String itemName = 'اسم الصنف';
  static const String unit = 'الوحدة';
  static const String qty = 'الكمية';
  static const String freeQty = 'ك.مجانية';
  static const String unitPrice = 'سعر الوحدة';
  static const String lineTotal = 'الإجمالي';
  static const String singlePieceCost = 'تكلفة الحبة';
  static const String subtotal = 'الإجمالي قبل الخصم';
  static const String discount = 'الخصم';
  static const String extraCharges = 'الأعباء';
  static const String netTotal = 'الصافي';
  static const String printedPrevBalance = 'الرصيد السابق المطبوع';
  static const String printedCurrBalance = 'الرصيد الحالي المطبوع';
  static const String needsReview = 'يحتاج مراجعة';

  // الموردون
  static const String suppliers = 'الموردون';
  static const String supplierLedger = 'كشف الحساب';
  static const String supplierItems = 'الأصناف المشتراة';
  static const String balanceMatched = 'متطابق';
  static const String balanceMismatch = 'فرق رصيد';
  static const String exportStatementPdf = 'تصدير كشف الحساب PDF ومشاركته';
  static const String runningBalance = 'الرصيد التراكمي';

  // الأصناف والأسعار
  static const String priceMemory = 'ذاكرة الأسعار';
  static const String catalog = 'دليل الأصناف';
  static const String lastPurchasePrice = 'آخر سعر شراء';
  static const String lowestPurchasePrice = 'أقل سعر شراء';
  static const String suggestedRetailPrice = 'سعر البيع المقترح';
  static const String supplierComparison = 'مقارنة الموردين';
  static const String priceHistory = 'تطور السعر';

  // الإعدادات
  static const String settings = 'الإعدادات';
  static const String backup = 'النسخ الاحتياطي';
  static const String restore = 'استعادة';
  static const String biometricLock = 'قفل التطبيق بالبصمة';
  static const String offlineQueue = 'طابور الصور دون إنترنت';
  static const String backupToDrive = 'نسخ احتياطي إلى Google Drive';
  static const String restoreFromDrive = 'استعادة من Google Drive';

  // رسائل التحقق
  static const String mathWarning = 'تعارض رياضي في هذا السطر — تم استنتاج الكمية';
  static const String balanceMismatchAlert = 'تنبيه عدم تطابق الرصيد';
  static const String priceIncrease = 'ارتفاع السعر';
  static const String priceDecrease = 'انخفاض السعر';
  static const String priceSame = 'السعر مطابق';
}
