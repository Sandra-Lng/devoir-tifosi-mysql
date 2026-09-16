USE tifosi;

-- ---- Requête 1 ----
-- But : afficher les noms des focaccias par ordre alphabétique croissant
-- Attendu : les 8 focaccias triées de A à Z
-- Obtenu : Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione
-- RAS, pas d'écart

SELECT nom
FROM foccacia
ORDER BY nom ASC;


-- ---- Requête 2 ----
-- But : afficher le nombre total d'ingrédients
-- Attendu : 25
-- Obtenu : 25

SELECT COUNT(*) AS nombre_ingredients
FROM ingredient;


-- ---- Requête 3 ----
-- But : afficher le prix moyen des focaccias
-- Attendu : environ 10.4 euros
-- Obtenu : 10.375000
-- (j'ai eu une erreur "No database selected" au premier essai, la base n'était
-- pas sélectionnée par défaut dans l'onglet, réglé en sélectionnant tifosi
-- dans le panneau de gauche avant de relancer)

SELECT AVG(prix) AS prix_moyen
FROM foccacia;


-- ---- Requête 4 ----
-- But : afficher les boissons avec leur marque, triées par nom de boisson
-- Attendu : les 12 boissons, chacune avec sa marque
-- Obtenu : 12 lignes, correspond bien (Capri-sun -> Coca-cola, Eau de source -> Cristalline, etc.)

SELECT boisson.nom AS nom_boisson, marque.nom AS nom_marque
FROM boisson
JOIN marque ON boisson.id_marque = marque.id_marque
ORDER BY boisson.nom ASC;


-- ---- Requête 5 ----
-- But : afficher les ingrédients pour la Raclaccia
-- Attendu : 7 ingrédients (base tomate, raclette, cresson, ail, champignon, parmesan, poivre)
-- Obtenu : les 7 mêmes avec leur quantité, ok

SELECT ingredient.nom AS nom_ingredient, comprend.quantite
FROM foccacia
JOIN comprend ON foccacia.id_foccacia = comprend.id_foccacia
JOIN ingredient ON comprend.id_ingredient = ingredient.id_ingredient
WHERE foccacia.nom = 'Raclaccia';


-- ---- Requête 6 ----
-- But : afficher le nom et le nombre d'ingrédients pour chaque focaccia
-- Attendu : Mozaccia 10 / Gorgonzollaccia 8 / Raclaccia 7 / Emmentalaccia 7 /
-- Tradizione 9 / Hawaienne 9 / Américaine 8 / Paysanne 12
-- Obtenu : pareil

SELECT foccacia.nom AS nom_foccacia, COUNT(comprend.id_ingredient) AS nombre_ingredients
FROM foccacia
JOIN comprend ON foccacia.id_foccacia = comprend.id_foccacia
GROUP BY foccacia.nom;


-- ---- Requête 7 ----
-- But : afficher la focaccia qui a le plus d'ingrédients
-- Attendu : Paysanne (12)
-- Obtenu : Paysanne, 12

SELECT foccacia.nom AS nom_foccacia, COUNT(comprend.id_ingredient) AS nombre_ingredients
FROM foccacia
JOIN comprend ON foccacia.id_foccacia = comprend.id_foccacia
GROUP BY foccacia.nom
ORDER BY nombre_ingredients DESC
LIMIT 1;


-- ---- Requête 8 ----
-- But : afficher les focaccias qui contiennent de l'ail
-- Attendu : Mozaccia, Gorgonzollaccia, Raclaccia, Paysanne
-- Obtenu : les 4 mêmes

SELECT DISTINCT foccacia.nom AS nom_foccacia
FROM foccacia
JOIN comprend ON foccacia.id_foccacia = comprend.id_foccacia
JOIN ingredient ON comprend.id_ingredient = ingredient.id_ingredient
WHERE ingredient.nom = 'Ail';


-- ---- Requête 9 ----
-- But : afficher les ingrédients qui ne sont utilisés dans aucune focaccia
-- Attendu : les ingrédients présents dans la table mais absents de toutes les recettes
-- Obtenu : Salami, Tomate cerise
-- ces deux ingrédients sont bien dans la table ingredient mais n'apparaissent
-- dans aucune des 8 recettes fournies

SELECT ingredient.nom AS nom_ingredient
FROM ingredient
LEFT JOIN comprend ON ingredient.id_ingredient = comprend.id_ingredient
WHERE comprend.id_ingredient IS NULL;


-- ---- Requête 10 ----
-- But : afficher les focaccias sans champignon
-- Attendu : les focaccias dont la recette ne contient pas de champignon
-- Obtenu : Hawaienne, Américaine

SELECT nom AS nom_foccacia
FROM foccacia
WHERE id_foccacia NOT IN (
    SELECT comprend.id_foccacia
    FROM comprend
    JOIN ingredient ON comprend.id_ingredient = ingredient.id_ingredient
    WHERE ingredient.nom = 'Champignon'
);
