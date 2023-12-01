DROP TABLE Pasazer;
DROP TABLE Rejs;
DROP TABLE Rezerwacja;
DROP TABLE Rozklad;
DROP TABLE Samolot;

select * from pasazer
select * from Rejs;
select * from Rezerwacja;
select * from Rozklad;
select * from Samolot;

use MojaBaza;

-- Table: Pasazer
CREATE TABLE Pasazer (
    Pesel varchar(11)  NOT NULL,
    imie varchar(20)  NOT NULL,
    nazwisko varchar(20)  NOT NULL,
    num_tel varchar(25) NOT NULL,
    kraj_zam varchar(85)  NOT NULL,
    adres_zam varchar(90)  NULL,
    email varchar(90)  NOT NULL,
    CONSTRAINT Pasazer_pk PRIMARY KEY (Pesel)
	);
	
-- Table: Rejs
CREATE TABLE Rejs (
    Numer INT IDENTITY (1,1) NOT NULL,
    SamolotID INTEGER  NOT NULL,
    RozkladID INTEGER  NOT NULL,
    data_wylot date  NOT NULL,
    data_przylot date  NOT NULL,
    CONSTRAINT Rejs_pk PRIMARY KEY (Numer)
);
-- Table: Rezerwacja
CREATE TABLE Rezerwacja (
    Id INT IDENTITY (1,1) NOT NULL,
    status varchar(30)  NOT NULL,
    Pasazer_Pesel varchar(11)  NOT NULL,
    Rejs_Numer integer  NOT NULL,
    miejsce_num varchar(5)  NOT NULL,
    cena_biletu money  NOT NULL,
    CONSTRAINT RezerwacjaS999822_pk PRIMARY KEY (Id)
);

-- Table: Rozklad 
CREATE TABLE Rozklad (
    ID INT IDENTITY (1,1) NOT NULL,
    dzien_tygodnia varchar(20)  NOT NULL,
    czas_wylot varchar(5)  NOT NULL,
    czas_przylot varchar(5)  NOT NULL,
    miasto_wylotu varchar(85)  NOT NULL,
    miasto_przylotu varchar(85)  NOT NULL,
    IATA_wylot varchar(3)  NOT NULL,
    IATA_przylot varchar(3)  NOT NULL,
    CONSTRAINT Rozklad_pk PRIMARY KEY (ID)
);

-- Table: Samolot
CREATE TABLE Samolot (
    Id INT IDENTITY (1,1) NOT NULL,
    model varchar(20)  NOT NULL,
    ilosc_miejsc int  NULL,
    CONSTRAINT Samolot_pk PRIMARY KEY (Id)
);

-- foreign keys
-- Reference: Rejs_Rozklad (table: Rejs)
ALTER TABLE [MojaBaza].[dbo].[Rejs] ADD CONSTRAINT Rejs_Rozklad
    FOREIGN KEY (RozkladID)
    REFERENCES Rozklad (ID)  


-- Reference: Rejs_Samolot (table: Rejs)
ALTER TABLE [MojaBaza].[dbo].[Rejs] ADD CONSTRAINT Rejs_Samolot
    FOREIGN KEY (SamolotID)
    REFERENCES Samolot (Id)  
;

-- Reference: Rezerwacja_Pasazer (table: Rezerwacja)
ALTER TABLE [MojaBaza].[dbo].[Rezerwacja] ADD CONSTRAINT Rezerwacja_Pasazer
    FOREIGN KEY (Pasazer_Pesel)
    REFERENCES Pasazer (Pesel)  
;

-- Reference: Rezerwacja_Rejs (table: Rezerwacja)
ALTER TABLE [MojaBaza].[dbo].[Rezerwacja] ADD CONSTRAINT Rezerwacja_Rejs
    FOREIGN KEY (Rejs_Numer)
    REFERENCES Rejs (Numer)  
;


-- End of file.