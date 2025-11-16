# App Store Yükleme Talimatları

## ✅ Tamamlanan Ayarlar

### 1. Proje Ayarları
- ✅ Bundle Identifier: `com.fastingjourney.app`
- ✅ Display Name: **Fasting Journey**
- ✅ Version: **1.0.0** (Build: 1)
- ✅ Deployment Target: **iOS 16.0**
- ✅ Swift Version: **5.0**
- ✅ Category: **Healthcare & Fitness**
- ✅ Supported Devices: **iPhone only (Portrait)**

### 2. Info.plist İzinleri
- ✅ Notifications (Bildirimler)
- ✅ Location (Konum - Eve yaklaşma bildirimleri için)
- ✅ Calendar (Takvim - Akıllı oruç önerileri için)
- ✅ Health (Sağlık - İsteğe bağlı)
- ✅ Encryption Declaration (ITSAppUsesNonExemptEncryption: false)

### 3. App Icon
- ✅ 1024x1024 Marketing Icon
- ✅ Tüm iPhone boyutları (40x40, 60x60, 58, 87, 80, 120, 180)

## 📱 TestFlight'a Yükleme Adımları

### Adım 1: Xcode'da Proje Ayarları
1. Xcode'da projeyi açın
2. Sol panelden **FastingJourney** projesini seçin
3. **Signing & Capabilities** sekmesine gidin
4. **Team** kısmına Apple Developer hesabınızı seçin
5. **Automatically manage signing** işaretli olmalı

### Adım 2: Archive Oluşturma
1. Xcode'da üst menüden **Product → Destination → Any iOS Device (arm64)** seçin
2. **Product → Clean Build Folder** yapın (⇧⌘K)
3. **Product → Archive** seçin (⌘⇧B sonra Archive)
4. Archive işlemi 2-5 dakika sürebilir

### Adım 3: TestFlight'a Yükleme
1. Archive penceresi açılınca **Distribute App** butonuna tıklayın
2. **App Store Connect** seçin → Next
3. **Upload** seçin → Next
4. **Automatically manage signing** seçin → Next
5. Özet ekranını kontrol edin → **Upload** tıklayın
6. Yükleme 5-10 dakika sürebilir

### Adım 4: App Store Connect Ayarları
1. [App Store Connect](https://appstoreconnect.apple.com) giriş yapın
2. **My Apps** → **+** (Plus) → **New App** tıklayın
3. Bilgileri doldurun:
   - **Platform**: iOS
   - **Name**: Fasting Journey
   - **Primary Language**: Turkish
   - **Bundle ID**: com.fastingjourney.app
   - **SKU**: fastingjourney-001
   - **User Access**: Full Access

### Adım 5: App Bilgileri
**App Information:**
- **Category**: Health & Fitness
- **Secondary Category**: Lifestyle (isteğe bağlı)
- **Content Rights**: Size ait içerik

**Pricing:**
- **Price**: Free (Ücretsiz)

**App Privacy:**
- Location: "Eve yaklaşma hatırlatmaları için"
- Calendar: "Akıllı oruç programı önerileri için"
- Health: "Sağlık verileriyle entegrasyon (isteğe bağlı)"

### Adım 6: Version Bilgileri

**What's New (Yenilikler):**
```
İlk sürüm! 🎉

✨ Özellikler:
• Kişiselleştirilmiş oruç programları (12/12, 14/10, 16/8, 18/6, 20/4, 24h)
• Gerçek zamanlı kalori yakım takibi
• Akıllı bildirimler (Aşama, kalori, su hatırlatıcıları)
• Oruç aşamaları ve vücut değişimleri bilgisi
• Su takibi ve hatırlatmaları
• Kilo takibi ve grafikler
• İlerleme ve başarı takibi
• Takvim entegrasyonu - Akıllı program önerileri
• Konum bazlı hatırlatmalar
• CoreData ile güvenli veri saklama
```

**Description (Açıklama):**
```
Fasting Journey - Bilimsel Oruç Takip Uygulaması 🌱

Intermittent fasting (aralıklı oruç) yolculuğunuzda yanınızdayız! Sağlıklı yaşam ve kilo yönetimi için profesyonel oruç takip uygulaması.

🎯 TEMEL ÖZELLİKLER

✅ 6 Farklı Oruç Programı
• 12/12 Başlangıç
• 14/10 Günlük
• 16/8 Klasik (En popüler)
• 18/6 İleri seviye
• 20/4 Warrior (Savaşçı)
• 24 Saat OMAD

🔥 Kalori Yakım Takibi
• Gerçek zamanlı kalori hesaplama
• Yağ yakım oranı gösterimi
• Ketozis durumu bildirimi
• Bilimsel Mifflin-St Jeor formülü

⏰ Akıllı Bildirimler
• Oruç aşama bildirimleri (4h, 8h, 12h, 16h)
• Ketozis moduna giriş uyarısı
• Su içme hatırlatmaları
• Geri sayım bildirimleri (1h, 30dk, 15dk, 5dk)

📊 Detaylı Takip
• Oruç geçmişi ve istatistikler
• Kilo takibi ve grafikler
• Su tüketimi takibi
• Başarı seviyeleri ve rozetler
• Seri (streak) takibi

🧬 Bilimsel Yaklaşım
• Vücudun oruç aşamaları
• Metabolik değişimler
• Otofaji ve hücre yenilenmesi
• Sağlık ipuçları

📅 Akıllı Özellikler
• Takvim entegrasyonu
• Günlük programınıza göre oruç önerileri
• Eve yaklaşma hatırlatmaları
• Kişiselleştirilmiş motivasyon mesajları

🎨 Modern Tasarım
• Kolay kullanım
• Göz yormayan arayüz
• Detaylı grafikler ve görseller
• Türkçe dil desteği

💪 Sağlık ve Fitness
• Kilo yönetimi
• Metabolizma hızlandırma
• Enerji artışı
• Zihinsel netlik

NEDEN FASTING JOURNEY?
• Tamamen ücretsiz
• Reklamsız deneyim
• Gizlilik odaklı (verileriniz cihazınızda)
• Bilimsel temelli yaklaşım
• Düzenli güncellemeler

NOT: Bu uygulama tıbbi tavsiye yerine geçmez. Sağlık durumunuz varsa doktorunuza danışın.

İyi oruclar! 🌟
```

**Keywords (Anahtar Kelimeler):**
```
oruç,intermittent fasting,aralıklı oruç,diyet,kilo verme,sağlık,fitness,kalori,keto,ketozis
```

**Screenshots Gereksinimleri:**
- **6.7" Display**: 1290 x 2796 (iPhone 15 Pro Max)
- **5.5" Display**: 1242 x 2208 (iPhone 8 Plus)

En az 3, en fazla 10 screenshot gerekli.

### Adım 7: TestFlight
1. Build işleme alındıktan sonra (Processing) bekleyin
2. **TestFlight** sekmesine gidin
3. **Internal Testing** altında test grubu oluşturun
4. **External Testing** için beta inceleme gönderin (isteğe bağlı)

## ⚠️ Önemli Notlar

### Team ID
Xcode'da **Signing & Capabilities** kısmında Apple Developer hesabınızı seçmelisiniz:
- Apple Developer Program üyeliği gereklidir ($99/yıl)
- Team ID otomatik olarak atanacak

### Bundle Identifier
`com.fastingjourney.app` - Bu benzersiz olmalı. Eğer başka biri kullanıyorsa değiştirmeniz gerekir:
- Örnek: `com.yourname.fastingjourney`
- Xcode → Project → Signing → Bundle Identifier'dan değiştirebilirsiniz

### Eksportlar
Eğer "Export Compliance" hatası alırsanız:
- Info.plist'te `ITSAppUsesNonExemptEncryption` zaten `false` olarak ayarlandı
- Bu uygulama şifreleme kullanmıyor

### Privacy
App Store Review için hazır:
- ✅ Tüm izin açıklamaları eklendi
- ✅ Veri toplama yok
- ✅ Reklam yok
- ✅ In-App Purchase yok

## 🚀 Hızlı Kontrol Listesi

- [ ] Apple Developer hesabı aktif
- [ ] Xcode'da Team seçildi
- [ ] Archive başarılı
- [ ] Upload başarılı
- [ ] App Store Connect'te app oluşturuldu
- [ ] Version bilgileri girildi
- [ ] Screenshots hazırlandı
- [ ] TestFlight'a yüklendi
- [ ] Test yapıldı
- [ ] Review için gönderildi

## 📞 Sorun Giderme

**"No signing certificate found"**
→ Xcode → Preferences → Accounts → Download Manual Profiles

**"Bundle Identifier already exists"**
→ Bundle ID'yi değiştirin (project.pbxproj'de PRODUCT_BUNDLE_IDENTIFIER)

**"Missing Compliance"**
→ Info.plist'te ITSAppUsesNonExemptEncryption zaten var

**"Invalid Icon"**
→ Assets.xcassets/AppIcon.appiconset'te icon'lar var, kontrol edin

## 📧 İletişim

Sorularınız için:
- App Store Connect Support
- Apple Developer Forums
- developer.apple.com/support

---

**Hazırlayan**: GitHub Copilot
**Tarih**: 15 Kasım 2025
**Versiyon**: 1.0.0
