# Hastane Otomasyonu – ER Diyagramı

Aşağıdaki diyagram, ödevde verilen yedi varlığı ve ilişkileri gösterir. N:M ilişkiler ilişkisel tablolar tasarlanırken ara tablolarla çözülür.

```mermaid
erDiagram
    POLIKLINIKLER ||--o{ DOKTORLAR : "calisir"
    HASTALAR ||--o{ HASTA_MUAYENELERI : "muayene olur"
    POLIKLINIKLER ||--o{ HASTA_MUAYENELERI : "muayene yapar"
    HASTALAR ||--o{ HASTA_TAHLILLERI : "tahlil yaptirir"
    TAHLILLER ||--o{ HASTA_TAHLILLERI : "hasta tahlili"
    DOKTORLAR ||--o{ DOKTOR_TAHLIL_ISTEMLERI : "ister"
    TAHLILLER ||--o{ DOKTOR_TAHLIL_ISTEMLERI : "istenir"
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
    HASTA_TAHLILLERI {
        int hasta_tahlil_id PK
        int hasta_id FK
        int tahlil_id FK
        string durum
    }
    DOKTOR_TAHLIL_ISTEMLERI {
        int doktor_tahlil_id PK
        int doktor_id FK
        int tahlil_id FK
        datetime istem_tarihi
    }
```

## İlişki özeti

| İlişki | Tür | Uygulama |
|---|---|---|
| Poliklinik–Doktor | 1:N | `doktorlar.poliklinik_id` |
| Hasta–Poliklinik | N:M | `hasta_muayeneleri` |
| Hasta–Tahlil | N:M | `hasta_tahlilleri` |
| Doktor–Tahlil | N:M | `doktor_tahlil_istemleri` |
| Laboratuvar–Tahlil | 1:N | `tahliller.laboratuvar_id` |
| Servis–Hemşire | 1:N | `hemsireler.servis_id` |
| Poliklinik–Servis | 1:N | `servisler.poliklinik_id` |

## Önemli tasarım notu

- Bir doktor yalnızca bir polikliniğe bağlıdır; bir poliklinikte birden fazla doktor olabilir.
- Her tahlil tek bir laboratuvara bağlıdır.
- Her hemşire tek bir servise bağlıdır.
- Her servis tek bir polikliniğe bağlıdır.
- Aynı hasta farklı tarihlerde aynı poliklinikte yeniden muayene olabileceği için muayene tablosunda ayrı bir `muayene_id` kullanılmıştır.
- Doktorun istediği tahlil ile hastanın yaptırdığı tahlil ayrı ilişki tablolarında tutulmuştur. Gerçek bir sistemde bu iki ilişki, ayrıca bir tahlil istemi/işlem kaydı üzerinden ilişkilendirilebilir.
