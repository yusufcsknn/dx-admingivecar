# dxadmingivecar

# 🚔 DX Admin Give Car

**DX Development** tarafından hazırlanmış, ESX & QBCore uyumlu, modern UI destekli admin araç verme scripti.

---

## ✨ Özellikler

- 🔑 Admin paneli üzerinden oyunculara araç verme
- 🎨 UI üzerinden **renk seçici** desteği
- 🚗 Araç **kalıcı** olarak DB’ye kaydedilir
- 🔧 ESX & QBCore uyumlu (otomatik algılama)
- 🗝️ Anahtar sistemi desteği (qb-vehiclekeys, esx_vehiclelock)
- 📦 ACE permission kontrolü (`dxadmingivecar.use`)
- 🌐 Discord webhook loglama (config.lua üzerinden)

---

## 🛠️ Kurulum

1. Dosyaları `resources/[dx]/dx-admingivecar` içine atın.
2. `server.cfg` içine ekleyin
3. `config.lua` dosyasında **Discord webhook URL** girin:
4. ACE permission ayarlayın (sadece adminler kullanabilsin): add_ace group.admin dxadmingivecar.use allow
