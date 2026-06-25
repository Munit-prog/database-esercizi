DROP TABLE IF EXISTS Visione  CASCADE;
DROP TABLE IF EXISTS Serie    CASCADE;
DROP TABLE IF EXISTS Abbonato CASCADE;
DROP TABLE IF EXISTS Rete     CASCADE;

CREATE TABLE Rete (
    id_rete         VARCHAR(8)  PRIMARY KEY,
    nome            VARCHAR(60) NOT NULL,
    paese           VARCHAR(40) NOT NULL,
    anno_fondazione INTEGER     NOT NULL
);

CREATE TABLE Serie (
    codice      VARCHAR(8)   PRIMARY KEY,
    titolo      VARCHAR(120) NOT NULL,
    id_rete     VARCHAR(8)   NOT NULL REFERENCES Rete(id_rete),
    genere      VARCHAR(30)  NOT NULL,
    anno_uscita INTEGER      NOT NULL
);

CREATE TABLE Abbonato (
    username VARCHAR(8)  PRIMARY KEY,
    nome     VARCHAR(40) NOT NULL,
    cognome  VARCHAR(40) NOT NULL,
    citta    VARCHAR(40) NOT NULL,
    piano    VARCHAR(10) NOT NULL
);

CREATE TABLE Visione (
    codice      VARCHAR(8) NOT NULL REFERENCES Serie(codice),
    username    VARCHAR(8) NOT NULL REFERENCES Abbonato(username),
    data_inizio DATE       NOT NULL,
    data_fine   DATE,
    voto        INTEGER    CHECK (voto BETWEEN 1 AND 10),
    PRIMARY KEY (codice, username),
    CHECK (data_fine IS NULL OR data_fine >= data_inizio)
);

INSERT INTO Rete VALUES
('R1','Atlas Studios','Statunitense',1998),
('R2','Nordlys','Norvegese',2010),
('R3','Mediterranea','Italiana',2005),
('R4','Sakura Films','Giapponese',2001);

INSERT INTO Serie VALUES
('S1','Codice Rosso','R1','Thriller',2018),
('S2','Oltre il Confine','R1','Thriller',2020),
('S3','Lezioni di Storia','R1','Documentario',2021),
('S4','Fiordi','R2','Drama',2019),
('S5','Luce del Nord','R2','Drama',2022),
('S6','Vicolo Corto','R3','Commedia',2017),
('S7','Estate a Roma','R3','Commedia',2023),
('S8','Mecha Dawn','R4','Animazione',2016),
('S9','Petali','R4','Animazione',2024);

INSERT INTO Abbonato VALUES
('U01','Marco','Rossi','Milano','Premium'),
('U02','Giulia','Bianchi','Milano','Free'),
('U03','Luca','Verdi','Roma','Premium'),
('U04','Sara','Neri','Milano','Free'),
('U05','Anna','Gialli','Torino','Premium'),
('U06','Paolo','Blu','Roma','Free'),
('U07','Elena','Viola','Milano','Premium');

INSERT INTO Visione VALUES
('S1','U01','2026-01-10','2026-01-20',9),
('S2','U01','2026-01-25','2026-02-10',8),
('S3','U01','2026-02-05',NULL,NULL),
('S6','U01','2026-03-10',NULL,NULL),
('S1','U02','2026-01-15','2026-02-01',7),
('S2','U02','2026-02-20',NULL,NULL),
('S4','U02','2026-03-05','2026-03-20',6),
('S4','U03','2026-01-12','2026-01-30',8),
('S5','U03','2026-02-15','2026-03-01',3),
('S1','U04','2026-03-15',NULL,NULL),
('S8','U04','2026-03-20',NULL,NULL),
('S8','U05','2026-03-25','2026-04-05',10),
('S6','U06','2026-01-08','2026-01-25',9),
('S7','U06','2026-02-02',NULL,2),
('S8','U07','2026-03-12','2026-03-30',8);
