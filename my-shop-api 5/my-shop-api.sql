-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : mariadb
-- Généré le : mar. 19 nov. 2024 à 17:48
-- Version du serveur : 11.4.4-MariaDB
-- Version de PHP : 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `my-shop-api`
--

-- --------------------------------------------------------

--
-- Structure de la table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `doctrine_migration_versions`
--

CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Déchargement des données de la table `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20211017214007', '2024-11-12 14:10:19', 499),
('DoctrineMigrations\\Version20211017223147', '2024-11-12 14:10:20', 3),
('DoctrineMigrations\\Version20211017225958', '2024-11-12 14:10:20', 4),
('DoctrineMigrations\\Version20211025232617', '2024-11-12 14:10:20', 18),
('DoctrineMigrations\\Version20211026014113', '2024-11-12 14:10:20', 16);

-- --------------------------------------------------------

--
-- Structure de la table `media_object`
--

CREATE TABLE `media_object` (
  `id` int(11) NOT NULL,
  `file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `price` int(11) NOT NULL,
  `image_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image_id`) VALUES
(31, 'Ballon de Football', 'Ballon de football résistant en cuir synthétique, parfait pour les matches en extérieur et pour les entraînements. Il offre une excellente trajectoire de tir et une durabilité supérieure.', 30, NULL),
(32, 'Chaussures de Football', 'Chaussures de football avec crampons moulés offrant une excellente adhérence sur terrain naturel et synthétique. Confortables et légères, elles permettent une grande liberté de mouvement.', 60, NULL),
(33, 'Maillot de Football', 'Maillot de football respirant en polyester, idéal pour les matches et les entraînements. Disponible en plusieurs tailles et couleurs.', 25, NULL),
(34, 'Haltères Hexagonaux 10kg', 'Paire d\'haltères hexagonaux en caoutchouc avec poignée en acier antiglisse. Idéal pour la musculation à domicile ou à la salle.', 50, NULL),
(35, 'Banc de Musculation Repliable', 'Banc de musculation réglable et repliable, parfait pour les exercices de développé couché, les abdominaux et bien plus encore. Compact et facile à ranger.', 150, NULL),
(36, 'Kettlebell en Fonte 12kg', 'Kettlebell en fonte durable de 12 kg, idéal pour améliorer la force fonctionnelle et l\'endurance musculaire. Poignée large pour une prise en main confortable.', 35, NULL),
(37, 'Vélo d\'Appartement', 'Vélo d\'appartement avec écran LCD, présélections de programmes d\'entraînement et résistance ajustable. Convient pour le cardio à domicile.', 400, NULL),
(38, 'Tapis de Course RunFast 300', 'Tapis de course pliable avec 15 niveaux d\'inclinaison et programmes intégrés. Parfait pour les entraînements de course à pied à domicile.', 800, NULL),
(39, 'Rameur Magnétique HomeRow', 'Rameur magnétique silencieux avec résistance ajustable, idéal pour travailler le cardio et renforcer l\'ensemble du corps.', 300, NULL),
(40, 'Tapis de Yoga', 'Tapis de yoga antiglisse épais (8 mm), offrant un excellent confort pour les poses au sol. Léger et facile à transporter.', 25, NULL),
(41, 'Brique de Yoga en Liège', 'Brique de yoga en liège naturel, aide à améliorer l\'alignement et la stabilité lors des poses de yoga. Facile à manipuler et écologique.', 10, NULL),
(42, 'Roue de Yoga Équilibre', 'Roue de yoga pour améliorer la flexibilité, les étirements et le renforcement des muscles profonds. Convient pour tous les niveaux de pratique.', 30, NULL),
(43, 'Chaussures de Course FlySpeed', 'Chaussures de running ultralégères avec amorti adaptatif et mesh respirant pour des courses longues et confortables.', 90, NULL),
(44, 'Ceinture de Running', 'Ceinture de running équipée de deux petites gourdes pour rester hydraté pendant la course. Réglable et confortable.', 20, NULL),
(45, 'Montre GPS Running Tracker', 'Montre GPS légère avec suivi de la vitesse, de la distance et de la fréquence cardiaque. Idéale pour suivre vos performances de running.', 100, NULL),
(46, 'Gants de Boxe Fighter Pro', 'Gants de boxe en cuir synthétique avec mousse à absorption de chocs, offrant une protection optimale pour l\'entraînement et les combats.', 40, NULL),
(47, 'Sac de Frappe Heavy Hit 100cm', 'Sac de frappe en simili cuir, rembourré pour absorber les chocs. Parfait pour les entraînements de boxe et de kickboxing.', 80, NULL),
(48, 'Protège-Tibias KickShield', 'Protège-tibias rembourrés pour une protection maximale lors des entraînements d\'arts martiaux ou de boxe thaïlandaise.', 25, NULL),
(49, 'Kit de Bandes de Résistance (5 pièces)', 'Ensemble de cinq bandes de résistance avec différents niveaux d\'intensité, parfait pour les exercices de renforcement musculaire et de rééducation.', 20, NULL),
(50, 'Corde à Sauter SpeedRope', 'Corde à sauter légère avec poignées ergonomiques et roulements à billes pour des rotations rapides. Idéale pour le cardio et le HIIT.', 15, NULL),
(51, 'Rouleau de Massage Musculaire', 'Rouleau de massage en mousse haute densité, idéal pour la récupération musculaire et les exercices de mobilité.', 20, NULL),
(52, 'Sac à Dos Sport Outdoor', 'Sac à dos de sport ergonomique avec compartiments multiples et poches latérales pour bouteilles, idéal pour la randonnée ou le sport quotidien.', 35, NULL),
(53, 'Gourde Isotherme SportFlex 750ml', 'Gourde en acier inoxydable, isotherme, gardant les boissons fraîches pendant 24h. Parfaite pour les activités en extérieur.', 18, NULL),
(54, 'Casquette de Sport UltraLight', 'Casquette légère et respirante, conçue pour protéger du soleil pendant les activités sportives en extérieur.', 13, NULL),
(55, 'Lunettes de Natation AquaClear', 'Lunettes de natation antifog avec protection UV et bandeau ajustable. Conviennent pour l\'entraînement en piscine ou en mer.', 17, NULL),
(56, 'Bonnet de Bain Silicone FitHead', 'Bonnet de bain en silicone flexible, offrant une bonne étanchéité et un ajustement confortable pour protéger les cheveux.', 8, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `product_category`
--

CREATE TABLE `product_category` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(180) NOT NULL,
  `roles` longtext NOT NULL COMMENT '(DC2Type:json)',
  `password` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `email`, `roles`, `password`, `full_name`) VALUES
(19, 'timbalmarceau@gmail.com', '[\"ROLE_ADMIN\"]', '$2y$13$K4WYR3sKEE.UH.eESlT4iea92qw/L2y65eskGOl8DjcSlfJxISyUC', 'Marceau Timbal-Loury');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Index pour la table `media_object`
--
ALTER TABLE `media_object`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_D34A04AD3DA5256D` (`image_id`);

--
-- Index pour la table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `IDX_CDFC73564584665A` (`product_id`),
  ADD KEY `IDX_CDFC735612469DE2` (`category_id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `media_object`
--
ALTER TABLE `media_object`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `FK_D34A04AD3DA5256D` FOREIGN KEY (`image_id`) REFERENCES `media_object` (`id`);

--
-- Contraintes pour la table `product_category`
--
ALTER TABLE `product_category`
  ADD CONSTRAINT `FK_CDFC735612469DE2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_CDFC73564584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
