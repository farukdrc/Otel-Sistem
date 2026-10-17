# Hastane Otomasyonu – Veritabanı Tasarımı

Bu depo, ders sonu ödevi kapsamında hastane otomasyonu için varlık-ilişki modelini ve ilişkisel veritabanı tablolarını içerir.

## Kapsam

Varlıklar: Hasta, Doktor, Poliklinik, Laboratuvar, Tahlil, Hemşire ve Servis.

- Poliklinik–Doktor: 1:N
- Hasta–Poliklinik: N:M
- Hasta–Tahlil: N:M
- Doktor–Tahlil: N:M
- Laboratuvar–Tahlil: 1:N
- Servis–Hemşire: 1:N
- Poliklinik–Servis: 1:N

## Dosyalar

- `database/schema.sql`: MySQL uyumlu tablo oluşturma komutları.
- `docs/er-diyagrami.md`: Mermaid ile ER diyagramı.

## Kurulum

1. MySQL veya MariaDB üzerinde bir veritabanı oluşturun.
2. `database/schema.sql` dosyasını çalıştırın.
3. Diyagramı GitHub Markdown görüntüleyicisinde `docs/er-diyagrami.md` dosyasından inceleyin.

## Tasarım notu

N:M ilişkiler ara tablolarla çözülmüştür. 1:N ilişkilerde yabancı anahtar, ilişkinin N tarafındaki tabloda tutulur. Bu çalışma ödevde verilen ilişkileri temel alır.