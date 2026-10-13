import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

enum AppLanguage { english, hindi }

class TranslationService {
  TranslationService._internal();
  static final TranslationService instance = TranslationService._internal();

  final ValueNotifier<AppLanguage> currentLanguageNotifier =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  OnDeviceTranslator? _translatorEnHi;
  OnDeviceTranslator? _translatorHiEn;

  final Map<String, String> _translationCache = {};
  bool _isDownloadingModel = false;

  AppLanguage get currentLanguage => currentLanguageNotifier.value;
  bool get isHindi => currentLanguage == AppLanguage.hindi;
  bool get isDownloadingModel => _isDownloadingModel;

  final Map<String, String> _dictionaryEnToHi = const {
    'My Profile': 'मेरी प्रोफाइल',
    'Account & Orders': 'खाता और ऑर्डर',
    'My Orders': 'मेरे ऑर्डर',
    'Already 12 orders placed': '12 ऑर्डर दिए जा चुके हैं',
    'Delivery Addresses': 'डिलीवरी पते',
    'Ranchi, Jharkhand - 834001': 'राँची, झारखंड - 834001',
    'My Wallet': 'मेरा वॉलेट',
    'Balance: ₹1,250.00 • Add Money': 'बैलेंस: ₹1,250.00 • पैसे जोड़ें',
    'Payment Methods': 'भुगतान के तरीके',
    'UPI, Credit/Debit Cards': 'यूपीआई, क्रेडिट/डेबिट कार्ड',
    'Settings & Preferences': 'सेटिंग्स और प्राथमिकताएं',
    'App Language': 'ऐप की भाषा',
    'English / हिंदी': 'अंग्रेज़ी / हिंदी',
    'Wishlist': 'विशलिस्ट',
    'Your saved items': 'आपके सहेजे गए सामान',
    'Notifications': 'सूचनाएं',
    'Offers, Order updates': 'ऑफ़र, ऑर्डर अपडेट',
    'Help & Support': 'सहायता और सहायता',
    '24x7 Customer support': '24x7 ग्राहक सेवा',
    'About Super Value': 'सुपर वैल्यू के बारे में',
    'Terms, Privacy Policy': 'नियम, गोपनीयता नीति',
    'LOGOUT': 'लॉगआउट',
    'Logout': 'लॉगआउट',
    'Are you sure you want to log out?': 'क्या आप लॉगआउट करना चाहते हैं?',
    'Cancel': 'रद्द करें',
    'Ujjwal Kumar': 'उज्ज्वल कुमार',
    'Super Value Market v1.0.0': 'सुपर वैल्यू मार्केट v1.0.0',
    'Select App Language': 'ऐप की भाषा चुनें',
    'English': 'English (अंग्रेज़ी)',
    'Hindi': 'हिंदी (Hindi)',
    'Using Google ML Kit Translation': 'गूगल एमएल किट अनुवाद का उपयोग',
  };

  Future<void> initTranslator() async {
    try {
      final modelManager = OnDeviceTranslatorModelManager();
      final bool isDownloaded = await modelManager
          .isModelDownloaded(TranslateLanguage.hindi.bcpCode);

      if (!isDownloaded) {
        _isDownloadingModel = true;
        await modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
        _isDownloadingModel = false;
      }

      _translatorEnHi = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: TranslateLanguage.hindi,
      );

      _translatorHiEn = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.hindi,
        targetLanguage: TranslateLanguage.english,
      );
    } catch (e) {
      debugPrint('ML Kit Translation Init Exception: $e');
      _isDownloadingModel = false;
    }
  }

  Future<void> changeLanguage(AppLanguage language) async {
    if (currentLanguageNotifier.value == language) return;

    if (language == AppLanguage.hindi && _translatorEnHi == null) {
      await initTranslator();
    }

    currentLanguageNotifier.value = language;
  }

  Future<String> translate(String text) async {
    if (currentLanguage == AppLanguage.english || text.trim().isEmpty) {
      return text;
    }

    if (_dictionaryEnToHi.containsKey(text)) {
      return _dictionaryEnToHi[text]!;
    }

    if (_translationCache.containsKey(text)) {
      return _translationCache[text]!;
    }

    if (_translatorEnHi != null) {
      try {
        final String translated = await _translatorEnHi!.translateText(text);
        _translationCache[text] = translated;
        return translated;
      } catch (e) {
        debugPrint('ML Kit Translate Error: $e');
      }
    }

    return text;
  }

  String tr(String text) {
    if (currentLanguage == AppLanguage.english) return text;
    if (_dictionaryEnToHi.containsKey(text)) return _dictionaryEnToHi[text]!;
    if (_translationCache.containsKey(text)) return _translationCache[text]!;
    return text;
  }
}
