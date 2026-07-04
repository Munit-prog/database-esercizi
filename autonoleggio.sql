-- =====================================================================
--  BASE DI DATI: AUTONOLEGGIO
--  Schema + popolamento (PostgreSQL)
-- =====================================================================

DROP TABLE IF EXISTS Noleggio CASCADE;
DROP TABLE IF EXISTS Auto     CASCADE;
DROP TABLE IF EXISTS Cliente  CASCADE;
DROP TABLE IF EXISTS Filiale  CASCADE;

CREATE TABLE Filiale (
    id_filiale  INTEGER      PRIMARY KEY,
    citta       VARCHAR(50)  NOT NULL,
    indirizzo   VARCHAR(80)  NOT NULL,
    telefono    VARCHAR(20)  NOT NULL,
    UNIQUE (citta, indirizzo),      -- chiave candidata
    UNIQUE (telefono)               -- chiave candidata
);

CREATE TABLE Auto (
    targa                 CHAR(7)      PRIMARY KEY,
    modello               VARCHAR(40)  NOT NULL,
    categoria             VARCHAR(20)  NOT NULL,
    anno_immatricolazione INTEGER      NOT NULL,
    id_filiale            INTEGER      NOT NULL REFERENCES Filiale(id_filiale)
);

CREATE TABLE Cliente (
    id_cliente      INTEGER      PRIMARY KEY,
    nome            VARCHAR(40)  NOT NULL,
    cognome         VARCHAR(40)  NOT NULL,
    codice_fiscale  CHAR(16)     NOT NULL UNIQUE,   -- chiave candidata
    num_patente     VARCHAR(20)  NOT NULL UNIQUE,   -- chiave candidata
    email           VARCHAR(60)  NOT NULL UNIQUE    -- chiave candidata
);

CREATE TABLE Noleggio (
    targa           CHAR(7)   NOT NULL REFERENCES Auto(targa),
    id_cliente      INTEGER   NOT NULL REFERENCES Cliente(id_cliente),
    data_ritiro     DATE      NOT NULL,
    data_riconsegna DATE,                 -- NULL = ancora in corso
    km_percorsi     INTEGER,
    valutazione     INTEGER,              -- 1..5, NULL = non valutato
    PRIMARY KEY (targa, data_ritiro)      -- un'auto non esce due volte lo stesso giorno
);

-- ---------------------------------------------------------------- FILIALI
INSERT INTO Filiale VALUES
 (1, 'Milano',  'Via Roma 1',           '02-1110000'),
 (2, 'Milano',  'Corso Buenos Aires 50','02-2220000'),
 (3, 'Roma',    'Via Nazionale 10',     '06-3330000'),
 (4, 'Torino',  'Via Po 5',             '011-4440000'),
 (5, 'Bologna', 'Via Rizzoli 3',        '051-5550000');

-- ---------------------------------------------------------------- AUTO
INSERT INTO Auto VALUES
 ('AA111AA', 'Fiat Panda',        'utilitaria', 2020, 1),
 ('BB222BB', 'VW Golf',           'berlina',    2021, 1),
 ('CC333CC', 'Hyundai Tucson',    'SUV',        2022, 1),
 ('DD444DD', 'Fiat 500',          'utilitaria', 2019, 2),
 ('EE555EE', 'Alfa Giulia',       'berlina',    2023, 2),
 ('FF666FF', 'Audi Q5',           'SUV',        2021, 3),
 ('GG777GG', 'Mazda MX5',         'sportiva',   2022, 3),
 ('HH888HH', 'Toyota Yaris',      'utilitaria', 2020, 4),
 ('II999II', 'BMW Serie 3',       'berlina',    2018, 4),
 ('JJ000JJ', 'Porsche Cayman',    'sportiva',   2023, 5),
 ('KK111KK', 'VW Touran',         'monovolume', 2019, 5),
 ('LL222LL', 'Dacia Duster',      'SUV',        2020, 2);   -- mai noleggiata

-- ---------------------------------------------------------------- CLIENTI
INSERT INTO Cliente VALUES
 (1, 'Mario',  'Rossi',   'RSSMRA80A01F205X', 'PAT001', 'mario.rossi@mail.it'),
 (2, 'Luigi',  'Verdi',   'VRDLGU85B02F205Y', 'PAT002', 'luigi.verdi@mail.it'),
 (3, 'Anna',   'Bianchi', 'BNCNNA90C41H501Z', 'PAT003', 'anna.bianchi@mail.it'),
 (4, 'Elena',  'Neri',    'NRELNE92D42L219W', 'PAT004', 'elena.neri@mail.it'),
 (5, 'Paolo',  'Gialli',  'GLLPLA88E05G273Q', 'PAT005', 'paolo.gialli@mail.it'),
 (6, 'Sara',   'Blu',     'BLUSRA95F45A662R', 'PAT006', 'sara.blu@mail.it'),      -- non ha mai noleggiato
 (7, 'Giulia', 'Ferrari', 'FRRGLI93H50D612T', 'PAT007', 'giulia.ferrari@mail.it');

-- ---------------------------------------------------------------- NOLEGGI
INSERT INTO Noleggio VALUES
 ('AA111AA', 1, '2024-01-10', '2024-01-15',  500, 5),
 ('BB222BB', 1, '2024-02-01', '2024-02-05',  800, 4),
 ('CC333CC', 1, '2024-03-01', '2024-03-10', 1200, 5),
 ('GG777GG', 1, '2024-04-01', '2024-04-03',  300, 5),
 ('KK111KK', 1, '2024-05-01',  NULL,         NULL, NULL),   -- in corso
 ('AA111AA', 1, '2024-06-01', '2024-06-02',  150, 3),       -- stessa auto, altra data
 ('DD444DD', 1, '2024-07-01', '2024-07-03',  200, 4),
 ('DD444DD', 2, '2024-01-20', '2024-01-25',  400, 4),
 ('EE555EE', 2, '2024-02-10', '2024-02-12',  250, 3),
 ('FF666FF', 2, '2024-03-15', '2024-03-20',  900, 5),
 ('II999II', 2, '2024-06-10', '2024-06-12',  100, 3),
 ('CC333CC', 2, '2024-07-20', '2024-07-25',  500, 4),
 ('GG777GG', 3, '2024-04-10', '2024-04-12',  200, 4),
 ('JJ000JJ', 3, '2024-05-10', '2024-05-15',  600, 5),
 ('BB222BB', 4, '2024-02-20', '2024-02-25',  700, 4),
 ('FF666FF', 4, '2024-04-20',  NULL,         NULL, NULL),   -- in corso
 ('EE555EE', 4, '2024-05-20', '2024-05-22',  200, NULL),    -- concluso, non valutato
 ('HH888HH', 5, '2024-03-05', '2024-03-08',  350, 2),       -- unico noleggio di Paolo
 ('FF666FF', 7, '2024-08-01', '2024-08-05',  400, 4),
 ('CC333CC', 7, '2024-09-01', '2024-09-05',  600, 5);
