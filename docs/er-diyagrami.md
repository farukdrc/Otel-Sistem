# Hastane Otomasyonu – ER Diyagramı

Bu diyagram, ödevde verilen yedi temel varlığı ve ilişkileri gösterir. Hasta–Tahlil ve Doktor–Tahlil N:M ilişkileri, hangi doktorun hangi hasta için hangi tahlili istediğini de saklayan `TAHLIL_ISTEMLERI` işlem tablosu üzerinden çözülmüştür.

```mermaid
erDiagram
    POLIKLINIKLER ||--o{ DOKTORLAR : "calisir"
    HASTALAR ||--o{ HASTA_MUAYENELERI : "muayene olur"
    POLIKLINIKLER ||--o{ HASTA_MUAYENELERI : "muayene yapar"
    HASTALAR ||--o{ TAHLIL_ISTEMLERI : "icin istenir"
    DOKTORLAR ||--o{ TAHLIL_ISTEMLERI : "ister"
    TAHLILLER ||--o{ TAHLIL_ISTEMLERI : "talep edilir"
    LABORATUVARLAR ||--o{ TAHLILLER : "gerceklestirir"
    POLIKLINIKLER ||--o{ SERVISLER : "aittir"
    SERVISLER ||--o{ HEMSIRELER : "calisir"

    POLIKLINIKLER {
        int poliklinik_id PK
        string poliklinik_adi
        string aciklama
    }
    DOKTORLAR {
        int doktor_id PK
        string ad
        string soyad
        string uzmanlik
        int poliklinik_id FK
    }
    HASTALAR {
        int hasta_id PK
        string tc_kimlik_no
        string ad
        string soyad
        date dogum_tarihi
        string telefon
    }
    LABORATUVARLAR {
        int laboratuvar_id PK
        string laboratuvar_adi
        string konum
    }
    TAHLILLER {
        int tahlil_id PK
        string tahlil_adi
        int laboratuvar_id FK
    }
    SERVISLER {
        int servis_id PK
        string servis_adi
        string kat_no
        int poliklinik_id FK
    }
    HEMSIRELER {
        int hemsire_id PK
        string ad
        string soyad
        int servis_id FK
    }
    HASTA_MUAYENELERI {
        int muayene_id PK
        int hasta_id FK
        int poliklinik_id FK
        datetime muayene_tarihi
    }
    TAHLIL_ISTEMLERI {
        int tahlil_istemi_id PK
        int hasta_id FK
        int doktor_id FK
        int tahlil_id FK
        datetime istem_tarihi
        datetime numune_alinma_tarihi
        string sonuc
        datetime sonuc_tarihi
        string durum
    }
```

## İlişki özeti

| İlişki | Tür | Uygulama |
|---|---|---|
| Poliklinik–Doktor | 1:N | `doktorlar.poliklinik_id` |
| Hasta–Poliklinik | N:M | `hasta_muayeneleri` |
| Hasta–Tahlil | N:M | `tahlil_istemleri` üzerinden |
| Doktor–Tahlil | N:M | `tahlil_istemleri` üzerinden |
| Laboratuvar–Tahlil | 1:N | `tahliller.laboratuvar_id` |
| Servis–Hemşire | 1:N | `hemsireler.servis_id` |
| Poliklinik–Servis | 1:N | `servisler.poliklinik_id` |

## Tahlil ilişkisinin nasıl çalıştığı

- `tahlil_istemleri.hasta_id`, tahlilin hangi hasta için istendiğini belirtir.
- `tahlil_istemleri.doktor_id`, tahlili isteyen doktoru belirtir.
- `tahlil_istemleri.tahlil_id`, istenen tahlil türünü belirtir.
- `sonuc`, `sonuc_tarihi`, `numune_alinma_tarihi` ve `durum` alanları sürecin ve sonucun izlenmesini sağlar.
- Aynı hasta aynı tahlili farklı tarihlerde yeniden yaptırabilir; her istek ayrı bir `tahlil_istemi_id` kaydıdır.
- Bir doktor farklı hastalara ve farklı tahlillere istek oluşturabilir. Her istek yalnızca bir hastaya, bir doktora ve bir tahlil türüne bağlanır.

## Diğer tasarım notları

- Bir doktor yalnızca bir polikliniğe bağlıdır; bir poliklinikte birden fazla doktor olabilir.
- Her tahlil türü tek bir laboratuvara bağlıdır.
- Her hemşire tek bir servise bağlıdır.
- Her servis tek bir polikliniğe bağlıdır.
- Aynı hasta farklı tarihlerde aynı poliklinikte yeniden muayene olabileceği için muayene tablosunda ayrı bir `muayene_id` kullanılmıştır.
