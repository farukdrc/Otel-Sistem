-- Hastane Otomasyonu Veritabanı
-- MySQL 8+ / MariaDB uyumlu
-- PK: Primary Key, FK: Foreign Key

CREATE DATABASE IF NOT EXISTS hastane_otomasyonu
  CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE hastane_otomasyonu;

CREATE TABLE poliklinikler (
    poliklinik_id INT AUTO_INCREMENT PRIMARY KEY,
    poliklinik_adi VARCHAR(100) NOT NULL UNIQUE,
    aciklama VARCHAR(255)
);

CREATE TABLE doktorlar (
    doktor_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(60) NOT NULL,
    soyad VARCHAR(60) NOT NULL,
    uzmanlik VARCHAR(100),
    telefon VARCHAR(20),
    poliklinik_id INT NOT NULL,
    CONSTRAINT fk_doktor_poliklinik
        FOREIGN KEY (poliklinik_id) REFERENCES poliklinikler(poliklinik_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_doktor_poliklinik (poliklinik_id)
);

CREATE TABLE hastalar (
    hasta_id INT AUTO_INCREMENT PRIMARY KEY,
    tc_kimlik_no CHAR(11) NOT NULL UNIQUE,
    ad VARCHAR(60) NOT NULL,
    soyad VARCHAR(60) NOT NULL,
    dogum_tarihi DATE,
    cinsiyet VARCHAR(20),
    telefon VARCHAR(20),
    adres VARCHAR(255)
);

CREATE TABLE laboratuvarlar (
    laboratuvar_id INT AUTO_INCREMENT PRIMARY KEY,
    laboratuvar_adi VARCHAR(100) NOT NULL UNIQUE,
    konum VARCHAR(100)
);

CREATE TABLE tahliller (
    tahlil_id INT AUTO_INCREMENT PRIMARY KEY,
    tahlil_adi VARCHAR(100) NOT NULL,
    aciklama VARCHAR(255),
    laboratuvar_id INT NOT NULL,
    CONSTRAINT fk_tahlil_laboratuvar
        FOREIGN KEY (laboratuvar_id) REFERENCES laboratuvarlar(laboratuvar_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_tahlil_laboratuvar (laboratuvar_id)
);

CREATE TABLE hemsireler (
    hemsire_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(60) NOT NULL,
    soyad VARCHAR(60) NOT NULL,
    telefon VARCHAR(20),
    servis_id INT NOT NULL
    -- servisler tablosu oluşturulduktan sonra FK aşağıda eklenir
);

CREATE TABLE servisler (
    servis_id INT AUTO_INCREMENT PRIMARY KEY,
    servis_adi VARCHAR(100) NOT NULL,
    kat_no VARCHAR(20),
    poliklinik_id INT NOT NULL,
    CONSTRAINT fk_servis_poliklinik
        FOREIGN KEY (poliklinik_id) REFERENCES poliklinikler(poliklinik_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_servis_poliklinik (poliklinik_id)
);

ALTER TABLE hemsireler
    ADD CONSTRAINT fk_hemsire_servis
    FOREIGN KEY (servis_id) REFERENCES servisler(servis_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

-- Hasta ↔ Poliklinik (N:M): muayene ilişkisi
CREATE TABLE hasta_muayeneleri (
    muayene_id INT AUTO_INCREMENT PRIMARY KEY,
    hasta_id INT NOT NULL,
    poliklinik_id INT NOT NULL,
    muayene_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notlar TEXT,
    CONSTRAINT fk_muayene_hasta
        FOREIGN KEY (hasta_id) REFERENCES hastalar(hasta_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_muayene_poliklinik
        FOREIGN KEY (poliklinik_id) REFERENCES poliklinikler(poliklinik_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_muayene_hasta (hasta_id),
    INDEX idx_muayene_poliklinik (poliklinik_id)
);

-- Hasta ↔ Tahlil (N:M): hastanın yaptırdığı tahliller
CREATE TABLE hasta_tahlilleri (
    hasta_tahlil_id INT AUTO_INCREMENT PRIMARY KEY,
    hasta_id INT NOT NULL,
    tahlil_id INT NOT NULL,
    istem_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sonuc TEXT,
    sonuc_tarihi DATETIME,
    durum VARCHAR(30) NOT NULL DEFAULT 'İstendi',
    CONSTRAINT fk_hasta_tahlil_hasta
        FOREIGN KEY (hasta_id) REFERENCES hastalar(hasta_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_hasta_tahlil_tahlil
        FOREIGN KEY (tahlil_id) REFERENCES tahliller(tahlil_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_hasta_tahlil_hasta (hasta_id),
    INDEX idx_hasta_tahlil_tahlil (tahlil_id)
);

-- Doktor ↔ Tahlil (N:M): doktorların istediği tahliller
CREATE TABLE doktor_tahlil_istemleri (
    doktor_tahlil_id INT AUTO_INCREMENT PRIMARY KEY,
    doktor_id INT NOT NULL,
    tahlil_id INT NOT NULL,
    istem_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aciklama VARCHAR(255),
    CONSTRAINT fk_doktor_tahlil_doktor
        FOREIGN KEY (doktor_id) REFERENCES doktorlar(doktor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_doktor_tahlil_tahlil
        FOREIGN KEY (tahlil_id) REFERENCES tahliller(tahlil_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_doktor_tahlil_doktor (doktor_id),
    INDEX idx_doktor_tahlil_tahlil (tahlil_id)
);
