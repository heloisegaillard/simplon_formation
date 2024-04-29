SHOW KEYS FROM villes WHERE Key_name = 'PRIMARY';
SHOW KEYS FROM departement WHERE Key_name = 'PRIMARY';
SELECT * FROM villes ORDER BY ville_commune;
-- 1 Obtenir la liste des 10 villes les plus peuplées en 2012
SELECT * FROM villes ORDER BY ville_population_2012 DESC LIMIT 10;
-- 2 Obtenir la liste des 50 villes ayant la plus faible superficie
SELECT * FROM villes ORDER BY ville_surface LIMIT 50;
-- 3 Obtenir la liste des départements d’outres-mer, c’est-à-dire ceux dont le numéro de département commencent par “97”
SELECT * FROM departement WHERE departement_code LIKE '97%';
-- 4 Obtenir le nom des 10 villes les plus peuplées en 2012, ainsi que le nom du département associé
SELECT ville_nom, departement_nom FROM villes JOIN departement ON villes.ville_departement = departement.departement_code ORDER BY ville_population_2012 DESC LIMIT 10;
-- 5 Obtenir la liste du nom de chaque département, associé à son code et du nombre de commune 
-- au sein de ces département, en triant afin d’obtenir en priorité les départements qui possèdent le plus de communes
SELECT departement.departement_nom, departement.departement_code,COUNT(villes.ville_commune) AS nombre_commune FROM departement INNER JOIN 
villes ON departement.departement_code=villes.ville_departement  GROUP BY departement.departement_nom, departement.departement_code ORDER BY nombre_commune DESC LIMIT 10;

-- ALTER TABLE villes ADD CONSTRAINT fk_ville_departement FOREIGN KEY (ville_departement) REFERENCES departement (departement_code);
-- ALTER TABLE villes ENGINE=InnoDB;
-- 6 Obtenir la liste des 10 plus grands départements, en terme de superficie
SELECT SUM(villes.ville_surface) AS superficie, departement.departement_code, departement.departement_nom FROM villes JOIN departement ON
 villes.ville_departement = departement.departement_code GROUP BY departement.departement_nom, departement.departement_code ORDER BY superficie DESC LIMIT 10;

SELECT ville_nom, departement_nom FROM villes JOIN departement ON villes.ville_departement = departement.departement_code ORDER BY ville_population_2012 DESC LIMIT 10;
-- 7 Compter le nombre de villes dont le nom commence par “Saint”
SELECT COUNT(DISTINCT villes.ville_nom) FROM villes WHERE villes.ville_nom LIKE "Saint%";
-- 8 Obtenir la liste des villes qui ont un nom existants plusieurs fois, 
-- et trier afin d’obtenir en premier celles dont le nom est 
-- le plus souvent utilisé par plusieurs communes

SELECT villes.ville_nom, COUNT(*) AS nombre_doublons FROM villes GROUP BY villes.ville_nom HAVING COUNT(*) > 1 ORDER BY nombre_doublons DESC;
-- 9 Obtenir en une seule requête SQL la liste des villes dont la superficie est supérieur à la superficie moyenne
SELECT villes.ville_nom, AVG(villes.ville_surface) AS moyenne FROM villes GROUP BY villes.ville_nom > moyenne;
