#!/usr/bin/env python3
import os, re

# Anchor key + translations for all 18 languages.
TRANS = {
    "english_language.dart":     ("Live customer support",         "Send us a message and our team will get back to you as soon as possible.",                       "Type a message..."),
    "arabic_language.dart":      ("الدعم المباشر للعملاء",        "أرسل لنا رسالة وسيرد عليك فريقنا في أقرب وقت ممكن.",                                              "اكتب رسالة..."),
    "bangali_language.dart":     ("লাইভ গ্রাহক সহায়তা",            "আমাদের একটি বার্তা পাঠান, আমাদের দল যত দ্রুত সম্ভব আপনার সাথে যোগাযোগ করবে।",                       "একটি বার্তা টাইপ করুন..."),
    "chinese_language.dart":     ("在线客户支持",                   "给我们发送消息,我们的团队会尽快回复您。",                                                            "输入消息..."),
    "french_language.dart":      ("Support client en direct",      "Envoyez-nous un message et notre équipe vous répondra dès que possible.",                       "Tapez un message..."),
    "german_language.dart":      ("Live-Kundensupport",            "Schicken Sie uns eine Nachricht und unser Team meldet sich so schnell wie möglich bei Ihnen.",  "Nachricht eingeben..."),
    "hindi_language.dart":       ("लाइव ग्राहक सहायता",            "हमें संदेश भेजें और हमारी टीम जल्द से जल्द आपसे संपर्क करेगी।",                                  "संदेश लिखें..."),
    "indonesian_language.dart":  ("Dukungan pelanggan langsung",   "Kirim pesan dan tim kami akan segera membalas Anda.",                                            "Ketik pesan..."),
    "italian_language.dart":     ("Supporto clienti dal vivo",     "Inviaci un messaggio e il nostro team ti risponderà al più presto.",                            "Scrivi un messaggio..."),
    "korean_language.dart":      ("실시간 고객 지원",                 "메시지를 보내주시면 저희 팀이 최대한 빨리 답변 드리겠습니다.",                                              "메시지 입력..."),
    "portuguese_language.dart":  ("Suporte ao cliente ao vivo",    "Envie-nos uma mensagem e nossa equipe entrará em contato assim que possível.",                  "Digite uma mensagem..."),
    "russian_language.dart":     ("Онлайн-поддержка клиентов",     "Отправьте нам сообщение, и наша команда ответит вам как можно скорее.",                         "Введите сообщение..."),
    "spanish_language.dart":     ("Soporte al cliente en vivo",    "Envíanos un mensaje y nuestro equipo te responderá lo antes posible.",                          "Escribe un mensaje..."),
    "swahili_language.dart":     ("Msaada wa moja kwa moja kwa wateja", "Tutumie ujumbe na timu yetu itakujibu haraka iwezekanavyo.",                              "Andika ujumbe..."),
    "tamil_language.dart":       ("நேரடி வாடிக்கையாளர் ஆதரவு",      "எங்களுக்கு செய்தி அனுப்பவும், எங்கள் குழு கூடிய விரைவில் உங்களைத் தொடர்பு கொள்ளும்.",       "செய்தியைத் தட்டச்சு செய்யவும்..."),
    "telugu_language.dart":      ("లైవ్ కస్టమర్ సపోర్ట్",          "మాకు సందేశం పంపండి, మా బృందం వీలైనంత త్వరగా మీకు తిరిగి సమాధానం ఇస్తుంది.",                         "సందేశం టైప్ చేయండి..."),
    "turkish_language.dart":     ("Canlı müşteri desteği",         "Bize bir mesaj gönderin, ekibimiz en kısa sürede size geri dönecektir.",                         "Mesaj yazın..."),
    "urdu_language.dart":        ("لائیو کسٹمر سپورٹ",             "ہمیں پیغام بھیجیں اور ہماری ٹیم جلد از جلد آپ سے رابطہ کرے گی۔",                              "پیغام لکھیں..."),
}

DIR = "c:/Users/chonsa/Documents/waxxapp/waxx_app/lib/localization/language"
NEW_KEYS = ["supportEmptyTitle", "supportEmptySubtitle", "supportComposeHint"]

for fname, vals in TRANS.items():
    path = os.path.join(DIR, fname)
    with open(path, "r", encoding="utf-8") as f:
        src = f.read()
    if all(k in src for k in NEW_KEYS):
        print(f"{fname}: already has keys, skipping")
        continue
    # Insert after the helpAndSupport line.
    pattern = re.compile(r'(\s*"helpAndSupport"\s*:\s*"[^"]*"\s*,\s*\n)')
    insertion = "".join([f'  "{k}": "{v}",\n' for k, v in zip(NEW_KEYS, vals)])
    new_src, n = pattern.subn(lambda m: m.group(1) + insertion, src, count=1)
    if n == 0:
        print(f"{fname}: helpAndSupport anchor not found, skipping")
        continue
    with open(path, "w", encoding="utf-8") as f:
        f.write(new_src)
    print(f"{fname}: inserted {len(NEW_KEYS)} keys")
