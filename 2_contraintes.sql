SET NAMES utf8mb4;
USE mini_projet_BDD;

ALTER TABLE Adherent
    ADD CONSTRAINT uq_adherent_mail UNIQUE (mail);

ALTER TABLE Contenir
    MODIFY quantite INT NOT NULL DEFAULT 1;

ALTER TABLE Commande
    MODIFY date_heure DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE Reserver
    MODIFY statut VARCHAR(20) NOT NULL DEFAULT 'en attente';

ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_id CHECK (id_adherent > 0);

ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_nom CHECK (CHAR_LENGTH(TRIM(nom_adherent)) > 0);
ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_prenom CHECK (CHAR_LENGTH(TRIM(prenom_adherent)) > 0);

ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_tel
    CHECK (tel IS NULL OR tel REGEXP '^0[1-9][0-9]{8}$');

ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_mail
    CHECK (mail IS NULL OR mail LIKE '%_@_%._%');

ALTER TABLE Abonnement
    ADD CONSTRAINT ck_abonnement_tarif CHECK (tarif >= 0);

ALTER TABLE Consommation
    ADD CONSTRAINT ck_conso_prix CHECK (prix_unitaire > 0);

ALTER TABLE Contenir
    ADD CONSTRAINT ck_contenir_quantite CHECK (quantite > 0);

ALTER TABLE Impression
    ADD CONSTRAINT ck_impression_pages CHECK (nb_page > 0);

ALTER TABLE Evenement
    ADD CONSTRAINT ck_evenement_capacite CHECK (capacite_max > 0);

ALTER TABLE Evenement
    ADD CONSTRAINT ck_evenement_tarif CHECK (tarif_evenement >= 0);

ALTER TABLE Batiment
    ADD CONSTRAINT ck_batiment_etages CHECK (nb_etage > 0);

ALTER TABLE Departement
    ADD CONSTRAINT ck_departement_etage CHECK (etage >= -1);

ALTER TABLE Exemplaire
    ADD CONSTRAINT ck_exemplaire_numero CHECK (numero_exemplaire > 0);

ALTER TABLE Commande
    ADD CONSTRAINT ck_commande_paiement
    CHECK (mode_paiement IN ('carte', 'espèces', 'chèque'));

ALTER TABLE Impression
    ADD CONSTRAINT ck_impression_format
    CHECK (format_papier IN ('A5', 'A4', 'A3'));

ALTER TABLE Reserver
    ADD CONSTRAINT ck_reserver_statut
    CHECK (statut IN ('en attente', 'confirmée', 'annulée'));

ALTER TABLE Emprunt
    ADD CONSTRAINT ck_emprunt_dates CHECK (date_fin_prevue >= date_debut);

ALTER TABLE Emprunt
    ADD CONSTRAINT ck_emprunt_retour
    CHECK (date_retour IS NULL OR date_retour >= date_debut);
    
ALTER TABLE Adherent
    ADD CONSTRAINT ck_adherent_date
    CHECK (date_souscription IS NULL OR date_souscription BETWEEN '2025-01-01' AND '2026-12-31');

    