CREATE DATABASE Blogdatabase;
USE Blogdatabase;

CREATE TABLE Utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL
);

DROP TABLE Article;

CREATE TABLE Article (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(150) NOT NULL,
    contenu TEXT NOT NULL,
    date_pub DATE,
    id_utilisateur INT,
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id)
);

CREATE TABLE Commentaire (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT NOT NULL,
    auteur VARCHAR(100),
    date_commentaire DATE,
    id_article INT,
    FOREIGN KEY (id_article) REFERENCES Article(id)
);


SHOW TABLES;
DESCRIBE Utilisateur;


INSERT INTO Utilisateur (nom, email, mot_de_passe) 
VALUES ('Alice', 'alice@test.com', '1234');
select * from Article ;
select * from Utilisateur;
SELECT titre, contenu , date_pub FROM Article;


SELECT titre,  date_pub
FROM Article
WHERE  date_pub >= '2024-01-01';

SELECT titre, date_pub
FROM Article
ORDER BY date_pub DESC;


SELECT titre
FROM Article
ORDER BY date_pub DESC
LIMIT 5;
SELECT COUNT(*) AS total_articles FROM Article;

SELECT MAX(date_pub) AS derniere_publication FROM Article;

SELECT id_utilisateur, COUNT(*) AS nb_articles
FROM Article
GROUP BY id_utilisateur;

SELECT id_utilisateur, COUNT(*) AS nb_articles
FROM Article
GROUP BY id_utilisateur
HAVING COUNT(*) >= 3;

SELECT AVG(nb_vues) AS moyenne_vues FROM Article;

-- Utiliser des jointures pour afficher les articles et leurs auteurs.

SELECT a.titre, a.date_pub, u.nom
FROM Article a
INNER JOIN Utilisateur u ON a.id_utilisateur = u.id;


SELECT a.titre, u.nom
FROM Article a
INNER JOIN Utilisateur u ON a.id_utilisateur = u.id_utilisateur
WHERE u.nom = 'Alice';
-- LEFT JOIN pour voir les articles sans auteur
SELECT a.titre, u.nom
FROM Article a
LEFT JOIN Utilisateur u ON a.id_utilisateur = u.id_utilisateur;

-- Jointure avec 3 tables

SELECT a.titre, u.nom, c.contenu
FROM Article a
INNER JOIN Utilisateur u ON a.id_utilisateur = u.id_utilisateur
INNER JOIN Commentaire c ON a.id = c.id_article;

-- insertion 
INSERT INTO Utilisateur (nom, email, mot_de_passe)
VALUES ('Alice', 'alice@test.com', '1234');

INSERT INTO Article (titre, contenu, date_pub, id_utilisateur)
VALUES ('Bienvenue sur le blog', 'Ceci est le premier article.', '2025-07-18', 1);

INSERT INTO Utilisateur (nom, email, mot_de_passe)
VALUES 
  ('Bob', 'bob@test.com', 'passbob'),
  ('Charlie', 'charlie@test.com', 'passcharlie');
  
  SELECT * FROM Utilisateur;
SELECT * FROM Article;

-- Modifier une ligne
UPDATE Utilisateur
SET nom = 'Alice Dupont', email = 'alice.dupont@test.com'
WHERE id_utilisateur= 1;

-- Modifier plusieurs lignes
UPDATE Article
SET titre = 'Article mis à jour'
WHERE id_utilisateur = 1;

-- Supprimer un enregistrement 
DELETE FROM Commentaire
WHERE id_utilisateur = 2;
-- Supprimer plusieurs lignes

DELETE FROM Article
WHERE date_pub < '2024-01-01';

-- Vérifier les résultats
SELECT * FROM Utilisateur;
SELECT * FROM Article;

























































































































































































































































































































































































































































































































































































































































































































