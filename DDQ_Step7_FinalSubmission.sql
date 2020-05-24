-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: classmysql.engr.oregonstate.edu:3306
-- Generation Time: Mar 16, 2020 at 07:46 AM
-- Server version: 10.4.11-MariaDB-log
-- PHP Version: 7.0.33

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_cargillb`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_loci`$$
CREATE PROCEDURE `add_loci` (IN `palaceID` INT(11), IN `lociName` VARCHAR(20) CHARSET utf8, IN `firstMnemo` INT(11), IN `secondMnemo` INT(11))  MODIFIES SQL DATA
BEGIN
	DECLARE lociID, chunkID INT;

	INSERT INTO loci (palace_id, name) VALUES (palaceID, lociName);    
    
	SELECT loci_id into lociID FROM loci WHERE palace_id = palaceID AND name = lociName;
    
	INSERT INTO chunks (first_chunk_value, second_chunk_value, loci_id) 
	VALUES
	(firstMnemo, secondMnemo, lociID);

	SELECT chunk_id into chunkID FROM chunks WHERE loci_id = lociID;

	INSERT INTO chunks_mnemo (chunk_id, first_mnemo, second_mnemo) 
	VALUES 
	(chunkID, firstMnemo, secondMnemo);
END$$

DROP PROCEDURE IF EXISTS `update_loci`$$
CREATE PROCEDURE `update_loci` (IN `lociName` VARCHAR(20), IN `lociID` INT(11), IN `chunkID` INT(11), IN `digitsA` INT(2), IN `digitsB` INT(2))  NO SQL
BEGIN

	UPDATE loci SET name = lociName WHERE loci_id = lociID;
	UPDATE chunks SET first_chunk_value = digitsA, second_chunk_value = digitsB WHERE chunk_id = chunkID;
	UPDATE chunks_mnemo SET first_mnemo = digitsA, second_mnemo = digitsB WHERE chunk_id = chunkID;
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `chunks_mnemo`
--

DROP TABLE IF EXISTS `chunks_mnemo`;
CREATE TABLE `chunks_mnemo` (
  `chunk_id` int(4) NOT NULL,
  `first_mnemo` int(2) DEFAULT NULL,
  `second_mnemo` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chunks_mnemo`
--

INSERT INTO `chunks_mnemo` (`chunk_id`, `first_mnemo`, `second_mnemo`) VALUES
(1, 19, 99),
(2, 20, 2),
(3, 20, 5),
(4, 19, 77),
(5, 19, 80),
(6, 19, 83),
(7, 20, 15),
(8, 20, 17),
(9, 20, 19),
(10, 19, 55),
(11, 19, 77),
(12, 19, 80),
(13, 19, 85);


-- --------------------------------------------------------

--
-- Table structure for table `chunks`
--

DROP TABLE IF EXISTS `chunks`;
CREATE TABLE `chunks` (
  `chunk_id` int(11) NOT NULL,
  `first_chunk_value` int(2) NOT NULL,
  `second_chunk_value` int(2) DEFAULT NULL,
  `loci_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `chunks`
--

INSERT INTO `chunks` (`chunk_id`, `first_chunk_value`, `second_chunk_value`, `loci_id`) VALUES
(10, 19, 55, 1),
(11, 19, 77, 2),
(12, 19, 80, 3),
(13, 19, 85, 4),
(1, 19, 99, 5),
(2, 20, 2, 6),
(3, 20, 5, 7),
(4, 19, 77, 8),
(5, 19, 80, 9),
(6, 19, 83, 10),
(7, 20, 15, 11),
(8, 20, 17, 12),
(9, 20, 19, 13);

-- --------------------------------------------------------

--
-- Table structure for table `loci`
--

DROP TABLE IF EXISTS `loci`;
CREATE TABLE `loci` (
  `loci_id` int(11) NOT NULL,
  `palace_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `loci`
--

INSERT INTO `loci` (`loci_id`, `palace_id`, `name`) VALUES
(1, 1, 'Front Door'),
(2, 1, 'Grandmother\'s Chair'),
(4, 1, 'Marble Entryway Table'),
(3, 1, 'Rocking Horse'),
(13, 2, 'Brake'),
(8, 2, 'Cup Holder'),
(5, 2, 'Door Handle'),
(12, 2, 'Gas Pedal'),
(7, 2, 'Ignition'),
(10, 2, 'Rearview Mirror'),
(6, 2, 'Seat Adjustment'),
(11, 2, 'Seatbelt'),
(9, 2, 'Side Mirror Adjustment');

-- --------------------------------------------------------

--
-- Table structure for table `mnemonics`
--

DROP TABLE IF EXISTS `mnemonics`;
CREATE TABLE `mnemonics` (
  `mnemo_id` int(2) NOT NULL,
  `person` varchar(60) DEFAULT NULL,
  `action` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mnemonics`
--

INSERT INTO `mnemonics` (`mnemo_id`, `person`, `action`) VALUES
(-1, 'n/a', 'n/a'),
(0, 'Ozzy Osbourne', 'Biting the head of a bat'),
(1, 'Orphan Annie', 'Hugging a dog'),
(2, 'Obi-wan kenobi', 'Struck down by darth vaders light saber'),
(3, NULL, NULL),
(4, 'Oscar Delahoya', 'Intensely punching, punching bag'),
(5, 'Omar Epps', 'Arguing with House wearing a white doctors coat'),
(6, NULL, NULL),
(7, NULL, NULL),
(8, NULL, NULL),
(9, NULL, NULL),
(10, NULL, NULL),
(11, NULL, NULL),
(12, NULL, NULL),
(13, NULL, NULL),
(14, NULL, NULL),
(15, 'Albert Einstein', 'Writing on a chalkboard'),
(16, NULL, NULL),
(17, 'Andy Griffith', 'Giving an opening statement to the jury'),
(18, NULL, NULL),
(19, 'Anna Nicole Smith', 'Posing for the cover of playboy'),
(20, 'Barack Obama', 'Giving a speech in front of a large US flag'),
(21, NULL, NULL),
(22, NULL, NULL),
(23, NULL, NULL),
(24, NULL, NULL),
(25, NULL, NULL),
(26, NULL, NULL),
(27, NULL, NULL),
(28, NULL, NULL),
(29, NULL, NULL),
(30, NULL, NULL),
(31, NULL, NULL),
(32, NULL, NULL),
(33, NULL, NULL),
(34, NULL, NULL),
(35, NULL, NULL),
(36, NULL, NULL),
(37, NULL, NULL),
(38, NULL, NULL),
(39, NULL, NULL),
(40, NULL, NULL),
(41, NULL, NULL),
(42, NULL, NULL),
(43, NULL, NULL),
(44, NULL, NULL),
(45, NULL, NULL),
(46, NULL, NULL),
(47, NULL, NULL),
(48, NULL, NULL),
(49, NULL, NULL),
(50, NULL, NULL),
(51, NULL, NULL),
(52, NULL, NULL),
(53, NULL, NULL),
(54, NULL, NULL),
(55, 'EminEm', 'Putting Kims dead body into the trunk'),
(56, NULL, NULL),
(57, NULL, NULL),
(58, NULL, NULL),
(59, NULL, NULL),
(60, NULL, NULL),
(61, NULL, NULL),
(62, NULL, NULL),
(63, NULL, NULL),
(64, NULL, NULL),
(65, NULL, NULL),
(66, NULL, NULL),
(67, NULL, NULL),
(68, NULL, NULL),
(69, NULL, NULL),
(70, NULL, NULL),
(71, NULL, NULL),
(72, NULL, NULL),
(73, NULL, NULL),
(74, NULL, NULL),
(75, NULL, NULL),
(76, NULL, NULL),
(77, 'Lady GaGa', 'Making a poker face with long straight white hair'),
(78, NULL, NULL),
(79, NULL, NULL),
(80, 'Santa Clause', 'HO HO HO, With a bag of toys over his shoulder'),
(81, NULL, NULL),
(82, 'Haley Berry', 'Crawling on the ground as catwoman'),
(83, 'Harry Carey', 'Calling a game in his huge black glasses'),
(84, NULL, NULL),
(85, 'He-man', 'Raising his sword with lighting coming out of it'),
(86, NULL, NULL),
(87, NULL, NULL),
(88, NULL, NULL),
(89, NULL, NULL),
(90, NULL, NULL),
(91, NULL, NULL),
(92, NULL, NULL),
(93, NULL, NULL),
(94, NULL, NULL),
(95, NULL, NULL),
(96, NULL, NULL),
(97, NULL, NULL),
(98, NULL, NULL),
(99, 'Wayne Gretzky', 'Holding Stanley Cup');

-- --------------------------------------------------------

--
-- Table structure for table `palaces`
--

DROP TABLE IF EXISTS `palaces`;
CREATE TABLE `palaces` (
  `palace_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `palaces`
--

INSERT INTO `palaces` (`palace_id`, `name`, `description`) VALUES
(1, 'Childhood home', 'Family birthdays'),
(2, 'Subaru Outback', 'Release years for Star Wars Films'),
(3, 'Empty sample', 'Template');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chunks`
--
ALTER TABLE `chunks`
  ADD PRIMARY KEY (`chunk_id`),
  ADD UNIQUE KEY `loci_id` (`loci_id`,`first_chunk_value`,`second_chunk_value`);

--
-- Indexes for table `chunks_mnemo`
--
ALTER TABLE `chunks_mnemo`
  ADD PRIMARY KEY (`chunk_id`),
  ADD KEY `first_mnemo` (`first_mnemo`),
  ADD KEY `second_mnemo` (`second_mnemo`);

--
-- Indexes for table `loci`
--
ALTER TABLE `loci`
  ADD PRIMARY KEY (`loci_id`),
  ADD UNIQUE KEY `loci_info` (`palace_id`,`name`);

--
-- Indexes for table `mnemonics`
--
ALTER TABLE `mnemonics`
  ADD PRIMARY KEY (`mnemo_id`),
  ADD UNIQUE KEY `person` (`person`),
  ADD UNIQUE KEY `action` (`action`);

--
-- Indexes for table `palaces`
--
ALTER TABLE `palaces`
  ADD PRIMARY KEY (`palace_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `chunks`
--
ALTER TABLE `chunks`
  MODIFY `chunk_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `loci`
--
ALTER TABLE `loci`
  MODIFY `loci_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `palaces`
--
ALTER TABLE `palaces`
  MODIFY `palace_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chunks`
--
ALTER TABLE `chunks`
  ADD CONSTRAINT `chunks_ibfk_1` FOREIGN KEY (`loci_id`) REFERENCES `loci` (`loci_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `chunks_mnemo`
--
ALTER TABLE `chunks_mnemo`
  ADD CONSTRAINT `chunks_mnemo_ibfk_1` FOREIGN KEY (`chunk_id`) REFERENCES `chunks` (`chunk_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chunks_mnemo_ibfk_2` FOREIGN KEY (`first_mnemo`) REFERENCES `mnemonics` (`mnemo_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chunks_mnemo_ibfk_3` FOREIGN KEY (`second_mnemo`) REFERENCES `mnemonics` (`mnemo_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `loci`
--
ALTER TABLE `loci`
  ADD CONSTRAINT `loci_ibfk_1` FOREIGN KEY (`palace_id`) REFERENCES `palaces` (`palace_id`) ON DELETE CASCADE ON UPDATE CASCADE;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
