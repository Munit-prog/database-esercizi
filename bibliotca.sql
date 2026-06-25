DROP TABLE IF EXISTS Prestito CASCADE;
DROP TABLE IF EXISTS Libro    CASCADE;
DROP TABLE IF EXISTS Lettore  CASCADE;
DROP TABLE IF EXISTS Autore   CASCADE;

CREATE TABLE Autore (
    id_autore    VARCHAR(8)  PRIMARY KEY,
    nome         VARCHAR(60) NOT NULL,
    nazionalita  VARCHAR(40) NOT NULL,
    anno_nascita INTEGER     NOT NULL
);

CREATE TABLE Libro (
    isbn               VARCHAR(8)   PRIMARY KEY,
    titolo             VARCHAR(120) NOT NULL,
    id_autore          VARCHAR(8)   NOT NULL REFERENCES Autore(id_autore),
    genere             VARCHAR(30)  NOT NULL,
    anno_pubblicazione INTEGER      NOT NULL
);

CREATE TABLE Lettore (
    tessera     VARCHAR(8)  PRIMARY KEY,
    nome        VARCHAR(40) NOT NULL,
    cognome     VARCHAR(40) NOT NULL,
    citta       VARCHAR(40) NOT NULL,
    corso_studi VARCHAR(40) NOT NULL
);

CREATE TABLE Prestito (
    isbn              VARCHAR(8) NOT NULL REFERENCES Libro(isbn),
    tessera           VARCHAR(8) NOT NULL REFERENCES Lettore(tessera),
    data_prestito     DATE       NOT NULL,
    data_restituzione DATE,
    valutazione       INTEGER    CHECK (valutazione BETWEEN 1 AND 10),
    PRIMARY KEY (isbn, tessera),
    CHECK (data_restituzione IS NULL OR data_restituzione >= data_prestito)
);

INSERT INTO Autore VALUES
('A1','Italo Calvino','Italiana',1923),
('A2','Jorge Luis Borges','Argentina',1899),
('A3','Ursula K. Le Guin','Statunitense',1929),
('A4','Haruki Murakami','Giapponese',1949);

INSERT INTO Libro VALUES
('L1','Il barone rampante','A1','Romanzo',1957),
('L2','Le citta invisibili','A1','Romanzo',1972),
('L3','Lezioni americane','A1','Saggio',1988),
('L4','Finzioni','A2','Racconti',1944),
('L5','L''Aleph','A2','Racconti',1949),
('L6','La mano sinistra del buio','A3','Fantascienza',1969),
('L7','I reietti dell''altro pianeta','A3','Fantascienza',1974),
('L8','Norwegian Wood','A4','Romanzo',1987),
('L9','Kafka sulla spiaggia','A4','Romanzo',2002);

INSERT INTO Lettore VALUES
('T01','Marco','Rossi','Milano','Informatica'),
('T02','Giulia','Bianchi','Milano','Lettere'),
('T03','Luca','Verdi','Roma','Informatica'),
('T04','Sara','Neri','Milano','Fisica'),
('T05','Anna','Gialli','Torino','Lettere'),
('T06','Paolo','Blu','Roma','Fisica'),
('T07','Elena','Viola','Milano','Informatica');

INSERT INTO Prestito VALUES
('L1','T01','2026-01-10','2026-01-20',9),
('L2','T01','2026-01-25','2026-02-10',8),
('L3','T01','2026-02-05',NULL,NULL),
('L6','T01','2026-03-10',NULL,NULL),
('L1','T02','2026-01-15','2026-02-01',7),
('L2','T02','2026-02-20',NULL,NULL),
('L4','T02','2026-03-05','2026-03-20',6),
('L4','T03','2026-01-12','2026-01-30',8),
('L5','T03','2026-02-15','2026-03-01',3),
('L1','T04','2026-03-15',NULL,NULL),
('L8','T04','2026-03-20',NULL,NULL),
('L8','T05','2026-03-25','2026-04-05',10),
('L6','T06','2026-01-08','2026-01-25',9),
('L7','T06','2026-02-02',NULL,2),
('L8','T07','2026-03-12','2026-03-30',8);
