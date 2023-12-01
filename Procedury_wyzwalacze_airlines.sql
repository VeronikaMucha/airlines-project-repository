Set serveroutput on;

/*Stworzyć procedurę która ma dodawać nową rezerwacje.
 Procedura ma sprawdzać czy istnieje wprowadzony pesel pasażera i rejs o wprowadzonym numerze.
Jeśli  się okaże że nie istnieje, procedura ma wyświetlić odpowiedni komunikat.
Jeśli pesel i numer rejsu istnieją w systemie, procedura ma dodać nową rezerwacje z wprowadzonymi parametrami.
*/

create or replace PROCEDURE Dodaj_rezerwacje(
R_PESEL rezerwacjas999822.PASAZER_PESEL%type,
R_REJS rezerwacjas999822.REJS_NUMER%type, 
R_MIEJSCE rezerwacjas999822.MIEJSCE_NUM%type, 
R_CENA rezerwacjas999822.CENA_BILETU%type)
AS
peselPas pasazer.pesel%type;
rejsIlosc rejs.numer%type;
BEGIN
 select count(*)
  into   peselPas
from pasazer p 
inner join rezerwacjas999822 r 
on p.pesel = r.pasazer_pesel 
where pesel = R_Pesel;
if peselPas >= 1 then
select count(*)
  into   rejsIlosc
from rejs re 
inner join rezerwacjas999822 r 
on re.numer = r.rejs_numer 
where numer = r_rejs;
if rejsIlosc >= 1 then
insert INTO rezerwacjas999822(STATUS, PASAZER_PESEL, REJS_NUMER, MIEJSCE_NUM, CENA_BILETU) 
VALUES ('Zarezerwowano',  R_PESEL, R_REJS, R_MIEJSCE, R_CENA);

else 
raise_application_error (-20500, 'Taki rejs nie istnieje.');

end if;

insert INTO rezerwacjas999822(STATUS, PASAZER_PESEL, REJS_NUMER, MIEJSCE_NUM, CENA_BILETU) 
VALUES ('Zarezerwowano',  R_PESEL, R_REJS, R_MIEJSCE, R_CENA);
DBMS_OUTPUT.PUT_LINE('dodano rezerwacje');

else 
raise_application_error (-20500, 'Nie mozna dodac rezerwacje. Takie pesel nie istnieje w bazie danych');

end if;
END;

--poprawny pesel i rejs
exec Dodaj_rezerwacje('87145208164', 1, 'A-11', 54 );

--niepoprawny rejs
exec Dodaj_rezerwacje('87145208164', 44, 'A-11', 54 );

--niepoprawny pesel
exec Dodaj_rezerwacje('97082023694', 1, 'A-11', 54 );

----------------------------------------PCOCEDURA Z KURSOREM--------------------------------------------
/*
czy istnieje numer rejsu który chcemy zamienić
zmienic date wylotu dla rejsu 
*/

create or replace PROCEDURE zmienDate(numerRejsu integer, DataChce date)
AS 
ID_Sam rejs.samolotid%type;
ID_rozkl rejs.rozkladid%type;
Nrrejs rejs.numer%type;
info varchar2(100);
nrIlosc integer;

CURSOR kursor IS SELECT samolotid, ROZKLADID, numer, data_wylot dw from rejs;
RS KURSOR%ROWTYPE;

begin
select count (*) 
into  nrIlosc
from rejs r where numer = numerRejsu;
if nrIlosc >= 1 then
OPEN KURSOR;
    LOOP
        FETCH KURSOR INTO RS;
         EXIT WHEN kursor%NOTFOUND;
          ID_Sam := rs.SAMOLOTID;
          ID_rozkl:= RS.ROZKLADID;
          if rs.dw <> datachce then
          UPDATE rejs set data_wylot = DataChce where numer = numerRejsu;
          
          end if;
    end loop; 
close kursor;  
else 
raise_application_error (-20500, 'Nie mozna zmienic date dla tego numeru rejsu. Rejsu nie istnieje');
end if;
end;


Set serveroutput on;

--poprawny --
exec zmienDate (2, to_date('05-10-2021','DD-MM-YYYY'));
--sprawdzamy czy zmienilo się --
select * from rejs where numer = 2
exec zmienDate (22, to_date('25-10-2021','DD-MM-YYYY'));
select * from rejs where numer = 2

--------------------wyzwalacz_1-----------------------------
-- - Nie pozwoli zmienić usunąć pasazera.
create or replace TRIGGER PR_WYZWALAC1
BEFORE DELETE ON PASAZER
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20503,'Nie mozna usunac pasazera');
end;

--Test
Delete from pasazer where pesel = '87145208164';
select * from pasazer where pesel = '87145208164';

------------------wyzwalacz_2------------------------------
-- - Nie pozwoli dodać/updajtować ilosc miejsc, kiedy jest więcej niż 950.

CREATE OR REPLACE TRIGGER PR_WYZWALAC2
BEFORE INSERT OR UPDATE OF ilosc_miejsc
ON samolot
FOR EACH ROW
BEGIN
    IF(:NEW.ilosc_miejsc > 950) THEN
        RAISE_APPLICATION_ERROR(-20503,'Ilosc miejsc w samolocie nie może być wieksza niż 950');
    END IF;
END;

--Test
update samolot set ilosc_miejsc = 955 where id = 1;
INSERT INTO samolot(model, ilosc_miejsc)values ('Nowy model', 955);
------------------------Wyzwalacz_3----------------------------
-- - Nie pozwoli dodać rezerwacje gdzie cena biletu jest mniejsza od 5 zt.

Create or replace TRIGGER PR_wyzwalac3
BEFORE DELETE OR UPDATE OR INSERT
ON rezerwacjas999822
FOR EACH ROW
BEGIN
if inserting 
and (:NEW.cena_biletu < 5)
    then
        RAISE_APPLICATION_ERROR(-20503,'Cena jest za niska');
    end if;
    if inserting 
and (:NEW.cena_biletu >1000)
    then
        RAISE_APPLICATION_ERROR(-20504,'Cena jest za wysoka');
    end if;
    if UPDATING 
    and :OLD.pasazer_pesel <> :NEW.pasazer_pesel 
    then
            RAISE_APPLICATION_ERROR(-20505,'Nie wolno zmieniac nr pesel pasazera');
        end if;
            if UPDATING 
    and :OLD.rejs_numer <> :NEW.rejs_numer 
    then
            RAISE_APPLICATION_ERROR(-20506,'Nie mozna zmienic numeru rejsu');
    end if;
     if DELETING then 
         if (:old.status = 'Zarezerwowano')then
             RAISE_APPLICATION_ERROR(-20507,'Nie wolno usuwac rezerwacji ktora jest Zarezerwowana');
         end if;
    end if;

end;

--Test
INSERT INTO RezerwacjaS999822(status, pasazer_pesel, rejs_numer, miejsce_num, cena_biletu) VALUES 	('Zarezerwowano','58121059221','3','D-20',4);
INSERT INTO RezerwacjaS999822(status, pasazer_pesel, rejs_numer, miejsce_num, cena_biletu) VALUES 	('Zarezerwowano','58121059221','3','D-20',1243);
update RezerwacjaS999822 set pasazer_pesel = '955567984' where id = 1;
update RezerwacjaS999822 set rejs_numer = 9 where id = 1;
Delete from RezerwacjaS999822 where  id = 6;
rollback

select * from RezerwacjaS999822 where  id = 1;
