CREATE DATABASE mini_projet_BDD;
USE mini_projet_BDD;
SET NAMES utf8mb4;

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY,
    categorie VARCHAR(50) NOT NULL,
    tarif DECIMAL(6,2) NOT NULL,
    duree VARCHAR(20) NOT NULL
);

CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY,
    nom_adherent VARCHAR(50) NOT NULL,
    prenom_adherent VARCHAR(50) NOT NULL,
    mail VARCHAR(100),
    tel VARCHAR(20),
    id_abonnement INT,
    date_souscription DATE,
    id_parrain INT,
    FOREIGN KEY (id_parrain) REFERENCES Adherent (id_adherent)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (id_abonnement) REFERENCES Abonnement (id_abonnement)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Consommation (
    id_conso INT PRIMARY KEY,
    prix_unitaire DECIMAL(6,2) NOT NULL,
    nom_conso VARCHAR(50) NOT NULL
);

CREATE TABLE Service (
    id_service INT PRIMARY KEY,
    nom_service VARCHAR(50) NOT NULL,
    id_membre_directeur INT UNIQUE
);

CREATE TABLE Membre (
    id_membre INT PRIMARY KEY,
    nom_membre VARCHAR(50) NOT NULL,
    prenom_membre VARCHAR(50) NOT NULL,
    id_service INT NOT NULL,
    FOREIGN KEY (id_service) REFERENCES Service (id_service)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE Service
    ADD CONSTRAINT fk_service_directeur
    FOREIGN KEY (id_membre_directeur) REFERENCES Membre (id_membre)
        ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE Commande (
    id_commande INT PRIMARY KEY,
    date_heure DATETIME,
    mode_paiement VARCHAR(20) NOT NULL,
    id_adherent INT NOT NULL,
    id_service INT NOT NULL,
    FOREIGN KEY (id_adherent) REFERENCES Adherent (id_adherent)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_service) REFERENCES Service (id_service)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Contenir (
    id_commande INT,
    id_conso INT,
    quantite INT,
    PRIMARY KEY (id_commande, id_conso),
    FOREIGN KEY (id_commande) REFERENCES Commande (id_commande)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_conso) REFERENCES Consommation (id_conso)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Impression (
    id_impression INT PRIMARY KEY,
    nb_page INT NOT NULL,
    format_papier VARCHAR(20) NOT NULL,
    mode_impression VARCHAR(30) NOT NULL,
    id_adherent INT NOT NULL,
    id_service INT NOT NULL,
    FOREIGN KEY (id_adherent) REFERENCES Adherent (id_adherent)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_service) REFERENCES Service (id_service)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Evenement (
    id_evenement INT PRIMARY KEY,
    type_evenement VARCHAR(50) NOT NULL,
    capacite_max INT NOT NULL,
    date_evenement DATE NOT NULL,
    tarif_evenement DECIMAL(6,2) NOT NULL
);

CREATE TABLE Inscrire (
    id_adherent INT,
    id_evenement INT,
    PRIMARY KEY (id_adherent, id_evenement),
    FOREIGN KEY (id_evenement) REFERENCES Evenement (id_evenement)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent (id_adherent)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Organiser (
    id_evenement INT,
    id_service INT,
    PRIMARY KEY (id_evenement, id_service),
    FOREIGN KEY (id_evenement) REFERENCES Evenement (id_evenement)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_service) REFERENCES Service (id_service)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Batiment (
    id_batiment INT PRIMARY KEY,
    nb_etage INT NOT NULL
);

CREATE TABLE Departement (
    id_departement INT PRIMARY KEY,
    nom_departement VARCHAR(50) NOT NULL,
    etage INT NOT NULL,
    id_batiment INT NOT NULL,
    FOREIGN KEY (id_batiment) REFERENCES Batiment (id_batiment)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ouvrage (
    id_ouvrage INT PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    auteur VARCHAR(50) NOT NULL,
    date_publication DATE NOT NULL,
    id_ouvrage_source INT,
    FOREIGN KEY (id_ouvrage_source) REFERENCES Ouvrage (id_ouvrage)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Exemplaire (
    id_ouvrage INT,
    numero_exemplaire INT,
    etat VARCHAR(30) NOT NULL,
    id_departement INT NOT NULL,
    PRIMARY KEY (id_ouvrage, numero_exemplaire),
    FOREIGN KEY (id_ouvrage) REFERENCES Ouvrage (id_ouvrage)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_departement) REFERENCES Departement (id_departement)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reserver (
    id_adherent INT,
    id_ouvrage INT,
    date_reservation DATE NOT NULL,
    statut VARCHAR(20),
    PRIMARY KEY (id_adherent, id_ouvrage),
    FOREIGN KEY (id_adherent) REFERENCES Adherent (id_adherent)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_ouvrage) REFERENCES Ouvrage (id_ouvrage)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Emprunt (
    id_emprunt INT PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin_prevue DATE NOT NULL,
    date_retour DATE,
    id_service INT NOT NULL,
    id_ouvrage INT NOT NULL,
    numero_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    FOREIGN KEY (id_service) REFERENCES Service (id_service)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_ouvrage, numero_exemplaire)
        REFERENCES Exemplaire (id_ouvrage, numero_exemplaire)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_adherent) REFERENCES Adherent (id_adherent)
        ON DELETE CASCADE ON UPDATE CASCADE
);