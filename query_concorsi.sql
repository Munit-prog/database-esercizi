
-- i candidati che si sono candidati a tutti i bandi del concorso 
-- con id_concorso='C1'

SELECT C.CODICE_FISCALE
FROM CANDIDATO C
WHERE NOT EXISTS (SELECT *
FROM BANDO B
WHERE B.CONCORSO = 'C1' AND NOT EXISTS(SELECT *
FROM CANDIDATURA CA
WHERE CA.CONCORSO=B.CONCORSO AND CA.PROFILO=B.PROFILO AND
C.CODICE_FISCALE = CA.CANDIDATO));

--le coppie di candidati distinti che si sono candidati esattamente
--allo stesso insieme di bandi, indipendentemente dall'esito
SELECT A.CODICE_FISCALE, B.CODICE_FISCALE
FROM CANDIDATO A, CANDIDATO B
WHERE A.CODICE_FISCALE<B.CODICE_FISCALE AND NOT EXISTS (
SELECT CONCORSO, PROFILO
FROM CANDIDATURA CA2
WHERE CA2.CANDIDATO = A.CODICE_FISCALE
EXCEPT
SELECT CONCORSO, PROFILO
FROM CANDIDATURA CA 
WHERE CA.CANDIDATO =B.CODICE_FISCALE)
AND NOT EXISTS(SELECT CONCORSO, PROFILO
FROM CANDIDATURA CA1
WHERE CA1.CANDIDATO=B.CODICE_FISCALE
EXCEPT
SELECT CONCORSO, PROFILO
FROM CANDIDATURA CA3
WHERE CA3.CANDIDATO=A.CODICE_FISCALE);

--i candidati che hanno ricevuto esito 'ammesso' in almeno una 
--candidatura ma non sono stati respinti in nessuna candidatura
SELECT C.CODICE_FISCALE
FROM CANDIDATO C
WHERE EXISTS (SELECT *
FROM CANDIDATURA CA
WHERE CA.CANDIDATO=C.CODICE_FISCALE AND CA.ESITO='ammesso'
AND NOT EXISTS (SELECT *
FROM CANDIDATURA CA2
WHERE CA2.CANDIDATO=C.CODICE_FISCALE AND CA2.ESITO ='respinto'
));
--i bandi i cui candidati sono solo residenti nella stessa regione
--(tutte le candidature di quel bando provengono da candidati di
--un'unica regione)
SELECT B.CONCORSO, B.PROFILO
FROM BANDO B
WHERE EXISTS (SELECT *
FROM CANDIDATURA K
WHERE K.CONCORSO=B.CONCORSO AND K.PROFILO=B.PROFILO AND
NOT EXISTS(SELECT *
FROM CANDIDATO C, CANDIDATO C1, CANDIDATURA CA, CANDIDATURA CA1
WHERE C.CODICE_FISCALE=CA.CANDIDATO AND
C1.CODICE_FISCALE = CA1.CANDIDATO AND
B.CONCORSO=CA.CONCORSO AND B.PROFILO=CA.PROFILO AND
B.CONCORSO=CA1.CONCORSO AND B.PROFILO = CA1.PROFILO AND
C.REGIONE_RESIDENZA <> C1.REGIONE_RESIDENZA));

--i concorsi per cui non esiste alcuna candidatura inviata prima di
--una certa data (es. prima del 01/03/2026

--i candidati che si sono candidati solo a bandi del concorso 'C1'
--e a nessun altro concorso

--i profili (intesi come bandi) presi da tutti i candidati che hanno
-- almeno una candidatura 'ammesso'

--le coppie di candidati distinti che non hanno nessun bando in 
--comune
