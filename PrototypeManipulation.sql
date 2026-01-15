CREATE DATABASE library;
USE library;

-- =====================
-- TABLE RAYON
-- =====================
CREATE TABLE rayon (
    rayon_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

-- =====================
-- TABLE AUTEUR
-- =====================
CREATE TABLE auteur (
    auteur_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL
);

-- =====================
-- TABLE LECTEUR
-- =====================
CREATE TABLE lecteur (
    lecteur_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    tel VARCHAR(15) NOT NULL UNIQUE,
    cin VARCHAR(8) NOT NULL UNIQUE
);

-- =====================
-- TABLE OUVRAGE
-- =====================
CREATE TABLE ouvrage (
    ouvrage_id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    annee_publication YEAR NOT NULL,
    rayon_id INT NOT NULL,
    FOREIGN KEY (rayon_id) REFERENCES rayon(rayon_id)
);

-- =====================
-- TABLE ASSOCIATION OUVRAGE / AUTEUR
-- =====================
CREATE TABLE ouvrage_auteur (
    ouvrage_id INT,
    auteur_id INT,
    PRIMARY KEY (ouvrage_id, auteur_id),
    FOREIGN KEY (ouvrage_id) REFERENCES ouvrage(ouvrage_id),
    FOREIGN KEY (auteur_id) REFERENCES auteur(auteur_id)
);

-- =====================
-- TABLE EMPRUNT
-- =====================
CREATE TABLE emprunt (
    emprunt_id INT AUTO_INCREMENT PRIMARY KEY,
   date_emprunt DATE NOT NULL DEFAULT (CURRENT_DATE),
    date_retour_prevue DATE NOT NULL,
    date_retour_effective DATE NULL,
    lecteur_id INT NOT NULL,
    ouvrage_id INT NOT NULL,
    FOREIGN KEY (lecteur_id) REFERENCES lecteur(lecteur_id),
    FOREIGN KEY (ouvrage_id) REFERENCES ouvrage(ouvrage_id)
);

-- =====================
-- TABLE PERSONNEL
-- =====================
CREATE TABLE personnel (
    personnel_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    tel VARCHAR(15) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    chef_id INT NULL,
    FOREIGN KEY (chef_id) REFERENCES personnel(personnel_id)
);

-- Insertion dans RAYON
INSERT INTO rayon (nom) VALUES 
('Informatique'), 
('Science-Fiction'), 
('Développement Personnel');

-- Insertion dans AUTEUR
INSERT INTO auteur (nom, prenom) VALUES 
('Martin', 'Robert'), 
('Herbert', 'Frank'), 
('Clear', 'James');

-- Insertion dans LECTEUR
INSERT INTO lecteur (nom, prenom, email, tel, cin) VALUES 
('Alaoui', 'Ahmed', 'ahmed@email.com', '0601020304', 'AB12345'),
('Dupont', 'Marie', 'marie@email.com', '0611223344', 'CD67890');
INSERT INTO lecteur (nom, prenom, email, tel, cin) 
VALUES ('oumayma', 'uhhabi', 'oumamaa@email.com', '0603090704', 'AZ2345');


-- Insertion dans OUVRAGE (Lié au rayon_id)
INSERT INTO ouvrage (titre, annee_publication, rayon_id) VALUES 
('Clean Code', 2008, 1),      -- 1 = Informatique
('Dune', 1965, 2),            -- 2 = Science-Fiction
('Atomic Habits', 2018, 3);   -- 3 = Dév Personnel

select * from ouvrage where ouvrage_id=1;
delete from ouvrage where ouvrage_id=1;
INSERT IGNORE INTO ouvrage_auteur (ouvrage_id, auteur_id) VALUES (1, 1), (2, 2), (3, 3), (4, 1);
select * from ouvrage_auteur;
-- Insertion dans EMPRUNT (Lecteur 1 emprunte l'ouvrage 1)
INSERT INTO emprunt (date_emprunt, date_retour_prevue, lecteur_id, ouvrage_id) VALUES 
('2026-01-05', '2026-01-19', 1, 1),('2026-02-05', '2028-01-19', 2, 2);
INSERT INTO emprunt (date_emprunt, date_retour_prevue, lecteur_id, ouvrage_id) VALUES 
('2026-02-05', '2028-01-19', 2, 2);

-- Insertion dans PERSONNEL (Gestion de la hiérarchie)
-- On crée d'abord le chef (chef_id est NULL)
INSERT INTO personnel (nom, email, tel, mot_de_passe, chef_id) VALUES 
('Admin Principal', 'admin@library.com', '0522001122', 'hash_mdp_123', NULL);

-- On crée un employé dont le chef est l'ID 1
INSERT INTO personnel (nom, email, tel, mot_de_passe, chef_id) VALUES 
('Agent Accueil', 'accueil@library.com', '0522445566', 'hash_mdp_456', 1);

select nom from rayon;

select nom , prenom from auteur;
SELECT titre, annee_publication FROM ouvrage;
SELECT nom, prenom, email FROM lecteur;

SELECT * FROM ouvrage 
WHERE annee_publication > 1950 ;


SELECT * FROM lecteur 
WHERE nom LIKE 'm%';

SELECT * FROM ouvrage 
ORDER BY annee_publication DESC;

select * from emprunt;
select * from emprunt where date_retour_effective is null;

select titre,r.nom ,ouvrage.rayon_id, r.rayon_id from ouvrage join rayon r on ouvrage.rayon_id= r.rayon_id;

select titre ,a.nom,a.prenom from ouvrage join  ouvrage_auteur oa on ouvrage.ouvrage_id=oa.ouvrage_id
join auteur a on oa.auteur_id=a.auteur_id;


select l.nom from lecteur l join emprunt e on l.lecteur_id = e.lecteur_id;
select r.rayon_id, count(*) from ouvrage join rayon r on ouvrage.rayon_id= r.rayon_id group by rayon_id;
-- requêtes UPDATE

update lecteur set email='fati@gmail.com' where lecteur_id=1;
update lecteur set tel=076543213 where cin='CD67890';

UPDATE ouvrage 
SET rayon_id = 3 
WHERE ouvrage_id = 2;

UPDATE emprunt 
SET date_retour_effective = '2029-01-01' 
WHERE emprunt_id = 1;
UPDATE personnel 
SET chef_id = 1
WHERE personnel_id = 1;


-- requête DELETE

delete from emprunt  where emprunt_id=2;
SELECT l.lecteur_id, l.nom, l.prenom, l.email
FROM lecteur l
LEFT JOIN emprunt e ON l.lecteur_id = e.lecteur_id
WHERE e.emprunt_id IS NULL;

delete from lecteur where lecteur_id = 5;


DELETE FROM lecteur 
WHERE lecteur_id IN (
    SELECT id_a_supprimer FROM (
        SELECT l.lecteur_id AS id_a_supprimer
        FROM lecteur l 
        LEFT JOIN emprunt e ON l.lecteur_id = e.lecteur_id 
        WHERE e.emprunt_id IS NULL
    ) AS table_temporaire
);



START TRANSACTION;


DELETE FROM ouvrage_auteur 
WHERE ouvrage_id NOT IN (SELECT ouvrage_id FROM emprunt);


DELETE FROM ouvrage 
WHERE ouvrage_id NOT IN (SELECT ouvrage_id FROM emprunt);


COMMIT;
INSERT INTO ouvrage (titre, annee_publication, rayon_id) 
VALUES ('The Clean Coder', 2011, 1);
INSERT INTO ouvrage_auteur (ouvrage_id, auteur_id) 
VALUES (14, 1);


select * from ouvrage ;
select * from ouvrage_auteur;
select * from personnel;
select * from emprunt;
select * from lecteur;
