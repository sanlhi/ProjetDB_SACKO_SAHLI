USE mini_projet_BDD;
SET NAMES utf8mb4;

SELECT titre, auteur, date_publication
FROM Ouvrage
WHERE genre IN ('Manga', 'Bande dessinée')
ORDER BY titre;

SELECT DISTINCT genre
FROM Ouvrage
ORDER BY genre;

SELECT nom_conso, prix_unitaire
FROM Consommation
WHERE nom_conso LIKE '%chocolat%' OR nom_conso LIKE 'Caf%'
ORDER BY prix_unitaire DESC;

SELECT id_commande, date_heure, mode_paiement
FROM Commande
WHERE date_heure BETWEEN '2026-01-01 00:00:00' AND '2026-06-30 23:59:59'
  AND mode_paiement = 'carte'
ORDER BY date_heure;

SELECT nom_adherent, prenom_adherent, mail
FROM Adherent
WHERE mail LIKE '%@efrei.net'
ORDER BY nom_adherent, prenom_adherent;

SELECT type_evenement, date_evenement, capacite_max, tarif_evenement
FROM Evenement
WHERE date_evenement > '2026-11-09'
ORDER BY date_evenement;

SELECT id_emprunt, id_adherent, id_ouvrage, numero_exemplaire, date_fin_prevue
FROM Emprunt
WHERE date_retour IS NULL
  AND date_fin_prevue < '2026-11-09'
ORDER BY date_fin_prevue;

SELECT id_adherent, nom_adherent, prenom_adherent, mail, tel
FROM Adherent
WHERE mail IS NULL OR tel IS NULL;

SELECT ab.categorie, COUNT(*) AS nb_adherents
FROM Adherent ad
JOIN Abonnement ab ON ab.id_abonnement = ad.id_abonnement
GROUP BY ab.categorie
ORDER BY nb_adherents DESC;

SELECT c.mode_paiement,
       COUNT(DISTINCT c.id_commande) AS nb_commandes,
       SUM(k.quantite * s.prix_unitaire) AS chiffre_affaires
FROM Commande c
JOIN Contenir k ON k.id_commande = c.id_commande
JOIN Consommation s ON s.id_conso = k.id_conso
GROUP BY c.mode_paiement
ORDER BY chiffre_affaires DESC;

SELECT o.genre, COUNT(*) AS nb_emprunts
FROM Emprunt e
JOIN Ouvrage o ON o.id_ouvrage = e.id_ouvrage
GROUP BY o.genre
HAVING COUNT(*) >= 5
ORDER BY nb_emprunts DESC;

SELECT ev.type_evenement,
       ev.capacite_max,
       COUNT(i.id_adherent) AS nb_inscrits,
       ROUND(100 * COUNT(i.id_adherent) / ev.capacite_max, 1) AS taux_remplissage
FROM Evenement ev
LEFT JOIN Inscrire i ON i.id_evenement = ev.id_evenement
GROUP BY ev.id_evenement, ev.type_evenement, ev.capacite_max
HAVING COUNT(i.id_adherent) / ev.capacite_max > 0.30
ORDER BY taux_remplissage DESC;

SELECT mode_impression, format_papier,
       COUNT(*) AS nb_impressions,
       SUM(nb_page) AS total_pages,
       ROUND(AVG(nb_page), 1) AS moyenne_pages
FROM Impression
GROUP BY mode_impression, format_papier
HAVING SUM(nb_page) > 50
ORDER BY total_pages DESC;

SELECT a.id_adherent, a.nom_adherent, a.prenom_adherent,
       SUM(k.quantite * s.prix_unitaire) AS depense_totale
FROM Adherent a
JOIN Commande c ON c.id_adherent = a.id_adherent
JOIN Contenir k ON k.id_commande = c.id_commande
JOIN Consommation s ON s.id_conso = k.id_conso
GROUP BY a.id_adherent, a.nom_adherent, a.prenom_adherent
ORDER BY depense_totale DESC
LIMIT 5;

SELECT MIN(prix_unitaire) AS prix_min,
       MAX(prix_unitaire) AS prix_max,
       ROUND(AVG(prix_unitaire), 2) AS prix_moyen
FROM Consommation;

SELECT o.titre, a.nom_adherent, a.prenom_adherent, e.date_debut, e.date_fin_prevue
FROM Emprunt e
JOIN Ouvrage o ON o.id_ouvrage = e.id_ouvrage
JOIN Adherent a ON a.id_adherent = e.id_adherent
WHERE e.date_retour IS NULL
ORDER BY e.date_fin_prevue;

SELECT a.id_adherent, a.nom_adherent, a.prenom_adherent, COUNT(c.id_commande) AS nb_commandes
FROM Adherent a
LEFT JOIN Commande c ON c.id_adherent = a.id_adherent
GROUP BY a.id_adherent, a.nom_adherent, a.prenom_adherent
ORDER BY nb_commandes, a.nom_adherent;


SELECT ex.id_ouvrage, o.titre, ex.numero_exemplaire, ex.etat
FROM Exemplaire ex
JOIN Ouvrage o ON o.id_ouvrage = ex.id_ouvrage
LEFT JOIN Emprunt em ON em.id_ouvrage = ex.id_ouvrage
                    AND em.numero_exemplaire = ex.numero_exemplaire
WHERE em.id_emprunt IS NULL
ORDER BY o.titre, ex.numero_exemplaire;


SELECT f.prenom_adherent AS filleul_prenom, f.nom_adherent AS filleul_nom,
       p.prenom_adherent AS parrain_prenom, p.nom_adherent AS parrain_nom
FROM Adherent f
JOIN Adherent p ON p.id_adherent = f.id_parrain
ORDER BY parrain_nom, filleul_nom;

SELECT ad.titre AS adaptation, ad.date_publication AS date_adaptation,
       src.titre AS ouvrage_source, src.date_publication AS date_source
FROM Ouvrage ad
JOIN Ouvrage src ON src.id_ouvrage = ad.id_ouvrage_source
ORDER BY src.titre;

SELECT s.nom_service, m.prenom_membre, m.nom_membre
FROM Service s
JOIN Membre m ON m.id_membre = s.id_membre_directeur
ORDER BY s.nom_service;

SELECT d.nom_departement, d.id_batiment, d.etage, COUNT(ex.id_ouvrage) AS nb_exemplaires
FROM Exemplaire ex
RIGHT JOIN Departement d ON d.id_departement = ex.id_departement
GROUP BY d.id_departement, d.nom_departement, d.id_batiment, d.etage
ORDER BY nb_exemplaires DESC;

SELECT ev.type_evenement, ev.date_evenement, s.nom_service, m.nom_membre AS directeur
FROM Evenement ev
JOIN Organiser o ON o.id_evenement = ev.id_evenement
JOIN Service s ON s.id_service = o.id_service
JOIN Membre m ON m.id_membre = s.id_membre_directeur
ORDER BY ev.date_evenement, s.nom_service;

SELECT nom_adherent, prenom_adherent
FROM Adherent
WHERE id_adherent IN (SELECT id_adherent FROM Reserver WHERE statut = 'confirmée')
ORDER BY nom_adherent;

SELECT id_ouvrage, titre, genre
FROM Ouvrage
WHERE id_ouvrage NOT IN (SELECT id_ouvrage FROM Reserver)
ORDER BY titre;

SELECT a.nom_adherent, a.prenom_adherent
FROM Adherent a
WHERE EXISTS (SELECT 1
              FROM Emprunt e
              WHERE e.id_adherent = a.id_adherent
                AND e.date_retour > e.date_fin_prevue)
ORDER BY a.nom_adherent;

SELECT a.nom_adherent, a.prenom_adherent
FROM Adherent a
WHERE NOT EXISTS (SELECT 1 FROM Commande c WHERE c.id_adherent = a.id_adherent)
ORDER BY a.nom_adherent;

SELECT nom_conso, prix_unitaire
FROM Consommation
WHERE prix_unitaire > ALL (SELECT prix_unitaire
                           FROM Consommation
                           WHERE nom_conso IN ('Café expresso', 'Café allongé', 'Cappuccino',
                                               'Chocolat chaud', 'Thé vert', 'Infusion'))
ORDER BY prix_unitaire DESC;

SELECT titre, genre, date_publication
FROM Ouvrage
WHERE date_publication > ANY (SELECT date_publication FROM Ouvrage WHERE genre = 'Manga')
ORDER BY date_publication;

SELECT c.id_commande, c.date_heure, SUM(k.quantite * s.prix_unitaire) AS montant
FROM Commande c
JOIN Contenir k ON k.id_commande = c.id_commande
JOIN Consommation s ON s.id_conso = k.id_conso
GROUP BY c.id_commande, c.date_heure
HAVING SUM(k.quantite * s.prix_unitaire) >
       (SELECT AVG(t.montant)
        FROM (SELECT SUM(k2.quantite * s2.prix_unitaire) AS montant
              FROM Contenir k2
              JOIN Consommation s2 ON s2.id_conso = k2.id_conso
              GROUP BY k2.id_commande) t)
ORDER BY montant DESC;

SELECT o.titre, a.nom_adherent, a.prenom_adherent
FROM Emprunt e
JOIN Ouvrage o ON o.id_ouvrage = e.id_ouvrage
JOIN Adherent a ON a.id_adherent = e.id_adherent
WHERE o.genre = 'Science-fiction'
  AND e.date_retour IS NULL;