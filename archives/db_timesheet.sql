-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 09, 2025 at 03:26 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_timesheet`
--

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `dept_id` int(5) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `dept_head` int(5) NOT NULL,
  `emp_count` int(10) NOT NULL,
  `dept_email` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`dept_id`, `dept_name`, `dept_head`, `emp_count`, `dept_email`) VALUES
(1, 'Human Resources', 1, 5, 'hr@example.com'),
(2, 'Engineering', 2, 12, 'engg@example.com'),
(3, 'Marketing', 3, 4, 'marketing@example.com'),
(4, 'Finance', 4, 3, 'finance@example.com');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `emp_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(300) NOT NULL,
  `password` varchar(300) NOT NULL,
  `role` varchar(100) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `rm_id` int(11) NOT NULL DEFAULT 1,
  `doj` date NOT NULL DEFAULT '2001-01-01'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`emp_id`, `name`, `email`, `password`, `role`, `dept_id`, `rm_id`, `doj`) VALUES
(1, 'Alice Johnson', '', '', 'admin', 1, 1, '2022-01-15'),
(2, 'Bob Smith', '', '', '', 2, 2, '2021-03-10'),
(3, 'Charlie Davis', '', '', '', 2, 2, '2023-06-01'),
(4, 'Diana Prince', '', '', '', 3, 3, '2020-11-20'),
(5, 'Ethan Hunt', '', '', '', 4, 4, '2019-08-05');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_id` int(10) NOT NULL,
  `emp_id` int(11) NOT NULL,
  `category` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `duration` time NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`task_id`, `emp_id`, `category`, `description`, `date`, `duration`, `status`) VALUES
(1, 1, 'Recruitment', 'Reviewed 10 resumes and conducted 2 interviews', '2025-06-01', '02:30:00', 1),
(2, 2, 'Development', 'Implemented login module', '2025-06-01', '04:00:00', 1),
(3, 3, 'Code Review', 'Reviewed PRs and provided feedback', '2025-06-02', '01:45:00', 1),
(4, 4, 'Campaign', 'Created social media strategy for new product', '2025-06-01', '03:15:00', 0),
(5, 5, 'Budgeting', 'Drafted Q3 budget proposal', '2025-06-02', '02:00:00', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`dept_id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`task_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `dept_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `emp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
