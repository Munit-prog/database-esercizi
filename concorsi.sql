-- ============================================================
--  Popolamento base di dati: CONCORSI e CANDIDATURE
--  PostgreSQL  -  riesehuibile (drop + create + insert)
-- ============================================================

DROP TABLE IF EXISTS Candidatura CASCADE;
DROP TABLE IF EXISTS Bando      CASCADE;
DROP TABLE IF EXISTS Candidato  CASCADE;
DROP TABLE IF EXISTS Concorso   CASCADE;

-- ------------------------------------------------------------
--  SCHEMA
-- ------------------------------------------------------------

CREATE TABLE Concorso (
    id_concorso       VARCHAR(10)  PRIMARY KEY,
    ente              VARCHAR(60)  NOT NULL,
    titolo            VARCHAR(120) NOT NULL,
    data_bando        DATE         NOT NULL,
    data_scadenza     DATE         NOT NULL,
    posti_disponibili INTEGER      NOT NULL CHECK (posti_disponibili >= 0),
    CHECK (data_scadenza >= data_bando)
);

CREATE TABLE Bando (
    concorso                VARCHAR(10)  NOT NULL,
    profilo                 VARCHAR(40)  NOT NULL,
    titolo_studio_richiesto VARCHAR(40)  NOT NULL,
    num_candidati           INTEGER      NOT NULL DEFAULT 0 CHECK (num_candidati >= 0),
    PRIMARY KEY (concorso, profilo),
    FOREIGN KEY (concorso) REFERENCES Concorso(id_concorso)
);

CREATE TABLE Candidato (
    codice_fiscale    VARCHAR(16)  PRIMARY KEY,
    nome              VARCHAR(40)  NOT NULL,
    cognome           VARCHAR(40)  NOT NULL,
    data_nascita      DATE         NOT NULL,
    regione_residenza VARCHAR(40)  NOT NULL,
    titolo_studio     VARCHAR(40)  NOT NULL
);

CREATE TABLE Candidatura (
    concorso   VARCHAR(10) NOT NULL,
    profilo    VARCHAR(40) NOT NULL,
    candidato  VARCHAR(16) NOT NULL,
    data_invio DATE        NOT NULL,
    esito      VARCHAR(10) CHECK (esito IN ('ammesso','respinto')),  -- NULL = non valutata
    punteggio  INTEGER     CHECK (punteggio IS NULL OR punteggio BETWEEN 0 AND 100),
    PRIMARY KEY (concorso, profilo, candidato),
    FOREIGN KEY (concorso, profilo) REFERENCES Bando(concorso, profilo),
    FOREIGN KEY (candidato)         REFERENCES Candidato(codice_fiscale)
);

-- NOTA: il vincolo "data_invio <= data_scadenza del concorso" e' inter-relazionale
--       (data_scadenza sta in Concorso, non in Candidatura) quindi non e' esprimibile
--       con un semplice CHECK: richiederebbe un trigger. I dati sotto lo rispettano.

-- ------------------------------------------------------------
--  DATI: CONCORSO
-- ------------------------------------------------------------

INSERT INTO Concorso (id_concorso, ente, titolo, data_bando, data_scadenza, posti_disponibili) VALUES
('C1', 'Comune di Milano',   'Concorso personale 2026',        '2026-01-10', '2026-02-28', 12),
('C2', 'Regione Lombardia',  'Concorso amministrativi 2026',   '2026-01-15', '2026-03-31',  8),
('C3', 'ASL Roma',           'Concorso tecnici sanitari 2026', '2026-02-01', '2026-04-30',  5),
('C4', 'Ministero Interno',  'Concorso dirigenti 2026',        '2026-02-15', '2026-05-31',  3);

-- ------------------------------------------------------------
--  DATI: BANDO
--  C1 ha 3 profili, C2 ne ha 2, C3 ne ha 1, C4 ne ha 1 (senza candidature)
-- ------------------------------------------------------------

INSERT INTO Bando (concorso, profilo, titolo_studio_richiesto, num_candidati) VALUES
('C1', 'amministrativo', 'Diploma',           5),
('C1', 'tecnico',        'Laurea Triennale',  4),
('C1', 'informatico',    'Laurea Magistrale', 2),
('C2', 'amministrativo', 'Diploma',           3),
('C2', 'tecnico',        'Laurea Triennale',  1),
('C3', 'tecnico',        'Laurea Triennale',  2),
('C4', 'dirigente',      'Laurea Magistrale', 0);

-- ------------------------------------------------------------
--  DATI: CANDIDATO
-- ------------------------------------------------------------

INSERT INTO Candidato (codice_fiscale, nome, cognome, data_nascita, regione_residenza, titolo_studio) VALUES
('CF001', 'Mario',  'Rossi',  '1990-03-12', 'Lombardia', 'Laurea Magistrale'),
('CF002', 'Luigi',  'Bianchi','1988-07-25', 'Lombardia', 'Laurea Triennale'),
('CF003', 'Anna',   'Verdi',  '1992-11-03', 'Lazio',     'Diploma'),
('CF004', 'Sara',   'Neri',   '1995-01-30', 'Lombardia', 'Laurea Magistrale'),
('CF005', 'Paolo',  'Gialli', '1991-06-18', 'Lazio',     'Laurea Triennale'),
('CF006', 'Elena',  'Blu',    '1993-09-09', 'Campania',  'Diploma'),
('CF007', 'Marco',  'Viola',  '1989-12-22', 'Lombardia', 'Laurea Magistrale'),
('CF008', 'Chiara', 'Rosa',   '1994-04-14', 'Lazio',     'Diploma');

-- ------------------------------------------------------------
--  DATI: CANDIDATURA
--  esito NULL = candidatura non ancora valutata; punteggio NULL = non assegnato
-- ------------------------------------------------------------

INSERT INTO Candidatura (concorso, profilo, candidato, data_invio, esito, punteggio) VALUES
-- CF001: tutti i 3 bandi di C1 + un bando di C2
('C1', 'amministrativo', 'CF001', '2026-02-01', 'ammesso',  85),
('C1', 'tecnico',        'CF001', '2026-02-02', 'respinto', 40),
('C1', 'informatico',    'CF001', '2026-02-03', 'ammesso',  90),
('C2', 'amministrativo', 'CF001', '2026-03-05', NULL,       NULL),

-- CF002: tutti e 3 i bandi di C1 (e nient'altro); una candidatura non valutata
('C1', 'amministrativo', 'CF002', '2026-02-05', 'ammesso',  70),
('C1', 'tecnico',        'CF002', '2026-02-06', 'ammesso',  75),
('C1', 'informatico',    'CF002', '2026-02-07', NULL,       NULL),

-- CF003: solo 2 dei 3 bandi di C1
('C1', 'amministrativo', 'CF003', '2026-02-10', 'respinto', 50),
('C1', 'tecnico',        'CF003', '2026-02-11', 'ammesso',  60),

-- CF004: {C1-amministrativo, C2-amministrativo}
('C1', 'amministrativo', 'CF004', '2026-02-12', 'ammesso',  88),
('C2', 'amministrativo', 'CF004', '2026-03-10', 'ammesso',  92),

-- CF007: stesso identico insieme di bandi di CF004
('C1', 'amministrativo', 'CF007', '2026-02-13', NULL,       NULL),
('C2', 'amministrativo', 'CF007', '2026-03-11', 'ammesso',  80),

-- CF005: solo C2 e C3 (nessun bando di C1)
('C2', 'tecnico',        'CF005', '2026-03-15', 'ammesso',  65),
('C3', 'tecnico',        'CF005', '2026-03-20', NULL,       NULL),

-- CF006: un solo bando, in C3
('C3', 'tecnico',        'CF006', '2026-04-01', 'respinto', 30),

-- CF008: un solo bando, in C1
('C1', 'tecnico',        'CF008', '2026-02-20', 'respinto', 45);

-- NB: il concorso C4 (bando 'dirigente') non ha alcuna candidatura.

-- ============================================================
--  Controlli rapidi (facoltativi)
-- ============================================================
-- SELECT concorso, profilo, COUNT(*) FROM Candidatura GROUP BY concorso, profilo;
-- SELECT * FROM Bando ORDER BY concorso, profilo;
