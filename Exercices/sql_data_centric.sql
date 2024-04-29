SHOW databases;
CREATE DATABASE data_centric;
SHOW DATABASES;
USE data_centric;
SELECT * FROM biens LIMIT 10;
DROP TABLE ventes;
SELECT * FROM lots LIMIT 10;
DROP TABLE lots;
SELECT COUNT(*) FROM ventes
INNER JOIN biens ON ventes.ventes_id = biens.id_bien WHERE ventes.nature_mutation = "Vente" and (biens.type_local="Appartement" or biens.type_local= "Maison");
SELECT COUNT(*) FROM biens WHERE type_local= "Appartement" or type_local = "Maison";
SELECT * FROM biens LIMIT 50;
DROP TABLE ventes;
DESCRIBE ventes;
SELECT COUNT(*) FROM ventes WHERE nature_mutation = 'Vente' and (MONTH(date_mutation) BETWEEN 1 and 3);
SELECT COUNT(*) FROM ventes WHERE nature_mutation = 'Vente' and (MONTH(date_mutation) BETWEEN 4 and 6);
SELECT COUNT(*) FROM ventes WHERE nature_mutation = 'Vente' and (MONTH(date_mutation) BETWEEN 7 and 9);
SELECT COUNT(*) FROM ventes WHERE nature_mutation = 'Vente' and (MONTH(date_mutation) BETWEEN 10 and 12);
SELECT COUNT(*) *100 /(SELECT COUNT(*) FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 and 3 AND nature_mutation='Ventes') 
FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 AND 3 and nature_mutation = 'Ventes';

SELECT COUNT(*)*100 / (SELECT COUNT(*)FROM ventes) FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 AND 3 and(MONTH(date_mutation) BETWEEN 1 and 3);
SELECT COUNT(*)*100 / (SELECT COUNT(*)FROM ventes) FROM ventes WHERE MONTH(date_mutation) BETWEEN 4 AND 6 and(MONTH(date_mutation) BETWEEN 4 and 6);
SELECT COUNT(*)*100 / (SELECT COUNT(*)FROM ventes) FROM ventes WHERE MONTH(date_mutation) BETWEEN 7 AND 9 and(MONTH(date_mutation) BETWEEN 7 and 9);
SELECT COUNT(*)*100 / (SELECT COUNT(*)FROM ventes) FROM ventes WHERE MONTH(date_mutation) BETWEEN 10 AND 12 and(MONTH(date_mutation) BETWEEN 10 and 12);

SELECT COUNT(*) FROM biens;
SELECT COUNT(*)*100 / (SELECT COUNT(*) FROM biens), nb_pieces_principales FROM biens WHERE nb_pieces_principales IS NOT NULL GROUP BY nb_pieces_principales;
SELECT COUNT(*)*100 / (SELECT COUNT(*) FROM biens ) 
FROM ventes INNER JOIN biens ON ventes.ventes_id = biens.id_bien WHERE type_local = "Appartement" AND nb_pieces_principales IS NOT NULL GROUP BY nb_pieces_principales;
SELECT nb_pieces_principales,(COUNT(ventes_id) * 100.0) / (SELECT COUNT(*) FROM biens WHERE type_local = "Appartement") AS pourcentage 
FROM ventes INNER JOIN biens ON ventes.ventes_id = biens.id_bien WHERE type_local = "Appartement" AND nb_pieces_principales IS NOT NULL GROUP BY nb_pieces_principales;

SELECT COUNT(*) FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id GROUP BY code_departement ORDER BY ventes DESC LIMIT 10;
SELECT COUNT(*) AS total , code_departement FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id 
GROUP BY code_departement ORDER BY total DESC LIMIT 10;
SELECT COUNT(*) AS total , code_departement FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id 
GROUP BY code_departement ORDER BY total LIMIT 10;


SELECT * FROM location INNER JOIN ventes ON ventes.ventes_id = location.id_bien WHERE code_departement 
IN (75, 77, 78, 91,92, 93, 94, 95) GROUP BY AVG(valeur_fonciere)LIMIT 10;

SELECT code_departement, AVG(valeur_fonciere / surface_reelle_bati) AS moyenne_valeur_fonciere
FROM ventes
INNER JOIN biens ON ventes.ventes_id = biens.id_bien 
INNER JOIN location ON ventes.ventes_id = location.id_bien
WHERE code_departement IN (75, 77, 78, 91, 92, 93, 94, 95) AND (valeur_fonciere AND surface_reelle_bati) IS NOT NULL AND valeur_fonciere < 1000000
GROUP BY code_departement;

SELECT lots.id_bien, code_departement, valeur_fonciere, lot_1_surface FROM ventes 
INNER JOIN lots ON ventes.ventes_id = lots.id_bien 
INNER JOIN location ON ventes.ventes_id = location.id_bien
WHERE lot_1_surface IS NOT NULL
ORDER BY valeur_fonciere DESC LIMIT 10;




SELECT surface_reelle_bati FROM biens;



SELECT * FROM ventes 
INNER JOIN biens ON ventes.ventes_id = biens.id_bien 
INNER JOIN location ON ventes.ventes_id = location.id_bien
ORDER BY valeur_fonciere DESC LIMIT 10;




SELECT code_departement, AVG(valeur_fonciere / lot_1_surface) AS moyenne_valeur_fonciere
FROM ventes
INNER JOIN lots ON ventes.ventes_id = lots.id_bien 
INNER JOIN location ON ventes.ventes_id = location.id_bien
WHERE code_departement IN (75, 77, 78, 91, 92, 93, 94, 95) AND (valeur_fonciere AND lot_1_surface) IS NOT NULL AND valeur_fonciere < 1000000
GROUP BY code_departement;


SELECT 
    ((COUNT(CASE WHEN MONTH(date_mutation) BETWEEN 4 AND 6 THEN 1 END)) / 
    COUNT(CASE WHEN MONTH(date_mutation) BETWEEN 1 AND 3 THEN 1 END)) - 1 AS taux_evolution
FROM 
    ventes;
    
SELECT ((ventes_deuxieme_trimestre - ventes_premier_trimestre) / ventes_premier_trimestre) * 100 AS taux_evolution
FROM (
    SELECT 
        (SELECT COUNT(*) FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 AND 3) AS ventes_premier_trimestre,
        (SELECT COUNT(*) FROM ventes WHERE MONTH(date_mutation) BETWEEN 4 AND 6) AS ventes_deuxieme_trimestre
) AS ventes_trimestres;
# Liste des communes où le nombre de ventes a augmenté d'au moins 20% entre le premier et le second trimestre de 2022
SELECT commune FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id 
WHERE nature_mutation = 'Vente' 
AND (SELECT (((ventes_deuxieme_trimestre - ventes_premier_trimestre) / ventes_premier_trimestre) * 100)>= 20 AS taux_evolution
FROM (SELECT (SELECT COUNT(*) FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 AND 3 GROUP BY commune) AS ventes_premier_trimestre,
        (SELECT COUNT(*) FROM ventes WHERE MONTH(date_mutation) BETWEEN 4 AND 6 GROUP BY commune) AS ventes_deuxieme_trimestre
) AS ventes_trimestres );


# 10
WITH trimestre_1 AS (SELECT COUNT(*) AS vente_t1, commune FROM location 
INNER JOIN ventes ON ventes.ventes_id = location.id_bien WHERE MONTH(date_mutation) BETWEEN 1 AND 3 GROUP BY commune),
 trimestre_2 AS (SELECT COUNT(*) AS vente_t2 , commune FROM location 
 INNER JOIN ventes ON ventes.ventes_id = location.id_bien WHERE MONTH(date_mutation) BETWEEN 4 AND 6 GROUP BY commune) 
 SELECT trimestre_1.commune, ((vente_t1- vente_t2)/vente_t2)*100 AS pourcentage FROM trimestre_1, trimestre_2  
HAVING pourcentage >=20 LIMIT 20;
 
 SELECT * FROM location;
 WHERE nature_mutation = 'Vente' AND  (1-(trimestre_1 - trimestre_2) / trimestre_2) * 100>= 20;

WITH vente1 AS (
 SELECT nom_commune, count(id_vente) AS nb_vente_t1
 FROM vente
 JOIN bien USING (id_bien)
 JOIN commune USING (id_codedep_codecommune)
 WHERE date BETWEEN '2020-01-01' AND '2020-03-31'
 GROUP BY nom_commune)
SELECT nom_commune AS "Commune", nb_vente_t1
FROM vente1
WHERE nb_vente_t1 > 50;

SELECT commune FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id WHERE nature_mutation = 'Vente' 
AND (SELECT (((ventes_deuxieme_trimestre - ventes_premier_trimestre) / ventes_premier_trimestre) * 100)FROM 
(SELECT COUNT(*) AS ventes_premier_trimestre FROM ventes WHERE MONTH(date_mutation) BETWEEN 1 AND 3) AS v1,
(SELECT COUNT(*) AS ventes_deuxieme_trimestre FROM ventes WHERE MONTH(date_mutation) BETWEEN 4 AND 6) AS v2)>= 20;



SELECT commune FROM location;
SELECT COUNT(*)*100 / (SELECT COUNT(*)FROM ventes) FROM ventes WHERE MONTH(date_mutation) BETWEEN 10 AND 12 and(MONTH(date_mutation) BETWEEN 10 and 12);
SELECT COUNT(*) FROM ventes WHERE nature_mutation = 'Vente' and (MONTH(date_mutation) BETWEEN 10 and 12);

SELECT nb_pieces_principales,(COUNT(ventes_id) * 100.0) / (SELECT COUNT(*) FROM biens WHERE type_local = "Appartement") AS pourcentage 
FROM ventes INNER JOIN biens ON ventes.ventes_id = biens.id_bien WHERE type_local = "Appartement" AND nb_pieces_principales IS NOT NULL GROUP BY nb_pieces_principales;


SELECT COUNT(*) AS total , code_departement FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id 
GROUP BY code_departement ORDER BY total DESC LIMIT 10;


SELECT COUNT(*) AS total , code_departement FROM location INNER JOIN ventes ON location.id_bien = ventes.ventes_id 
GROUP BY code_departement ORDER BY total LIMIT 10;


SELECT lots.id_bien, code_departement, valeur_fonciere, lot_1_surface FROM ventes 
INNER JOIN lots ON ventes.ventes_id = lots.id_bien 
INNER JOIN location ON ventes.ventes_id = location.id_bien
WHERE lot_1_surface IS NOT NULL
ORDER BY valeur_fonciere DESC LIMIT 10;
