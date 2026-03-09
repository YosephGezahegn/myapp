/// Supported languages for the app.
enum AppLanguage {
  english,
  amharic,
  oromiffa,
}

extension AppLanguageExtension on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.amharic:
        return 'am';
      case AppLanguage.oromiffa:
        return 'om';
    }
  }

  String get nativeName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.amharic:
        return 'አማርኛ';
      case AppLanguage.oromiffa:
        return 'Afaan Oromoo';
    }
  }

  String get flag {
    switch (this) {
      case AppLanguage.english:
        return '🇬🇧';
      case AppLanguage.amharic:
        return '🇪🇹';
      case AppLanguage.oromiffa:
        return '🇪🇹';
    }
  }
}

/// All UI strings keyed by a string ID, then by language.
class S {
  S._();

  static String get(String key, AppLanguage lang) {
    return _strings[key]?[lang] ?? _strings[key]?[AppLanguage.english] ?? key;
  }

  static final Map<String, Map<AppLanguage, String>> _strings = {
    // ── App Title ──────────────────────────────────────────────────────────
    'appTitle': {
      AppLanguage.english: 'EthioMotion',
      AppLanguage.amharic: 'ኢትዮሞሽን',
      AppLanguage.oromiffa: 'ItoMooshiin',
    },
    'appSubtitle': {
      AppLanguage.english: 'WORDS',
      AppLanguage.amharic: 'ቃላት',
      AppLanguage.oromiffa: 'JECHOOTAA',
    },
    'appTagline': {
      AppLanguage.english: 'Heads Up! Ethiopian Edition',
      AppLanguage.amharic: 'ራስ ላይ! የኢትዮጵያ እትም',
      AppLanguage.oromiffa: 'Mataa Irratti! Maxxansa Itoophiyaa',
    },

    // ── Home Screen ───────────────────────────────────────────────────────
    'play': {
      AppLanguage.english: 'PLAY',
      AppLanguage.amharic: 'ጫወት',
      AppLanguage.oromiffa: 'TAPHACHUU',
    },
    'howToPlay': {
      AppLanguage.english: 'How to Play',
      AppLanguage.amharic: 'እንዴት ይጫወቱ',
      AppLanguage.oromiffa: 'Akkamitti Taphatama',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.amharic: 'ቋንቋ',
      AppLanguage.oromiffa: 'Afaan',
    },

    // ── How to Play Steps ─────────────────────────────────────────────────
    'step1Title': {
      AppLanguage.english: 'Choose a category',
      AppLanguage.amharic: 'ምድብ ምረጡ',
      AppLanguage.oromiffa: 'Goosa filadhu',
    },
    'step1Desc': {
      AppLanguage.english:
          'Pick from Ethiopian food, cities, celebrities, and more!',
      AppLanguage.amharic: 'ከኢትዮጵያ ምግብ፣ ከተሞች፣ ታዋቂ ሰዎች እና ሌሎችም ይምረጡ!',
      AppLanguage.oromiffa:
          'Nyaata Itoophiyaa, magaalota, namoota beekamoo fi kanneen biroo keessaa filadhu!',
    },
    'step2Title': {
      AppLanguage.english: 'Hold phone on forehead',
      AppLanguage.amharic: 'ስልኩን ግንባር ላይ ያድርጉ',
      AppLanguage.oromiffa: 'Bilbila adda irratti qabi',
    },
    'step2Desc': {
      AppLanguage.english:
          'Place your phone on your forehead with the screen facing outward.',
      AppLanguage.amharic: 'ስልኩን ስክሪኑ ወደ ውጪ ሆኖ ግንባርዎ ላይ ያድርጉ።',
      AppLanguage.oromiffa:
          'Bilbila kee iskiriiniin isaa gara alaatti garagalee adda kee irratti kaa\'i.',
    },
    'step3Title': {
      AppLanguage.english: 'Friends give clues',
      AppLanguage.amharic: 'ጓደኞች ፍንጭ ይሰጣሉ',
      AppLanguage.oromiffa: 'Hiriyyonni mallattoo kennu',
    },
    'step3Desc': {
      AppLanguage.english:
          'Your friends describe the word on screen without saying it!',
      AppLanguage.amharic: 'ጓደኞችዎ ቃሉን ሳይናገሩ ይገልጻሉ!',
      AppLanguage.oromiffa:
          'Hiriyyonni kee jecha iskiriinii irratti argamu osoo hin jedhiin ibsu!',
    },
    'step4Title': {
      AppLanguage.english: 'Tilt to answer',
      AppLanguage.amharic: 'ለመመለስ ያናውጡ',
      AppLanguage.oromiffa: 'Deebiisuuf naanneessi',
    },
    'step4Desc': {
      AppLanguage.english: 'Tilt DOWN for correct ✓ | Tilt UP to skip ✗',
      AppLanguage.amharic: 'ለትክክል ወደ ታች ✓ | ለመዝለል ወደ ላይ ✗',
      AppLanguage.oromiffa: 'Sirrii ✓ gad naanneessi | Darbuu ✗ ol naanneessi',
    },

    // ── Category Selection ────────────────────────────────────────────────
    'chooseCategory': {
      AppLanguage.english: 'Choose Category',
      AppLanguage.amharic: 'ምድብ ይምረጡ',
      AppLanguage.oromiffa: 'Goosa Filadhu',
    },
    'roundDuration': {
      AppLanguage.english: 'Round Duration',
      AppLanguage.amharic: 'የጨዋታ ጊዜ',
      AppLanguage.oromiffa: 'Yeroo Taphaataa',
    },
    'tiltSensitivity': {
      AppLanguage.english: 'Tilt Sensitivity',
      AppLanguage.amharic: 'የማናወጥ ስሜት',
      AppLanguage.oromiffa: 'Miiraa Naannessuu',
    },
    'words': {
      AppLanguage.english: 'words',
      AppLanguage.amharic: 'ቃላት',
      AppLanguage.oromiffa: 'jechootaa',
    },

    // ── Sensitivity Labels ────────────────────────────────────────────────
    'low': {
      AppLanguage.english: 'Low',
      AppLanguage.amharic: 'ዝቅተኛ',
      AppLanguage.oromiffa: 'Gadi',
    },
    'medium': {
      AppLanguage.english: 'Medium',
      AppLanguage.amharic: 'መካከለኛ',
      AppLanguage.oromiffa: 'Giddugaleessa',
    },
    'high': {
      AppLanguage.english: 'High',
      AppLanguage.amharic: 'ከፍተኛ',
      AppLanguage.oromiffa: 'Ol-aanaa',
    },
    'veryHigh': {
      AppLanguage.english: 'Very High',
      AppLanguage.amharic: 'በጣም ከፍተኛ',
      AppLanguage.oromiffa: 'Baay\'ee Ol-aanaa',
    },

    // ── Countdown Screen ──────────────────────────────────────────────────
    'getReady': {
      AppLanguage.english: 'Get Ready!',
      AppLanguage.amharic: 'ተዘጋጁ!',
      AppLanguage.oromiffa: 'Of Jedhi!',
    },
    'holdForehead': {
      AppLanguage.english: 'Hold your phone on your forehead!',
      AppLanguage.amharic: 'ስልክዎን ግንባርዎ ላይ ያድርጉ!',
      AppLanguage.oromiffa: 'Bilbila kee adda kee irratti qabi!',
    },
    'tiltDown': {
      AppLanguage.english: 'Tilt DOWN',
      AppLanguage.amharic: 'ወደ ታች',
      AppLanguage.oromiffa: 'Gad Naanneessi',
    },
    'correct': {
      AppLanguage.english: 'Correct',
      AppLanguage.amharic: 'ትክክል',
      AppLanguage.oromiffa: 'Sirrii',
    },
    'tiltUp': {
      AppLanguage.english: 'Tilt UP',
      AppLanguage.amharic: 'ወደ ላይ',
      AppLanguage.oromiffa: 'Ol Naanneessi',
    },
    'skip': {
      AppLanguage.english: 'Skip',
      AppLanguage.amharic: 'ዝለል',
      AppLanguage.oromiffa: 'Darbi',
    },

    // ── Game Screen ───────────────────────────────────────────────────────
    'correctFeedback': {
      AppLanguage.english: 'CORRECT! ✓',
      AppLanguage.amharic: 'ትክክል! ✓',
      AppLanguage.oromiffa: 'SIRRII! ✓',
    },
    'skipFeedback': {
      AppLanguage.english: 'SKIP ✗',
      AppLanguage.amharic: 'ዝለል ✗',
      AppLanguage.oromiffa: 'DARBI ✗',
    },
    'motionSensorActive': {
      AppLanguage.english: 'Motion sensor active',
      AppLanguage.amharic: 'የእንቅስቃሴ ዳሳሽ ንቁ ነው',
      AppLanguage.oromiffa: 'Sensariin sochii hojii irra jira',
    },
    'motionSensorUnavailable': {
      AppLanguage.english: 'Motion sensor unavailable — use buttons',
      AppLanguage.amharic: 'የእንቅስቃሴ ዳሳሽ የለም — አዝራሮችን ይጠቀሙ',
      AppLanguage.oromiffa:
          'Sensariin sochii hin argamne — qaree fayyadami',
    },

    // ── Result Screen ─────────────────────────────────────────────────────
    'outstanding': {
      AppLanguage.english: 'Outstanding!',
      AppLanguage.amharic: 'እጅግ በጣም ጥሩ!',
      AppLanguage.oromiffa: 'Baay\'ee Gaarii!',
    },
    'wellDone': {
      AppLanguage.english: 'Well Done!',
      AppLanguage.amharic: 'በጣም ጥሩ!',
      AppLanguage.oromiffa: 'Gaarii!',
    },
    'goodTry': {
      AppLanguage.english: 'Good Try!',
      AppLanguage.amharic: 'ጥሩ ሙከራ!',
      AppLanguage.oromiffa: 'Yaalii Gaarii!',
    },
    'keepPracticing': {
      AppLanguage.english: 'Keep Practicing!',
      AppLanguage.amharic: 'መለማመድዎን ይቀጥሉ!',
      AppLanguage.oromiffa: 'Shaakala Itti Fufi!',
    },
    'accuracy': {
      AppLanguage.english: 'Accuracy',
      AppLanguage.amharic: 'ትክክለኛነት',
      AppLanguage.oromiffa: 'Sirrii ta\'uu',
    },
    'skipped': {
      AppLanguage.english: 'Skipped',
      AppLanguage.amharic: 'የተዘለለ',
      AppLanguage.oromiffa: 'Darbame',
    },
    'wordResults': {
      AppLanguage.english: 'Word Results',
      AppLanguage.amharic: 'የቃላት ውጤቶች',
      AppLanguage.oromiffa: 'Bu\'aa Jechootaa',
    },
    'playAgain': {
      AppLanguage.english: 'Play Again',
      AppLanguage.amharic: 'ዳግም ጫወት',
      AppLanguage.oromiffa: 'Irra Deebi\'ii Taphachuu',
    },
    'home': {
      AppLanguage.english: 'Home',
      AppLanguage.amharic: 'ዋና ገጽ',
      AppLanguage.oromiffa: 'Fuula Duraa',
    },
  };
}
