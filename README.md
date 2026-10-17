# Hastane Otomasyonu – Veritabanı Tasarımı

Bu depo, ders sonu ödevi kapsamında hastane otomasyonu için varlık-ilişki modelini ve ilişkisel veritabanı tablolarını içerir. Çalışma ER diyagramı ve veritabanı şemasıyla sınırlıdır; çalışan bir otomasyon uygulaması içermez.

## Kapsam

Temel varlıklar: Hasta, Doktor, Poliklinik, Laboratuvar, Tahlil, Hemşire ve Servis.

- Poliklinik–Doktor: 1:N
- Hasta–Poliklinik: N:M, `hasta_muayeneleri` ara tablosuyla
- Hasta–Tahlil: N:M, `tahlil_istemleri` üzerinden
- Doktor–Tahlil: N:M, `tahlil_istemleri` üzerinden
- Laboratuvar–Tahlil: 1:N
- Servis–Hemşire: 1:N
- Poliklinik–Servis: 1:N

## Dosyalar

- `database/schema.sql`: MySQL/MariaDB uyumlu tablo oluşturma komutları.
- `docs/er-diyagrami.md`: Mermaid ile ER diyagramı ve ilişki açıklamaları.

## Kurulum

1. MySQL veya MariaDB üzerinde `database/schema.sql` dosyasını çalıştırın.
2. Diyagramı GitHub Markdown görüntüleyicisinde `docs/er-diyagrami.md` dosyasından inceleyin.

## Tahlil ilişkisinin tasarımı

`tahlil_istemleri` tablosu aynı kayıtta hasta, doktor ve tahlil türünü yabancı anahtarlarla birbirine bağlar. Böylece hangi doktorun hangi hasta için hangi tahlili istediği kaydedilir; durum ve sonuç bilgileri de aynı isteğe bağlı tutulur. Bu yaklaşım, doktor talebi ile hastanın tahlil sonucunun birbiriyle karışmasını engeller.

N:M ilişkiler ara tablolarla/işlem tablolarıyla çözülür. 1:N ilişkilerde yabancı anahtar, ilişkinin N tarafındaki tabloda tutulur.
