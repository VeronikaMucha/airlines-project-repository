 Przygotować treść pytań oraz odpowiedzi do własnej  bazy danych    
  1.- 2 podzapytanie zwykłe w warunku where – 2p
  2.- 2  podzapytanie zwykłe z podzapytaniem w klauzuli from -2p
  3.- 2 podzapytania zwykłe w warunku having  - 2p
  4.- 2 podzapytania skorelowane z podzapytaniem w klauzuli where  - 2p
  5.- 1 podzapytanie skorelowane z podzapytaniem w warunku having    - 2p

--Komentarz  
1-ok; 
1b-zła koncepcja każdy rejs ma przecież jeden model samolotu, Dlaczego skorelowane????
2a-- dla każdej rezerwacji a nie pasażera = ok 
2b- co to liczy? 
3a, 3b - ok 
4a, 4b - ok ale bez korelacji--- zamiast 1ai1b 
5 - ok, ale bez korelacji-- jak w 3ai3b--0p


--1. Wypisać numery telefonów pasażerów, których rezerwacja ma inny status niż pasażera o imieniu ‘Astra’.
SELECT imie, nazwisko, num_tel
FROM pasazer p, rezerwacjas999822 r
WHERE p.pesel = r.pasazer_pesel AND r.status != (SELECT rez.status
                                                FROM rezerwacjas999822 rez, pasazer pas
                                                WHERE  pas.pesel = rez.pasazer_pesel
                                                AND pas.imie = 'Astra'); 
 
--1b++. Podaj model samolotu w którym ilość miejsc mniejsza niż średnia ilość miejsc we wszystkich samolotach. 
SELECT s.model, s.ilosc_miejsc
FROM samolot s
WHERE s.ilosc_miejsc < 
(SELECT AVG(sa.ilosc_miejsc)
FROM samolot sa);



--2.a Dla każdj rezerwacji wypisać imię pasazera i cenę biletu dodatkowo dodając średnią cenę za  bilet na ten Rejs.
SELECT p.imie,r.rejs_numer, r.cena_biletu, sriednia_cena
FROM pasazer p, rezerwacjas999822 r, (SELECT rejs_numer, round(avg(cena_biletu),2) sriednia_cena 
FROM rezerwacjas999822 
GROUP BY rejs_numer) xx
WHERE p.pesel = r.pasazer_pesel AND r.rejs_numer = xx.rejs_numer;

--2.b Oblicz procentową ilość ludzi dla każdego rejsu.(liczy na którym rejsie ile pocentów rezerwacji w calej awiakompanii)
SELECT a.rejs_numer "Rejs",
100*a.Liczba_pasazerow/b.Liczba_pasazerow AS "%Ludzi na rejsie"
FROM
(SELECT rejs_numer, COUNT(pasazer_pesel) AS Liczba_pasazerow
FROM rezerwacjas999822
GROUP BY rejs_numer) a, 
(SELECT COUNT(pasazer_pesel) AS Liczba_pasazerow
FROM rezerwacjas999822) b;

--3.Wybrać numery rejsów, których średnią cena za bilet przekracza średnią cenę za bilet  rejsu o numerze ‘ 1LK-5625 ’.
SELECT r.rejs_numer, AVG(r.cena_biletu) AS "Sriednia cena biletu"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING AVG(r.cena_biletu) > (SELECT AVG(re.cena_biletu)
                            FROM rezerwacjas999822 re
                            WHERE rejs_numer = '1LK-5625'
                            GROUP BY rejs_numer);

--3 Wypisać rejs który ma największa liczbę pasażerów.
SELECT rejs_numer, count(pasazer_pesel)
FROM rezerwacjas999822
GROUP BY rejs_numer
HAVING COUNT(pasazer_pesel)=
(SELECT MAX(COUNT(pasazer_pesel))
FROM rezerwacjas999822
GROUP BY rejs_numer)

--4. Znaleźć pasażerów, w których cena za bilet jest powyżej średniej.
SELECT p.imie, p.nazwisko, re.cena_biletu, re.rejs_numer
FROM pasazer p, rezerwacjas999822 re
WHERE p.pesel = re.pasazer_pesel AND cena_biletu > (SELECT AVG(r.cena_biletu)
                    FROM rezerwacjas999822 r);
                    
--4. Podaj model samolotu w którym ilość miejsc mniejsza niż średnia ilość miejsc we wszystkich samolotach. 
SELECT s.model, s.ilosc_miejsc
FROM samolot s
WHERE s.ilosc_miejsc < 
(SELECT AVG(sa.ilosc_miejsc)
FROM samolot sa);

--+4a Dla każdego rejsu wypisać pasażera który ma najdrożczy bilet.
SELECT r.rejs_numer, imie, nazwisko, cena_biletu
FROM pasazer p INNER JOIN rezerwacjas999822 r on p.pesel = r.pasazer_pesel 
WHERE cena_biletu = (SELECT MAX(cena_biletu)
FROM rezerwacjas999822 re
WHERE re.rejs_numer = r.rejs_numer)

--4.b)Dla każdego samolotu znaleść paszaera który ma ostatnie miejsce(od piwerwszego do ostatniego po numeram) w samolocie 

--5.Znaleść rejs na którym ilość pasażerów jest mniejsza niż na rejsie 'SD5131'
SELECT r.rejs_numer, count(r.pasazer_pesel) AS "liczba pasażerów"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING COUNT(r.cena_biletu) < (SELECT count(re.pasazer_pesel)
                            FROM rezerwacjas999822 re
                            WHERE rejs_numer = 'SD5131'
                            GROUP BY rejs_numer);


--5.Znaleść rejsu znal na którym ilość pasażerów jest najmniejsza

SELECT r.rejs_numer, count(r.pasazer_pesel) AS "liczba pasażerów"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING COUNT(r.cena_biletu) < (SELECT count(re.pasazer_pesel)
                            FROM rezerwacjas999822 re
                            WHERE re. Przygotować treść pytań oraz odpowiedzi do własnej  bazy danych    
  1.- 2 podzapytanie zwykłe w warunku where – 2p
  2.- 2  podzapytanie zwykłe z podzapytaniem w klauzuli from -2p
  3.- 2 podzapytania zwykłe w warunku having  - 2p
  4.- 2 podzapytania skorelowane z podzapytaniem w klauzuli where  - 2p
  5.- 1 podzapytanie skorelowane z podzapytaniem w warunku having    - 2p

--Komentarz  
1-ok; 
1b-zła koncepcja każdy rejs ma przecież jeden model samolotu, Dlaczego skorelowane????
2a-- dla każdej rezerwacji a nie pasażera = ok 
2b- co to liczy? 
3a, 3b - ok 
4a, 4b - ok ale bez korelacji--- zamiast 1ai1b 
5 - ok, ale bez korelacji-- jak w 3ai3b--0p


--1. Wypisać numery telefonów pasażerów, których rezerwacja ma inny status niż pasażera o imieniu ‘Astra’.
SELECT imie, nazwisko, num_tel
FROM pasazer p, rezerwacjas999822 r
WHERE p.pesel = r.pasazer_pesel AND r.status != (SELECT rez.status
                                                FROM rezerwacjas999822 rez, pasazer pas
                                                WHERE  pas.pesel = rez.pasazer_pesel
                                                AND pas.imie = 'Astra'); 
 
--1b++. Podaj model samolotu w którym ilość miejsc mniejsza niż średnia ilość miejsc we wszystkich samolotach. 
SELECT s.model, s.ilosc_miejsc
FROM samolot s
WHERE s.ilosc_miejsc < 
(SELECT AVG(sa.ilosc_miejsc)
FROM samolot sa);



--2.a Dla każdj rezerwacji wypisać imię pasazera i cenę biletu dodatkowo dodając średnią cenę za  bilet na ten Rejs.
SELECT p.imie,r.rejs_numer, r.cena_biletu, sriednia_cena
FROM pasazer p, rezerwacjas999822 r, (SELECT rejs_numer, round(avg(cena_biletu),2) sriednia_cena 
FROM rezerwacjas999822 
GROUP BY rejs_numer) xx
WHERE p.pesel = r.pasazer_pesel AND r.rejs_numer = xx.rejs_numer;

--2.b Oblicz procentową ilość ludzi dla każdego rejsu.(liczy na którym rejsie ile pocentów rezerwacji w calej awiakompanii)
SELECT a.rejs_numer "Rejs",
100*a.Liczba_pasazerow/b.Liczba_pasazerow AS "%Ludzi na rejsie"
FROM
(SELECT rejs_numer, COUNT(pasazer_pesel) AS Liczba_pasazerow
FROM rezerwacjas999822
GROUP BY rejs_numer) a, 
(SELECT COUNT(pasazer_pesel) AS Liczba_pasazerow
FROM rezerwacjas999822) b;

--3.Wybrać numery rejsów, których średnią cena za bilet przekracza średnią cenę za bilet  rejsu o numerze ‘ 1LK-5625 ’.
SELECT r.rejs_numer, AVG(r.cena_biletu) AS "Sriednia cena biletu"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING AVG(r.cena_biletu) > (SELECT AVG(re.cena_biletu)
                            FROM rezerwacjas999822 re
                            WHERE rejs_numer = '1LK-5625'
                            GROUP BY rejs_numer);

--3 Wypisać rejs który ma największa liczbę pasażerów.
SELECT rejs_numer, count(pasazer_pesel)
FROM rezerwacjas999822
GROUP BY rejs_numer
HAVING COUNT(pasazer_pesel)=
(SELECT MAX(COUNT(pasazer_pesel))
FROM rezerwacjas999822
GROUP BY rejs_numer)

--4. Znaleźć pasażerów, w których cena za bilet jest powyżej średniej.
SELECT p.imie, p.nazwisko, re.cena_biletu, re.rejs_numer
FROM pasazer p, rezerwacjas999822 re
WHERE p.pesel = re.pasazer_pesel AND cena_biletu > (SELECT AVG(r.cena_biletu)
                    FROM rezerwacjas999822 r);
                    
--4. Podaj model samolotu w którym ilość miejsc mniejsza niż średnia ilość miejsc we wszystkich samolotach. 
SELECT s.model, s.ilosc_miejsc
FROM samolot s
WHERE s.ilosc_miejsc < 
(SELECT AVG(sa.ilosc_miejsc)
FROM samolot sa);

--+4a Dla każdego rejsu wypisać pasażera który ma najdrożczy bilet.
SELECT r.rejs_numer, imie, nazwisko, cena_biletu
FROM pasazer p INNER JOIN rezerwacjas999822 r on p.pesel = r.pasazer_pesel 
WHERE cena_biletu = (SELECT MAX(cena_biletu)
FROM rezerwacjas999822 re
WHERE re.rejs_numer = r.rejs_numer)

--4.b)Dla każdego samolotu znaleść paszaera który ma ostatnie miejsce(od piwerwszego do ostatniego po numeram) w samolocie 

--5.Znaleść rejs na którym ilość pasażerów jest mniejsza niż na rejsie 'SD5131'
SELECT r.rejs_numer, count(r.pasazer_pesel) AS "liczba pasażerów"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING COUNT(r.cena_biletu) < (SELECT count(re.pasazer_pesel)
                            FROM rezerwacjas999822 re
                            WHERE rejs_numer = 'SD5131'
                            GROUP BY rejs_numer);

--5.++Dla każdego rejsu który ma anulowana rezerwacje (status krtórej jest 'Anulowano') policzyć max ilość pasazerów. 

SELECT rejs_numer, status, count(pasazer_pesel)
FROM rezerwacjas999822 r
WHERE status = 'Anulowano'
GROUP BY r.rejs_numer, status
HAVING COUNT(pasazer_pesel) =
(SELECT max (COUNT(pasazer_pesel))
FROM rezerwacjas999822 s
WHERE s.status = 'Anulowano' and s.rejs_numer = r.rejs_numer
GROUP BY s.rejs_numer, s.status)

--5.Znaleść rejsu znal na którym ilość pasażerów jest najmniejsza

SELECT r.rejs_numer, count(r.pasazer_pesel) AS "liczba pasażerów"
FROM rezerwacjas999822 r
GROUP BY r.rejs_numer
HAVING COUNT(r.cena_biletu) = (SELECT MAX(count(re.pasazer_pesel))
                            FROM rezerwacjas999822 re
                            WHERE re.rejs_numer = r.rejs_numer
                            GROUP BY rejs_numer);

select distinct dzien_tygodnia from rozklad
select * from rejs
select * from rezerwacjas999822

--5.Dla każdego dnia tygodnia znalesc rejs ktory ma najwiecej rezerwacji.
SELECT distinct dzien_tygodnia, numer, count(t.id)
FROM rozklad INNER JOIN rejs r ON r.rozkladid = rozklad.id 
INNER JOIN rezerwacjas999822 t ON t.rejs_numer = r.numer
GROUP BY dzien_tygodnia, numer
HAVING count(t.id) = 
(select max(count(f.id))
FROM rozklad d INNER JOIN rejs m ON m.rozkladid = d.id 
INNER JOIN rezerwacjas999822 f ON f.rejs_numer = m.numer
where r.numer =m.numer 
GROUP BY d.dzien_tygodnia, m.numer)

SELECT katedra, przedmiot, symbol, COUNT(ocena)
FROM a1_ocena o, a1_przedmiot p
WHERE o.idprzedmiot = p.idprzedmiot 
AND katedra IN('Bazy danych', 'Podstawy Informatyki') AND ocena = 2
HAVING COUNT(ocena)>2
GROUP BY katedra, przedmiot, symbol

                            GROUP BY rejs_numer);

select distinct dzien_tygodnia from rozklad
select * from rejs
select * from rezerwajas999822

--5.Dla każdego dnia tygodnia znalesc rejs ktory ma najwiecej rezerwacji.
SELECT distinct dzien_tygodnia, numer, count(t.id)
FROM rozklad INNER JOIN rejs r ON r.rozkladid = rozklad.id 
INNER JOIN rezerwacjas999822 t ON t.rejs_numer = r.numer
GROUP BY dzien_tygodnia, numer
HAVING count(t.id) = 
(select max(count(f.id))
FROM rozklad d INNER JOIN rejs m ON m.rozkladid = d.id 
INNER JOIN rezerwacjas999822 f ON f.rejs_numer = m.numer
where r.numer =m.numer 
GROUP BY d.dzien_tygodnia, m.numer)

SELECT katedra, przedmiot, symbol, COUNT(ocena)
FROM a1_ocena o, a1_przedmiot p
WHERE o.idprzedmiot = p.idprzedmiot 
AND katedra IN('Bazy danych', 'Podstawy Informatyki') AND ocena = 2
HAVING COUNT(ocena)>2
GROUP BY katedra, przedmiot, symbol
