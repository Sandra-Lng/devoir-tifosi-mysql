-- création de la base tifosi + utilisateur dédié

CREATE DATABASE IF NOT EXISTS tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi2026$Rest';
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';
FLUSH PRIVILEGES;

USE tifosi;

-- tables sans dépendance

CREATE TABLE ingredient (
    id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE marque (
    id_marque INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    code_postal INT NOT NULL
);

CREATE TABLE foccacia (
    id_foccacia INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) NOT NULL
);

-- boisson : cardinalité 1,1 côté boisson vers marque donc la FK est directement ici
CREATE TABLE boisson (
    id_boisson INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    id_marque INT NOT NULL,
    FOREIGN KEY (id_marque) REFERENCES marque(id_marque)
);

-- menu : idem, une focaccia est liée à un seul menu (1,1) donc FK dans menu
CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) NOT NULL,
    id_foccacia INT NOT NULL UNIQUE,
    FOREIGN KEY (id_foccacia) REFERENCES foccacia(id_foccacia)
);

-- tables de liaison pour les relations plusieurs-à-plusieurs

-- quels ingrédients dans quelle focaccia, avec la quantité
CREATE TABLE comprend (
    id_ingredient INT NOT NULL,
    id_foccacia INT NOT NULL,
    quantite INT NOT NULL,
    PRIMARY KEY (id_ingredient, id_foccacia),
    FOREIGN KEY (id_ingredient) REFERENCES ingredient(id_ingredient),
    FOREIGN KEY (id_foccacia) REFERENCES foccacia(id_foccacia)
);

-- historique des achats clients
CREATE TABLE achete (
    id_client INT NOT NULL,
    id_menu INT NOT NULL,
    date_achat DATE NOT NULL,
    PRIMARY KEY (id_client, id_menu, date_achat),
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);

-- boissons proposées dans chaque menu
CREATE TABLE contient (
    id_menu INT NOT NULL,
    id_boisson INT NOT NULL,
    PRIMARY KEY (id_menu, id_boisson),
    FOREIGN KEY (id_menu) REFERENCES menu(id_menu),
    FOREIGN KEY (id_boisson) REFERENCES boisson(id_boisson)
);
