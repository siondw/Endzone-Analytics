DROP SCHEMA IF EXISTS `GameDayMetrics` ;
CREATE SCHEMA IF NOT EXISTS `GameDayMetrics` DEFAULT CHARACTER SET latin1 ;
USE `GameDayMetrics` ;


GRANT ALL PRIVILEGES ON GameDayMetrics.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
USE GameDayMetrics;


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP DATABASE IF EXISTS `GameDayMetrics`;
CREATE DATABASE GameDayMetrics;

USE GameDayMetrics;
CREATE TABLE NFLTeams(
    team_abbr VARCHAR(3) PRIMARY KEY,
    team_name VARCHAR(50),
    division VARCHAR(50),
    conference VARCHAR(50),
    salary_cap INT,
    third_conv_rate float,
    redzone_eff float,
    avg_ticket_price INT,
    wins INT,
    losses INT,
   win_pct float GENERATED ALWAYS AS (wins / (wins + losses)) STORED
);

CREATE TABLE Team_Picks (
    team_abbr VARCHAR(3),
    pick_id INT AUTO_INCREMENT,
    INDEX (pick_id),
    pick_num INT,
    year INT,
    PRIMARY KEY (team_abbr, pick_id),
    CONSTRAINT FOREIGN KEY (team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Game (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team_abbr VARCHAR(3) NOT NULL,
    INDEX(home_team_abbr),
    away_team_abbr VARCHAR(3) NOT NULL,
    INDEX(away_team_abbr),
    winner VARCHAR(50) NOT NULL,
    INDEX(winner),
    loser VARCHAR(50) NOT NULL,
    INDEX(loser),
    home_score INT NOT NULL,
    away_score INT NOT NULL,
    yards_leader VARCHAR(50),
    td_leader VARCHAR(50),
    pass_yds_leader VARCHAR(50),
    week_num TINYINT,
    ticket_price INT,
    CONSTRAINT FOREIGN KEY (home_team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (away_team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Team_Game(
   team_abbr varchar(3),
   game_id int,
   PRIMARY KEY (team_abbr, game_id),
   CONSTRAINT FOREIGN KEY (team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Game_Highlight(
   game_id int,
   link varchar(200),
   description varchar(150),
   PRIMARY KEY (game_id, link),
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Play_by_Play(
   game_id int,
   play_id int AUTO_INCREMENT,
   index(play_id),
   play_summary varchar(200),
   time varchar(10),
   quarter int,
   PRIMARY KEY (game_id, play_id),
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Players(
   player_id int PRIMARY KEY AUTO_INCREMENT,
   team_name varchar(50),
   team_abbr varchar(3) NOT NULL,
   INDEX (team_abbr),
   position varchar (4),
   qbr float,
   pass_yards_total int,
   rush_yards_total int,
   rec_yards_total int,
   rush_tds_total int,
   pass_tds_total int,
   rec_tds_total int,
   games_played int,
   total_tds_line float,
   total_tds_odds varchar(50),
   school varchar (50),
   total_yds_line float,
   total_yds_odds varchar(50),
   shuttle_time float,
   forty_time float,
   bench_presses int,
   CONSTRAINT FOREIGN KEY (team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Player_Injuries(
   player_id int,
   injury_id int AUTO_INCREMENT,
   index(injury_id),
   injury varchar(200),
   duration varchar(50),
   PRIMARY KEY (player_id, injury_id),
   CONSTRAINT FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Player_Game_Stats(
   game_id int NOT NULL,
   INDEX(game_id),
   player_id int NOT NULL,
   INDEX(player_id),
   stat_id int NOT NULL AUTO_INCREMENT,
   pass_tds int,
   pass_yds int,
   rush_tds int,
   rush_yds int,
   rec_tds int,
   rec_yds int,
   PRIMARY KEY (stat_id, game_id, player_id),
   CONSTRAINT FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


INSERT INTO NFLTeams (team_abbr, team_name, division, conference, salary_cap, third_conv_rate, redzone_eff, avg_ticket_price, wins, losses) VALUES 
('AZ', 'Arizona Cardinals', 'NFC West', 'NFC', 7863982, 0.46, 0.51, 94, 5, 12),
('ATL', 'Atlanta Falcons', 'NFC South', 'NFC', 39410705, 0.34, 0.64, 112, 4, 13),
('BAL', 'Baltimore Ravens', 'AFC North', 'AFC', 26727883, 0.34, 0.59, 95, 11, 6),
('BUF', 'Buffalo Bills', 'AFC East', 'AFC', 1759639, 0.46, 0.54, 123, 10, 7),
('CAR', 'Carolina Panthers', 'NFC South', 'NFC', 28756204, 0.38, 0.44, 81, 5, 12),
('CHI', 'Chicago Bears', 'NFC North', 'NFC', 10672710, 0.47, 0.53, 66, 8, 9),
('CIN', 'Cincinnati Bengals', 'AFC North', 'AFC', 10392379, 0.42, 0.62, 121, 10, 7),
('CLE', 'Cleveland Browns', 'AFC North', 'AFC', 15166744, 0.41, 0.54, 100, 7, 10),
('DAL', 'Dallas Cowboys', 'NFC East', 'NFC', 15767186, 0.51, 0.53, 134, 12, 5),
('DEN', 'Denver Broncos', 'AFC West', 'AFC', 26620196, 0.38, 0.62, 60, 7, 10),
('DET', 'Detroit Lions', 'NFC North', 'NFC', 31155299, 0.36, 0.61, 120, 3, 14),
('GB', 'Green Bay Packers', 'NFC North', 'NFC', 22354690, 0.52, 0.63, 136, 13, 4),
('HOU', 'Houston Texans', 'AFC South', 'AFC', 24725939, 0.47, 0.53, 119, 4, 13),
('IND', 'Indianapolis Colts', 'AFC South', 'AFC', 24060729, 0.4, 0.61, 89, 9, 8),
('JAC', 'Jacksonville Jaguars', 'AFC South', 'AFC', 13932528, 0.46, 0.45, 129, 2, 15),
('KC', 'Kansas City Chiefs', 'AFC West', 'AFC', 28888331, 0.52, 0.45, 98, 14, 3),
('LV', 'Las Vegas Raiders', 'AFC West', 'AFC', 6143321, 0.41, 0.53, 100, 8, 9),
('LAC', 'Los Angeles Chargers', 'AFC West', 'AFC', 15220613, 0.39, 0.52, 117, 9, 8),
('LAR', 'Los Angeles Rams', 'NFC West', 'NFC', 23093842, 0.47, 0.66, 96, 12, 5),
('MIA', 'Miami Dolphins', 'AFC East', 'AFC', 34998831, 0.37, 0.45, 74, 9, 8),
('MIN', 'Minnesota Vikings', 'NFC North', 'NFC', 13680005, 0.44, 0.51, 138, 7, 10),
('NE', 'New England Patriots', 'AFC East', 'AFC', 24577700, 0.41, 0.54, 73, 10, 7),
('NO', 'New Orleans Saints', 'NFC South', 'NFC', 21294905, 0.46, 0.56, 72, 9, 8),
('NYG', 'New York Giants', 'NFC East', 'NFC', 22459705, 0.52, 0.61, 64, 6, 11),
('NYJ', 'New York Jets', 'AFC East', 'AFC', 11087158, 0.43, 0.57, 81, 2, 15),
('PHI', 'Philadelphia Eagles', 'NFC East', 'NFC', 8709819, 0.4, 0.51, 71, 9, 8),
('PIT', 'Pittsburgh Steelers', 'AFC North', 'AFC', 2147007, 0.53, 0.63, 130, 9, 8),
('SF', 'San Francisco 49ers', 'NFC West', 'NFC', 13762192, 0.47, 0.48, 130, 6, 11),
('SEA', 'Seattle Seahawks', 'NFC West', 'NFC', 39573185, 0.35, 0.49, 76, 12, 5),
('TB', 'Tampa Bay Buccaneers', 'NFC South', 'NFC', 14431821, 0.38, 0.46, 117, 13, 4),
('TEN', 'Tennessee Titans', 'AFC South', 'AFC', 30492076, 0.45, 0.53, 87, 12, 5),
('WAS', 'Washington Commanders', 'NFC East', 'NFC', 20226615, 0.37, 0.46, 82, 7, 10);


INSERT INTO Players (player_id, team_name, team_abbr, position, qbr, pass_yards_total, rush_yards_total, rec_yards_total, rush_tds_total, pass_tds_total, rec_tds_total, games_played, total_tds_line, total_tds_odds, school, total_yds_line, total_yds_odds, shuttle_time, forty_time, bench_presses) VALUES 
(1, 'James Conner', 'AZ', 'RB', 0, 0, 782, 300, 7, 0, 1, 13, 5.5, '-119', 'Pitt', 480.5, '+180', 6.5, 4.9,21),
(2, 'Eno Benjamin', 'AZ', 'RB', 0, 0, 299, 184, 2, 0, 0, 10, 2.5, '+147', 'East Carolina', 498.5, '-102', 7.13, 4.24,14),
(3, 'Kyler Murray', 'AZ', 'QB', 53.6, 0, 418, 0, 3, 14, 0, 11, 2.5, '-145', 'BYU', 855.5, '+249', 6.85, 4.52,17),
(4, 'Keaontay Ingram', 'AZ', 'RB', 0, 0, 60, 21, 1, 0, 0, 12, 4.5, '+151', 'Northwestern', 549.5, '+170', 7.02, 4.25,11),
(5, 'Darrel Williams', 'AZ', 'RB', 0, 0, 102, 9, 1, 0, 0, 6, 4.5, '+203', 'UNLV', 939.5, '-190', 6.6, 4.37,3),
(6, 'Corey Clement', 'AZ', 'RB', 0, 0, 55, 54, 1, 0, 0, 9, 3.5, '-171', 'Georgia Southern', 732.5, '-146', 6.8, 4.36,19),
(7, 'Trace McSorley', 'AZ', 'QB', 10.6, 412, 61, 0, 0, 0, 0, 6, 2.5, '-139', 'Middle Tennessee', 847.5, '-101', 6.61, 4.95,21),
(8, 'Colt McCoy', 'AZ', 'QB', 39.3, 780, 36, 0, 0, 1, 0, 4, 4.5, '-133', 'USC', 513.5, '+202', 6.25, 4.26,6),
(9, 'Greg Dortch', 'AZ', 'WR', 0, 0, 44, 467, 0, 0, 2, 16, 3.5, '-192', 'Liberty', 492.5, '+250', 7.13, 4.36,14),
(10, 'Rondale Moore', 'AZ', 'WR', 0, 0, -5, 414, 0, 0, 1, 8, 8.5, '-196', 'Nebraska', 1114.5, '-177', 6.83, 4.83,22),
(11, 'Pharoh Cooper', 'AZ', 'WR', 0, 0, 15, 6, 0, 0, 0, 5, 5.5, '-146', 'Texas Tech', 873.5, '+199', 6.23, 5.13,13),
(12, 'David Blough', 'AZ', 'QB', 29.8, 402, 5, 0, 0, 2, 0, 2, 7.5, '-166', 'Miami', 923.5, '-152', 6.66, 4.76,10),
(13, 'Marquise Brown', 'AZ', 'WR', 0, 0, 1, 709, 0, 0, 3, 12, 8.5, '-127', 'Arkansas', 1031.5, '-151', 7.09, 4.82,13),
(14, 'DeAndre Hopkins', 'AZ', 'WR', 0, 0, 0, 717, 0, 0, 3, 9, 2.5, '-171', 'Baylor', 707.5, '+232', 6.32, 4.91,2),
(15, 'Zach Ertz', 'AZ', 'TE', 0, 0, 0, 406, 0, 0, 4, 10, 7.5, '+238', 'BYU', 959.5, '-163', 6.82, 5.18,1),
(16, 'Trey McBride', 'AZ', 'TE', 0, 0, 0, 265, 0, 0, 1, 16, 5.5, '-171', 'Middle Tennessee', 523.5, '+144', 6.26, 4.46,16),
(17, 'A.J. Green', 'AZ', 'WR', 0, 0, 0, 236, 0, 0, 2, 15, 8.5, '-154', 'Miami, Ohio', 817.5, '+203', 6.65, 5.13,22),
(18, 'Andre Baccellia', 'AZ', 'WR', 0, 0, 0, 45, 0, 0, 0, 8, 5.5, '+144', 'Appalachian State', 557.5, '+223', 6.26, 4.44,20),
(19, 'Robbie Chosen', 'AZ', 'WR', 0, 0, 0, 76, 0, 0, 0, 10, 5.5, '-150', 'Texas A&M', 771.5, '+244', 7.01, 4.62,6),
(20, 'Stephen Anderson', 'AZ', 'TE', 0, 0, 0, 9, 0, 0, 0, 16, 4.5, '-154', 'North Texas', 1040.5, '+110', 6.83, 4.58,10),
(21, 'Maxx Williams', 'AZ', 'TE', 0, 0, 0, 18, 0, 0, 0, 11, 8.5, '-199', 'Louisville', 1179.5, '+157', 6.57, 4.92,22),
(22, 'Andy Isabella', 'AZ', 'WR', 0, 0, 0, 21, 0, 0, 0, 3, 4.5, '+250', 'UConn', 1144.5, '+146', 6.47, 4.3,13),
(23, 'Kamu Grugier-Hill', 'AZ', 'LB', 0, 0, 0, 4, 0, 0, 0, 9, 0.5, '-180', 'Texas A&M', 797.5, '-179', 6.5, 4.6,16),
(24, 'TySon Williams', 'AZ', 'RB', 0, 0, 0, 5, 0, 0, 0, 1, 6.5, '+219', 'Wyoming', 624.5, '-106', 6.48, 4.41,9),
(25, 'Tyler Allgeier', 'ATL', 'RB', 0, 0, 1035, 139, 3, 0, 1, 16, 6.5, '+224', 'Arkansas', 1124.5, '+114', 6.97, 4.67,15),
(26, 'Cordarrelle Patterson', 'ATL', 'RB', 0, 0, 695, 122, 8, 0, 0, 13, 8.5, '+206', 'Nebraska', 825.5, '+106', 6.75, 4.77,14),
(27, 'Marcus Mariota', 'ATL', 'QB', 57.7, 2219, 438, 0, 4, 15, 0, 13, 2.5, '-155', 'Virginia Tech', 1029.5, '+149', 6.5, 4.2,2),
(28, 'Caleb Huntley', 'ATL', 'RB', 0, 0, 366, 3, 1, 0, 0, 12, 7.5, '-105', 'Arizona State', 1007.5, '-127', 6.41, 4.83,10),
(29, 'Avery Williams', 'ATL', 'RB', 0, 0, 109, 61, 1, 0, 0, 17, 8.5, '-171', 'Jacksonville State', 532.5, '+146', 6.44, 4.78,15),
(30, 'Desmond Ridder', 'ATL', 'QB', 52, 708, 64, 0, 0, 2, 0, 4, 7.5, '+232', 'Auburn', 548.5, '-176', 6.51, 4.62,8),
(31, 'Olamide Zaccheaus', 'ATL', 'WR', 0, 0, 7, 533, 0, 0, 3, 17, 5.5, '-100', 'Fresno State', 668.5, '-193', 6.57, 4.85,12),
(32, 'Damien Williams', 'ATL', 'RB', 0, 0, 2, 0, 0, 0, 0, 1, 3.5, '-190', 'West Virginia', 930.5, '+193', 7.16, 5.04,10),
(33, 'Keith Smith', 'ATL', 'FB', 0, 0, 2, 8, 0, 0, 0, 17, 2.5, '-167', 'Arizona', 1075.5, '+250', 6.4, 4.84,20),
(34, 'Feleipe Franks', 'ATL', 'TE', 0, 0, 0, 0, 0, 0, 0, 11, 4.5, '+168', 'Akron', 563.5, '-191', 6.93, 4.41,5),
(35, 'Drake London', 'ATL', 'WR', 0, 0, 0, 866, 0, 0, 4, 17, 5.5, '-184', 'Charlotte', 798.5, '+142', 6.83, 4.65,2),
(36, 'Kyle Pitts', 'ATL', 'TE', 0, 0, 0, 356, 0, 0, 2, 10, 3.5, '+170', 'Notre Dame', 898.5, '-154', 6.77, 4.68,20),
(37, 'MyCole Pruitt', 'ATL', 'TE', 0, 0, 0, 150, 0, 0, 4, 13, 5.5, '+136', 'Vanderbilt', 665.5, '-173', 6.61, 4.25,12),
(38, 'Damiere Byrd', 'ATL', 'WR', 0, 0, 0, 268, 0, 0, 2, 14, 8.5, '+184', 'Oregon', 552.5, '-103', 6.79, 4.92,21),
(39, 'KhaDarel Hodge', 'ATL', 'WR', 0, 0, 0, 202, 0, 0, 1, 17, 6.5, '-181', 'ULM', 839.5, '-193', 6.46, 4.96,21),
(40, 'Anthony Firkser', 'ATL', 'TE', 0, 0, 0, 100, 0, 0, 0, 11, 8.5, '+216', 'Pitt', 518.5, '-155', 6.92, 4.56,13),
(41, 'Parker Hesse', 'ATL', 'TE', 0, 0, 0, 89, 0, 0, 0, 17, 6.5, '+100', 'Washington State', 1154.5, '-129', 7.07, 4.46,22),
(42, 'Bryan Edwards', 'ATL', 'WR', 0, 0, 0, 15, 0, 0, 0, 7, 8.5, '-177', 'Liberty', 541.5, '+162', 6.6, 4.65,21),
(43, 'Frank Darby', 'ATL', 'WR', 0, 0, 0, 15, 0, 0, 0, 5, 5.5, '-150', 'Cincinnati', 1127.5, '-168', 6.23, 4.84,20),
(44, 'Josh Ali', 'ATL', 'WR', 0, 0, 0, 0, 0, 0, 0, 2, 6.5, '-101', 'Nebraska', 645.5, '-118', 6.62, 4.58,21),
(45, 'Lamar Jackson', 'BAL', 'QB', 61.1, 2242, 764, 0, 3, 17, 0, 12, 4.5, '+113', 'Pitt', 730.5, '-185', 6.63, 5.08,9),
(46, 'Kenyan Drake', 'BAL', 'RB', 0, 0, 482, 89, 4, 0, 1, 12, 8.5, '-183', 'Oklahoma', 1109.5, '-104', 6.58, 4.85,1),
(47, 'J.K. Dobbins', 'BAL', 'RB', 0, 0, 520, 42, 2, 0, 1, 8, 5.5, '-121', 'East Carolina', 745.5, '+145', 6.74, 4.76,6),
(48, 'Gus Edwards', 'BAL', 'RB', 0, 0, 433, 0, 3, 0, 0, 9, 2.5, '+213', 'Georgia', 762.5, '+146', 6.63, 4.66,1),
(49, 'Justice Hill', 'BAL', 'RB', 0, 0, 262, 58, 0, 0, 0, 15, 10.5, '+237', 'Missouri', 752.5, '+144', 6.48, 5.1,14),
(50, 'Tyler Huntley', 'BAL', 'QB', 43, 658, 137, 0, 1, 2, 0, 6, 2.5, '-193', 'Buffalo', 1091.5, '-190', 6.5, 4.23,14),
(51, 'Devin Duvernay', 'BAL', 'WR', 0, 0, 84, 407, 1, 0, 3, 14, 4.5, '+232', 'USC', 1047.5, '+199', 6.55, 4.81,7),
(52, 'Mike Davis', 'BAL', 'RB', 0, 0, 18, 4, 0, 0, 0, 8, 10.5, '-110', 'Texas Tech', 455.5, '-180', 7.14, 4.99,3),
(53, 'Patrick Ricard', 'BAL', 'FB', 0, 0, 16, 74, 0, 0, 0, 17, 2.5, '-113', 'Ohio State', 848.5, '-151', 7.01, 4.44,4),
(54, 'Mark Andrews', 'BAL', 'TE', 0, 0, 8, 847, 0, 0, 5, 15, 10.5, '-103', 'Tennessee', 631.5, '-135', 6.97, 5.09,2),
(55, 'Anthony Brown', 'BAL', 'QB', 13.7, 302, -5, 0, 0, 0, 0, 2, 10.5, '-173', 'Boise State', 493.5, '+141', 6.34, 5.16,6),
(56, 'Andy Isabella', 'BAL', 'WR', 0, 0, 1, 0, 0, 0, 0, 2, 6.5, '+169', 'Clemson', 538.5, '-101', 6.47, 4.96,19),
(57, 'Demarcus Robinson', 'BAL', 'WR', 0, 0, 0, 458, 0, 0, 2, 17, 2.5, '-111', 'Tennessee', 730.5, '-112', 6.78, 4.55,8),
(58, 'Isaiah Likely', 'BAL', 'TE', 0, 0, 0, 373, 0, 0, 3, 16, 4.5, '-105', 'Northern Illinois', 826.5, '+104', 6.88, 4.58,9),
(59, 'Rashod Bateman', 'BAL', 'WR', 0, 0, 0, 285, 0, 0, 2, 6, 9.5, '-136', 'Troy', 1123.5, '+159', 6.3, 4.52,7),
(60, 'Josh Oliver', 'BAL', 'TE', 0, 0, 0, 149, 0, 0, 2, 17, 7.5, '+156', 'Ole Miss', 808.5, '+164', 7.11, 4.51,15),
(61, 'DeSean Jackson', 'BAL', 'WR', 0, 0, 0, 153, 0, 0, 0, 7, 10.5, '+121', 'Michigan', 1179.5, '-188', 6.86, 4.77,11),
(62, 'James Proche', 'BAL', 'WR', 0, 0, 0, 62, 0, 0, 0, 15, 9.5, '-192', 'Coastal Carolina', 1103.5, '-118', 6.6, 4.94,19),
(63, 'Charlie Kolar', 'BAL', 'TE', 0, 0, 0, 49, 0, 0, 0, 2, 4.5, '-146', 'Fresno State', 948.5, '+211', 7.01, 4.25,14),
(64, 'Tylan Wallace', 'BAL', 'WR', 0, 0, 0, 33, 0, 0, 0, 9, 3.5, '-196', 'Hawaii', 817.5, '+139', 7.06, 5.02,6),
(65, 'Sammy Watkins', 'BAL', 'WR', 0, 0, 0, 119, 0, 0, 0, 3, 6.5, '+199', 'Kansas State', 578.5, '+236', 6.21, 4.58,10),
(66, 'Devin Singletary', 'BUF', 'RB', 0, 0, 819, 280, 5, 0, 1, 16, 5.5, '+193', 'Minnesota', 873.5, '-142', 6.97, 4.58,21),
(67, 'Josh Allen', 'BUF', 'QB', 73.4, 4283, 762, 0, 7, 35, 0, 16, 9.5, '-170', 'North Texas', 699.5, '+186', 6.59, 4.86,8),
(68, 'James Cook', 'BUF', 'RB', 0, 0, 507, 180, 2, 0, 1, 16, 3.5, '+184', 'Texas State', 493.5, '+137', 6.93, 4.85,5),
(69, 'Zack Moss', 'BUF', 'RB', 0, 0, 91, 27, 0, 0, 0, 5, 3.5, '+116', 'Colorado', 773.5, '-177', 7.1, 4.24,16),
(70, 'Isaiah McKenzie', 'BUF', 'WR', 0, 0, 55, 423, 1, 0, 4, 15, 8.5, '-103', 'FAU', 1091.5, '-113', 6.88, 4.52,8),
(71, 'Nyheim Hines', 'BUF', 'RB', 0, 0, -3, 53, 0, 0, 1, 9, 6.5, '-174', 'Stanford', 1124.5, '+186', 7.19, 4.33,14),
(72, 'Case Keenum', 'BUF', 'QB', 4.7, 8, 0, 0, 0, 0, 0, 2, 9.5, '+133', 'Notre Dame', 1058.5, '+192', 6.75, 5.02,18),
(73, 'Duke Johnson', 'BUF', 'RB', 0, 0, 4, 0, 0, 0, 0, 1, 8.5, '-127', 'Georgia Southern', 796.5, '-192', 6.83, 5.06,8),
(74, 'Stefon Diggs', 'BUF', 'WR', 0, 0, -3, 1429, 0, 0, 11, 16, 4.5, '+131', 'Temple', 1021.5, '+196', 6.96, 4.96,8),
(75, 'Gabriel Davis', 'BUF', 'WR', 0, 0, 0, 836, 0, 0, 7, 15, 8.5, '-163', 'FAU', 795.5, '+173', 6.75, 4.49,20),
(76, 'Dawson Knox', 'BUF', 'TE', 0, 0, 0, 517, 0, 0, 6, 15, 5.5, '-169', 'Western Kentucky', 1096.5, '-186', 6.9, 4.99,14),
(77, 'Khalil Shakir', 'BUF', 'WR', 0, 0, 0, 161, 0, 0, 1, 14, 10.5, '-152', 'Colorado State', 527.5, '-200', 6.77, 4.45,21),
(78, 'Reggie Gilliam', 'BUF', 'FB', 0, 0, 0, 69, 0, 0, 1, 15, 8.5, '+104', 'Houston', 1065.5, '-144', 6.76, 4.58,4),
(79, 'Quintin Morris', 'BUF', 'TE', 0, 0, 0, 84, 0, 0, 1, 14, 8.5, '-147', 'Florida State', 805.5, '-106', 6.61, 5.19,21),
(80, 'Jamison Crowder', 'BUF', 'WR', 0, 0, 0, 60, 0, 0, 0, 4, 10.5, '+116', 'Indiana', 802.5, '-118', 6.5, 5.17,9),
(81, 'Isaiah Hodgins', 'BUF', 'WR', 0, 0, 0, 41, 0, 0, 0, 2, 10.5, '+192', 'Illinois', 976.5, '-117', 6.41, 4.41,1),
(82, 'Jake Kumerow', 'BUF', 'WR', 0, 0, 0, 64, 0, 0, 0, 6, 4.5, '+112', 'Eastern Michigan', 667.5, '-113', 6.96, 4.99,5),
(83, 'Cole Beasley', 'BUF', 'WR', 0, 0, 0, 18, 0, 0, 0, 2, 7.5, '+241', 'Stanford', 782.5, '-161', 6.56, 4.74,20),
(84, 'John Brown', 'BUF', 'WR', 0, 0, 0, 42, 0, 0, 1, 3, 9.5, '+117', 'Cincinnati', 1010.5, '-131', 7.17, 4.43,11),
(85, 'Tommy Sweeney', 'BUF', 'TE', 0, 0, 0, 7, 0, 0, 0, 5, 10.5, '+153', 'Oregon', 469.5, '-116', 7.11, 5.1,5),
(86, 'Tanner Gentry', 'BUF', 'WR', 0, 0, 0, 0, 0, 0, 0, 3, 10.5, '-112', 'Navy', 601.5, '+144', 6.43, 4.82,20),
(87, 'Donta Foreman', 'CAR', 'RB', 0, 0, 914, 26, 5, 0, 0, 17, 3.5, '+110', 'Iowa State', 738.5, '+223', 7.18, 4.89,15),
(88, 'Chuba Hubbard', 'CAR', 'RB', 0, 0, 466, 171, 2, 0, 0, 15, 8.5, '-185', 'Georgia', 510.5, '-164', 6.79, 4.74,9),
(89, 'Christian McCaffrey', 'CAR', 'RB', 0, 0, 393, 277, 2, 0, 1, 6, 4.5, '+169', 'Utah', 834.5, '-185', 6.23, 4.94,7),
(90, 'Sam Darnold', 'CAR', 'QB', 51.4, 1143, 106, 0, 2, 7, 0, 6, 9.5, '-195', 'Buffalo', 1091.5, '+149', 7.04, 4.35,6),
(91, 'Raheem Blackshear', 'CAR', 'RB', 0, 0, 77, 93, 3, 0, 0, 13, 6.5, '+144', 'Syracuse', 1162.5, '+171', 6.26, 4.43,4),
(92, 'Baker Mayfield', 'CAR', 'QB', 26.3, 2163, 52, 0, 1, 10, 0, 7, 8.5, '-186', 'Arkansas State', 539.5, '+110', 7.09, 4.55,11),
(93, 'D.J. Moore', 'CAR', 'WR', 0, 0, 53, 888, 0, 0, 7, 17, 8.5, '+168', 'Colorado', 554.5, '-172', 6.66, 4.53,5),
(94, 'Laviska Shenault Jr.', 'CAR', 'WR', 0, 0, 65, 272, 1, 0, 1, 13, 3.5, '+245', 'NC State', 977.5, '-194', 6.42, 4.49,6),
(95, 'Spencer Brown', 'CAR', 'RB', 0, 0, 43, 10, 0, 0, 0, 2, 2.5, '+232', 'Florida', 1184.5, '+240', 7.02, 5,6),
(96, 'P.J. Walker', 'CAR', 'QB', 25.1, 731, 39, 0, 0, 3, 0, 6, 3.5, '-119', 'New Mexico State', 1146.5, '+245', 6.72, 4.28,17),
(97, 'Sean Chandler', 'CAR', 'S', 0, 0, 2, 0, 0, 0, 0, 17, 3.5, '+132', 'Texas Tech', 1061.5, '+180', 6.99, 4.43,16),
(98, 'Terrace Marshall Jr.', 'CAR', 'WR', 0, 0, 0, 490, 0, 0, 1, 14, 5.5, '+180', 'Ball State', 544.5, '+169', 6.34, 5.04,19),
(99, 'Shi Smith', 'CAR', 'WR', 0, 0, 0, 296, 0, 0, 2, 17, 6.5, '+128', 'Rutgers', 947.5, '+248', 6.87, 4.49,4),
(100, 'Ian Thomas', 'CAR', 'TE', 0, 0, 0, 197, 0, 0, 0, 17, 4.5, '-143', 'USF', 768.5, '-129', 7.05, 5.04,14),
(101, 'Tommy Tremble', 'CAR', 'TE', 0, 0, 0, 174, 0, 0, 3, 17, 5.5, '-186', 'LSU', 848.5, '+103', 6.33, 5.09,7),
(102, 'Robbie Chosen', 'CAR', 'WR', 0, 0, 0, 206, 0, 0, 1, 6, 4.5, '+112', 'Coastal Carolina', 608.5, '-187', 6.94, 4.66,18),
(103, 'Giovanni Ricci', 'CAR', 'TE', 0, 0, 0, 100, 0, 0, 0, 15, 5.5, '-176', 'Penn State', 550.5, '+133', 6.73, 4.63,15),
(104, 'Stephen Sullivan', 'CAR', 'TE', 0, 0, 0, 46, 0, 0, 0, 14, 9.5, '-172', 'Buffalo', 694.5, '-139', 7.08, 4.77,9),
(105, 'David Montgomery', 'CHI', 'RB', 0, 0, 801, 316, 5, 0, 1, 16, 10.5, '+180', 'Purdue', 1090.5, '+103', 6.23, 4.32,3),
(106, 'Justin Fields', 'CHI', 'QB', 56.3, 2242, 1143, 0, 8, 17, 0, 15, 6.5, '-134', 'Western Michigan', 832.5, '+249', 6.92, 5.11,13),
(107, 'Khalil Herbert', 'CHI', 'RB', 0, 0, 731, 57, 4, 0, 1, 13, 7.5, '+220', 'San Jose State', 850.5, '-173', 6.46, 5.15,3),
(108, 'Trestan Ebner', 'CHI', 'RB', 0, 0, 54, 8, 0, 0, 0, 17, 9.5, '-135', 'Nevada', 881.5, '+211', 6.87, 4.85,14),
(109, 'Darrynton Evans', 'CHI', 'RB', 0, 0, 64, 33, 0, 0, 0, 6, 2.5, '-141', 'Baylor', 886.5, '-141', 6.3, 5.14,13),
(110, 'Velus Jones Jr.', 'CHI', 'WR', 0, 0, 103, 107, 1, 0, 1, 12, 10.5, '-197', 'Wyoming', 987.5, '+150', 6.54, 5.15,10),
(111, 'Equanimeous St. Brown', 'CHI', 'WR', 0, 0, 54, 323, 0, 0, 1, 16, 2.5, '-131', 'Indiana', 538.5, '+156', 7.16, 5.06,3),
(112, 'Trevor Siemian', 'CHI', 'QB', 27.9, 184, 8, 0, 0, 1, 0, 2, 8.5, '+171', 'Louisiana Tech', 994.5, '+174', 7, 4.32,4),
(113, 'Cole Kmet', 'CHI', 'TE', 0, 0, 9, 544, 0, 0, 7, 17, 2.5, '-195', 'FAU', 802.5, '-159', 6.85, 4.39,14),
(114, 'Dante Pettis', 'CHI', 'WR', 0, 0, 37, 245, 0, 0, 3, 17, 2.5, '+238', 'Duke', 731.5, '-126', 6.75, 4.8,3),
(115, 'Tim Boyle', 'CHI', 'QB', 1.2, 33, -2, 0, 0, 0, 0, 1, 9.5, '+231', 'New Mexico State', 1145.5, '-146', 6.35, 4.46,17),
(116, 'Nathan Peterman', 'CHI', 'QB', 41.9, 139, 7, 0, 0, 1, 0, 3, 9.5, '+193', 'South Alabama', 1018.5, '+249', 6.4, 4.29,10),
(117, 'Darnell Mooney', 'CHI', 'WR', 0, 0, 2, 493, 0, 0, 2, 12, 3.5, '+202', 'Iowa State', 465.5, '+135', 6.2, 4.93,6),
(118, 'Chase Claypool', 'CHI', 'WR', 0, 0, 4, 140, 0, 0, 0, 7, 3.5, '+212', 'Colorado State', 1167.5, '-115', 6.27, 5.06,16),
(119, 'Ihmir Smith-Marsette', 'CHI', 'WR', 0, 0, -1, 15, 0, 0, 0, 6, 8.5, '-146', 'Wisconsin', 1127.5, '-184', 6.33, 4.25,11),
(120, 'Byron Pringle', 'CHI', 'WR', 0, 0, 0, 135, 0, 0, 2, 11, 3.5, '-184', 'Florida', 935.5, '+230', 6.68, 4.82,10),
(121, 'NKeal Harry', 'CHI', 'WR', 0, 0, 0, 116, 0, 0, 1, 7, 2.5, '+103', 'Kansas', 629.5, '+140', 6.73, 4.28,4),
(122, 'Ryan Griffin', 'CHI', 'TE', 0, 0, 0, 26, 0, 0, 0, 15, 5.5, '-134', 'Purdue', 564.5, '+193', 7, 5.17,5),
(123, 'Nsimba Webster', 'CHI', 'WR', 0, 0, 0, 14, 0, 0, 0, 2, 7.5, '+218', 'Wake Forest', 542.5, '-177', 6.5, 4.26,9),
(124, 'Trevon Wesco', 'CHI', 'TE', 0, 0, 0, 26, 0, 0, 0, 14, 10.5, '+212', 'Missouri', 692.5, '-109', 7.03, 4.29,17),
(125, 'Khari Blasingame', 'CHI', 'FB', 0, 0, 0, 0, 0, 0, 0, 16, 6.5, '+113', 'Oregon State', 533.5, '+122', 6.89, 4.75,9),
(126, 'Jake Tonges', 'CHI', 'TE', 0, 0, 0, 0, 0, 0, 0, 4, 10.5, '+109', 'Washington State', 1086.5, '-172', 7.08, 5.07,12),
(127, 'Joe Mixon', 'CIN', 'RB', 0, 0, 814, 441, 7, 0, 2, 14, 5.5, '-177', 'Illinois', 1198.5, '-143', 6.38, 4.68,14),
(128, 'Samaje Perine', 'CIN', 'RB', 0, 0, 394, 287, 2, 0, 4, 16, 5.5, '-140', 'Washington', 1029.5, '-188', 7.1, 4.65,13),
(129, 'Joe Burrow', 'CIN', 'QB', 60.8, 4475, 257, 0, 5, 35, 0, 16, 4.5, '-113', 'Colorado', 700.5, '+125', 6.47, 4.45,20),
(130, 'Trayveon Williams', 'CIN', 'RB', 0, 0, 30, 30, 0, 0, 0, 8, 4.5, '-168', 'North Carolina', 1132.5, '+159', 6.68, 4.81,5),
(131, 'JaMarr Chase', 'CIN', 'WR', 0, 0, 8, 1046, 0, 0, 9, 12, 5.5, '+167', 'Oklahoma', 1063.5, '-185', 6.44, 4.99,9),
(132, 'Trent Taylor', 'CIN', 'WR', 0, 0, 15, 62, 0, 0, 0, 16, 4.5, '+186', 'Louisiana Tech', 995.5, '-138', 6.96, 4.6,19),
(133, 'Brandon Allen', 'CIN', 'QB', 46.5, 22, -1, 0, 0, 0, 0, 1, 3.5, '-164', 'Wyoming', 796.5, '-170', 6.78, 4.45,11),
(134, 'Trenton Irwin', 'CIN', 'WR', 0, 0, 11, 231, 0, 0, 4, 9, 9.5, '+206', 'Tulsa', 1175.5, '-121', 7.06, 5.06,5),
(135, 'Tee Higgins', 'CIN', 'WR', 0, 0, 0, 1029, 0, 0, 7, 16, 6.5, '-186', 'Illinois', 531.5, '+247', 6.44, 4.41,2),
(136, 'Tyler Boyd', 'CIN', 'WR', 0, 0, 0, 762, 0, 0, 5, 16, 6.5, '+113', 'Air Force', 1030.5, '+168', 6.74, 5.17,1),
(137, 'Hayden Hurst', 'CIN', 'TE', 0, 0, 0, 414, 0, 0, 2, 13, 8.5, '-163', 'Alabama', 616.5, '-128', 6.73, 4.39,13),
(138, 'Mitchell Wilcox', 'CIN', 'TE', 0, 0, 0, 139, 0, 0, 1, 16, 3.5, '+217', 'Kansas State', 704.5, '+236', 7.07, 4.28,7),
(139, 'Chris Evans', 'CIN', 'RB', 0, 0, 0, 38, 0, 0, 1, 12, 8.5, '+159', 'Middle Tennessee', 872.5, '+159', 6.52, 4.96,9),
(140, 'Devin Asiasi', 'CIN', 'TE', 0, 0, 0, 5, 0, 0, 0, 12, 9.5, '+173', 'Utah', 982.5, '+136', 6.7, 4.86,2),
(141, 'Drew Sample', 'CIN', 'TE', 0, 0, 0, -2, 0, 0, 0, 2, 5.5, '-128', 'Marshall', 607.5, '+138', 6.61, 4.3,11),
(142, 'Mike Thomas', 'CIN', 'WR', 0, 0, 0, 38, 0, 0, 0, 10, 10.5, '-137', 'Alabama', 869.5, '-179', 6.72, 4.48,14),
(143, 'Stanley Morgan Jr.', 'CIN', 'WR', 0, 0, 0, 0, 0, 0, 0, 14, 4.5, '-126', 'Akron', 573.5, '+131', 7.02, 4.23,10),
(144, 'Nick Chubb', 'CLE', 'RB', 0, 0, 1525, 239, 12, 0, 1, 17, 4.5, '+210', 'Boise State', 988.5, '+170', 6.93, 4.48,17),
(145, 'Kareem Hunt', 'CLE', 'RB', 0, 0, 468, 210, 3, 0, 1, 17, 6.5, '+215', 'UCLA', 880.5, '+135', 6.79, 5.18,8),
(146, 'Jacoby Brissett', 'CLE', 'QB', 62, 2608, 243, 0, 2, 12, 0, 16, 3.5, '+237', 'NC State', 656.5, '-175', 6.63, 4.43,4),
(147, 'Deshaun Watson', 'CLE', 'QB', 40.4, 1102, 175, 0, 1, 7, 0, 6, 2.5, '-145', 'Washington', 698.5, '+118', 6.44, 4.48,6),
(148, 'Jerome Ford', 'CLE', 'RB', 0, 0, 12, 0, 0, 0, 0, 13, 3.5, '+181', 'LSU', 594.5, '-188', 7.04, 5.04,13),
(149, 'Anthony Schwartz', 'CLE', 'WR', 0, 0, 57, 51, 1, 0, 0, 11, 9.5, '+199', 'Middle Tennessee', 865.5, '-182', 6.99, 4.47,20),
(150, 'Dernest Johnson', 'CLE', 'RB', 0, 0, 17, 7, 0, 0, 0, 15, 4.5, '+185', 'Maryland', 1137.5, '-111', 6.57, 5.12,18),
(151, 'David Njoku', 'CLE', 'TE', 0, 0, -8, 628, 0, 0, 4, 14, 5.5, '+183', 'Duke', 826.5, '-140', 6.22, 4.73,14),
(152, 'Donovan Peoples-Jones', 'CLE', 'WR', 0, 0, 2, 839, 0, 0, 3, 17, 7.5, '-149', 'Middle Tennessee', 549.5, '+124', 6.98, 4.74,13),
(153, 'Harrison Bryant', 'CLE', 'TE', 0, 0, 8, 239, 0, 0, 1, 17, 4.5, '-132', 'Texas A&M', 1184.5, '-122', 6.21, 4.96,3),
(154, 'Michael Woods II', 'CLE', 'WR', 0, 0, -5, 45, 0, 0, 0, 10, 2.5, '+229', 'Coastal Carolina', 562.5, '+214', 6.36, 4.66,17),
(155, 'Demetric Felton', 'CLE', 'RB', 0, 0, -4, 8, 0, 0, 0, 8, 8.5, '-126', 'Pitt', 902.5, '-145', 6.27, 5.03,9),
(156, 'Amari Cooper', 'CLE', 'WR', 0, 0, 0, 1160, 0, 0, 9, 17, 3.5, '-164', 'Tulane', 894.5, '-200', 6.51, 5,15),
(157, 'David Bell', 'CLE', 'WR', 0, 0, 0, 214, 0, 0, 0, 16, 2.5, '-172', 'Kansas', 1102.5, '+215', 6.26, 4.39,14),
(158, 'Pharaoh Brown', 'CLE', 'TE', 0, 0, 0, 45, 0, 0, 0, 13, 2.5, '-105', 'Ohio State', 506.5, '+203', 6.48, 4.62,8),
(159, 'Daylen Baldwin', 'CLE', 'WR', 0, 0, 0, 25, 0, 0, 0, 1, 2.5, '-199', 'Ole Miss', 668.5, '-125', 6.82, 4.68,12),
(160, 'Jack Conklin', 'CLE', 'T', 0, 0, 0, 0, 0, 0, 0, 14, 8.5, '-185', 'Wisconsin', 488.5, '+184', 6.5, 4.43,10),
(161, 'Miller Forristall', 'CLE', 'TE', 0, 0, 0, 0, 0, 0, 0, 4, 8.5, '+105', 'Arkansas', 709.5, '-153', 6.76, 4.74,3),
(162, 'Ezekiel Elliott', 'DAL', 'RB', 0, 0, 876, 92, 12, 0, 0, 15, 2.5, '+210', 'Kansas', 470.5, '-158', 6.68, 4.74,3),
(163, 'Tony Pollard', 'DAL', 'RB', 0, 0, 1007, 371, 9, 0, 3, 16, 9.5, '-132', 'North Texas', 958.5, '-115', 6.31, 4.95,6),
(164, 'Dak Prescott', 'DAL', 'QB', 59.9, 2860, 182, 0, 1, 23, 0, 12, 4.5, '+178', 'Minnesota', 821.5, '-175', 6.97, 4.95,5),
(165, 'Malik Davis', 'DAL', 'RB', 0, 0, 161, 63, 1, 0, 0, 12, 9.5, '-146', 'Wisconsin', 1141.5, '-126', 6.31, 4.96,9),
(166, 'CeeDee Lamb', 'DAL', 'WR', 0, 0, 47, 1359, 0, 0, 9, 17, 4.5, '+225', 'Notre Dame', 563.5, '-136', 6.75, 4.6,13),
(167, 'Cooper Rush', 'DAL', 'QB', 60.8, 1051, 6, 0, 0, 5, 0, 9, 3.5, '+104', 'UMass', 800.5, '+151', 6.26, 5.11,6),
(168, 'KaVontae Turpin', 'DAL', 'WR', 0, 0, 17, 9, 0, 0, 0, 17, 10.5, '-167', 'Jacksonville State', 920.5, '+178', 6.58, 4.26,6),
(169, 'Peyton Hendershot', 'DAL', 'TE', 0, 0, 2, 103, 1, 0, 2, 17, 8.5, '+215', 'Akron', 521.5, '+105', 7.01, 4.46,20),
(170, 'Bryan Anger', 'DAL', 'P', 0, 0, 0, 0, 0, 0, 0, 17, 7.5, '-166', 'USF', 524.5, '+187', 6.39, 4.99,11),
(171, 'Dalton Schultz', 'DAL', 'TE', 0, 0, 0, 577, 0, 0, 5, 15, 10.5, '-132', 'Jacksonville State', 547.5, '+171', 6.68, 4.64,8),
(172, 'Noah Brown', 'DAL', 'WR', 0, 0, 0, 555, 0, 0, 3, 16, 4.5, '+178', 'Ball State', 1140.5, '+245', 6.95, 4.23,3),
(173, 'Michael Gallup', 'DAL', 'WR', 0, 0, 0, 424, 0, 0, 4, 14, 3.5, '-129', 'Texas A&M', 1109.5, '-176', 6.58, 4.58,8),
(174, 'Jake Ferguson', 'DAL', 'TE', 0, 0, 0, 174, 0, 0, 2, 16, 8.5, '-197', 'UNLV', 1052.5, '+205', 6.8, 4.31,18),
(175, 'T.Y. Hilton', 'DAL', 'WR', 0, 0, 0, 121, 0, 0, 0, 3, 8.5, '-114', 'North Carolina', 1004.5, '-193', 6.73, 4.52,4),
(176, 'Simi Fehoko', 'DAL', 'WR', 0, 0, 0, 24, 0, 0, 0, 5, 8.5, '-172', 'Rice', 562.5, '-182', 6.47, 5.03,12),
(177, 'Dennis Houston', 'DAL', 'WR', 0, 0, 0, 16, 0, 0, 0, 2, 3.5, '+180', 'Washington State', 827.5, '-104', 7.18, 4.29,14),
(178, 'Sean McKeon', 'DAL', 'TE', 0, 0, 0, 11, 0, 0, 0, 13, 9.5, '+180', 'Georgia', 1062.5, '+231', 7.2, 4.59,20),
(179, 'Jalen Tolbert', 'DAL', 'WR', 0, 0, 0, 12, 0, 0, 0, 8, 10.5, '-180', 'Fresno State', 881.5, '-108', 6.47, 4.41,1),
(180, 'James Washington', 'DAL', 'WR', 0, 0, 0, 0, 0, 0, 0, 2, 5.5, '-193', 'Coastal Carolina', 912.5, '+106', 6.89, 4.48,12),
(181, 'Latavius Murray', 'DEN', 'RB', 0, 0, 703, 124, 5, 0, 0, 12, 4.5, '+171', 'USC', 552.5, '-127', 6.29, 4.33,17),
(182, 'Melvin Gordon', 'DEN', 'RB', 0, 0, 318, 223, 2, 0, 0, 10, 7.5, '-167', 'Charlotte', 901.5, '-174', 6.9, 5.19,13),
(183, 'Russell Wilson', 'DEN', 'QB', 38.7, 3524, 277, 1, 3, 16, 0, 15, 4.5, '+213', 'Nebraska', 808.5, '-134', 7.15, 4.99,12),
(184, 'Javonte Williams', 'DEN', 'RB', 0, 0, 204, 76, 0, 0, 0, 4, 5.5, '+107', 'Appalachian State', 866.5, '-122', 7.15, 4.62,18),
(185, 'Chase Edmonds', 'DEN', 'RB', 0, 0, 125, 61, 0, 0, 0, 5, 7.5, '-181', 'North Texas', 1061.5, '+211', 6.24, 4.29,15),
(186, 'Mike Boone', 'DEN', 'RB', 0, 0, 102, 96, 0, 0, 0, 9, 10.5, '-144', 'Michigan State', 456.5, '-147', 7.03, 4.98,6),
(187, 'Marlon Mack', 'DEN', 'RB', 0, 0, 84, 99, 1, 0, 1, 6, 10.5, '-148', 'Illinois', 583.5, '-119', 6.64, 4.34,13),
(188, 'Brett Rypien', 'DEN', 'QB', 25.8, 483, 7, 0, 0, 2, 0, 4, 6.5, '-142', 'Akron', 523.5, '+228', 6.26, 4.73,4),
(189, 'Montrell Washington', 'DEN', 'WR', 0, 0, 30, 2, 0, 0, 0, 15, 6.5, '+102', 'Texas Tech', 597.5, '-159', 6.63, 4.61,11),
(190, 'Jerry Jeudy', 'DEN', 'WR', 0, 0, 40, 972, 0, 0, 6, 15, 2.5, '-195', 'Kentucky', 708.5, '+229', 6.42, 5.12,18),
(191, 'Devine Ozigbo', 'DEN', 'RB', 0, 0, 4, 3, 0, 0, 0, 4, 3.5, '-164', 'Louisiana', 840.5, '+177', 6.71, 5.18,6),
(192, 'Kendall Hinton', 'DEN', 'WR', 0, 0, 13, 311, 0, 0, 0, 12, 5.5, '-111', 'Utah', 997.5, '-105', 6.98, 4.83,20),
(193, 'KJ Hamler', 'DEN', 'WR', 0, 0, 23, 165, 0, 0, 0, 7, 3.5, '-159', 'Fresno State', 1197.5, '+216', 6.27, 4.83,12),
(194, 'Andrew Beck', 'DEN', 'FB', 0, 0, 0, 69, 0, 0, 0, 13, 9.5, '+207', 'FIU', 968.5, '-102', 6.95, 4.81,18),
(195, 'Courtland Sutton', 'DEN', 'WR', 0, 0, 5, 829, 0, 0, 2, 15, 4.5, '+222', 'Virginia Tech', 889.5, '-152', 6.26, 5.04,6),
(196, 'Tyler Badie', 'DEN', 'RB', 0, 0, 0, 24, 0, 0, 1, 1, 3.5, '-124', 'Kentucky', 740.5, '+249', 6.39, 4.66,12),
(197, 'Greg Dulcich', 'DEN', 'TE', 0, 0, 0, 411, 0, 0, 2, 10, 7.5, '-136', 'Indiana', 495.5, '-113', 6.45, 4.99,3),
(198, 'Eric Saubert', 'DEN', 'TE', 0, 0, 0, 148, 0, 0, 1, 17, 5.5, '-146', 'Arkansas State', 856.5, '+199', 6.44, 5.06,1),
(199, 'Albert Okwuegbunam', 'DEN', 'TE', 0, 0, 0, 95, 0, 0, 1, 8, 3.5, '-128', 'Ohio', 600.5, '-120', 7.12, 4.88,18),
(200, 'Eric Tomlinson', 'DEN', 'TE', 0, 0, 0, 79, 0, 0, 2, 17, 5.5, '-105', 'Fresno State', 626.5, '-158', 7.04, 4.23,7),
(201, 'Brandon Johnson', 'DEN', 'WR', 0, 0, 0, 42, 0, 0, 1, 7, 8.5, '+113', 'Minnesota', 617.5, '-140', 6.64, 5.01,18),
(202, 'Freddie Swain', 'DEN', 'WR', 0, 0, 0, 74, 0, 0, 0, 3, 5.5, '+219', 'Ball State', 739.5, '-112', 6.41, 5.11,13),
(203, 'Tyrie Cleveland', 'DEN', 'WR', 0, 0, 0, 28, 0, 0, 0, 6, 7.5, '-161', 'Oklahoma', 600.5, '-190', 6.61, 4.71,18),
(204, 'Jalen Virgil', 'DEN', 'WR', 0, 0, 0, 75, 0, 0, 1, 9, 3.5, '+113', 'FIU', 945.5, '+241', 6.39, 4.44,10),
(205, 'Jamaal Williams', 'DET', 'RB', 0, 0, 1066, 73, 17, 0, 0, 17, 5.5, '+108', 'Clemson', 1133.5, '-119', 6.76, 4.81,9),
(206, 'DAndre Swift', 'DET', 'RB', 0, 0, 542, 389, 5, 0, 3, 14, 7.5, '+163', 'Purdue', 930.5, '-107', 6.73, 4.87,16),
(207, 'Justin Jackson', 'DET', 'RB', 0, 0, 170, 101, 1, 0, 1, 16, 5.5, '-165', 'Texas A&M', 570.5, '-145', 6.91, 4.71,17),
(208, 'Jared Goff', 'DET', 'QB', 63.3, 4438, 73, 5, 0, 29, 0, 17, 4.5, '+212', 'Ohio State', 631.5, '+132', 7.16, 4.7,9),
(209, 'Craig Reynolds', 'DET', 'RB', 0, 0, 102, 116, 0, 0, 0, 9, 6.5, '+115', 'Florida', 817.5, '-152', 6.46, 4.5,16),
(210, 'Amon-Ra St. Brown', 'DET', 'WR', 0, 0, 95, 1161, 0, 0, 6, 16, 6.5, '+197', 'Iowa State', 575.5, '+122', 6.33, 5.01,17),
(211, 'Kalif Raymond', 'DET', 'WR', 0, 0, 36, 616, 0, 0, 0, 17, 4.5, '-131', 'South Alabama', 1175.5, '-198', 6.31, 4.68,7),
(212, 'Nate Sudfeld', 'DET', 'QB', 9.2, 10, -4, 0, 0, 0, 0, 2, 7.5, '+205', 'USF', 639.5, '-120', 6.47, 4.83,1),
(213, 'C.J. Moore', 'DET', 'S', 0, 0, 55, 0, 0, 0, 0, 11, 10.5, '+111', 'Baylor', 474.5, '-166', 7, 4.28,15),
(214, 'Jason Cabinda', 'DET', 'FB', 0, 0, 4, 5, 0, 0, 0, 8, 4.5, '+243', 'Old Dominion', 990.5, '-133', 6.44, 4.78,11),
(215, 'Jameson Williams', 'DET', 'WR', 0, 0, 40, 41, 0, 0, 1, 6, 7.5, '-123', 'Arkansas State', 1000.5, '+226', 6.36, 4.79,6),
(216, 'Josh Reynolds', 'DET', 'WR', 0, 0, 0, 479, 0, 0, 3, 14, 2.5, '+242', 'Ohio', 1042.5, '-139', 6.62, 5.16,12),
(217, 'DJ Chark', 'DET', 'WR', 0, 0, 0, 502, 0, 0, 3, 11, 8.5, '-113', 'NC State', 1139.5, '-151', 6.41, 4.69,18),
(218, 'T.J. Hockenson', 'DET', 'TE', 0, 0, 0, 395, 0, 0, 3, 7, 4.5, '+195', 'Arizona State', 1037.5, '-111', 7.02, 4.96,3),
(219, 'Brock Wright', 'DET', 'TE', 0, 0, 0, 216, 0, 0, 4, 17, 8.5, '-133', 'Bowling Green', 537.5, '-154', 6.49, 4.82,18),
(220, 'James Mitchell', 'DET', 'TE', 0, 0, 0, 113, 0, 0, 1, 14, 7.5, '+237', 'Texas Tech', 1009.5, '-121', 6.6, 4.37,5),
(221, 'Shane Zylstra', 'DET', 'TE', 0, 0, 0, 60, 0, 0, 4, 13, 9.5, '+177', 'Duke', 645.5, '-137', 6.8, 4.78,1),
(222, 'Tom Kennedy', 'DET', 'WR', 0, 0, 0, 141, 0, 0, 0, 7, 8.5, '+186', 'UConn', 981.5, '+216', 7, 4.45,5),
(223, 'Quintez Cephus', 'DET', 'WR', 0, 0, 0, 15, 0, 0, 0, 4, 3.5, '-130', 'Houston', 1165.5, '-107', 6.82, 4.61,20),
(224, 'Maurice Alexander', 'DET', 'WR', 0, 0, 0, 7, 0, 0, 0, 4, 10.5, '+217', 'Coastal Carolina', 960.5, '-116', 6.89, 4.47,10),
(225, 'Penei Sewell', 'DET', 'T', 0, 0, 0, 9, 0, 0, 0, 17, 8.5, '-131', 'Minnesota', 964.5, '+147', 6.91, 4.99,5),
(226, 'Aaron Jones', 'GB', 'RB', 0, 0, 1121, 395, 2, 0, 5, 17, 7.5, '-156', 'New Mexico', 832.5, '+212', 7.05, 4.84,19),
(227, 'AJ Dillon', 'GB', 'RB', 0, 0, 770, 206, 7, 0, 0, 17, 9.5, '+127', 'Akron', 845.5, '-121', 6.59, 4.52,6),
(228, 'Aaron Rodgers', 'GB', 'QB', 41.3, 3695, 94, 0, 1, 26, 0, 17, 2.5, '-180', 'Georgia', 505.5, '-142', 6.32, 4.39,17),
(229, 'Patrick Taylor', 'GB', 'RB', 0, 0, 31, 17, 0, 0, 0, 14, 3.5, '-131', 'Alabama', 733.5, '+188', 6.98, 4.57,17),
(230, 'Christian Watson', 'GB', 'WR', 0, 0, 80, 611, 2, 0, 7, 14, 4.5, '-141', 'Wyoming', 716.5, '-179', 7.15, 4.37,8),
(231, 'Allen Lazard', 'GB', 'WR', 0, 0, 0, 788, 0, 0, 6, 15, 8.5, '+131', 'Arizona State', 821.5, '+170', 6.6, 4.27,20),
(232, 'Romeo Doubs', 'GB', 'WR', 0, 0, 11, 425, 0, 0, 3, 13, 9.5, '+208', 'Iowa', 905.5, '+246', 7.12, 4.55,7),
(233, 'Kylin Hill', 'GB', 'RB', 0, 0, 7, 0, 0, 0, 0, 2, 8.5, '-164', 'Georgia Tech', 911.5, '-103', 7.11, 4.3,20),
(234, 'Dallin Leavitt', 'GB', 'S', 0, 0, 0, 0, 0, 0, 0, 17, 8.5, '+247', 'Nebraska', 934.5, '-104', 6.6, 4.23,14),
(235, 'Jordan Love', 'GB', 'QB', 83.2, 195, -1, 0, 0, 1, 0, 4, 2.5, '-106', 'Illinois', 920.5, '+154', 6.41, 4.58,14),
(236, 'Robert Tonyan', 'GB', 'TE', 0, 0, 0, 470, 0, 0, 2, 17, 8.5, '-124', 'Liberty', 1102.5, '-124', 7.08, 5.05,10),
(237, 'Randall Cobb', 'GB', 'WR', 0, 0, 0, 417, 0, 0, 1, 13, 2.5, '+128', 'Kent State', 651.5, '+178', 6.72, 4.68,2),
(238, 'Josiah Deguara', 'GB', 'TE', 0, 0, 0, 114, 0, 0, 0, 17, 8.5, '+100', 'UCF', 837.5, '-125', 6.96, 4.87,19),
(239, 'Sammy Watkins', 'GB', 'WR', 0, 0, 0, 206, 0, 0, 0, 9, 9.5, '+103', 'Jacksonville State', 523.5, '-123', 6.77, 4.45,10),
(240, 'Marcedes Lewis', 'GB', 'TE', 0, 0, 0, 66, 0, 0, 2, 17, 7.5, '-176', 'Kansas', 695.5, '-124', 7.16, 4.78,16),
(241, 'Samori Toure', 'GB', 'WR', 0, 0, 0, 82, 0, 0, 1, 11, 10.5, '+110', 'Buffalo', 1091.5, '+248', 6.34, 4.49,4),
(242, 'Tyler Davis', 'GB', 'TE', 0, 0, 0, 26, 0, 0, 0, 17, 2.5, '+158', 'Toledo', 1025.5, '-103', 6.85, 4.96,20),
(243, 'Amari Rodgers', 'GB', 'WR', 0, 0, 0, 50, 0, 0, 0, 10, 7.5, '+157', 'Illinois', 468.5, '+154', 6.44, 4.48,16),
(244, 'Juwann Winfree', 'GB', 'WR', 0, 0, 0, 17, 0, 0, 0, 3, 8.5, '-127', 'Liberty', 822.5, '-162', 6.45, 4.56,6),
(245, 'David Bakhtiari', 'GB', 'T', 0, 0, 0, 0, 0, 0, 0, 11, 6.5, '-139', 'Kansas State', 1020.5, '+185', 6.25, 4.92,5),
(246, 'Dameon Pierce', 'HOU', 'RB', 0, 0, 939, 165, 4, 0, 1, 13, 7.5, '-160', 'Tulane', 819.5, '+124', 6.31, 5.13,9),
(247, 'Dare Ogunbowale', 'HOU', 'RB', 0, 0, 123, 104, 1, 0, 0, 17, 9.5, '-177', 'Oregon State', 642.5, '+158', 6.27, 4.38,17),
(248, 'Royce Freeman', 'HOU', 'RB', 0, 0, 117, 33, 0, 0, 0, 4, 5.5, '-131', 'Tulane', 1190.5, '+137', 6.27, 4.64,2),
(249, 'Davis Mills', 'HOU', 'QB', 35, 3118, 108, 0, 2, 17, 0, 15, 9.5, '+175', 'Alabama', 611.5, '-189', 6.92, 4.8,16),
(250, 'Rex Burkhead', 'HOU', 'RB', 0, 0, 80, 204, 0, 0, 1, 16, 9.5, '+107', 'ULM', 566.5, '-100', 6.38, 4.29,7),
(251, 'Jeff Driskel', 'HOU', 'QB', 20.9, 108, 75, 4, 0, 1, 0, 7, 10.5, '+247', 'Minnesota', 668.5, '-166', 6.65, 5.08,19),
(252, 'Kyle Allen', 'HOU', 'QB', 3.7, 416, 13, 0, 0, 2, 0, 2, 9.5, '+149', 'Wake Forest', 821.5, '-120', 7.16, 4.51,9),
(253, 'Chris Moore', 'HOU', 'WR', 0, 0, 3, 548, 0, 0, 2, 16, 5.5, '+222', 'Wake Forest', 772.5, '-114', 6.53, 4.81,15),
(254, 'Eno Benjamin', 'HOU', 'RB', 0, 0, 1, 0, 0, 0, 0, 2, 9.5, '+170', 'Oregon State', 788.5, '+123', 6.32, 4.79,13),
(255, 'Brandin Cooks', 'HOU', 'WR', 0, 0, 7, 699, 0, 0, 3, 13, 3.5, '+127', 'Ball State', 640.5, '-118', 6.46, 4.74,3),
(256, 'Amari Rodgers', 'HOU', 'WR', 0, 0, 7, 154, 0, 0, 1, 6, 4.5, '+233', 'Texas Tech', 1133.5, '+184', 6.79, 4.35,16),
(257, 'M.J. Stewart', 'HOU', 'DB', 0, 0, 3, 0, 0, 0, 0, 17, 8.5, '-116', 'Akron', 495.5, '+148', 6.48, 4.64,16),
(258, 'Jordan Akins', 'HOU', 'TE', 0, 0, 0, 495, 0, 0, 5, 15, 4.5, '+229', 'Stanford', 481.5, '-178', 6.79, 4.89,18),
(259, 'Nico Collins', 'HOU', 'WR', 0, 0, 0, 481, 0, 0, 2, 10, 6.5, '+216', 'Texas A&M', 872.5, '-116', 7.15, 4.23,17),
(260, 'Phillip Dorsett', 'HOU', 'WR', 0, 0, 0, 257, 0, 0, 1, 15, 8.5, '+197', 'TCU', 721.5, '+203', 6.64, 4.87,11),
(261, 'Brevin Jordan', 'HOU', 'TE', 0, 0, 0, 128, 0, 0, 0, 11, 8.5, '+210', 'Memphis', 1088.5, '-184', 6.79, 4.39,3),
(262, 'O.J. Howard', 'HOU', 'TE', 0, 0, 0, 145, 0, 0, 2, 13, 4.5, '+127', 'Rutgers', 612.5, '+125', 6.5, 4.37,4),
(263, 'Pharaoh Brown', 'HOU', 'TE', 0, 0, 0, 72, 0, 0, 0, 3, 9.5, '+113', 'Akron', 1064.5, '+217', 6.88, 4.44,16),
(264, 'Teagan Quitoriano', 'HOU', 'TE', 0, 0, 0, 113, 0, 0, 2, 9, 9.5, '-107', 'Ole Miss', 786.5, '-145', 6.55, 5.15,10),
(265, 'Troy Hairston', 'HOU', 'FB', 0, 0, 0, 19, 0, 0, 0, 16, 5.5, '+170', 'Purdue', 1078.5, '+140', 7.05, 4.93,9),
(266, 'Mason Schreck', 'HOU', 'TE', 0, 0, 0, 6, 0, 0, 0, 3, 5.5, '+109', 'Nebraska', 862.5, '+245', 6.94, 4.33,11),
(267, 'Jalen Camp', 'HOU', 'WR', 0, 0, 0, 7, 0, 0, 0, 2, 2.5, '-136', 'Houston', 1119.5, '+246', 6.5, 4.42,6),
(268, 'Tyron Johnson', 'HOU', 'WR', 0, 0, 0, 8, 0, 0, 0, 2, 8.5, '+110', 'Louisiana', 1137.5, '+238', 6.67, 5.05,2),
(269, 'Chris Conley', 'HOU', 'WR', 0, 0, 0, 0, 0, 0, 0, 2, 5.5, '-174', 'Oklahoma State', 450.5, '-200', 6.72, 5.06,10),
(270, 'Jonathan Taylor', 'IND', 'RB', 0, 0, 861, 143, 4, 0, 0, 11, 4.5, '-133', 'Tulsa', 1131.5, '-147', 6.69, 4.79,10),
(271, 'Zack Moss', 'IND', 'RB', 0, 0, 365, 12, 1, 0, 0, 8, 4.5, '-143', 'Hawaii', 1176.5, '-129', 6.81, 4.49,4),
(272, 'Deon Jackson', 'IND', 'RB', 0, 0, 236, 209, 1, 0, 1, 16, 10.5, '+241', 'Kentucky', 977.5, '-142', 6.7, 4.25,15),
(273, 'Matt Ryan', 'IND', 'QB', 44.9, 3057, 70, 0, 1, 14, 0, 12, 10.5, '-176', 'Miami, Ohio', 915.5, '+157', 6.87, 5.1,17),
(274, 'Nyheim Hines', 'IND', 'RB', 0, 0, 36, 188, 1, 0, 0, 7, 7.5, '+195', 'Oregon State', 822.5, '+195', 6.46, 4.89,18),
(275, 'Sam Ehlinger', 'IND', 'QB', 33.8, 573, 87, 0, 0, 3, 0, 4, 4.5, '-113', 'Cincinnati', 845.5, '+224', 6.61, 4.72,4),
(276, 'Phillip Lindsay', 'IND', 'RB', 0, 0, 49, 19, 0, 0, 0, 3, 5.5, '-147', 'Louisiana Tech', 950.5, '+144', 6.25, 4.89,4),
(277, 'Jordan Wilkins', 'IND', 'RB', 0, 0, 58, 29, 0, 0, 0, 4, 10.5, '-179', 'Kansas State', 1089.5, '-148', 6.93, 4.94,6),
(278, 'Parris Campbell', 'IND', 'WR', 0, 0, 58, 623, 0, 0, 3, 17, 4.5, '-108', 'Nebraska', 632.5, '-166', 7.17, 4.24,10),
(279, 'Michael Pittman Jr.', 'IND', 'WR', 0, 0, 30, 925, 0, 0, 4, 16, 8.5, '-147', 'Arkansas State', 1073.5, '+104', 7.06, 4.53,1),
(280, 'Ashton Dulin', 'IND', 'WR', 0, 0, 8, 207, 0, 0, 1, 12, 4.5, '-187', 'Army', 622.5, '+109', 6.26, 4.78,2),
(281, 'Nick Foles', 'IND', 'QB', 8, 224, 8, 0, 0, 0, 0, 3, 6.5, '+184', 'FAU', 673.5, '+141', 6.46, 5.13,5),
(282, 'Kylen Granson', 'IND', 'TE', 0, 0, 0, 302, 0, 0, 0, 13, 4.5, '-151', 'Memphis', 778.5, '+161', 6.49, 4.67,6),
(283, 'Alec Pierce', 'IND', 'WR', 0, 0, 0, 593, 0, 0, 2, 16, 8.5, '+115', 'Wake Forest', 859.5, '-148', 6.36, 4.97,19),
(284, 'Jelani Woods', 'IND', 'TE', 0, 0, 0, 312, 0, 0, 3, 15, 10.5, '-143', 'UMass', 1143.5, '-129', 6.78, 5.15,2),
(285, 'Mo Alie-Cox', 'IND', 'TE', 0, 0, 0, 189, 0, 0, 3, 17, 6.5, '-199', 'Marshall', 717.5, '-143', 6.82, 5.07,5),
(286, 'Mike Strachan', 'IND', 'WR', 0, 0, 0, 59, 0, 0, 0, 13, 3.5, '-176', 'Toledo', 818.5, '+105', 6.34, 5.2,17),
(287, 'Dezmon Patmon', 'IND', 'WR', 0, 0, 0, 24, 0, 0, 0, 1, 2.5, '+101', 'Ohio State', 831.5, '-115', 6.83, 4.24,15),
(288, 'Keke Coutee', 'IND', 'WR', 0, 0, 0, 20, 0, 0, 0, 8, 6.5, '-186', 'Coastal Carolina', 474.5, '-153', 6.53, 5.09,17),
(289, 'Travis Etienne', 'JAC', 'RB', 0, 0, 1125, 316, 5, 0, 0, 17, 4.5, '+132', 'Baylor', 626.5, '-179', 6.35, 4.68,14),
(290, 'James Robinson', 'JAC', 'RB', 0, 0, 340, 46, 3, 0, 1, 7, 5.5, '-197', 'Appalachian State', 900.5, '-145', 6.82, 4.61,16),
(291, 'Trevor Lawrence', 'JAC', 'QB', 56.1, 4113, 291, 0, 5, 25, 0, 17, 9.5, '+232', 'Army', 838.5, '+249', 6.53, 5.06,16),
(292, 'Jamycal Hasty', 'JAC', 'RB', 0, 0, 194, 126, 2, 0, 1, 17, 3.5, '-120', 'Kansas', 884.5, '-146', 6.28, 4.38,12),
(293, 'Jamal Agnew', 'JAC', 'WR', 0, 0, 86, 187, 0, 0, 3, 15, 9.5, '+163', 'UMass', 695.5, '+199', 6.93, 4.88,9),
(294, 'Snoop Conner', 'JAC', 'RB', 0, 0, 42, 0, 1, 0, 0, 8, 10.5, '-159', 'Baylor', 718.5, '+230', 6.88, 4.92,4),
(295, 'Christian Kirk', 'JAC', 'WR', 0, 0, 11, 1108, 0, 0, 8, 17, 2.5, '+249', 'LSU', 645.5, '-135', 6.83, 4.26,1),
(296, 'Zay Jones', 'JAC', 'WR', 0, 0, 18, 823, 0, 0, 5, 16, 3.5, '+145', 'Temple', 786.5, '-124', 7.19, 4.22,6),
(297, 'C.J. Beathard', 'JAC', 'QB', 22.9, 35, -4, 0, 0, 0, 0, 4, 6.5, '-191', 'Fresno State', 865.5, '-155', 6.74, 4.82,20),
(298, 'Evan Engram', 'JAC', 'TE', 0, 0, 13, 766, 0, 0, 4, 17, 4.5, '+177', 'Northwestern', 902.5, '-169', 6.82, 4.72,9),
(299, 'Marvin Jones', 'JAC', 'WR', 0, 0, 0, 529, 0, 0, 3, 16, 4.5, '-192', 'Cincinnati', 530.5, '+128', 6.64, 4.46,6),
(300, 'Dan Arnold', 'JAC', 'TE', 0, 0, 0, 135, 0, 0, 0, 17, 4.5, '-199', 'California', 1043.5, '+211', 7.01, 5.19,6),
(301, 'Chris Manhertz', 'JAC', 'TE', 0, 0, 0, 42, 0, 0, 0, 17, 6.5, '-108', 'Buffalo', 1157.5, '+236', 6.61, 4.5,14),
(302, 'Luke Farrell', 'JAC', 'TE', 0, 0, 0, 40, 0, 0, 0, 17, 10.5, '+193', 'Boston College', 698.5, '-136', 6.42, 4.56,20),
(303, 'Tim Jones', 'JAC', 'WR', 0, 0, 0, 30, 0, 0, 0, 17, 4.5, '-148', 'Kent State', 892.5, '-156', 6.83, 4.28,14),
(304, 'Isiah Pacheco', 'KC', 'RB', 0, 0, 830, 130, 5, 0, 0, 17, 10.5, '-199', 'North Carolina', 998.5, '-171', 6.83, 4.95,1),
(305, 'Jerick McKinnon', 'KC', 'RB', 0, 0, 291, 512, 1, 0, 9, 17, 4.5, '+128', 'Wisconsin', 723.5, '-193', 6.76, 4.52,15),
(306, 'Clyde Edwards-Helaire', 'KC', 'RB', 0, 0, 302, 151, 3, 0, 3, 10, 3.5, '-131', 'UAB', 532.5, '-133', 6.95, 4.82,1),
(307, 'Patrick Mahomes', 'KC', 'QB', 79, 5250, 358, 6, 4, 41, 0, 17, 5.5, '+106', 'Northwestern', 1069.5, '-146', 6.67, 4.52,20),
(308, 'Ronald Jones II', 'KC', 'RB', 0, 0, 70, 22, 1, 0, 0, 6, 2.5, '+142', 'LSU', 454.5, '+172', 6.92, 4.58,3),
(309, 'Kadarius Toney', 'KC', 'WR', 0, 0, 59, 171, 1, 0, 2, 7, 5.5, '+240', 'Kentucky', 1111.5, '+167', 6.37, 4.61,15),
(310, 'Michael Burton', 'KC', 'FB', 0, 0, 7, 11, 0, 0, 0, 17, 6.5, '+152', 'Utah', 623.5, '+220', 7.04, 5.15,18),
(311, 'Chad Henne', 'KC', 'QB', 3.8, 0, -5, 0, 0, 0, 0, 3, 10.5, '+230', 'SMU', 449.5, '+246', 6.43, 4.71,15),
(312, 'Mecole Hardman', 'KC', 'WR', 0, 0, 31, 297, 2, 0, 4, 8, 2.5, '-138', 'Purdue', 785.5, '+150', 7.08, 4.46,7),
(313, 'Skyy Moore', 'KC', 'WR', 0, 0, 24, 250, 0, 0, 0, 16, 3.5, '+212', 'James Madison', 900.5, '+245', 6.32, 5.07,11),
(314, 'Travis Kelce', 'KC', 'TE', 0, 0, 5, 1338, 0, 0, 12, 17, 8.5, '+248', 'Memphis', 1047.5, '+187', 6.56, 5.12,13),
(315, 'Marquez Valdes-Scantling', 'KC', 'WR', 0, 0, -3, 687, 0, 0, 2, 17, 9.5, '+111', 'UCF', 690.5, '+201', 6.98, 4.79,15),
(316, 'Noah Gray', 'KC', 'TE', 0, 0, 1, 299, 1, 0, 1, 17, 4.5, '+103', 'Illinois', 484.5, '+219', 6.76, 4.35,13),
(317, 'JuJu Smith-Schuster', 'KC', 'WR', 0, 0, 0, 933, 0, 0, 3, 16, 7.5, '+235', 'Iowa', 673.5, '+153', 6.4, 4.58,2),
(318, 'Justin Watson', 'KC', 'WR', 0, 0, 0, 315, 0, 0, 2, 17, 4.5, '-168', 'Western Michigan', 461.5, '+221', 7.04, 4.66,6),
(319, 'Jody Fortson', 'KC', 'TE', 0, 0, 0, 108, 0, 0, 2, 13, 5.5, '-175', 'Arkansas State', 822.5, '-119', 6.62, 4.48,12),
(320, 'Blake Bell', 'KC', 'TE', 0, 0, 0, 20, 0, 0, 1, 3, 2.5, '+248', 'Clemson', 1194.5, '+239', 6.59, 4.37,16),
(321, 'Josh Jacobs', 'LV', 'RB', 0, 0, 1653, 400, 12, 0, 0, 17, 8.5, '+147', 'New Mexico', 658.5, '+250', 6.44, 5.09,20),
(322, 'Derek Carr', 'LV', 'QB', 57.6, 3522, 102, 0, 0, 24, 0, 15, 3.5, '+185', 'Oklahoma', 673.5, '+215', 6.41, 4.62,8),
(323, 'Brandon Bolden', 'LV', 'RB', 0, 0, 66, 57, 0, 0, 1, 16, 10.5, '-117', 'Kansas State', 1132.5, '+228', 6.64, 4.98,12),
(324, 'Zamir White', 'LV', 'RB', 0, 0, 70, 0, 0, 0, 0, 14, 8.5, '-168', 'LSU', 602.5, '+174', 6.73, 5.14,15),
(325, 'Jarrett Stidham', 'LV', 'QB', 59.7, 656, 84, 0, 0, 4, 0, 5, 7.5, '+120', 'Tennessee', 572.5, '+222', 6.98, 4.75,5),
(326, 'Mack Hollins', 'LV', 'WR', 0, 0, 40, 690, 0, 0, 4, 17, 5.5, '-189', 'Kent State', 514.5, '-100', 6.95, 4.79,19),
(327, 'Ameer Abdullah', 'LV', 'RB', 0, 0, 20, 211, 0, 0, 1, 17, 2.5, '-129', 'New Mexico', 542.5, '+165', 6.48, 4.99,14),
(328, 'DJ Turner', 'LV', 'WR', 0, 0, 26, 0, 0, 0, 0, 9, 4.5, '-123', 'Louisiana Tech', 1060.5, '-176', 6.7, 4.94,1),
(329, 'Davante Adams', 'LV', 'WR', 0, 0, -1, 1516, 0, 0, 14, 17, 7.5, '-100', 'North Texas', 694.5, '-186', 6.81, 4.92,1),
(330, 'Matthias Farley', 'LV', 'S', 0, 0, -3, 0, 0, 0, 0, 17, 8.5, '-163', 'Louisiana', 457.5, '+136', 7.18, 5.16,4),
(331, 'Hunter Renfrow', 'LV', 'WR', 0, 0, 0, 330, 0, 0, 2, 10, 8.5, '+104', 'Utah', 644.5, '-188', 6.25, 5.05,9),
(332, 'Foster Moreau', 'LV', 'TE', 0, 0, 2, 420, 0, 0, 2, 15, 9.5, '+195', 'UCF', 864.5, '+139', 6.96, 4.25,4),
(333, 'Darren Waller', 'LV', 'TE', 0, 0, 0, 388, 0, 0, 3, 9, 4.5, '+211', 'UConn', 950.5, '-199', 6.95, 4.8,15),
(334, 'Keelan Cole', 'LV', 'WR', 0, 0, 0, 141, 0, 0, 1, 14, 4.5, '-154', 'Kentucky', 919.5, '-150', 6.72, 4.26,3),
(335, 'Jakob Johnson', 'LV', 'FB', 0, 0, 0, 10, 0, 0, 0, 17, 10.5, '+144', 'Florida', 517.5, '-152', 7.11, 4.22,8),
(336, 'Jesper Horsted', 'LV', 'TE', 0, 0, 0, 19, 0, 0, 0, 15, 4.5, '+162', 'UCF', 583.5, '+247', 6.38, 4.44,11),
(337, 'Austin Ekeler', 'LAC', 'RB', 0, 0, 915, 722, 13, 0, 5, 17, 7.5, '-162', 'Toledo', 697.5, '-125', 6.9, 4.51,2),
(338, 'Joshua Kelley', 'LAC', 'RB', 0, 0, 287, 101, 2, 0, 0, 13, 5.5, '+221', 'Michigan State', 1131.5, '-147', 6.6, 5.05,19),
(339, 'Justin Herbert', 'LAC', 'QB', 60.2, 4739, 147, -10, 0, 25, 0, 17, 6.5, '-117', 'Old Dominion', 753.5, '+156', 6.75, 4.78,20),
(340, 'Sony Michel', 'LAC', 'RB', 0, 0, 106, 53, 0, 0, 0, 10, 4.5, '+168', 'Florida', 1159.5, '+226', 6.33, 4.43,18),
(341, 'Isaiah Spiller', 'LAC', 'RB', 0, 0, 41, 13, 0, 0, 0, 6, 8.5, '+139', 'Marshall', 982.5, '-172', 6.29, 4.73,19),
(342, 'Larry Rountree', 'LAC', 'RB', 0, 0, 19, 14, 0, 0, 0, 4, 8.5, '-102', 'Hawaii', 1002.5, '+143', 6.39, 4.26,18),
(343, 'Zander Horvath', 'LAC', 'FB', 0, 0, 8, 8, 0, 0, 2, 15, 5.5, '+138', 'Penn State', 664.5, '+148', 6.65, 5.18,19),
(344, 'DeAndre Carter', 'LAC', 'WR', 0, 0, -15, 538, 0, 0, 3, 17, 10.5, '+148', 'Oregon', 878.5, '-195', 6.8, 4.41,7),
(345, 'Josh Palmer', 'LAC', 'WR', 0, 0, 4, 769, 0, 0, 3, 16, 2.5, '+148', 'Colorado', 1065.5, '+227', 6.73, 4.74,6),
(346, 'Keenan Allen', 'LAC', 'WR', 0, 0, 8, 752, 0, 0, 4, 10, 3.5, '+221', 'Tennessee', 1014.5, '-197', 6.32, 5.17,15),
(347, 'Gerald Everett', 'LAC', 'TE', 0, 0, 0, 555, 0, 0, 4, 16, 4.5, '-158', 'Troy', 841.5, '-160', 6.89, 4.38,12),
(348, 'Chase Daniel', 'LAC', 'QB', 59.9, 52, 4, 0, 0, 1, 0, 4, 6.5, '-178', 'San Diego State', 737.5, '+239', 6.29, 5.18,16),
(349, 'Mike Williams', 'LAC', 'WR', 0, 0, 0, 895, 0, 0, 4, 13, 10.5, '-152', 'Houston', 968.5, '+212', 6.51, 4.82,2),
(350, 'Michael Bandy', 'LAC', 'WR', 0, 0, 0, 89, 0, 0, 0, 10, 2.5, '-185', 'Oklahoma', 743.5, '+241', 6.83, 5.15,16),
(351, 'Tre McKitty', 'LAC', 'TE', 0, 0, 0, 72, 0, 0, 0, 17, 6.5, '-176', 'Western Kentucky', 621.5, '+209', 6.84, 4.25,12),
(352, 'Donald Parham', 'LAC', 'TE', 0, 0, 0, 130, 0, 0, 1, 6, 2.5, '+105', 'Oklahoma State', 475.5, '+166', 6.73, 5.05,7),
(353, 'Stone Smartt', 'LAC', 'TE', 0, 0, 0, 17, 0, 0, 0, 7, 10.5, '-192', 'Kansas State', 1156.5, '-120', 6.31, 4.89,17),
(354, 'Jalen Guyton', 'LAC', 'WR', 0, 0, 0, 64, 0, 0, 0, 3, 7.5, '-126', 'Georgia State', 717.5, '-114', 6.55, 4.53,18),
(355, 'Jason Moore', 'LAC', 'WR', 0, 0, 0, 5, 0, 0, 0, 6, 5.5, '+155', 'San Jose State', 555.5, '-164', 6.41, 4.26,10),
(356, 'Richard Rodgers', 'LAC', 'TE', 0, 0, 0, 4, 0, 0, 0, 10, 9.5, '-115', 'USC', 1004.5, '-194', 6.8, 4.33,3),
(357, 'Cam Akers', 'LAR', 'RB', 0, 0, 786, 117, 7, 0, 0, 15, 4.5, '-182', 'Miami', 531.5, '-160', 6.61, 4.43,2),
(358, 'Darrell Henderson', 'LAR', 'RB', 0, 0, 283, 102, 3, 0, 0, 10, 6.5, '-107', 'Wisconsin', 812.5, '-114', 6.36, 4.33,16),
(359, 'Kyren Williams', 'LAR', 'RB', 0, 0, 139, 76, 0, 0, 0, 10, 3.5, '-183', 'Arizona State', 1024.5, '-153', 6.65, 4.54,5),
(360, 'Bryce Perkins', 'LAR', 'QB', 28.7, 161, 90, 0, 0, 1, 0, 5, 9.5, '-157', 'Iowa State', 491.5, '+207', 6.49, 4.97,13),
(361, 'Malcolm Brown', 'LAR', 'RB', 0, 0, 81, 37, 1, 0, 0, 11, 7.5, '+210', 'UTEP', 936.5, '+154', 6.27, 4.51,19),
(362, 'Brandon Powell', 'LAR', 'WR', 0, 0, 80, 156, 0, 0, 0, 17, 10.5, '-198', 'Missouri', 1043.5, '+171', 6.84, 4.9,17),
(363, 'Baker Mayfield', 'LAR', 'QB', 26.3, 2163, 37, 0, 0, 10, 0, 5, 3.5, '+177', 'Rice', 980.5, '-125', 6.99, 4.37,16),
(364, 'Matthew Stafford', 'LAR', 'QB', 52.3, 2087, 9, 0, 1, 10, 0, 9, 8.5, '-170', 'Northwestern', 457.5, '+126', 6.47, 4.97,17),
(365, 'Cooper Kupp', 'LAR', 'WR', 0, 0, 52, 812, 1, 0, 6, 9, 4.5, '-175', 'Notre Dame', 962.5, '+184', 6.44, 4.72,20),
(366, 'Tutu Atwell', 'LAR', 'WR', 0, 0, 34, 298, 1, 0, 1, 13, 3.5, '-104', 'Miami, Ohio', 798.5, '+154', 6.27, 4.31,20),
(367, 'Ronnie Rivers', 'LAR', 'RB', 0, 0, 21, 29, 0, 0, 0, 8, 5.5, '-143', 'New Mexico State', 493.5, '-137', 6.92, 4.91,13),
(368, 'John Wolford', 'LAR', 'QB', 24.2, 390, 32, 0, 0, 1, 0, 3, 4.5, '-110', 'Nevada', 1071.5, '+146', 6.22, 4.26,5),
(369, 'Ben Skowronek', 'LAR', 'WR', 0, 0, 17, 376, 1, 0, 0, 14, 8.5, '-161', 'South Alabama', 1031.5, '-174', 7.16, 5.06,5),
(370, 'Tyler Higbee', 'LAR', 'TE', 0, 0, 0, 620, 0, 0, 3, 17, 5.5, '+136', 'West Virginia', 951.5, '-135', 6.89, 5.15,1),
(371, 'Allen Robinson', 'LAR', 'WR', 0, 0, 0, 339, 0, 0, 3, 10, 5.5, '+148', 'USF', 968.5, '-138', 6.6, 4.28,8),
(372, 'Van Jefferson', 'LAR', 'WR', 0, 0, 0, 369, 0, 0, 3, 11, 8.5, '-161', 'Western Michigan', 898.5, '+143', 6.5, 4.66,1),
(373, 'Brycen Hopkins', 'LAR', 'TE', 0, 0, 0, 109, 0, 0, 0, 14, 8.5, '+134', 'South Alabama', 456.5, '+131', 7, 4.92,8),
(374, 'Kendall Blanton', 'LAR', 'TE', 0, 0, 0, 35, 0, 0, 0, 4, 5.5, '-128', 'Army', 736.5, '-162', 6.51, 4.76,4),
(375, 'Austin Trammell', 'LAR', 'WR', 0, 0, 0, 13, 0, 0, 0, 6, 3.5, '+158', 'Southern Miss', 942.5, '-126', 6.82, 4.6,7),
(376, 'Jake Gervase', 'LAR', 'LB', 0, 0, 0, 12, 0, 0, 0, 14, 7.5, '+164', 'Marshall', 1165.5, '+101', 6.67, 4.65,15),
(377, 'Jacob Harris', 'LAR', 'WR', 0, 0, 0, 6, 0, 0, 0, 7, 8.5, '-166', 'Oklahoma State', 883.5, '+245', 6.53, 4.92,17),
(378, 'Lance McCutcheon', 'LAR', 'WR', 0, 0, 0, 0, 0, 0, 0, 10, 8.5, '-132', 'Troy', 1134.5, '-173', 7.11, 4.98,3),
(379, 'Raheem Mostert', 'MIA', 'RB', 0, 0, 891, 202, 3, 0, 2, 16, 8.5, '+103', 'San Jose State', 937.5, '+136', 6.73, 4.67,9),
(380, 'Jeff Wilson', 'MIA', 'RB', 0, 0, 392, 94, 3, 0, 1, 8, 6.5, '+111', 'Arkansas', 656.5, '-117', 7.15, 4.39,7),
(381, 'Chase Edmonds', 'MIA', 'RB', 0, 0, 120, 96, 2, 0, 1, 8, 8.5, '-164', 'Pitt', 1185.5, '-180', 6.96, 4.35,4),
(382, 'Tua Tagovailoa', 'MIA', 'QB', 70.6, 3548, 70, 0, 0, 25, 0, 13, 7.5, '+111', 'Texas', 671.5, '+137', 6.21, 4.54,13),
(383, 'Skylar Thompson', 'MIA', 'QB', 28.7, 534, 21, 0, 0, 1, 0, 7, 6.5, '-196', 'Georgia State', 990.5, '+227', 6.92, 4.9,18),
(384, 'Salvon Ahmed', 'MIA', 'RB', 0, 0, 64, 8, 1, 0, 0, 12, 6.5, '-166', 'Stanford', 1150.5, '+240', 6.79, 4.94,11),
(385, 'Myles Gaskin', 'MIA', 'RB', 0, 0, 26, 28, 0, 0, 0, 4, 6.5, '-110', 'San Jose State', 931.5, '+184', 6.68, 4.75,8),
(386, 'Tyreek Hill', 'MIA', 'WR', 0, 0, 32, 1710, 1, 0, 7, 17, 7.5, '-132', 'ULM', 939.5, '+206', 6.2, 4.3,3),
(387, 'Alec Ingold', 'MIA', 'FB', 0, 0, 8, 105, 1, 0, 1, 17, 2.5, '+107', 'Washington State', 1147.5, '-138', 6.82, 4.64,10),
(388, 'Jaylen Waddle', 'MIA', 'WR', 0, 0, 26, 1356, 0, 0, 8, 17, 8.5, '-143', 'Kansas State', 1088.5, '+148', 6.65, 4.26,6),
(389, 'Teddy Bridgewater', 'MIA', 'QB', 49.5, 683, 27, 0, 0, 4, 0, 5, 4.5, '-118', 'Old Dominion', 786.5, '-189', 6.41, 4.84,1),
(390, 'Durham Smythe', 'MIA', 'TE', 0, 0, 1, 129, 1, 0, 1, 16, 7.5, '-136', 'San Diego State', 724.5, '-188', 6.68, 4.57,13),
(391, 'Cedrick Wilson Jr.', 'MIA', 'WR', 0, 0, 8, 136, 0, 0, 0, 15, 10.5, '-112', 'Oregon State', 969.5, '+120', 6.89, 4.81,11),
(392, 'Clayton Fejedelem', 'MIA', 'S', 0, 0, 0, 0, 0, 0, 0, 13, 2.5, '+112', 'Northern Illinois', 471.5, '-185', 6.84, 4.31,10),
(393, 'Robert Hunt', 'MIA', 'OL', 0, 0, 0, 0, 0, 0, 0, 17, 9.5, '+150', 'Wyoming', 639.5, '-163', 6.74, 4.21,8),
(394, 'Mike Gesicki', 'MIA', 'TE', 0, 0, 0, 362, 0, 0, 5, 17, 4.5, '+152', 'James Madison', 554.5, '-183', 7.17, 4.43,14),
(395, 'Trent Sherfield', 'MIA', 'WR', 0, 0, 0, 417, 0, 0, 2, 17, 10.5, '+213', 'Boise State', 1148.5, '-116', 6.58, 4.33,10),
(396, 'River Cracraft', 'MIA', 'WR', 0, 0, 0, 102, 0, 0, 2, 11, 7.5, '+130', 'Troy', 958.5, '-193', 6.88, 4.82,1),
(397, 'Braylon Sanders', 'MIA', 'WR', 0, 0, 0, 17, 0, 0, 0, 3, 8.5, '-147', 'Ball State', 1115.5, '+144', 6.54, 4.6,6),
(398, 'Erik Ezukanma', 'MIA', 'WR', 0, 0, 0, 3, 0, 0, 0, 1, 6.5, '-119', 'Hawaii', 548.5, '+243', 7.11, 4.35,20),
(399, 'Tanner Conner', 'MIA', 'TE', 0, 0, 0, 0, 0, 0, 0, 13, 4.5, '+107', 'Northern Illinois', 1157.5, '+141', 7.19, 4.75,4),
(400, 'Dalvin Cook', 'MIN', 'RB', 0, 0, 1173, 295, 8, 0, 2, 17, 10.5, '-178', 'Troy', 687.5, '-134', 6.73, 4.66,5),
(401, 'Alexander Mattison', 'MIN', 'RB', 0, 0, 283, 91, 5, 0, 1, 17, 5.5, '+178', 'Duke', 889.5, '-117', 6.49, 4.7,20),
(402, 'Kirk Cousins', 'MIN', 'QB', 52.3, 4547, 97, 0, 2, 29, 0, 17, 4.5, '+246', 'Wake Forest', 1063.5, '-125', 6.44, 4.96,7),
(403, 'Kene Nwangwu', 'MIN', 'RB', 0, 0, 14, 21, 0, 0, 0, 17, 4.5, '+240', 'Auburn', 535.5, '+173', 6.23, 4.53,12),
(404, 'Ty Chandler', 'MIN', 'RB', 0, 0, 20, 0, 0, 0, 0, 3, 10.5, '+164', 'Louisville', 841.5, '-142', 6.28, 4.28,15),
(405, 'Justin Jefferson', 'MIN', 'WR', 0, 0, 24, 1809, 1, 0, 8, 17, 9.5, '+103', 'Oklahoma State', 466.5, '-179', 6.89, 5.04,15),
(406, 'C.J. Ham', 'MIN', 'FB', 0, 0, 7, 86, 2, 0, 0, 17, 8.5, '+227', 'Central Michigan', 999.5, '+114', 7.09, 4.53,16),
(407, 'Jalen Reagor', 'MIN', 'WR', 0, 0, 25, 104, 0, 0, 1, 17, 9.5, '-187', 'Fresno State', 626.5, '+175', 6.45, 4.45,13),
(408, 'Nick Mullens', 'MIN', 'QB', 58.3, 224, 8, 0, 0, 1, 0, 4, 3.5, '-150', 'BYU', 465.5, '-141', 6.89, 4.71,8),
(409, 'K.J. Osborn', 'MIN', 'WR', 0, 0, 6, 650, 0, 0, 5, 17, 10.5, '-161', 'Western Michigan', 707.5, '+105', 6.98, 4.45,10),
(410, 'Adam Thielen', 'MIN', 'WR', 0, 0, 4, 716, 0, 0, 6, 17, 4.5, '+117', 'Bowling Green', 1173.5, '-197', 7.04, 4.53,13),
(411, 'T.J. Hockenson', 'MIN', 'TE', 0, 0, 0, 519, 0, 0, 3, 10, 6.5, '-105', 'UConn', 570.5, '+233', 6.83, 5.03,2),
(412, 'Irv Smith Jr.', 'MIN', 'TE', 0, 0, 0, 182, 0, 0, 2, 8, 4.5, '+123', 'Georgia State', 790.5, '+205', 6.65, 4.68,11),
(413, 'Johnny Mundt', 'MIN', 'TE', 0, 0, 0, 140, 0, 0, 1, 17, 9.5, '-143', 'Old Dominion', 967.5, '-166', 6.35, 4.67,6),
(414, 'Jalen Nailor', 'MIN', 'WR', 0, 0, 0, 179, 0, 0, 1, 15, 8.5, '+188', 'Texas A&M', 540.5, '-145', 6.67, 4.55,7),
(415, 'Ben Ellefson', 'MIN', 'TE', 0, 0, 0, 26, 0, 0, 0, 4, 6.5, '-126', 'Stanford', 465.5, '-165', 7.08, 4.4,6),
(416, 'Rhamondre Stevenson', 'NE', 'RB', 0, 0, 1040, 421, 5, 0, 1, 17, 6.5, '-122', 'FAU', 799.5, '-146', 6.86, 4.37,18),
(417, 'Damien Harris', 'NE', 'RB', 0, 0, 462, 97, 3, 0, 0, 11, 10.5, '-140', 'Illinois', 973.5, '+161', 7.02, 4.55,18),
(418, 'Mac Jones', 'NE', 'QB', 38.4, 2997, 102, 0, 1, 14, 0, 14, 10.5, '+245', 'Central Michigan', 841.5, '+160', 6.9, 4.87,19),
(419, 'Kevin Harris', 'NE', 'RB', 0, 0, 52, 0, 1, 0, 0, 5, 5.5, '+246', 'Pitt', 1193.5, '-109', 7.16, 4.78,11),
(420, 'Pierre Strong', 'NE', 'RB', 0, 0, 100, 42, 1, 0, 0, 15, 6.5, '-153', 'Rice', 1007.5, '+125', 7.02, 4.9,19),
(421, 'J.J. Taylor', 'NE', 'RB', 0, 0, 9, 8, 0, 0, 0, 1, 2.5, '+234', 'Old Dominion', 738.5, '+103', 6.98, 4.4,6),
(422, 'Bailey Zappe', 'NE', 'QB', 36.4, 781, 0, -6, 0, 5, 0, 4, 3.5, '-103', 'Oregon State', 824.5, '-103', 6.66, 4.97,14),
(423, 'Kendrick Bourne', 'NE', 'WR', 0, 0, 39, 434, 0, 0, 1, 16, 5.5, '-171', 'Liberty', 1118.5, '+196', 6.6, 4.48,9),
(424, 'Tyquan Thornton', 'NE', 'WR', 0, 0, 16, 247, 1, 0, 2, 13, 3.5, '+138', 'Jacksonville State', 611.5, '-127', 6.36, 4.95,2),
(425, 'Jakobi Meyers', 'NE', 'WR', 0, 0, -11, 804, 0, 0, 6, 14, 3.5, '+137', 'Tulsa', 930.5, '+240', 6.91, 5.16,10),
(426, 'Ty Montgomery', 'NE', 'WR', 0, 0, -2, 15, 0, 0, 1, 1, 10.5, '+229', 'Temple', 483.5, '-157', 6.91, 4.95,18),
(427, 'Jonnu Smith', 'NE', 'TE', 0, 0, 5, 245, 0, 0, 0, 14, 8.5, '-190', 'Florida', 844.5, '-103', 6.87, 4.82,3),
(428, 'Hunter Henry', 'NE', 'TE', 0, 0, 0, 509, 0, 0, 2, 17, 3.5, '-132', 'ULM', 1169.5, '-155', 6.54, 4.5,12),
(429, 'Nelson Agholor', 'NE', 'WR', 0, 0, 0, 362, 0, 0, 2, 16, 2.5, '-129', 'Memphis', 647.5, '-189', 6.37, 4.92,14),
(430, 'DeVante Parker', 'NE', 'WR', 0, 0, 0, 539, 0, 0, 3, 13, 2.5, '+144', 'Mississippi State', 853.5, '-101', 7.2, 5.17,9),
(431, 'Marcus Jones', 'NE', 'DB', 0, 0, 0, 78, 0, 0, 1, 15, 8.5, '-141', 'Appalachian State', 983.5, '+180', 6.58, 4.63,2),
(432, 'LilJordan Humphrey', 'NE', 'WR', 0, 0, 0, 20, 0, 0, 0, 6, 3.5, '+130', 'Georgia', 628.5, '+168', 6.51, 4.66,11),
(433, 'Alvin Kamara', 'NO', 'RB', 0, 0, 897, 490, 2, 0, 2, 15, 8.5, '-173', 'East Carolina', 544.5, '+247', 7.15, 4.8,16),
(434, 'Taysom Hill', 'NO', 'TE', 0, 0, 575, 77, 7, 0, 2, 16, 10.5, '+239', 'Oregon', 1099.5, '+186', 7.16, 5.2,14),
(435, 'Mark Ingram', 'NO', 'RB', 0, 0, 233, 68, 1, 0, 0, 10, 5.5, '+223', 'West Virginia', 758.5, '-140', 6.82, 4.76,17),
(436, 'Andy Dalton', 'NO', 'QB', 53.1, 2871, 54, 0, 0, 18, 0, 14, 3.5, '+193', 'Baylor', 994.5, '+104', 7.2, 4.23,18),
(437, 'David Johnson', 'NO', 'RB', 0, 0, 24, 47, 0, 0, 0, 5, 9.5, '-160', 'Navy', 880.5, '+118', 7.11, 4.49,8),
(438, 'Latavius Murray', 'NO', 'RB', 0, 0, 57, 8, 1, 0, 0, 1, 8.5, '+220', 'Coastal Carolina', 535.5, '+141', 7.03, 4.66,15),
(439, 'Dwayne Washington', 'NO', 'RB', 0, 0, 38, 7, 0, 0, 0, 12, 4.5, '-101', 'Western Kentucky', 656.5, '-160', 6.21, 5.01,1),
(440, 'Jameis Winston', 'NO', 'QB', 34.7, 858, 16, 0, 0, 4, 0, 3, 8.5, '+138', 'Miami', 594.5, '+227', 6.63, 4.38,20),
(441, 'Rashid Shaheed', 'NO', 'WR', 0, 0, 57, 488, 1, 0, 2, 12, 9.5, '-164', 'Memphis', 903.5, '+194', 6.91, 4.25,12),
(442, 'Adam Prentice', 'NO', 'FB', 0, 0, 9, 9, 0, 0, 0, 11, 6.5, '-173', 'Coastal Carolina', 1135.5, '+183', 6.52, 4.54,6),
(443, 'Eno Benjamin', 'NO', 'RB', 0, 0, 13, 9, 0, 0, 0, 3, 10.5, '+185', 'Texas Tech', 525.5, '+100', 6.87, 5.15,16),
(444, 'Tony Jones', 'NO', 'RB', 0, 0, 8, 12, 0, 0, 0, 2, 9.5, '+159', 'Ole Miss', 1091.5, '+191', 6.87, 5.15,8),
(445, 'Jordan Howard', 'NO', 'RB', 0, 0, 1, 0, 0, 0, 0, 2, 10.5, '-190', 'Rice', 1014.5, '-102', 6.6, 4.24,13),
(446, 'Chris Olave', 'NO', 'WR', 0, 0, 0, 1042, 0, 0, 4, 15, 7.5, '+133', 'Washington', 911.5, '+160', 6.83, 4.99,14),
(447, 'Juwan Johnson', 'NO', 'TE', 0, 0, 0, 508, 0, 0, 7, 16, 4.5, '+139', 'Ball State', 819.5, '-195', 6.93, 4.87,15),
(448, 'Jarvis Landry', 'NO', 'WR', 0, 0, 0, 272, 0, 0, 1, 9, 5.5, '-143', 'Appalachian State', 549.5, '-112', 6.59, 5.13,3),
(449, 'TreQuan Smith', 'NO', 'WR', 0, 0, 0, 278, 0, 0, 1, 15, 6.5, '-129', 'UCLA', 1051.5, '-115', 6.54, 4.39,6),
(450, 'Adam Trautman', 'NO', 'TE', 0, 0, 0, 207, 0, 0, 1, 15, 5.5, '+149', 'Stanford', 1060.5, '+227', 6.56, 4.93,18),
(451, 'Marquez Callaway', 'NO', 'WR', 0, 0, 0, 158, 0, 0, 1, 14, 9.5, '+240', 'Middle Tennessee', 1183.5, '+229', 6.5, 4.45,5),
(452, 'Michael Thomas', 'NO', 'WR', 0, 0, 0, 171, 0, 0, 3, 3, 5.5, '-198', 'Ohio', 1040.5, '+102', 6.78, 5,5),
(453, 'Deonte Harty', 'NO', 'WR', 0, 0, 0, 13, 0, 0, 0, 4, 2.5, '+213', 'Rutgers', 959.5, '-185', 6.26, 4.27,18),
(454, 'Keith Kirkwood', 'NO', 'WR', 0, 0, 0, 18, 0, 0, 0, 5, 2.5, '-176', 'Wake Forest', 483.5, '+109', 6.64, 5,8),
(455, 'Nick Vannett', 'NO', 'TE', 0, 0, 0, 13, 0, 0, 0, 3, 6.5, '-198', 'Illinois', 771.5, '+203', 6.47, 4.8,19),
(456, 'Kevin White', 'NO', 'WR', 0, 0, 0, 74, 0, 0, 0, 7, 5.5, '+124', 'Bowling Green', 642.5, '+178', 6.63, 5.17,11),
(457, 'Saquon Barkley', 'NYG', 'RB', 0, 0, 1312, 338, 10, 0, 0, 16, 2.5, '-134', 'Georgia Tech', 1114.5, '+225', 6.32, 4.38,3),
(458, 'Daniel Jones', 'NYG', 'QB', 62.9, 3205, 708, 0, 7, 15, 0, 16, 4.5, '-144', 'James Madison', 564.5, '+103', 6.34, 4.68,5),
(459, 'Matt Breida', 'NYG', 'RB', 0, 0, 220, 118, 1, 0, 0, 17, 7.5, '+153', 'ULM', 787.5, '+166', 7.13, 4.52,6),
(460, 'Gary Brightwell', 'NYG', 'RB', 0, 0, 141, 39, 1, 0, 0, 17, 3.5, '+149', 'Washington State', 892.5, '+185', 6.58, 4.94,18),
(461, 'Davis Webb', 'NYG', 'QB', 76.9, 168, 41, 0, 1, 1, 0, 1, 2.5, '+188', 'Southern Miss', 1077.5, '+143', 6.87, 4.97,17),
(462, 'Tyrod Taylor', 'NYG', 'QB', 11.6, 58, 70, 0, 0, 1, 0, 3, 8.5, '-164', 'Minnesota', 820.5, '+177', 7.18, 5.01,3),
(463, 'Richie James', 'NYG', 'WR', 0, 0, 6, 569, 0, 0, 4, 17, 6.5, '+145', 'Stanford', 1012.5, '-174', 6.6, 4.68,6),
(464, 'WanDale Robinson', 'NYG', 'WR', 0, 0, -1, 227, 0, 0, 1, 6, 3.5, '+114', 'Georgia Tech', 820.5, '-129', 6.41, 4.67,16),
(465, 'Kadarius Toney', 'NYG', 'WR', 0, 0, 23, 0, 0, 0, 0, 2, 2.5, '+245', 'Kansas State', 716.5, '-105', 6.32, 4.74,6),
(466, 'Jamie Gillan', 'NYG', 'P', 0, 0, -3, 0, 0, 0, 0, 17, 3.5, '-103', 'LSU', 503.5, '-155', 6.71, 4.46,16),
(467, 'Daniel Bellinger', 'NYG', 'TE', 0, 0, 2, 268, 1, 0, 2, 12, 8.5, '+160', 'Louisiana Tech', 596.5, '+223', 6.81, 4.62,9),
(468, 'Darius Slayton', 'NYG', 'WR', 0, 0, 0, 724, 0, 0, 2, 16, 7.5, '+227', 'Kentucky', 1138.5, '+225', 6.64, 5.16,5),
(469, 'Isaiah Hodgins', 'NYG', 'WR', 0, 0, 0, 351, 0, 0, 4, 8, 9.5, '-187', 'Arizona State', 700.5, '-198', 6.55, 5.07,20),
(470, 'Lawrence Cager', 'NYG', 'TE', 0, 0, 0, 118, 0, 0, 1, 6, 8.5, '-170', 'Marshall', 980.5, '-121', 6.56, 4.9,9),
(471, 'Sterling Shepard', 'NYG', 'WR', 0, 0, 0, 154, 0, 0, 1, 3, 9.5, '-100', 'Boston College', 725.5, '-148', 6.99, 4.42,7),
(472, 'David Sills', 'NYG', 'WR', 0, 0, 0, 106, 0, 0, 0, 9, 10.5, '-110', 'Tennessee', 475.5, '-171', 6.38, 4.51,6),
(473, 'Tanner Hudson', 'NYG', 'TE', 0, 0, 0, 132, 0, 0, 0, 11, 6.5, '-174', 'Toledo', 661.5, '-159', 7.07, 5.12,20),
(474, 'Marcus Johnson', 'NYG', 'WR', 0, 0, 0, 99, 0, 0, 0, 14, 10.5, '+226', 'Indiana', 880.5, '-188', 7.03, 5.04,10),
(475, 'Chris Myarick', 'NYG', 'FB', 0, 0, 0, 65, 0, 0, 1, 16, 2.5, '-158', 'Louisiana', 1177.5, '-131', 6.85, 4.23,4),
(476, 'Kenny Golladay', 'NYG', 'WR', 0, 0, 0, 81, 0, 0, 1, 12, 4.5, '-112', 'Alabama', 966.5, '-194', 7.05, 4.55,20),
(477, 'Nick Vannett', 'NYG', 'TE', 0, 0, 0, 42, 0, 0, 0, 6, 5.5, '+136', 'NC State', 509.5, '-165', 6.76, 4.63,10),
(478, 'Michael Carter', 'NYJ', 'RB', 0, 0, 402, 288, 3, 0, 0, 16, 4.5, '+104', 'UNLV', 1036.5, '-106', 6.86, 5.13,1),
(479, 'Zonovan Knight', 'NYJ', 'RB', 0, 0, 300, 100, 1, 0, 0, 7, 6.5, '+182', 'Air Force', 700.5, '-126', 6.27, 4.72,7),
(480, 'Breece Hall', 'NYJ', 'RB', 0, 0, 463, 218, 4, 0, 1, 7, 9.5, '-107', 'Northern Illinois', 549.5, '+129', 6.79, 4.6,6),
(481, 'Ty Johnson', 'NYJ', 'RB', 0, 0, 160, 88, 1, 0, 0, 17, 9.5, '-130', 'Ball State', 1020.5, '-143', 6.34, 5.06,11),
(482, 'James Robinson', 'NYJ', 'RB', 0, 0, 85, 5, 0, 0, 1, 4, 10.5, '-168', 'South Alabama', 588.5, '+125', 6.51, 4.98,13),
(483, 'Zach Wilson', 'NYJ', 'QB', 38.5, 1688, 102, 2, 1, 6, 1, 9, 10.5, '-175', 'Oklahoma State', 945.5, '+103', 6.5, 4.94,8),
(484, 'Braxton Berrios', 'NYJ', 'WR', 0, 0, 91, 145, 2, 0, 0, 17, 10.5, '+163', 'Minnesota', 753.5, '+144', 6.67, 4.88,6),
(485, 'Chris Streveler', 'NYJ', 'QB', 73.9, 90, 54, 0, 0, 0, 0, 2, 7.5, '+237', 'Texas', 855.5, '-153', 7.13, 4.23,6),
(486, 'Mike White', 'NYJ', 'QB', 38.9, 1192, 9, 0, 1, 3, 0, 4, 3.5, '-139', 'Colorado State', 658.5, '-169', 6.34, 5.15,20),
(487, 'Elijah Moore', 'NYJ', 'WR', 0, 0, 5, 446, 0, 0, 1, 16, 4.5, '+197', 'Marshall', 667.5, '-170', 7.16, 5.13,3),
(488, 'Garrett Wilson', 'NYJ', 'WR', 0, 0, 4, 1103, 0, 0, 4, 17, 10.5, '-159', 'Virginia', 1012.5, '-156', 7.14, 5.1,17),
(489, 'Joe Flacco', 'NYJ', 'QB', 36.1, 1051, 6, -3, 0, 5, 0, 5, 2.5, '+130', 'Arizona State', 956.5, '+193', 6.33, 4.76,1),
(490, 'Tyler Conklin', 'NYJ', 'TE', 0, 0, 3, 552, 0, 0, 3, 17, 2.5, '+131', 'Bowling Green', 1108.5, '+175', 6.63, 4.93,14),
(491, 'Ashtyn Davis', 'NYJ', 'S', 0, 0, 2, 0, 0, 0, 0, 14, 7.5, '-138', 'UConn', 843.5, '-128', 6.64, 4.83,19),
(492, 'Corey Davis', 'NYJ', 'WR', 0, 0, 0, 536, 0, 0, 2, 13, 4.5, '-122', 'Arizona', 700.5, '-140', 7.06, 5.02,5),
(493, 'C.J. Uzomah', 'NYJ', 'TE', 0, 0, 0, 232, 0, 0, 2, 15, 9.5, '+113', 'Mississippi State', 1098.5, '-173', 7.17, 4.76,4),
(494, 'Denzel Mims', 'NYJ', 'WR', 0, 0, 0, 186, 0, 0, 0, 10, 6.5, '-146', 'Southern Miss', 623.5, '-176', 6.42, 4.25,3),
(495, 'Jeff Smith', 'NYJ', 'WR', 0, 0, 0, 134, 0, 0, 0, 11, 7.5, '+138', 'Kent State', 465.5, '-128', 7.14, 4.51,1),
(496, 'Jeremy Ruckert', 'NYJ', 'TE', 0, 0, 0, 8, 0, 0, 0, 9, 9.5, '-156', 'California', 1114.5, '-146', 6.71, 4.89,12),
(497, 'Lawrence Cager', 'NYJ', 'TE', 0, 0, 0, 0, 0, 0, 0, 1, 6.5, '-141', 'Coastal Carolina', 577.5, '+171', 6.87, 4.41,6),
(498, 'Miles Sanders', 'PHI', 'RB', 0, 0, 1269, 78, 11, 0, 0, 17, 8.5, '-142', 'Old Dominion', 736.5, '+195', 7.19, 4.64,16),
(499, 'Jalen Hurts', 'PHI', 'QB', 68.3, 3701, 760, 0, 13, 22, 0, 15, 4.5, '+214', 'Oklahoma State', 1016.5, '+228', 6.31, 4.54,10),
(500, 'Boston Scott', 'PHI', 'RB', 0, 0, 217, 15, 3, 0, 0, 15, 5.5, '+155', 'New Mexico', 457.5, '+145', 6.2, 5.01,14),
(501, 'Kenneth Gainwell', 'PHI', 'RB', 0, 0, 240, 169, 4, 0, 0, 17, 5.5, '-103', 'Kansas State', 699.5, '-127', 7.02, 4.62,2),
(502, 'Gardner Minshew II', 'PHI', 'QB', 41.6, 663, 3, 0, 1, 3, 0, 5, 4.5, '+131', 'Rutgers', 1100.5, '-112', 6.61, 4.91,16),
(503, 'Quez Watkins', 'PHI', 'WR', 0, 0, 1, 354, 0, 0, 3, 17, 5.5, '+109', 'Miami', 1135.5, '+239', 7.16, 4.69,17),
(504, 'Trey Sermon', 'PHI', 'RB', 0, 0, 19, 0, 0, 0, 0, 2, 3.5, '-192', 'UConn', 958.5, '+150', 6.42, 5.1,18),
(505, 'Zach Pascal', 'PHI', 'WR', 0, 0, 0, 150, 0, 0, 1, 17, 7.5, '-121', 'Eastern Michigan', 751.5, '-139', 6.72, 4.25,17),
(506, 'DeVonta Smith', 'PHI', 'WR', 0, 0, 0, 1196, 0, 0, 7, 17, 5.5, '+124', 'James Madison', 677.5, '-174', 7.08, 5.05,18),
(507, 'A.J. Brown', 'PHI', 'WR', 0, 0, 0, 1496, 0, 0, 11, 17, 3.5, '-140', 'Iowa State', 1081.5, '-122', 6.31, 4.45,20),
(508, 'Dallas Goedert', 'PHI', 'TE', 0, 0, 0, 702, 0, 0, 3, 12, 4.5, '-167', 'Memphis', 1018.5, '+141', 6.35, 4.69,8),
(509, 'Jack Stoll', 'PHI', 'TE', 0, 0, 0, 123, 0, 0, 0, 17, 3.5, '-168', 'James Madison', 746.5, '-198', 6.96, 4.24,18),
(510, 'Grant Calcaterra', 'PHI', 'TE', 0, 0, 0, 81, 0, 0, 0, 15, 9.5, '-197', 'Tennessee', 466.5, '-176', 7.13, 4.82,3),
(511, 'Noah Togiai', 'PHI', 'TE', 0, 0, 0, 0, 0, 0, 0, 2, 6.5, '-125', 'Central Michigan', 725.5, '+246', 6.26, 4.21,4),
(512, 'Najee Harris', 'PIT', 'RB', 0, 0, 1034, 229, 7, 0, 3, 17, 9.5, '-102', 'Boston College', 889.5, '-160', 6.34, 4.75,10),
(513, 'Jaylen Warren', 'PIT', 'RB', 0, 0, 379, 214, 1, 0, 0, 16, 7.5, '+142', 'Florida', 801.5, '+164', 6.84, 4.36,18),
(514, 'Kenny Pickett', 'PIT', 'QB', 53.6, 2404, 237, 0, 3, 7, 0, 13, 10.5, '+139', 'North Carolina', 945.5, '-164', 6.85, 4.91,10),
(515, 'Benny Snell Jr.', 'PIT', 'RB', 0, 0, 90, 17, 1, 0, 0, 17, 9.5, '-142', 'Old Dominion', 723.5, '+143', 6.37, 4.47,3),
(516, 'Mitchell Trubisky', 'PIT', 'QB', 58.5, 1252, 38, 0, 2, 4, 0, 7, 8.5, '-147', 'UCF', 595.5, '-119', 6.31, 4.31,11),
(517, 'Steven Sims', 'PIT', 'WR', 0, 0, 70, 104, 0, 0, 0, 12, 4.5, '-175', 'Texas A&M', 1020.5, '+119', 6.22, 5.1,18),
(518, 'Derek Watt', 'PIT', 'FB', 0, 0, 21, 11, 1, 0, 1, 17, 5.5, '+172', 'UCLA', 856.5, '-121', 6.76, 4.43,13),
(519, 'Chase Claypool', 'PIT', 'WR', 0, 0, 55, 311, 0, 0, 1, 8, 9.5, '-152', 'Ohio State', 801.5, '-130', 7.15, 4.93,7),
(520, 'Gunner Olszewski', 'PIT', 'WR', 0, 0, 39, 53, 0, 0, 0, 16, 7.5, '+167', 'Oklahoma', 653.5, '+239', 6.46, 4.77,6),
(521, 'Diontae Johnson', 'PIT', 'WR', 0, 0, 25, 882, 0, 0, 0, 17, 8.5, '+106', 'Northwestern', 902.5, '+177', 6.35, 5.08,13),
(522, 'Anthony McFarland Jr.', 'PIT', 'RB', 0, 0, 30, 11, 0, 0, 0, 1, 5.5, '+198', 'Sam Houston', 1027.5, '-185', 6.46, 5.05,10),
(523, 'George Pickens', 'PIT', 'WR', 0, 0, 24, 801, 1, 0, 4, 17, 2.5, '-123', 'Georgia State', 582.5, '+106', 6.52, 4.54,8),
(524, 'Connor Heyward', 'PIT', 'TE', 0, 0, 27, 151, 0, 0, 1, 17, 5.5, '+198', 'Notre Dame', 1144.5, '+184', 6.22, 5.07,10),
(525, 'Marcus Allen', 'PIT', 'LB', 0, 0, 4, 0, 0, 0, 0, 15, 9.5, '+106', 'Eastern Michigan', 673.5, '+250', 6.25, 5.19,10),
(526, 'Pat Freiermuth', 'PIT', 'TE', 0, 0, 0, 732, 0, 0, 2, 16, 4.5, '+173', 'Akron', 577.5, '-173', 6.24, 4.54,9),
(527, 'Zach Gentry', 'PIT', 'TE', 0, 0, 0, 132, 0, 0, 0, 17, 10.5, '-198', 'Buffalo', 795.5, '-104', 7.19, 4.76,20),
(528, 'Miles Boykin', 'PIT', 'WR', 0, 0, 0, 11, 0, 0, 0, 16, 7.5, '+111', 'Georgia Tech', 1178.5, '+186', 6.63, 4.28,16),
(529, 'Cody White', 'PIT', 'WR', 0, 0, 0, 2, 0, 0, 0, 1, 3.5, '+199', 'Baylor', 466.5, '+111', 6.45, 4.78,11),
(530, 'Christian McCaffrey', 'SF', 'RB', 0, 0, 746, 464, 6, 0, 4, 11, 4.5, '-100', 'Kentucky', 900.5, '-121', 7.05, 4.64,12),
(531, 'Jeff Wilson', 'SF', 'RB', 0, 0, 468, 91, 2, 0, 0, 8, 2.5, '-184', 'Texas A&M', 540.5, '+219', 6.69, 4.53,7),
(532, 'Elijah Mitchell', 'SF', 'RB', 0, 0, 279, 7, 2, 0, 0, 5, 3.5, '-143', 'Old Dominion', 1113.5, '-121', 6.36, 4.89,5),
(533, 'Jordan Mason', 'SF', 'RB', 0, 0, 258, 0, 1, 0, 0, 16, 9.5, '+242', 'UConn', 989.5, '-182', 6.74, 4.23,19),
(534, 'Deebo Samuel', 'SF', 'WR', 0, 0, 232, 632, 3, 0, 2, 13, 3.5, '-177', 'Miami, Ohio', 993.5, '+114', 6.32, 4.5,19),
(535, 'Tyrion Davis-Price', 'SF', 'RB', 0, 0, 99, 0, 0, 0, 0, 6, 2.5, '-103', 'UConn', 1074.5, '+119', 7.13, 5.06,16),
(536, 'Jimmy Garoppolo', 'SF', 'QB', 56.3, 2437, 33, 0, 2, 16, 0, 11, 10.5, '-168', 'Oregon State', 803.5, '+103', 6.69, 4.5,15),
(537, 'Brock Purdy', 'SF', 'QB', 67.5, 1374, 13, 0, 1, 13, 0, 9, 5.5, '+201', 'Oklahoma', 459.5, '-132', 6.54, 4.32,8),
(538, 'Trey Lance', 'SF', 'QB', 36.9, 194, 67, 0, 0, 0, 0, 2, 6.5, '-147', 'Ole Miss', 1199.5, '-174', 6.49, 4.74,18),
(539, 'Tevin Coleman', 'SF', 'RB', 0, 0, 26, 44, 1, 0, 1, 5, 2.5, '-130', 'Hawaii', 1010.5, '-133', 6.7, 5.1,7),
(540, 'Kyle Juszczyk', 'SF', 'FB', 0, 0, 26, 200, 1, 0, 1, 16, 5.5, '-192', 'Indiana', 467.5, '+147', 6.75, 4.84,18),
(541, 'Ray-Ray McCloud', 'SF', 'WR', 0, 0, 78, 243, 1, 0, 1, 17, 7.5, '+143', 'Purdue', 673.5, '+215', 6.76, 4.5,10),
(542, 'Brandon Aiyuk', 'SF', 'WR', 0, 0, 23, 1015, 0, 0, 8, 17, 7.5, '-138', 'Old Dominion', 849.5, '-183', 7.08, 5.06,13),
(543, 'Josh Johnson', 'SF', 'QB', 21.9, 10, 3, 0, 0, 0, 0, 2, 6.5, '-120', 'Oklahoma', 493.5, '-108', 6.7, 4.92,15),
(544, 'Danny Gray', 'SF', 'WR', 0, 0, 9, 10, 0, 0, 0, 13, 4.5, '-132', 'Minnesota', 456.5, '+122', 6.23, 5.11,5),
(545, 'George Kittle', 'SF', 'TE', 0, 0, 0, 765, 0, 0, 11, 15, 5.5, '-187', 'Rutgers', 559.5, '+240', 6.46, 4.7,12),
(546, 'Jauan Jennings', 'SF', 'WR', 0, 0, 0, 416, 0, 0, 1, 16, 6.5, '+249', 'Appalachian State', 772.5, '+222', 6.94, 5,3),
(547, 'Tyler Kroft', 'SF', 'TE', 0, 0, 0, 57, 0, 0, 0, 11, 7.5, '+183', 'Wyoming', 941.5, '+206', 7.13, 4.73,5),
(548, 'Ross Dwelley', 'SF', 'TE', 0, 0, 0, 105, 0, 0, 1, 12, 6.5, '+202', 'Louisville', 684.5, '-127', 6.48, 5.18,1),
(549, 'Charlie Woerner', 'SF', 'TE', 0, 0, 0, 0, 0, 0, 0, 17, 4.5, '+215', 'NC State', 525.5, '-199', 6.99, 5.16,11),
(550, 'Kenneth Walker III', 'SEA', 'RB', 0, 0, 1050, 165, 9, 0, 0, 15, 3.5, '-176', 'Memphis', 788.5, '-178', 6.42, 4.83,16),
(551, 'Geno Smith', 'SEA', 'QB', 62.8, 4282, 366, 0, 1, 30, 0, 17, 2.5, '+247', 'Ohio', 678.5, '-118', 6.96, 4.44,10),
(552, 'Rashaad Penny', 'SEA', 'RB', 0, 0, 346, 16, 2, 0, 0, 5, 6.5, '-180', 'Fresno State', 956.5, '-134', 6.63, 4.5,5),
(553, 'DeeJay Dallas', 'SEA', 'RB', 0, 0, 186, 126, 0, 0, 0, 15, 6.5, '+143', 'Washington', 987.5, '-161', 6.35, 5.15,13),
(554, 'Travis Homer', 'SEA', 'RB', 0, 0, 74, 157, 0, 0, 1, 10, 6.5, '+199', 'LSU', 547.5, '+137', 6.88, 4.81,20),
(555, 'Tony Jones', 'SEA', 'RB', 0, 0, 16, 18, 0, 0, 0, 4, 8.5, '+146', 'Bowling Green', 779.5, '-159', 6.76, 4.97,3),
(556, 'Godwin Igwebuike', 'SEA', 'RB', 0, 0, 4, 3, 0, 0, 0, 5, 4.5, '+100', 'Marshall', 641.5, '+201', 7.08, 4.75,1),
(557, 'Marquise Goodwin', 'SEA', 'WR', 0, 0, 5, 387, 0, 0, 4, 13, 7.5, '+246', 'UNLV', 805.5, '-188', 6.86, 4.83,6),
(558, 'Dwayne Eskridge', 'SEA', 'WR', 0, 0, 10, 58, 0, 0, 0, 10, 8.5, '+201', 'UNLV', 1157.5, '-148', 6.54, 4.23,13),
(559, 'Michael Dickson', 'SEA', 'P', 0, 0, -18, 0, 0, 0, 0, 17, 4.5, '-104', 'Clemson', 926.5, '-173', 6.79, 4.52,2),
(560, 'Nick Bellore', 'SEA', 'LB', 0, 0, 3, 0, 0, 0, 0, 16, 9.5, '+161', 'UTSA', 567.5, '+109', 7.05, 4.41,11),
(561, 'D.K. Metcalf', 'SEA', 'WR', 0, 0, 0, 1048, 0, 0, 6, 17, 2.5, '+100', 'Miami, Ohio', 1029.5, '-110', 6.74, 4.38,12),
(562, 'Tyler Lockett', 'SEA', 'WR', 0, 0, 0, 1033, 0, 0, 9, 16, 5.5, '-193', 'New Mexico', 1061.5, '-168', 6.31, 4.48,2),
(563, 'Noah Fant', 'SEA', 'TE', 0, 0, 0, 486, 0, 0, 4, 17, 7.5, '+113', 'Notre Dame', 731.5, '-100', 6.5, 4.94,2),
(564, 'Will Dissly', 'SEA', 'TE', 0, 0, 0, 349, 0, 0, 3, 15, 7.5, '-159', 'Stanford', 737.5, '-158', 6.32, 5.14,7),
(565, 'Colby Parkinson', 'SEA', 'TE', 0, 0, 0, 322, 0, 0, 2, 17, 9.5, '-128', 'Southern Miss', 1034.5, '-141', 7.02, 4.45,7),
(566, 'Laquon Treadwell', 'SEA', 'WR', 0, 0, 0, 42, 0, 0, 0, 6, 6.5, '-199', 'Louisville', 449.5, '-109', 6.95, 5.14,5),
(567, 'Penny Hart', 'SEA', 'WR', 0, 0, 0, 20, 0, 0, 0, 9, 3.5, '-161', 'Florida', 851.5, '+193', 7.12, 5.11,3),
(568, 'Cade Johnson', 'SEA', 'WR', 0, 0, 0, 21, 0, 0, 0, 3, 10.5, '-104', 'FAU', 1127.5, '+193', 6.77, 4.42,12),
(569, 'Dareke Young', 'SEA', 'WR', 0, 0, 0, 24, 0, 0, 0, 13, 7.5, '-113', 'Rice', 717.5, '-109', 6.73, 4.45,9),
(570, 'Tyler Mabry', 'SEA', 'TE', 0, 0, 0, 7, 0, 0, 1, 2, 4.5, '+181', 'LSU', 696.5, '+126', 6.85, 5.05,13),
(571, 'Leonard Fournette', 'TB', 'RB', 0, 0, 668, 523, 3, 0, 3, 16, 9.5, '-138', 'Louisiana', 663.5, '+126', 7.13, 4.6,15),
(572, 'Rachaad White', 'TB', 'RB', 0, 0, 481, 290, 1, 0, 2, 17, 6.5, '-146', 'Auburn', 767.5, '-100', 6.28, 4.67,8),
(573, 'Tom Brady', 'TB', 'QB', 54.6, 4694, -1, 0, 1, 25, 0, 17, 4.5, '-117', 'Iowa', 900.5, '-102', 6.62, 4.75,10),
(574, 'KeShawn Vaughn', 'TB', 'RB', 0, 0, 53, 19, 0, 0, 0, 15, 3.5, '-166', 'Miami, Ohio', 1160.5, '-141', 6.45, 4.98,8),
(575, 'Giovani Bernard', 'TB', 'RB', 0, 0, 28, -1, 0, 0, 0, 8, 4.5, '-159', 'Fresno State', 1052.5, '-124', 6.7, 5.14,3),
(576, 'Julio Jones', 'TB', 'WR', 0, 0, 45, 299, 0, 0, 2, 10, 2.5, '-142', 'Colorado State', 478.5, '-155', 6.99, 4.82,9),
(577, 'Chris Godwin', 'TB', 'WR', 0, 0, 5, 1023, 0, 0, 3, 15, 5.5, '-147', 'Pitt', 1065.5, '+148', 6.53, 4.39,16),
(578, 'Breshad Perriman', 'TB', 'WR', 0, 0, -7, 110, 0, 0, 1, 11, 10.5, '-194', 'Middle Tennessee', 1125.5, '-117', 6.28, 4.69,9),
(579, 'Deven Thompkins', 'TB', 'WR', 0, 0, 26, 32, 0, 0, 0, 5, 10.5, '-126', 'Boston College', 649.5, '+150', 7.14, 4.28,2),
(580, 'Scott Miller', 'TB', 'WR', 0, 0, 8, 185, 0, 0, 0, 15, 4.5, '+218', 'Baylor', 529.5, '+203', 6.62, 4.51,4),
(581, 'Jaelon Darden', 'TB', 'WR', 0, 0, 2, 26, 0, 0, 0, 12, 6.5, '+113', 'North Carolina', 1149.5, '+124', 7.1, 5.11,6),
(582, 'Mike Evans', 'TB', 'WR', 0, 0, 0, 1124, 0, 0, 6, 15, 9.5, '-153', 'BYU', 721.5, '+225', 6.83, 4.68,20),
(583, 'Russell Gage', 'TB', 'WR', 0, 0, 0, 426, 0, 0, 5, 13, 7.5, '-127', 'Texas State', 512.5, '+192', 6.54, 4.22,1),
(584, 'Cade Otton', 'TB', 'TE', 0, 0, 0, 391, 0, 0, 2, 16, 10.5, '+195', 'Michigan', 914.5, '+119', 6.86, 4.91,11),
(585, 'Cameron Brate', 'TB', 'TE', 0, 0, 0, 174, 0, 0, 0, 11, 5.5, '+238', 'Maryland', 678.5, '-120', 6.58, 5.05,4),
(586, 'Ko Kieft', 'TB', 'TE', 0, 0, 0, 80, 0, 0, 1, 17, 8.5, '-167', 'Western Michigan', 1103.5, '-172', 6.48, 4.74,17),
(587, 'Cole Beasley', 'TB', 'WR', 0, 0, 0, 17, 0, 0, 0, 2, 6.5, '-100', 'Coastal Carolina', 599.5, '-107', 6.57, 4.75,12),
(588, 'Kyle Rudolph', 'TB', 'TE', 0, 0, 0, 28, 0, 0, 1, 9, 10.5, '-185', 'Penn State', 1067.5, '-121', 6.3, 4.87,7),
(589, 'Derrick Henry', 'TEN', 'RB', 0, 0, 1538, 398, 13, 0, 0, 16, 7.5, '+213', 'Troy', 501.5, '-149', 6.6, 4.21,20),
(590, 'Ryan Tannehill', 'TEN', 'QB', 51.2, 2536, 98, 0, 2, 13, 0, 12, 4.5, '+143', 'Stanford', 945.5, '+199', 6.46, 4.89,17),
(591, 'Malik Willis', 'TEN', 'QB', 13.3, 276, 123, 0, 1, 0, 0, 8, 2.5, '+242', 'SMU', 934.5, '+237', 6.29, 4.57,1),
(592, 'Hassan Haskins', 'TEN', 'RB', 0, 0, 93, 57, 0, 0, 0, 15, 3.5, '+242', 'Michigan State', 487.5, '+119', 6.5, 5.2,16),
(593, 'Dontrell Hilliard', 'TEN', 'RB', 0, 0, 145, 177, 0, 0, 4, 12, 10.5, '-132', 'East Carolina', 1043.5, '+214', 7.02, 4.46,12),
(594, 'Julius Chestnut', 'TEN', 'RB', 0, 0, 12, 41, 0, 0, 0, 6, 7.5, '+147', 'Cincinnati', 506.5, '+102', 6.94, 4.93,14),
(595, 'Joshua Dobbs', 'TEN', 'QB', 52.8, 411, 44, 0, 0, 2, 0, 2, 7.5, '-116', 'Houston', 603.5, '+106', 6.6, 4.61,14),
(596, 'Jonathan Ward', 'TEN', 'RB', 0, 0, 25, 7, 0, 0, 0, 3, 3.5, '-160', 'FAU', 880.5, '-172', 7.19, 4.63,4),
(597, 'Treylon Burks', 'TEN', 'WR', 0, 0, 47, 444, 0, 0, 1, 11, 3.5, '-182', 'Colorado State', 593.5, '+237', 6.23, 5.04,13),
(598, 'Chigoziem Okonkwo', 'TEN', 'TE', 0, 0, 2, 450, 0, 0, 3, 17, 2.5, '-108', 'Boise State', 526.5, '+175', 6.95, 5.1,9),
(599, 'Racey McMath', 'TEN', 'WR', 0, 0, 4, 40, 0, 0, 0, 5, 9.5, '+113', 'Indiana', 554.5, '-177', 6.2, 4.71,1),
(600, 'Robert Woods', 'TEN', 'WR', 0, 0, 0, 527, 0, 0, 2, 17, 8.5, '-148', 'Georgia Southern', 1013.5, '+205', 6.22, 4.83,3),
(601, 'Austin Hooper', 'TEN', 'TE', 0, 0, 0, 444, 0, 0, 2, 17, 2.5, '-159', 'Louisiana Tech', 663.5, '+135', 6.35, 4.51,18),
(602, 'Nick Westbrook-Ikhine', 'TEN', 'WR', 0, 0, 0, 397, 0, 0, 3, 17, 7.5, '-146', 'New Mexico', 621.5, '+156', 6.31, 4.48,15),
(603, 'Geoff Swaim', 'TEN', 'TE', 0, 0, 0, 58, 0, 0, 1, 17, 4.5, '+140', 'Kansas State', 825.5, '-103', 6.31, 4.39,11),
(604, 'Kyle Philips', 'TEN', 'WR', 0, 0, 0, 78, 0, 0, 0, 4, 6.5, '-114', 'Marshall', 1152.5, '+123', 6.48, 4.48,13),
(605, 'Chris Conley', 'TEN', 'WR', 0, 0, 0, 46, 0, 0, 0, 7, 2.5, '+239', 'Western Kentucky', 1120.5, '+137', 6.67, 4.61,20),
(606, 'Cody Hollister', 'TEN', 'WR', 0, 0, 0, 54, 0, 0, 0, 11, 5.5, '+177', 'Northwestern', 626.5, '+164', 6.61, 5.2,6),
(607, 'C.J. Board', 'TEN', 'WR', 0, 0, 0, 6, 0, 0, 0, 4, 9.5, '-109', 'Vanderbilt', 782.5, '-108', 6.44, 4.44,8),
(608, 'Mason Kinsey', 'TEN', 'WR', 0, 0, 0, 3, 0, 0, 0, 2, 9.5, '-132', 'Appalachian State', 750.5, '+188', 6.22, 4.33,19),
(609, 'Josh Gordon', 'TEN', 'WR', 0, 0, 0, 0, 0, 0, 0, 2, 4.5, '-191', 'Oklahoma State', 485.5, '-169', 6.51, 4.79,18),
(610, 'Brian Robinson Jr.', 'WAS', 'RB', 0, 0, 797, 60, 2, 0, 1, 12, 10.5, '+124', 'Arkansas State', 1198.5, '+139', 6.53, 4.85,8),
(611, 'Antonio Gibson', 'WAS', 'RB', 0, 0, 546, 353, 3, 0, 2, 15, 2.5, '+204', 'Toledo', 670.5, '+211', 6.84, 4.33,20),
(612, 'Curtis Samuel', 'WAS', 'WR', 0, 0, 187, 656, 1, 0, 4, 17, 4.5, '-180', 'Bowling Green', 1192.5, '-118', 6.6, 4.87,11),
(613, 'Jonathan Williams', 'WAS', 'RB', 0, 0, 152, 40, 0, 0, 0, 13, 7.5, '-186', 'Oklahoma State', 542.5, '-190', 6.95, 4.62,2),
(614, 'Taylor Heinicke', 'WAS', 'QB', 46.5, 1859, 96, 0, 1, 12, 0, 9, 6.5, '-200', 'USC', 498.5, '+141', 6.22, 4.96,15),
(615, 'J.D. McKissic', 'WAS', 'RB', 0, 0, 95, 173, 0, 0, 0, 8, 10.5, '+230', 'Notre Dame', 1102.5, '-176', 6.9, 5.19,7),
(616, 'Carson Wentz', 'WAS', 'QB', 34.4, 1755, 86, 0, 1, 11, 0, 8, 10.5, '+137', 'Oklahoma', 718.5, '+176', 6.44, 4.63,17),
(617, 'Jaret Patterson', 'WAS', 'RB', 0, 0, 78, 0, 0, 0, 0, 3, 7.5, '+235', 'LSU', 1162.5, '+172', 6.58, 4.23,4),
(618, 'Terry McLaurin', 'WAS', 'WR', 0, 0, 29, 1191, 0, 0, 5, 17, 8.5, '+197', 'Tennessee', 925.5, '+229', 6.71, 5.13,4),
(619, 'Sam Howell', 'WAS', 'QB', 48.3, 169, 35, 0, 1, 1, 0, 1, 3.5, '-172', 'Army', 966.5, '-125', 6.94, 5.19,18),
(620, 'Reggie Bonnafon', 'WAS', 'RB', 0, 0, 8, 0, 0, 0, 0, 1, 10.5, '-128', 'Kansas State', 765.5, '-156', 7.2, 4.69,13),
(621, 'Jahan Dotson', 'WAS', 'WR', 0, 0, -7, 523, 0, 0, 7, 12, 7.5, '-107', 'NC State', 672.5, '-127', 6.41, 4.21,11),
(622, 'Armani Rogers', 'WAS', 'TE', 0, 0, 26, 64, 0, 0, 0, 11, 10.5, '-119', 'Florida', 779.5, '+200', 6.5, 4.46,17),
(623, 'Dyami Brown', 'WAS', 'WR', 0, 0, 15, 143, 0, 0, 2, 15, 8.5, '+126', 'Missouri', 659.5, '-191', 6.78, 4.92,15),
(624, 'Logan Thomas', 'WAS', 'TE', 0, 0, 0, 323, 0, 0, 1, 14, 4.5, '+170', 'LSU', 493.5, '+203', 6.39, 5.11,3),
(625, 'John Bates', 'WAS', 'TE', 0, 0, 0, 108, 0, 0, 1, 16, 8.5, '+148', 'UMass', 690.5, '-181', 6.99, 4.36,15),
(626, 'Cam Sims', 'WAS', 'WR', 0, 0, 0, 89, 0, 0, 0, 17, 3.5, '+173', 'UNLV', 693.5, '-141', 6.61, 4.49,17),
(627, 'Dax Milne', 'WAS', 'WR', 0, 0, 0, 37, 0, 0, 1, 15, 5.5, '+126', 'UMass', 990.5, '+195', 6.51, 4.76,4),
(628, 'Cole Turner', 'WAS', 'TE', 0, 0, 0, 23, 0, 0, 0, 10, 9.5, '-102', 'Akron', 637.5, '+100', 6.35, 4.27,14);


INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',1,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',2,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',3,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',4,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',5,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',6,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',7,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',8,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',9,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',10,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',11,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',12,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',13,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',14,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',15,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',16,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',17,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',18,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',19,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',20,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',21,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',22,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',23,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',24,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',25,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',26,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',27,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',28,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',29,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',30,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',31,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',32,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',33,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',34,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',35,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',36,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',37,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',38,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',39,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',40,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',41,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',42,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',43,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',44,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',45,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',46,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',47,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',48,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',49,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',50,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',51,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',52,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',53,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',54,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',55,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',56,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',57,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',58,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',59,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',60,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',61,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',62,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',63,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',64,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',65,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',66,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',67,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',68,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',69,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',70,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',71,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',72,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',73,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',74,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',75,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',76,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',77,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',78,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',79,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',80,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',81,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',82,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',83,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',84,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',85,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',86,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',87,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',88,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',89,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',90,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',91,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',92,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',93,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',94,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',95,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',96,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',97,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',98,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',99,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',100,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',101,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',102,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',103,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',104,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',105,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',106,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',107,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',108,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',109,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',110,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',111,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',112,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',113,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',114,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',115,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',116,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',117,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',118,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',119,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',120,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',121,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',122,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',123,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',124,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',125,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',126,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',127,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',128,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',129,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',130,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',131,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',132,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',133,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',134,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',135,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',136,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',137,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',138,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',139,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',140,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',141,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',142,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',143,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',144,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',145,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',146,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',147,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',148,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',149,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',150,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',151,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',152,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',153,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',154,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',155,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',156,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',157,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',158,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',159,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',160,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',161,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',162,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',163,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',164,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',165,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',166,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',167,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',168,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',169,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',170,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',171,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',172,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',173,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',174,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',175,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',176,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',177,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',178,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',179,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',180,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',181,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',182,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',183,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',184,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',185,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',186,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',187,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',188,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',189,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',190,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',191,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',192,2023);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',1,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',2,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',3,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',4,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',5,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',6,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',7,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',8,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',9,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',10,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',11,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',12,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',13,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',14,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',15,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',16,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',17,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',18,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',19,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',20,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',21,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',22,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',23,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',24,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',25,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',26,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',27,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',28,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',29,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',30,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',31,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',32,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',33,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',34,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',35,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',36,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',37,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',38,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',39,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',40,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',41,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',42,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',43,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',44,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',45,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',46,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',47,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',48,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',49,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',50,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',51,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',52,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',53,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',54,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',55,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',56,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',57,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',58,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',59,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',60,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',61,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',62,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',63,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',64,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',65,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',66,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',67,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',68,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',69,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',70,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',71,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',72,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',73,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',74,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',75,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',76,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',77,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',78,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',79,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',80,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',81,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',82,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',83,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',84,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',85,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',86,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',87,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',88,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',89,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',90,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',91,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',92,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',93,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',94,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',95,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',96,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',97,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NO',98,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',99,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',100,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',101,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',102,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',103,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',104,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',105,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',106,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',107,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',108,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',109,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',110,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',111,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIA',112,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',113,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',114,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',115,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',116,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',117,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',118,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',119,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',120,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',121,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',122,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',123,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',124,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',125,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',126,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',127,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',128,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',129,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SEA',130,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',131,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',132,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',133,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',134,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',135,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',136,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',137,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',138,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',139,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',140,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',141,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',142,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',143,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',144,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',145,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',146,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYJ',147,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',148,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('ATL',149,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',150,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',151,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',152,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',153,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',154,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',155,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',156,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',157,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',158,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',159,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',160,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',161,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',162,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',163,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',164,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',165,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',166,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',167,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',168,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',169,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CIN',170,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',171,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',172,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',173,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',174,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',175,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('HOU',176,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',177,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',178,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DAL',179,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('JAC',180,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',181,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('MIN',182,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',183,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',184,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',185,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('KC',186,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',187,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',188,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',189,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',190,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',191,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',192,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',193,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',194,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',195,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',196,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CHI',197,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TEN',198,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',199,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAC',200,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',201,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CAR',202,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',203,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',204,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('TB',205,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BUF',206,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',207,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',208,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('IND',209,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LV',210,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('CLE',211,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NE',212,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DEN',213,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',214,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('AZ',215,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('DET',216,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('LAR',217,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('GB',218,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PIT',219,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('WAS',220,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('NYG',221,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('SF',222,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('BAL',223,2024);
INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('PHI',224,2024);


INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES
(2,'PHI', 'ATL', 'Philadelphia Eagles', 'Atlanta Falcons', 32, 6, 'DeVonta Smith', 'A.J. Brown', 'Jalen Hurts', 1, 287);

INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES
(1,'TB', 'DAL', 'Tampa Bay Buccaneers', 'Dallas Cowboys', 31, 29, 'Dennis Houston', 'Rachaad White', 'Tom Brady', 1, 217),
(3,'PIT', 'BUF', 'Pittsburgh Steelers', 'Buffalo Bills', 23, 16, 'Duke Johnson', 'Devin Singletary', 'Josh Allen', 1, 238),
(4,'CAR', 'NYJ', 'Carolina Panthers', 'New York Jets', 19, 14, 'Elijah Moore', 'Spencer Brown', 'Baker Mayfield', 1, 186),
(5,'CIN', 'MIN', 'Cincinnati Bengals', 'Minnesota Vikings', 27, 24, 'Trayveon Williams', 'Jalen Reagor', 'Kirk Cousins', 1, 287),
(6,'SEA', 'IND', 'Seattle Seahawks', 'Indianapolis Colts', 28, 16, 'Mike Strachan', 'Laquon Treadwell', 'Geno Smith', 1, 207),
(7,'AZ', 'TEN', 'Arizona Cardinals', 'Tennessee Titans', 38, 13, 'Marquise Brown', 'Rondale Moore', 'Ryan Tannehill', 1, 121),
(8,'SF', 'DET', 'San Francisco 49ers', 'Detroit Lions', 41, 33, 'Josh Reynolds', 'DAndre Swift', 'Jared Goff', 1, 171),
(9,'HOU', 'JAC', 'Houston Texans', 'Jacksonville Jaguars', 37, 21, 'O.J. Howard', 'Pharaoh Brown', 'Trevor Lawrence', 1, 331),
(10,'LAC', 'WAS', 'Los Angeles Chargers', 'Washington Football Team', 20, 16, 'Cole Turner', 'Dax Milne', 'Justin Herbert', 1, 337),
(11,'KC', 'CLE', 'Kansas City Chiefs', 'Cleveland Browns', 33, 29, 'Blake Bell', 'David Njoku', 'Patrick Mahomes', 1, 213),
(12,'DEN', 'NYG', 'Denver Broncos', 'New York Giants', 27, 13, 'Eric Saubert', 'Courtland Sutton', 'Russell Wilson', 1, 203),
(13,'NO', 'GB', 'New Orleans Saints', 'Green Bay Packers', 38, 3, 'Josiah Deguara', 'AJ Dillon', 'Aaron Rodgers', 1, 256),
(14,'MIA', 'NE', 'Miami Dolphins', 'New England Patriots', 17, 16, 'Damien Harris', 'Tyquan Thornton', 'Tua Tagovailoa', 1, 259),
(15,'LAR', 'CHI', 'Los Angeles Rams', 'Chicago Bears', 34, 14, 'Brandon Powell', 'Darrynton Evans', 'Justin Fields', 1, 329),
(16,'LV', 'BAL', 'Las Vegas Raiders', 'Baltimore Ravens', 33, 27, 'Foster Moreau', 'Davante Adams', 'Derek Carr', 1, 285),
(17,'WAS', 'NYG', 'Washington Football Team', 'New York Giants', 30, 29, 'Cam Sims', 'Marcus Johnson', 'Daniel Jones', 2, 144),
(18,'BUF', 'MIA', 'Buffalo Bills', 'Miami Dolphins', 35, 0, 'Jake Kumerow', 'Khalil Shakir', 'Josh Allen', 2, 249),
(19,'CAR', 'NO', 'Carolina Panthers', 'New Orleans Saints', 26, 7, 'Stephen Sullivan', 'Terrace Marshall Jr.', 'Andy Dalton', 2, 163),
(20,'CHI', 'CIN', 'Chicago Bears', 'Cincinnati Bengals', 20, 17, 'Equanimeous St. Brown', 'Trayveon Williams', 'Joe Burrow', 2, 302),
(21,'CLE', 'HOU', 'Cleveland Browns', 'Houston Texans', 31, 21, 'Dameon Pierce', 'Daylen Baldwin', 'Davis Mills', 2, 219),
(22,'LAR', 'IND', 'Los Angeles Rams', 'Indianapolis Colts', 27, 24, 'Cooper Kupp', 'Jordan Wilkins', 'Matt Ryan', 2, 157),
(23,'DEN', 'JAC', 'Denver Broncos', 'Jacksonville Jaguars', 23, 13, 'Tyler Badie', 'Courtland Sutton', 'Trevor Lawrence', 2, 159),
(24,'NE', 'NYJ', 'New England Patriots', 'New York Jets', 25, 6, 'Garrett Wilson', 'Kendrick Bourne', 'Mac Jones', 2, 270),
(25,'SF', 'PHI', 'San Francisco 49ers', 'Philadelphia Eagles', 17, 11, 'Jack Stoll', 'Quez Watkins', 'Jalen Hurts', 2, 300),
(26,'LV', 'PIT', 'Las Vegas Raiders', 'Pittsburgh Steelers', 26, 17, 'Gunner Olszewski', 'Hunter Renfrow', 'Derek Carr', 2, 271),
(27,'TB', 'ATL', 'Tampa Bay Buccaneers', 'Atlanta Falcons', 48, 25, 'Bryan Edwards', 'Ko Kieft', 'Tom Brady', 2, 201),
(28,'AZ', 'MIN', 'Arizona Cardinals', 'Minnesota Vikings', 34, 33, 'Dalvin Cook', 'Corey Clement', 'Kirk Cousins', 2, 232),
(29,'DAL', 'LAC', 'Dallas Cowboys', 'Los Angeles Chargers', 20, 17, 'CeeDee Lamb', 'Tony Pollard', 'Justin Herbert', 2, 147),
(30,'TEN', 'SEA', 'Tennessee Titans', 'Seattle Seahawks', 33, 30, 'Jonathan Ward', 'Mason Kinsey', 'Geno Smith', 2, 331),
(31,'BAL', 'KC', 'Baltimore Ravens', 'Kansas City Chiefs', 36, 35, 'Jerick McKinnon', 'Ronald Jones II', 'Patrick Mahomes', 2, 255),
(32,'GB', 'DET', 'Green Bay Packers', 'Detroit Lions', 35, 17, 'Kylin Hill', 'James Mitchell', 'Jared Goff', 2, 216),
(33,'CAR', 'HOU', 'Carolina Panthers', 'Houston Texans', 24, 9, 'Eno Benjamin', 'Terrace Marshall Jr.', 'Davis Mills', 3, 137),
(34,'ATL', 'NYG', 'Atlanta Falcons', 'New York Giants', 17, 14, 'Gary Brightwell', 'Tanner Hudson', 'Daniel Jones', 3, 237),
(35,'BUF', 'WAS', 'Buffalo Bills', 'Washington Football Team', 43, 21, 'Jamison Crowder', 'John Brown', 'Josh Allen', 3, 317),
(36,'CLE', 'CHI', 'Cleveland Browns', 'Chicago Bears', 26, 6, 'Jerome Ford', 'Trestan Ebner', 'Jacoby Brissett', 3, 265),
(37,'CIN', 'PIT', 'Cincinnati Bengals', 'Pittsburgh Steelers', 24, 10, 'Gunner Olszewski', 'Trent Taylor', 'Joe Burrow', 3, 252),
(38,'TEN', 'IND', 'Tennessee Titans', 'Indianapolis Colts', 25, 16, 'Parris Campbell', 'Jordan Wilkins', 'Matt Ryan', 3, 258),
(39,'AZ', 'JAC', 'Arizona Cardinals', 'Jacksonville Jaguars', 31, 19, 'Christian Kirk', 'Marvin Jones', 'Trevor Lawrence', 3, 270),
(40,'BAL', 'DET', 'Baltimore Ravens', 'Detroit Lions', 19, 17, 'Tom Kennedy', 'Brock Wright', 'Jared Goff', 3, 334),
(41,'LAC', 'KC', 'Los Angeles Chargers', 'Kansas City Chiefs', 30, 24, 'Richard Rodgers', 'Sony Michel', 'Patrick Mahomes', 3, 104),
(42,'NO', 'NE', 'New Orleans Saints', 'New England Patriots', 28, 13, 'Damien Harris', 'Mark Ingram', 'Mac Jones', 3, 303),
(43,'DEN', 'NYJ', 'Denver Broncos', 'New York Jets', 26, 0, 'Garrett Wilson', 'Corey Davis', 'Russell Wilson', 3, 279),
(44,'LV', 'MIA', 'Las Vegas Raiders', 'Miami Dolphins', 31, 28, 'Tanner Conner', 'Jaylen Waddle', 'Tua Tagovailoa', 3, 100),
(45,'MIN', 'SEA', 'Minnesota Vikings', 'Seattle Seahawks', 30, 17, 'Travis Homer', 'Rashaad Penny', 'Kirk Cousins', 3, 346),
(46,'LAR', 'TB', 'Los Angeles Rams', 'Tampa Bay Buccaneers', 34, 24, 'Allen Robinson', 'Jacob Harris', 'Tom Brady', 3, 226),
(47,'GB', 'SF', 'Green Bay Packers', 'San Francisco 49ers', 30, 28, 'Samori Toure', 'Elijah Mitchell', 'Aaron Rodgers', 3, 111),
(48,'DAL', 'PHI', 'Dallas Cowboys', 'Philadelphia Eagles', 41, 21, 'Grant Calcaterra', 'Simi Fehoko', 'Jalen Hurts', 3, 166),
(49,'CIN', 'JAC', 'Cincinnati Bengals', 'Jacksonville Jaguars', 24, 21, 'Snoop Conner', 'Chris Manhertz', 'Joe Burrow', 4, 263),
(50,'WAS', 'ATL', 'Washington Football Team', 'Atlanta Falcons', 34, 30, 'Cordarrelle Patterson', 'Brian Robinson Jr.', 'Marcus Mariota', 4, 293),
(51,'BUF', 'HOU', 'Buffalo Bills', 'Houston Texans', 40, 0, 'Pharaoh Brown', 'Devin Singletary', 'Josh Allen', 4, 289),
(52,'DAL', 'CAR', 'Dallas Cowboys', 'Carolina Panthers', 36, 28, 'Tommy Tremble', 'Christian McCaffrey', 'Dak Prescott', 4, 240),
(53,'CHI', 'DET', 'Chicago Bears', 'Detroit Lions', 24, 14, 'Kalif Raymond', 'Ihmir Smith-Marsette', 'Jared Goff', 4, 267),
(54,'CLE', 'MIN', 'Cleveland Browns', 'Minnesota Vikings', 14, 7, 'Daylen Baldwin', 'Michael Woods II', 'Kirk Cousins', 4, 218),
(55,'IND', 'MIA', 'Indianapolis Colts', 'Miami Dolphins', 27, 17, 'Dezmon Patmon', 'Jordan Wilkins', 'Tua Tagovailoa', 4, 282),
(56,'KC', 'PHI', 'Kansas City Chiefs', 'Philadelphia Eagles', 42, 30, 'Grant Calcaterra', 'Trey Sermon', 'Patrick Mahomes', 4, 244),
(57,'NYG', 'NO', 'New York Giants', 'New Orleans Saints', 27, 21, 'Darius Slayton', 'Richie James', 'Daniel Jones', 4, 227),
(58,'NYJ', 'TEN', 'New York Jets', 'Tennessee Titans', 27, 24, 'Hassan Haskins', 'Geoff Swaim', 'Ryan Tannehill', 4, 226),
(59,'AZ', 'LAR', 'Arizona Cardinals', 'Los Angeles Rams', 37, 20, 'Darrell Henderson', 'TySon Williams', 'Baker Mayfield', 4, 227),
(60,'SEA', 'SF', 'Seattle Seahawks', 'San Francisco 49ers', 28, 21, 'Ray-Ray McCloud', 'DeeJay Dallas', 'Geno Smith', 4, 283),
(61,'BAL', 'DEN', 'Baltimore Ravens', 'Denver Broncos', 23, 7, 'Chase Edmonds', 'Kenyan Drake', 'Russell Wilson', 4, 235),
(62,'GB', 'PIT', 'Green Bay Packers', 'Pittsburgh Steelers', 27, 17, 'Jaylen Warren', 'AJ Dillon', 'Aaron Rodgers', 4, 295),
(63,'TB', 'NE', 'Tampa Bay Buccaneers', 'New England Patriots', 19, 17, 'Ty Montgomery', 'Cade Otton', 'Tom Brady', 4, 203),
(64,'LAC', 'LV', 'Los Angeles Chargers', 'Las Vegas Raiders', 28, 14, 'Josh Jacobs', 'Isaiah Spiller', 'Justin Herbert', 4, 146),
(65,'LAR', 'SEA', 'Los Angeles Rams', 'Seattle Seahawks', 26, 17, 'Dareke Young', 'Rashaad Penny', 'Geno Smith', 5, 165),
(66,'ATL', 'NYJ', 'Atlanta Falcons', 'New York Jets', 27, 20, 'Bryan Edwards', 'Anthony Firkser', 'Marcus Mariota', 5, 321);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (67,'PHI', 'CAR', 'Philadelphia Eagles', 'Carolina Panthers', 21, 18, 'Jack Stoll', 'Ian Thomas', 'Jalen Hurts', 5, 226);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (68,'GB', 'CIN', 'Green Bay Packers', 'Cincinnati Bengals', 25, 22, 'Samori Toure', 'Samaje Perine', 'Joe Burrow', 5, 301);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (69,'PIT', 'DEN', 'Pittsburgh Steelers', 'Denver Broncos', 27, 19, 'Albert Okwuegbunam', 'KJ Hamler', 'Russell Wilson', 5, 279);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (70,'MIN', 'DET', 'Minnesota Vikings', 'Detroit Lions', 19, 17, 'Josh Reynolds', 'Shane Zylstra', 'Kirk Cousins', 5, 309);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (71,'NE', 'HOU', 'New England Patriots', 'Houston Texans', 25, 22, 'Nelson Agholor', 'Tyron Johnson', 'Davis Mills', 5, 236);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (72,'TEN', 'JAC', 'Tennessee Titans', 'Jacksonville Jaguars', 37, 19, 'Jonathan Ward', 'Robert Woods', 'Trevor Lawrence', 5, 300);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (73,'TB', 'MIA', 'Tampa Bay Buccaneers', 'Miami Dolphins', 45, 17, 'Cedrick Wilson Jr.', 'Chase Edmonds', 'Tom Brady', 5, 136);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (74,'NO', 'WAS', 'New Orleans Saints', 'Washington Football Team', 33, 22, 'Juwan Johnson', 'Nick Vannett', 'Andy Dalton', 5, 108);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (75,'CHI', 'LV', 'Chicago Bears', 'Las Vegas Raiders', 20, 9, 'David Montgomery', 'Trevon Wesco', 'Derek Carr', 5, 242);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (76,'LAC', 'CLE', 'Los Angeles Chargers', 'Cleveland Browns', 47, 42, 'Michael Bandy', 'Keenan Allen', 'Justin Herbert', 5, 118);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (77,'AZ', 'SF', 'Arizona Cardinals', 'San Francisco 49ers', 17, 10, 'Tevin Coleman', 'A.J. Green', 'Jimmy Garoppolo', 5, 229);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (78,'DAL', 'NYG', 'Dallas Cowboys', 'New York Giants', 44, 20, 'Marcus Johnson', 'James Washington', 'Daniel Jones', 5, 300);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (79,'BUF', 'KC', 'Buffalo Bills', 'Kansas City Chiefs', 38, 20, 'Tommy Sweeney', 'Justin Watson', 'Patrick Mahomes', 5, 312);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (80,'BAL', 'IND', 'Baltimore Ravens', 'Indianapolis Colts', 31, 25, 'Mike Strachan', 'Keke Coutee', 'Matt Ryan', 5, 235);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (81,'TB', 'PHI', 'Tampa Bay Buccaneers', 'Philadelphia Eagles', 28, 22, 'DeVonta Smith', 'Grant Calcaterra', 'Tom Brady', 6, 262);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (82,'JAC', 'MIA', 'Jacksonville Jaguars', 'Miami Dolphins', 23, 20, 'Travis Etienne', 'Luke Farrell', 'Trevor Lawrence', 6, 195);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (83,'MIN', 'CAR', 'Minnesota Vikings', 'Carolina Panthers', 34, 28, 'Adam Thielen', 'Alexander Mattison', 'Kirk Cousins', 6, 164);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (84,'GB', 'CHI', 'Green Bay Packers', 'Chicago Bears', 24, 14, 'Equanimeous St. Brown', 'Velus Jones Jr.', 'Aaron Rodgers', 6, 340);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (85,'CIN', 'DET', 'Cincinnati Bengals', 'Detroit Lions', 34, 11, 'DAndre Swift', 'Quintez Cephus', 'Joe Burrow', 6, 101);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (86,'IND', 'HOU', 'Indianapolis Colts', 'Houston Texans', 31, 3, 'Nyheim Hines', 'Dare Ogunbowale', 'Davis Mills', 6, 233);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (87,'KC', 'WAS', 'Kansas City Chiefs', 'Washington Football Team', 31, 13, 'Antonio Gibson', 'Jaret Patterson', 'Patrick Mahomes', 6, 299);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (88,'LAR', 'NYG', 'Los Angeles Rams', 'New York Giants', 38, 11, 'Kadarius Toney', 'David Sills', 'Daniel Jones', 6, 167);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (89,'BAL', 'LAC', 'Baltimore Ravens', 'Los Angeles Chargers', 34, 6, 'Gus Edwards', 'Josh Oliver', 'Justin Herbert', 6, 133);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (90,'AZ', 'CLE', 'Arizona Cardinals', 'Cleveland Browns', 37, 14, 'David Njoku', 'Eno Benjamin', 'Jacoby Brissett', 6, 249);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (91,'DAL', 'NE', 'Dallas Cowboys', 'New England Patriots', 35, 29, 'Noah Brown', 'Simi Fehoko', 'Mac Jones', 6, 210);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (92,'LV', 'DEN', 'Las Vegas Raiders', 'Denver Broncos', 34, 24, 'Ameer Abdullah', 'Foster Moreau', 'Russell Wilson', 6, 141);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (93,'PIT', 'SEA', 'Pittsburgh Steelers', 'Seattle Seahawks', 23, 20, 'Dareke Young', 'Zach Gentry', 'Geno Smith', 6, 325);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (94,'TEN', 'BUF', 'Tennessee Titans', 'Buffalo Bills', 34, 31, 'John Brown', 'Dawson Knox', 'Josh Allen', 6, 172);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (95,'CLE', 'DEN', 'Cleveland Browns', 'Denver Broncos', 17, 14, 'Chase Edmonds', 'DErnest Johnson', 'Russell Wilson', 7, 269);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (96,'ATL', 'MIA', 'Atlanta Falcons', 'Miami Dolphins', 30, 28, 'MyCole Pruitt', 'Myles Gaskin', 'Tua Tagovailoa', 7, 120);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (97,'NYG', 'CAR', 'New York Giants', 'Carolina Panthers', 25, 3, 'Stephen Sullivan', 'Terrace Marshall Jr.', 'Daniel Jones', 7, 295);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (98,'CIN', 'BAL', 'Cincinnati Bengals', 'Baltimore Ravens', 41, 17, 'Isaiah Likely', 'Devin Asiasi', 'Joe Burrow', 7, 112);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (99,'GB', 'WAS', 'Green Bay Packers', 'Washington Football Team', 24, 10, 'Josiah Deguara', 'Jonathan Williams', 'Aaron Rodgers', 7, 220);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (100,'TEN', 'KC', 'Tennessee Titans', 'Kansas City Chiefs', 27, 3, 'Derrick Henry', 'Jonathan Ward', 'Patrick Mahomes', 7, 208);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (101,'NE', 'NYJ', 'New England Patriots', 'New York Jets', 54, 13, 'C.J. Uzomah', 'DeVante Parker', 'Mac Jones', 7, 143);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (102,'LAR', 'DET', 'Los Angeles Rams', 'Detroit Lions', 28, 19, 'James Mitchell', 'Darrell Henderson', 'Jared Goff', 7, 324);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (103,'LV', 'PHI', 'Las Vegas Raiders', 'Philadelphia Eagles', 33, 22, 'Josh Jacobs', 'Mack Hollins', 'Jalen Hurts', 7, 141);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (104,'TB', 'CHI', 'Tampa Bay Buccaneers', 'Chicago Bears', 38, 3, 'Breshad Perriman', 'Trestan Ebner', 'Tom Brady', 7, 340);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (105,'AZ', 'HOU', 'Arizona Cardinals', 'Houston Texans', 31, 5, 'O.J. Howard', 'Darrel Williams', 'Davis Mills', 7, 117);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (106,'IND', 'SF', 'Indianapolis Colts', 'San Francisco 49ers', 30, 18, 'Christian McCaffrey', 'Keke Coutee', 'Matt Ryan', 7, 303);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (107,'NO', 'SEA', 'New Orleans Saints', 'Seattle Seahawks', 13, 10, 'Dwayne Eskridge', 'Rashid Shaheed', 'Geno Smith', 7, 266);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (108,'GB', 'AZ', 'Green Bay Packers', 'Arizona Cardinals', 24, 21, 'Darrel Williams', 'Andre Baccellia', 'Aaron Rodgers', 8, 133);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (109,'CAR', 'ATL', 'Carolina Panthers', 'Atlanta Falcons', 19, 13, 'Feleipe Franks', 'Damien Williams', 'Marcus Mariota', 8, 100);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (110,'BUF', 'MIA', 'Buffalo Bills', 'Miami Dolphins', 26, 11, 'Cole Beasley', 'Tanner Conner', 'Josh Allen', 8, 129);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (111,'SF', 'CHI', 'San Francisco 49ers', 'Chicago Bears', 33, 22, 'NKeal Harry', 'Jordan Mason', 'Jimmy Garoppolo', 8, 147);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (112,'NYJ', 'CIN', 'New York Jets', 'Cincinnati Bengals', 34, 31, 'Zonovan Knight', 'Tyler Conklin', 'Joe Burrow', 8, 319);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (113,'PIT', 'CLE', 'Pittsburgh Steelers', 'Cleveland Browns', 15, 10, 'David Njoku', 'Miller Forristall', 'Jacoby Brissett', 8, 204);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (114,'TEN', 'IND', 'Tennessee Titans', 'Indianapolis Colts', 34, 31, 'Michael Pittman Jr.', 'Mike Strachan', 'Matt Ryan', 8, 231);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (115,'PHI', 'DET', 'Philadelphia Eagles', 'Detroit Lions', 44, 6, 'Kenneth Gainwell', 'Dandre Swift', 'Jared Goff', 8, 179);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (116,'LAR', 'HOU', 'Los Angeles Rams', 'Houston Texans', 38, 22, 'Brandin Cooks', 'Ronnie Rivers', 'Davis Mills', 8, 133);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (117,'SEA', 'JAC', 'Seattle Seahawks', 'Jacksonville Jaguars', 31, 7, 'Dan Arnold', 'Snoop Conner', 'Geno Smith', 8, 344);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (118,'NE', 'LAC', 'New England Patriots', 'Los Angeles Chargers', 27, 24, 'Rhamondre Stevenson', 'Richard Rodgers', 'Justin Herbert', 8, 237);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (119,'NO', 'TB', 'New Orleans Saints', 'Tampa Bay Buccaneers', 36, 27, 'Mark Ingram', 'Nick Vannett', 'Tom Brady', 8, 268);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (120,'DEN', 'WAS', 'Denver Broncos', 'Washington Football Team', 17, 10, 'Javonte Williams', 'Freddie Swain', 'Russell Wilson', 8, 253);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (121,'DAL', 'MIN', 'Dallas Cowboys', 'Minnesota Vikings', 20, 16, 'Justin Jefferson', 'Irv Smith Jr.', 'Kirk Cousins', 8, 149);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (122,'KC', 'NYG', 'Kansas City Chiefs', 'New York Giants', 20, 17, 'Daniel Bellinger', 'David Sills', 'Patrick Mahomes', 8, 166);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (123,'IND', 'NYJ', 'Indianapolis Colts', 'New York Jets', 45, 30, 'Keke Coutee', 'Deon Jackson', 'Matt Ryan', 9, 167);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (124,'ATL', 'NO', 'Atlanta Falcons', 'New Orleans Saints', 27, 25, 'Tyler Allgeier', 'Juwan Johnson', 'Andy Dalton', 9, 236);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (125,'JAC', 'BUF', 'Jacksonville Jaguars', 'Buffalo Bills', 9, 6, 'Isaiah McKenzie', 'Tommy Sweeney', 'Josh Allen', 9, 169);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (126,'DEN', 'DAL', 'Denver Broncos', 'Dallas Cowboys', 30, 16, 'Jalen Virgil', 'Sean McKeon', 'Russell Wilson', 9, 313);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (127,'BAL', 'MIN', 'Baltimore Ravens', 'Minnesota Vikings', 34, 31, 'Jalen Reagor', 'Adam Thielen', 'Kirk Cousins', 9, 232);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (128,'NE', 'CAR', 'New England Patriots', 'Carolina Panthers', 24, 6, 'Terrace Marshall Jr.', 'J.J. Taylor', 'Mac Jones', 9, 188);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (129,'CLE', 'CIN', 'Cleveland Browns', 'Cincinnati Bengals', 41, 16, 'Pharaoh Brown', 'David Njoku', 'Joe Burrow', 9, 213);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (130,'MIA', 'HOU', 'Miami Dolphins', 'Houston Texans', 17, 9, 'Jordan Akins', 'Brandin Cooks', 'Tua Tagovailoa', 9, 332);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (131,'NYG', 'LV', 'New York Giants', 'Las Vegas Raiders', 23, 16, 'Tanner Hudson', 'Jesper Horsted', 'Derek Carr', 9, 286);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (132,'LAC', 'PHI', 'Los Angeles Chargers', 'Philadelphia Eagles', 27, 24, 'A.J. Brown', 'Stone Smartt', 'Justin Herbert', 9, 115);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (133,'AZ', 'SF', 'Arizona Cardinals', 'San Francisco 49ers', 31, 17, 'Elijah Mitchell', 'Rondale Moore', 'Jimmy Garoppolo', 9, 233);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (134,'KC', 'GB', 'Kansas City Chiefs', 'Green Bay Packers', 13, 7, 'Romeo Doubs', 'Aaron Jones', 'Patrick Mahomes', 9, 208);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (135,'TEN', 'LAR', 'Tennessee Titans', 'Los Angeles Rams', 28, 16, 'Allen Robinson', 'Cam Akers', 'Ryan Tannehill', 9, 216);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (136,'PIT', 'CHI', 'Pittsburgh Steelers', 'Chicago Bears', 29, 27, 'Jaylen Warren', 'Pat Freiermuth', 'Kenny Pickett', 9, 232);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (137,'MIA', 'BAL', 'Miami Dolphins', 'Baltimore Ravens', 22, 10, 'Andy Isabella', 'Durham Smythe', 'Tua Tagovailoa', 10, 267);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (138,'DAL', 'ATL', 'Dallas Cowboys', 'Atlanta Falcons', 43, 3, 'Kyle Pitts', 'Damien Williams', 'Dak Prescott', 10, 296);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (139,'BUF', 'NYJ', 'Buffalo Bills', 'New York Jets', 45, 17, 'Stefon Diggs', 'Elijah Moore', 'Josh Allen', 10, 310);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (140,'PIT', 'DET', 'Pittsburgh Steelers', 'Detroit Lions', 16, 16, 'Jameson Williams', 'Amon-Ra St. Brown', 'Jared Goff', 10, 337);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (141,'TEN', 'NO', 'Tennessee Titans', 'New Orleans Saints', 23, 21, 'Kyle Philips', 'Derrick Henry', 'Andy Dalton', 10, 201);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (142,'WAS', 'TB', 'Washington Football Team', 'Tampa Bay Buccaneers', 29, 19, 'Ko Kieft', 'Reggie Bonnafon', 'Tom Brady', 10, 324);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (143,'NE', 'CLE', 'New England Patriots', 'Cleveland Browns', 45, 7, 'Daylen Baldwin', 'David Bell', 'Mac Jones', 10, 233);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (144,'IND', 'JAC', 'Indianapolis Colts', 'Jacksonville Jaguars', 23, 17, 'Deon Jackson', 'Zack Moss', 'Trevor Lawrence', 10, 225);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (145,'MIN', 'LAC', 'Minnesota Vikings', 'Los Angeles Chargers', 27, 20, 'Irv Smith Jr.', 'Jalen Nailor', 'Justin Herbert', 10, 173);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (146,'CAR', 'AZ', 'Carolina Panthers', 'Arizona Cardinals', 34, 10, 'Donta Foreman', 'Pharoh Cooper', 'Baker Mayfield', 10, 153);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (147,'PHI', 'DEN', 'Philadelphia Eagles', 'Denver Broncos', 30, 13, 'Dallas Goedert', 'Chase Edmonds', 'Jalen Hurts', 10, 136);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (148,'GB', 'SEA', 'Green Bay Packers', 'Seattle Seahawks', 17, 0, 'Randall Cobb', 'Colby Parkinson', 'Geno Smith', 10, 322);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (149,'KC', 'LV', 'Kansas City Chiefs', 'Las Vegas Raiders', 41, 14, 'Ameer Abdullah', 'DJ Turner', 'Patrick Mahomes', 10, 168);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (150,'SF', 'LAR', 'San Francisco 49ers', 'Los Angeles Rams', 31, 10, 'Cooper Kupp', 'Deebo Samuel', 'Jimmy Garoppolo', 10, 308);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (151,'NE', 'ATL', 'New England Patriots', 'Atlanta Falcons', 25, 0, 'Frank Darby', 'Cordarrelle Patterson', 'Mac Jones', 11, 222);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (152,'IND', 'BUF', 'Indianapolis Colts', 'Buffalo Bills', 41, 15, 'Cole Beasley', 'Mo Alie-Cox', 'Josh Allen', 11, 349);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (153,'BAL', 'CHI', 'Baltimore Ravens', 'Chicago Bears', 16, 13, 'Jake Tonges', 'David Montgomery', 'Lamar Jackson', 11, 331);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (154,'HOU', 'TEN', 'Houston Texans', 'Tennessee Titans', 22, 13, 'Royce Freeman', 'Chris Moore', 'Davis Mills', 11, 295);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (155,'SF', 'JAC', 'San Francisco 49ers', 'Jacksonville Jaguars', 30, 10, 'James Robinson', 'Elijah Mitchell', 'Trevor Lawrence', 11, 146);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (156,'PHI', 'NO', 'Philadelphia Eagles', 'New Orleans Saints', 40, 29, 'Jarvis Landry', 'Tony Jones', 'Jalen Hurts', 11, 176);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (157,'WAS', 'CAR', 'Washington Football Team', 'Carolina Panthers', 27, 21, 'Jonathan Williams', 'Spencer Brown', 'Baker Mayfield', 11, 222);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (158,'CLE', 'DET', 'Cleveland Browns', 'Detroit Lions', 13, 10, 'Jameson Williams', 'Craig Reynolds', 'Jared Goff', 11, 300);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (159,'MIN', 'GB', 'Minnesota Vikings', 'Green Bay Packers', 34, 31, 'Justin Jefferson', 'K.J. Osborn', 'Kirk Cousins', 11, 180);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (160,'MIA', 'NYJ', 'Miami Dolphins', 'New York Jets', 24, 17, 'Garrett Wilson', 'Chase Edmonds', 'Tua Tagovailoa', 11, 213);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (161,'CIN', 'LV', 'Cincinnati Bengals', 'Las Vegas Raiders', 32, 13, 'Brandon Bolden', 'Trenton Irwin', 'Joe Burrow', 11, 184);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (162,'KC', 'DAL', 'Kansas City Chiefs', 'Dallas Cowboys', 19, 9, 'Peyton Hendershot', 'James Washington', 'Patrick Mahomes', 11, 132);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (163,'AZ', 'SEA', 'Arizona Cardinals', 'Seattle Seahawks', 23, 13, 'Corey Clement', 'Laquon Treadwell', 'Geno Smith', 11, 281);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (164,'LAC', 'PIT', 'Los Angeles Chargers', 'Pittsburgh Steelers', 41, 37, 'Jalen Guyton', 'Anthony McFarland Jr.', 'Justin Herbert', 11, 311);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (165,'TB', 'NYG', 'Tampa Bay Buccaneers', 'New York Giants', 30, 10, 'Kyle Rudolph', 'Gary Brightwell', 'Tom Brady', 11, 108);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (166,'CHI', 'DET', 'Chicago Bears', 'Detroit Lions', 16, 14, 'Chase Claypool', 'Dante Pettis', 'Jared Goff', 12, 242);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (167,'LV', 'DAL', 'Las Vegas Raiders', 'Dallas Cowboys', 36, 33, 'Jesper Horsted', 'Hunter Renfrow', 'Derek Carr', 12, 256);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (168,'BUF', 'NO', 'Buffalo Bills', 'New Orleans Saints', 31, 6, 'Eno Benjamin', 'Dawson Knox', 'Josh Allen', 12, 264);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (169,'ATL', 'JAC', 'Atlanta Falcons', 'Jacksonville Jaguars', 21, 14, 'Jamycal Hasty', 'Travis Etienne', 'Trevor Lawrence', 12, 306);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (170,'CIN', 'PIT', 'Cincinnati Bengals', 'Pittsburgh Steelers', 41, 10, 'Steven Sims', 'Trayveon Williams', 'Joe Burrow', 12, 201);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (171,'NYJ', 'HOU', 'New York Jets', 'Houston Texans', 21, 14, 'Breece Hall', 'Braxton Berrios', 'Davis Mills', 12, 126);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (172,'NYG', 'PHI', 'New York Giants', 'Philadelphia Eagles', 13, 7, 'Sterling Shepard', 'Miles Sanders', 'Jalen Hurts', 12, 111);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (173,'MIA', 'CAR', 'Miami Dolphins', 'Carolina Panthers', 33, 10, 'Braylon Sanders', 'River Cracraft', 'Tua Tagovailoa', 12, 268);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (174,'TB', 'IND', 'Tampa Bay Buccaneers', 'Indianapolis Colts', 38, 31, 'Nyheim Hines', 'Ko Kieft', 'Tom Brady', 12, 341);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (175,'NE', 'TEN', 'New England Patriots', 'Tennessee Titans', 36, 13, 'J.J. Taylor', 'Nick Westbrook-Ikhine', 'Mac Jones', 12, 246);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (176,'DEN', 'LAC', 'Denver Broncos', 'Los Angeles Chargers', 28, 13, 'Chase Edmonds', 'Jalen Guyton', 'Justin Herbert', 12, 177);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (177,'SF', 'MIN', 'San Francisco 49ers', 'Minnesota Vikings', 34, 26, 'Irv Smith Jr.', 'Tevin Coleman', 'Kirk Cousins', 12, 207);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (178,'GB', 'LAR', 'Green Bay Packers', 'Los Angeles Rams', 36, 28, 'Ronnie Rivers', 'Kendall Blanton', 'Aaron Rodgers', 12, 140);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (179,'BAL', 'CLE', 'Baltimore Ravens', 'Cleveland Browns', 16, 10, 'Isaiah Likely', 'Harrison Bryant', 'Jacoby Brissett', 12, 157);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (180,'WAS', 'SEA', 'Washington Football Team', 'Seattle Seahawks', 17, 15, 'Colby Parkinson', 'John Bates', 'Geno Smith', 12, 233);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (181,'DAL', 'NO', 'Dallas Cowboys', 'New Orleans Saints', 27, 17, 'Alvin Kamara', 'Jake Ferguson', 'Andy Dalton', 13, 299);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (182,'TB', 'ATL', 'Tampa Bay Buccaneers', 'Atlanta Falcons', 30, 17, 'Damien Williams', 'Leonard Fournette', 'Tom Brady', 13, 321);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (183,'AZ', 'CHI', 'Arizona Cardinals', 'Chicago Bears', 33, 22, 'Nsimba Webster', 'Byron Pringle', 'Justin Fields', 13, 296);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (184,'LAC', 'CIN', 'Los Angeles Chargers', 'Cincinnati Bengals', 41, 22, 'Tee Higgins', 'Isaiah Spiller', 'Justin Herbert', 13, 206);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (185,'DET', 'MIN', 'Detroit Lions', 'Minnesota Vikings', 29, 27, 'Tom Kennedy', 'Amon-Ra St. Brown', 'Kirk Cousins', 13, 122);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (186,'PHI', 'NYJ', 'Philadelphia Eagles', 'New York Jets', 33, 18, 'Trey Sermon', 'Jeff Smith', 'Jalen Hurts', 13, 340);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (187,'IND', 'HOU', 'Indianapolis Colts', 'Houston Texans', 31, 0, 'Jordan Akins', 'Mike Strachan', 'Davis Mills', 13, 283);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (188,'MIA', 'NYG', 'Miami Dolphins', 'New York Giants', 20, 9, 'Marcus Johnson', 'Durham Smythe', 'Tua Tagovailoa', 13, 145);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (189,'SEA', 'SF', 'Seattle Seahawks', 'San Francisco 49ers', 30, 23, 'Elijah Mitchell', 'Tyler Mabry', 'Geno Smith', 13, 259);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (190,'WAS', 'LV', 'Washington Football Team', 'Las Vegas Raiders', 17, 15, 'DJ Turner', 'Davante Adams', 'Derek Carr', 13, 179);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (191,'LAR', 'JAC', 'Los Angeles Rams', 'Jacksonville Jaguars', 37, 7, 'Austin Trammell', 'Brandon Powell', 'Trevor Lawrence', 13, 126);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (192,'PIT', 'BAL', 'Pittsburgh Steelers', 'Baltimore Ravens', 20, 19, 'Charlie Kolar', 'Gus Edwards', 'Kenny Pickett', 13, 280);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (193,'KC', 'DEN', 'Kansas City Chiefs', 'Denver Broncos', 22, 9, 'Skyy Moore', 'Tyrie Cleveland', 'Patrick Mahomes', 13, 310);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (194,'NE', 'BUF', 'New England Patriots', 'Buffalo Bills', 14, 10, 'Pierre Strong', 'John Brown', 'Josh Allen', 13, 119);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (195,'MIN', 'PIT', 'Minnesota Vikings', 'Pittsburgh Steelers', 36, 28, 'Jaylen Warren', 'Diontae Johnson', 'Kirk Cousins', 14, 238);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (196,'ATL', 'CAR', 'Atlanta Falcons', 'Carolina Panthers', 29, 21, 'MyCole Pruitt', 'Christian McCaffrey', 'Marcus Mariota', 14, 112);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (197,'SF', 'CIN', 'San Francisco 49ers', 'Cincinnati Bengals', 26, 23, 'Tyler Boyd', 'Mike Thomas', 'Joe Burrow', 14, 239);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (198,'CLE', 'BAL', 'Cleveland Browns', 'Baltimore Ravens', 24, 22, 'Sammy Watkins', 'Justice Hill', 'Jacoby Brissett', 14, 222);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (199,'DAL', 'WAS', 'Dallas Cowboys', 'Washington Football Team', 27, 20, 'Cam Sims', 'John Bates', 'Dak Prescott', 14, 210);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (200,'SEA', 'HOU', 'Seattle Seahawks', 'Houston Texans', 33, 13, 'Laquon Treadwell', 'Dwayne Eskridge', 'Geno Smith', 14, 188);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (201,'TEN', 'JAC', 'Tennessee Titans', 'Jacksonville Jaguars', 20, 0, 'Marvin Jones', 'Christian Kirk', 'Trevor Lawrence', 14, 215);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (202,'KC', 'LV', 'Kansas City Chiefs', 'Las Vegas Raiders', 48, 9, 'Noah Gray', 'Jesper Horsted', 'Patrick Mahomes', 14, 136);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (203,'NO', 'NYJ', 'New Orleans Saints', 'New York Jets', 30, 9, 'C.J. Uzomah', 'Denzel Mims', 'Andy Dalton', 14, 338);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (204,'DEN', 'DET', 'Denver Broncos', 'Detroit Lions', 38, 10, 'Montrell Washington', 'Albert Okwuegbunam', 'Jared Goff', 14, 127);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (205,'LAC', 'NYG', 'Los Angeles Chargers', 'New York Giants', 37, 21, 'David Sills', 'Tanner Hudson', 'Justin Herbert', 14, 223);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (206,'TB', 'BUF', 'Tampa Bay Buccaneers', 'Buffalo Bills', 33, 27, 'Zack Moss', 'Gabriel Davis', 'Tom Brady', 14, 195);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (207,'GB', 'CHI', 'Green Bay Packers', 'Chicago Bears', 45, 30, 'Chase Claypool', 'Darrynton Evans', 'Aaron Rodgers', 14, 341);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (208,'LAR', 'AZ', 'Los Angeles Rams', 'Arizona Cardinals', 30, 23, 'TySon Williams', 'Kendall Blanton', 'Baker Mayfield', 14, 274);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (209,'KC', 'LAC', 'Kansas City Chiefs', 'Los Angeles Chargers', 34, 28, 'Mecole Hardman', 'Richard Rodgers', 'Patrick Mahomes', 15, 175);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (210,'IND', 'NE', 'Indianapolis Colts', 'New England Patriots', 27, 17, 'Pierre Strong', 'Nelson Agholor', 'Matt Ryan', 15, 224);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (211,'BUF', 'CAR', 'Buffalo Bills', 'Carolina Panthers', 31, 14, 'Isaiah McKenzie', 'Spencer Brown', 'Josh Allen', 15, 252);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (212,'DET', 'AZ', 'Detroit Lions', 'Arizona Cardinals', 30, 12, 'Maxx Williams', 'Trey McBride', 'Jared Goff', 15, 102);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (213,'DAL', 'NYG', 'Dallas Cowboys', 'New York Giants', 21, 6, 'Daniel Bellinger', 'Sterling Shepard', 'Daniel Jones', 15, 320);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (214,'GB', 'BAL', 'Green Bay Packers', 'Baltimore Ravens', 31, 30, 'Devin Duvernay', 'Patrick Taylor', 'Aaron Rodgers', 15, 176);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (215,'HOU', 'JAC', 'Houston Texans', 'Jacksonville Jaguars', 30, 16, 'Tyron Johnson', 'Christian Kirk', 'Trevor Lawrence', 15, 138);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (216,'MIA', 'NYJ', 'Miami Dolphins', 'New York Jets', 31, 24, 'Mike Gesicki', 'Chase Edmonds', 'Tua Tagovailoa', 15, 349);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (217,'PIT', 'TEN', 'Pittsburgh Steelers', 'Tennessee Titans', 19, 13, 'Racey McMath', 'Benny Snell Jr.', 'Ryan Tannehill', 15, 143);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (218,'SF', 'ATL', 'San Francisco 49ers', 'Atlanta Falcons', 31, 13, 'Bryan Edwards', 'KhaDarel Hodge', 'Jimmy Garoppolo', 15, 254);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (219,'CIN', 'DEN', 'Cincinnati Bengals', 'Denver Broncos', 15, 10, 'Albert Okwuegbunam', 'Jerry Jeudy', 'Joe Burrow', 15, 206);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (220,'NO', 'TB', 'New Orleans Saints', 'Tampa Bay Buccaneers', 9, 0, 'Leonard Fournette', 'David Johnson', 'Tom Brady', 15, 214);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (221,'LV', 'CLE', 'Las Vegas Raiders', 'Cleveland Browns', 16, 14, 'Demetric Felton', 'Josh Jacobs', 'Derek Carr', 15, 241);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (222,'MIN', 'CHI', 'Minnesota Vikings', 'Chicago Bears', 17, 9, 'Justin Jefferson', 'Johnny Mundt', 'Kirk Cousins', 15, 170);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (223,'PHI', 'WAS', 'Philadelphia Eagles', 'Washington Football Team', 27, 17, 'Dyami Brown', 'Curtis Samuel', 'Jalen Hurts', 15, 335);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (224,'LAR', 'SEA', 'Los Angeles Rams', 'Seattle Seahawks', 20, 10, 'Travis Homer', 'Tyler Lockett', 'Geno Smith', 15, 132);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (225,'TEN', 'SF', 'Tennessee Titans', 'San Francisco 49ers', 20, 17, 'Derrick Henry', 'Geoff Swaim', 'Ryan Tannehill', 16, 226);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (226,'GB', 'CLE', 'Green Bay Packers', 'Cleveland Browns', 24, 22, 'DErnest Johnson', 'David Bell', 'Aaron Rodgers', 16, 102);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (227,'IND', 'AZ', 'Indianapolis Colts', 'Arizona Cardinals', 22, 16, 'Jonathan Taylor', 'A.J. Green', 'Matt Ryan', 16, 124);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (228,'ATL', 'DET', 'Atlanta Falcons', 'Detroit Lions', 20, 16, 'T.J. Hockenson', 'Anthony Firkser', 'Jared Goff', 16, 324);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (229,'BUF', 'NE', 'Buffalo Bills', 'New England Patriots', 33, 21, 'Isaiah Hodgins', 'Devin Singletary', 'Josh Allen', 16, 237);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (230,'TB', 'CAR', 'Tampa Bay Buccaneers', 'Carolina Panthers', 32, 6, 'Julio Jones', 'Raheem Blackshear', 'Tom Brady', 16, 189);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (231,'CIN', 'BAL', 'Cincinnati Bengals', 'Baltimore Ravens', 41, 21, 'Sammy Watkins', 'J.K. Dobbins', 'Joe Burrow', 16, 225);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (232,'HOU', 'LAC', 'Houston Texans', 'Los Angeles Chargers', 41, 29, 'Austin Ekeler', 'O.J. Howard', 'Justin Herbert', 16, 291);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (233,'NYJ', 'JAC', 'New York Jets', 'Jacksonville Jaguars', 26, 21, 'James Robinson', 'Denzel Mims', 'Trevor Lawrence', 16, 142);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (234,'LAR', 'MIN', 'Los Angeles Rams', 'Minnesota Vikings', 30, 23, 'Justin Jefferson', 'Darrell Henderson', 'Kirk Cousins', 16, 172);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (235,'PHI', 'NYG', 'Philadelphia Eagles', 'New York Giants', 34, 10, 'Darius Slayton', 'A.J. Brown', 'Jalen Hurts', 16, 267);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (236,'CHI', 'SEA', 'Chicago Bears', 'Seattle Seahawks', 25, 24, 'Will Dissly', 'Cole Kmet', 'Geno Smith', 16, 248);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (237,'LV', 'DEN', 'Las Vegas Raiders', 'Denver Broncos', 17, 13, 'Courtland Sutton', 'Tyrie Cleveland', 'Russell Wilson', 16, 243);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (238,'KC', 'PIT', 'Kansas City Chiefs', 'Pittsburgh Steelers', 36, 10, 'Justin Watson', 'Cody White', 'Patrick Mahomes', 16, 143);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (239,'DAL', 'WAS', 'Dallas Cowboys', 'Washington Football Team', 56, 14, 'Jonathan Williams', 'Noah Brown', 'Dak Prescott', 16, 269);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (240,'MIA', 'NO', 'Miami Dolphins', 'New Orleans Saints', 20, 3, 'Braylon Sanders', 'Jordan Howard', 'Tua Tagovailoa', 16, 255);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (241,'BUF', 'ATL', 'Buffalo Bills', 'Atlanta Falcons', 29, 15, 'Khalil Shakir', 'Quintin Morris', 'Josh Allen', 17, 266);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (242,'NO', 'CAR', 'New Orleans Saints', 'Carolina Panthers', 18, 10, 'David Johnson', 'Dwayne Washington', 'Andy Dalton', 17, 192);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (243,'CHI', 'NYG', 'Chicago Bears', 'New York Giants', 29, 3, 'Marcus Johnson', 'Lawrence Cager', 'Daniel Jones', 17, 235);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (244,'CIN', 'KC', 'Cincinnati Bengals', 'Kansas City Chiefs', 34, 31, 'Samaje Perine', 'Tyler Boyd', 'Patrick Mahomes', 17, 180);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (245,'LV', 'IND', 'Las Vegas Raiders', 'Indianapolis Colts', 23, 20, 'Keelan Cole', 'Ashton Dulin', 'Derek Carr', 17, 323);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (246,'AZ', 'DAL', 'Arizona Cardinals', 'Dallas Cowboys', 25, 22, 'Keaontay Ingram', 'Maxx Williams', 'Dak Prescott', 17, 191);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (247,'NE', 'JAC', 'New England Patriots', 'Jacksonville Jaguars', 50, 10, 'Jamycal Hasty', 'James Robinson', 'Trevor Lawrence', 17, 106);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (248,'TEN', 'MIA', 'Tennessee Titans', 'Miami Dolphins', 34, 3, 'Dontrell Hilliard', 'Erik Ezukanma', 'Tua Tagovailoa', 17, 290);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (249,'TB', 'NYJ', 'Tampa Bay Buccaneers', 'New York Jets', 28, 24, 'Breece Hall', 'Chris Godwin', 'Tom Brady', 17, 249);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (250,'PHI', 'WAS', 'Philadelphia Eagles', 'Washington Football Team', 20, 16, 'DeVonta Smith', 'Kenneth Gainwell', 'Jalen Hurts', 17, 104);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (251,'LAC', 'DEN', 'Los Angeles Chargers', 'Denver Broncos', 34, 13, 'Kendall Hinton', 'Larry Rountree', 'Justin Herbert', 17, 280);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (252,'SF', 'HOU', 'San Francisco 49ers', 'Houston Texans', 23, 7, 'Christian McCaffrey', 'Chris Moore', 'Davis Mills', 17, 157);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (253,'SEA', 'DET', 'Seattle Seahawks', 'Detroit Lions', 51, 29, 'Colby Parkinson', 'DJ Chark', 'Jared Goff', 17, 282);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (254,'LAR', 'BAL', 'Los Angeles Rams', 'Baltimore Ravens', 20, 19, 'Lance McCutcheon', 'Van Jefferson', 'Lamar Jackson', 17, 253);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (255,'GB', 'MIN', 'Green Bay Packers', 'Minnesota Vikings', 37, 10, 'Kylin Hill', 'Patrick Taylor', 'Kirk Cousins', 17, 345);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (256,'PIT', 'CLE', 'Pittsburgh Steelers', 'Cleveland Browns', 26, 14, 'George Pickens', 'Cody White', 'Jacoby Brissett', 17, 340);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (257,'KC', 'DEN', 'Kansas City Chiefs', 'Denver Broncos', 28, 24, 'Albert Okwuegbunam', 'Eric Saubert', 'Patrick Mahomes', 18, 245);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (258,'DAL', 'PHI', 'Dallas Cowboys', 'Philadelphia Eagles', 51, 26, 'Tony Pollard', 'Boston Scott', 'Jalen Hurts', 18, 154);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (259,'NO', 'ATL', 'New Orleans Saints', 'Atlanta Falcons', 30, 20, 'Chris Olave', 'Kyle Pitts', 'Andy Dalton', 18, 153);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (260,'TB', 'CAR', 'Tampa Bay Buccaneers', 'Carolina Panthers', 41, 17, 'Breshad Perriman', 'Jaelon Darden', 'Tom Brady', 18, 253);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (261,'MIN', 'CHI', 'Minnesota Vikings', 'Chicago Bears', 31, 17, 'Jalen Reagor', 'Dante Pettis', 'Kirk Cousins', 18, 163);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (262,'CLE', 'CIN', 'Cleveland Browns', 'Cincinnati Bengals', 21, 16, 'Drew Sample', 'Mitchell Wilcox', 'Joe Burrow', 18, 221);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (263,'JAC', 'IND', 'Jacksonville Jaguars', 'Indianapolis Colts', 26, 11, 'Jonathan Taylor', 'Jamycal Hasty', 'Trevor Lawrence', 18, 248);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (264,'DET', 'GB', 'Detroit Lions', 'Green Bay Packers', 37, 30, 'James Mitchell', 'Amon-Ra St. Brown', 'Jared Goff', 18, 256);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (265,'TEN', 'HOU', 'Tennessee Titans', 'Houston Texans', 28, 25, 'Chigoziem Okonkwo', 'O.J. Howard', 'Davis Mills', 18, 117);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (266,'MIA', 'NE', 'Miami Dolphins', 'New England Patriots', 33, 24, 'Chase Edmonds', 'J.J. Taylor', 'Tua Tagovailoa', 18, 102);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (267,'WAS', 'NYG', 'Washington Football Team', 'New York Giants', 22, 7, 'David Sills', 'Saquon Barkley', 'Daniel Jones', 18, 329);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (268,'PIT', 'BAL', 'Pittsburgh Steelers', 'Baltimore Ravens', 16, 13, 'Diontae Johnson', 'Devin Duvernay', 'Kenny Pickett', 18, 259);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (269,'BUF', 'NYJ', 'Buffalo Bills', 'New York Jets', 27, 10, 'Tanner Gentry', 'John Brown', 'Josh Allen', 18, 142);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (270,'SEA', 'AZ', 'Seattle Seahawks', 'Arizona Cardinals', 38, 30, 'Noah Fant', 'TySon Williams', 'Geno Smith', 18, 177);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (271,'SF', 'LAR', 'San Francisco 49ers', 'Los Angeles Rams', 27, 24, 'Christian McCaffrey', 'Brycen Hopkins', 'Jimmy Garoppolo', 18, 319);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (272,'LV', 'LAC', 'Las Vegas Raiders', 'Los Angeles Chargers', 35, 32, 'Austin Ekeler', 'Hunter Renfrow', 'Justin Herbert', 18, 327);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (273,'CIN', 'LV', 'Cincinnati Bengals', 'Las Vegas Raiders', 26, 19, 'DJ Turner', 'Mack Hollins', 'Joe Burrow', 19, 280);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (274,'BUF', 'NE', 'Buffalo Bills', 'New England Patriots', 47, 17, 'Nyheim Hines', 'Tyquan Thornton', 'Josh Allen', 19, 313);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (275,'TB', 'PHI', 'Tampa Bay Buccaneers', 'Philadelphia Eagles', 31, 15, 'Quez Watkins', 'Grant Calcaterra', 'Tom Brady', 19, 190);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (276,'SF', 'DAL', 'San Francisco 49ers', 'Dallas Cowboys', 23, 17, 'Dennis Houston', 'Noah Brown', 'Dak Prescott', 19, 167);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (277,'KC', 'PIT', 'Kansas City Chiefs', 'Pittsburgh Steelers', 42, 21, 'Justin Watson', 'Blake Bell', 'Patrick Mahomes', 19, 120);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (278,'LAR', 'AZ', 'Los Angeles Rams', 'Arizona Cardinals', 34, 11, 'Corey Clement', 'Tyler Higbee', 'Baker Mayfield', 19, 290);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (279,'CIN', 'TEN', 'Cincinnati Bengals', 'Tennessee Titans', 19, 16, 'Jamarr Chase', 'Treylon Burks', 'Joe Burrow', 20, 280);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (280,'SF', 'GB', 'San Francisco 49ers', 'Green Bay Packers', 13, 10, 'Jordan Mason', 'Ross Dwelley', 'Aaron Rodgers', 20, 310);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (281,'LAR', 'TB', 'Los Angeles Rams', 'Tampa Bay Buccaneers', 30, 27, 'Lance McCutcheon', 'Tyler Higbee', 'Tom Brady', 20, 154);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (282,'KC', 'BUF', 'Kansas City Chiefs', 'Buffalo Bills', 42, 36, 'Mecole Hardman', 'Isiah Pacheco', 'Patrick Mahomes', 20, 245);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (283,'CIN', 'KC', 'Cincinnati Bengals', 'Kansas City Chiefs', 27, 24, 'Mitchell Wilcox', 'Isiah Pacheco', 'Patrick Mahomes', 21, 150);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (284,'LAR', 'SF', 'Los Angeles Rams', 'San Francisco 49ers', 20, 17, 'Kyren Williams', 'Cam Akers', 'Jimmy Garoppolo', 21, 340);											
INSERT INTO Game (game_id, home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES (285,'LAR', 'CIN', 'Los Angeles Rams', 'Cincinnati Bengals', 23, 20, 'Cam Akers', 'Jacob Harris', 'Joe Burrow', 22, 191);											


INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',1);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',1);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',2);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',2);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',3);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',3);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',4);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',4);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',5);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',5);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',6);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',6);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',7);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',7);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',8);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',8);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',9);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',9);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',10);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',10);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',11);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',11);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',12);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',12);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',13);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',13);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',14);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',14);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',15);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',15);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',16);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',16);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',17);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',17);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',18);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',18);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',19);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',19);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',20);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',20);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',21);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',21);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',22);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',22);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',23);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',23);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',24);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',24);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',25);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',25);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',26);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',26);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',27);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',27);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',28);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',28);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',29);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',29);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',30);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',30);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',31);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',31);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',32);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',32);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',33);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',33);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',34);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',34);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',35);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',35);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',36);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',36);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',37);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',37);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',38);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',38);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',39);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',39);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',40);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',40);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',41);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',41);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',42);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',42);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',43);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',43);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',44);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',44);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',45);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',45);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',46);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',46);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',47);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',47);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',48);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',48);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',49);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',49);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',50);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',50);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',51);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',51);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',52);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',52);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',53);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',53);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',54);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',54);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',55);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',55);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',56);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',56);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',57);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',57);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',58);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',58);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',59);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',59);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',60);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',60);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',61);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',61);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',62);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',62);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',63);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',63);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',64);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',64);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',65);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',65);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',66);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',66);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',67);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',67);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',68);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',68);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',69);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',69);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',70);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',70);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',71);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',71);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',72);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',72);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',73);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',73);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',74);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',74);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',75);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',75);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',76);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',76);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',77);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',77);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',78);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',78);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',79);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',79);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',80);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',80);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',81);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',81);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',82);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',82);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',83);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',83);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',84);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',84);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',85);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',85);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',86);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',86);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',87);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',87);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',88);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',88);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',89);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',89);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',90);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',90);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',91);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',91);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',92);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',92);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',93);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',93);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',94);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',94);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',95);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',95);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',96);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',96);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',97);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',97);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',98);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',98);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',99);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',99);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',100);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',100);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',101);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',101);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',102);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',102);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',103);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',103);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',104);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',104);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',105);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',105);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',106);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',106);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',107);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',107);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',108);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',108);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',109);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',109);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',110);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',110);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',111);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',111);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',112);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',112);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',113);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',113);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',114);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',114);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',115);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',115);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',116);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',116);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',117);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',117);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',118);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',118);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',119);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',119);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',120);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',120);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',121);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',121);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',122);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',122);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',123);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',123);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',124);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',124);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',125);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',125);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',126);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',126);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',127);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',127);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',128);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',128);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',129);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',129);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',130);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',130);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',131);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',131);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',132);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',132);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',133);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',133);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',134);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',134);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',135);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',135);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',136);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',136);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',137);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',137);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',138);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',138);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',139);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',139);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',140);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',140);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',141);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',141);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',142);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',142);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',143);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',143);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',144);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',144);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',145);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',145);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',146);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',146);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',147);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',147);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',148);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',148);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',149);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',149);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',150);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',150);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',151);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',151);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',152);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',152);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',153);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',153);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',154);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',154);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',155);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',155);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',156);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',156);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',157);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',157);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',158);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',158);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',159);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',159);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',160);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',160);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',161);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',161);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',162);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',162);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',163);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',163);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',164);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',164);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',165);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',165);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',166);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',166);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',167);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',167);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',168);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',168);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',169);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',169);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',170);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',170);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',171);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',171);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',172);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',172);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',173);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',173);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',174);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',174);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',175);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',175);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',176);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',176);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',177);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',177);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',178);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',178);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',179);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',179);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',180);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',180);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',181);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',181);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',182);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',182);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',183);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',183);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',184);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',184);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',185);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',185);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',186);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',186);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',187);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',187);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',188);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',188);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',189);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',189);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',190);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',190);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',191);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',191);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',192);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',192);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',193);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',193);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',194);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',194);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',195);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',195);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',196);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',196);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',197);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',197);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',198);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',198);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',199);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',199);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',200);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',200);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',201);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',201);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',202);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',202);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',203);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',203);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',204);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',204);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',205);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',205);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',206);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',206);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',207);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',207);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',208);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',208);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',209);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',209);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',210);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',210);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',211);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',211);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',212);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',212);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',213);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',213);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',214);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',214);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',215);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',215);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',216);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',216);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',217);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',217);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',218);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',218);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',219);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',219);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',220);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',220);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',221);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',221);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',222);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',222);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',223);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',223);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',224);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',224);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',225);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',225);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',226);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',226);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',227);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',227);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',228);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',228);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',229);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',229);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',230);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',230);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',231);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',231);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',232);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',232);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',233);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',233);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',234);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',234);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',235);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',235);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',236);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',236);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',237);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',237);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',238);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',238);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',239);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',239);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',240);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',240);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',241);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',241);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',242);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',242);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',243);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',243);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',244);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',244);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',245);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',245);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',246);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',246);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',247);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',247);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',248);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',248);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',249);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',249);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',250);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',250);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',251);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',251);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',252);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',252);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',253);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',253);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',254);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',254);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',255);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',255);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',256);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',256);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DEN',257);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',257);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',258);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',258);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('ATL',259);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NO',259);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CAR',260);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',260);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CHI',261);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIN',261);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',262);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CLE',262);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('IND',263);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('JAC',263);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DET',264);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',264);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('HOU',265);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',265);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('MIA',266);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',266);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYG',267);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('WAS',267);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BAL',268);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',268);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',269);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NYJ',269);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',270);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SEA',270);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',271);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',271);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',272);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAC',272);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',273);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LV',273);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',274);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('NE',274);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PHI',275);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',275);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('DAL',276);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',276);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',277);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('PIT',277);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('AZ',278);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',278);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',279);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TEN',279);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('GB',280);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',280);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',281);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('TB',281);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('BUF',282);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',282);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',283);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('KC',283);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',284);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('SF',284);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('CIN',285);
INSERT INTO Team_Game (team_abbr, game_id) VALUES ('LAR',285);


INSERT INTO Game_Highlight (game_id, link, description) VALUES (1, 'http://indiatimes.com/id/sapien.xml', 'Highlights from Tampa Bay Buccaneers vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (2, 'https://auda.org.au/erat/eros/viverra/eget.js', 'Highlights from Philadelphia Eagles vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (3, 'https://digg.com/in.aspx', 'Highlights from Pittsburgh Steelers vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (4, 'http://zimbio.com/mattis/nibh/ligula/nec/sem/duis/aliquam.js', 'Highlights from Carolina Panthers vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (5, 'http://dion.ne.jp/vestibulum/ante/ipsum/primis.xml', 'Highlights from Cincinnati Bengals vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (6, 'http://over-blog.com/consequat/ut/nulla/sed/accumsan/felis.json', 'Highlights from Seattle Seahawks vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (7, 'http://exblog.jp/penatibus/et/magnis/dis/parturient/montes.jpg', 'Highlights from Arizona Cardinals vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (8, 'https://usda.gov/aenean/fermentum/donec/ut.js', 'Highlights from San Francisco 49ers vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (9, 'https://e-recht24.de/aliquet/ultrices/erat/tortor/sollicitudin/mi.jsp', 'Highlights from Houston Texans vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (10, 'http://exblog.jp/sit/amet/nulla/quisque.jsp', 'Highlights from Los Angeles Chargers vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (11, 'http://slashdot.org/molestie/nibh/in.png', 'Highlights from Kansas City Chiefs vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (12, 'https://columbia.edu/interdum/eu/tincidunt/in/leo/maecenas/pulvinar.json', 'Highlights from Denver Broncos vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (13, 'https://google.cn/consequat/ut/nulla/sed/accumsan.aspx', 'Highlights from New Orleans Saints vs. Green Bay Packers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (14, 'https://nymag.com/tellus/nulla/ut/erat/id/mauris/vulputate.aspx', 'Highlights from Miami Dolphins vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (15, 'http://huffingtonpost.com/in/hac/habitasse.jpg', 'Highlights from Los Angeles Rams vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (16, 'https://scientificamerican.com/rutrum/ac/lobortis/vel/dapibus.html', 'Highlights from Las Vegas Raiders vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (17, 'http://cnbc.com/sed/ante.json', 'Highlights from Washington Football Team vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (18, 'https://diigo.com/a/feugiat/et.json', 'Highlights from Buffalo Bills vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (19, 'http://ezinearticles.com/vivamus/vel/nulla/eget/eros/elementum.aspx', 'Highlights from Carolina Panthers vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (20, 'http://simplemachines.org/id.png', 'Highlights from Chicago Bears vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (21, 'http://hatena.ne.jp/luctus/et/ultrices.png', 'Highlights from Cleveland Browns vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (22, 'http://lycos.com/ut/erat/id/mauris/vulputate/elementum.jpg', 'Highlights from Los Angeles Rams vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (23, 'https://mozilla.com/dictumst.xml', 'Highlights from Denver Broncos vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (24, 'https://printfriendly.com/eget/vulputate/ut.png', 'Highlights from New England Patriots vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (25, 'https://shop-pro.jp/rhoncus/dui/vel/sem/sed.jsp', 'Highlights from San Francisco 49ers vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (26, 'http://whitehouse.gov/cras/in/purus/eu.aspx', 'Highlights from Las Vegas Raiders vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (27, 'https://craigslist.org/semper/sapien/a/libero/nam/dui.aspx', 'Highlights from Tampa Bay Buccaneers vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (28, 'https://i2i.jp/in/purus/eu/magna/vulputate/luctus.json', 'Highlights from Arizona Cardinals vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (29, 'https://purevolume.com/neque/sapien/placerat/ante/nulla.json', 'Highlights from Dallas Cowboys vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (30, 'https://dot.gov/maecenas/tristique.xml', 'Highlights from Tennessee Titans vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (31, 'https://unicef.org/odio/cras/mi.xml', 'Highlights from Baltimore Ravens vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (32, 'http://icq.com/quis/orci/eget/orci/vehicula/condimentum.png', 'Highlights from Green Bay Packers vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (33, 'http://bloglovin.com/ante/nulla/justo.png', 'Highlights from Carolina Panthers vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (34, 'https://noaa.gov/condimentum.json', 'Highlights from Atlanta Falcons vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (35, 'https://ifeng.com/integer/non/velit/donec/diam.aspx', 'Highlights from Buffalo Bills vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (36, 'https://walmart.com/tempus/vivamus/in/felis/eu/sapien.png', 'Highlights from Cleveland Browns vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (37, 'http://google.ru/enim/in/tempor/turpis/nec/euismod.jsp', 'Highlights from Cincinnati Bengals vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (38, 'http://oakley.com/felis/fusce/posuere.jsp', 'Highlights from Tennessee Titans vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (39, 'http://dot.gov/pretium/iaculis/justo/in/hac.aspx', 'Highlights from Arizona Cardinals vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (40, 'http://aol.com/amet/consectetuer/adipiscing/elit.js', 'Highlights from Baltimore Ravens vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (41, 'https://springer.com/congue/etiam/justo/etiam/pretium/iaculis.js', 'Highlights from Los Angeles Chargers vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (42, 'https://seesaa.net/at/nulla.html', 'Highlights from New Orleans Saints vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (43, 'http://zimbio.com/metus/sapien/ut/nunc/vestibulum/ante/ipsum.jsp', 'Highlights from Denver Broncos vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (44, 'https://youtu.be/sem/mauris.html', 'Highlights from Las Vegas Raiders vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (45, 'https://state.gov/tristique/in/tempus/sit/amet/sem/fusce.jpg', 'Highlights from Minnesota Vikings vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (46, 'http://zimbio.com/nulla/nunc/purus/phasellus/in/felis.jsp', 'Highlights from Los Angeles Rams vs. Tampa Bay Buccaneers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (47, 'https://cyberchimps.com/eros/suspendisse.aspx', 'Highlights from Green Bay Packers vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (48, 'https://house.gov/molestie.js', 'Highlights from Dallas Cowboys vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (49, 'https://surveymonkey.com/dapibus/augue.jsp', 'Highlights from Cincinnati Bengals vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (50, 'http://ebay.com/mattis/odio/donec/vitae/nisi/nam.png', 'Highlights from Washington Football Team vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (51, 'https://ehow.com/natoque/penatibus/et.html', 'Highlights from Buffalo Bills vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (52, 'http://cafepress.com/molestie/nibh/in/lectus/pellentesque/at/nulla.js', 'Highlights from Dallas Cowboys vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (53, 'https://delicious.com/imperdiet/et/commodo.html', 'Highlights from Chicago Bears vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (54, 'https://rambler.ru/vestibulum/quam/sapien/varius/ut.jpg', 'Highlights from Cleveland Browns vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (55, 'https://photobucket.com/non/quam/nec/dui/luctus.aspx', 'Highlights from Indianapolis Colts vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (56, 'http://blogspot.com/lorem/ipsum/dolor/sit/amet/consectetuer.aspx', 'Highlights from Kansas City Chiefs vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (57, 'http://wp.com/odio/consequat/varius/integer/ac.jpg', 'Highlights from New York Giants vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (58, 'http://meetup.com/faucibus/orci.jsp', 'Highlights from New York Jets vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (59, 'http://tinyurl.com/eros/elementum/pellentesque/quisque.xml', 'Highlights from Arizona Cardinals vs. Los Angeles Rams');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (60, 'http://prnewswire.com/luctus/et/ultrices/posuere/cubilia.aspx', 'Highlights from Seattle Seahawks vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (61, 'https://tinypic.com/posuere.js', 'Highlights from Baltimore Ravens vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (62, 'http://tripadvisor.com/nunc/proin/at/turpis.js', 'Highlights from Green Bay Packers vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (63, 'https://ehow.com/sapien/urna/pretium/nisl.js', 'Highlights from Tampa Bay Buccaneers vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (64, 'https://usatoday.com/tellus/semper/interdum/mauris/ullamcorper.jpg', 'Highlights from Los Angeles Chargers vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (65, 'http://unc.edu/quam/fringilla/rhoncus/mauris/enim/leo.json', 'Highlights from Los Angeles Rams vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (66, 'https://jugem.jp/nonummy/integer/non/velit.jsp', 'Highlights from Atlanta Falcons vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (67, 'https://storify.com/id/ligula/suspendisse/ornare.json', 'Highlights from Philadelphia Eagles vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (68, 'https://nydailynews.com/sed.html', 'Highlights from Green Bay Packers vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (69, 'http://wired.com/imperdiet/nullam/orci/pede/venenatis/non/sodales.js', 'Highlights from Pittsburgh Steelers vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (70, 'https://rediff.com/arcu/sed/augue/aliquam/erat/volutpat.xml', 'Highlights from Minnesota Vikings vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (71, 'http://toplist.cz/eget/massa/tempor.png', 'Highlights from New England Patriots vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (72, 'https://microsoft.com/nisi/vulputate/nonummy/maecenas.html', 'Highlights from Tennessee Titans vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (73, 'http://nifty.com/integer/tincidunt/ante/vel/ipsum/praesent/blandit.aspx', 'Highlights from Tampa Bay Buccaneers vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (74, 'https://linkedin.com/eget/tempus/vel.xml', 'Highlights from New Orleans Saints vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (75, 'http://surveymonkey.com/viverra/pede/ac/diam/cras/pellentesque/volutpat.aspx', 'Highlights from Chicago Bears vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (76, 'https://elegantthemes.com/nunc/viverra/dapibus.png', 'Highlights from Los Angeles Chargers vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (77, 'https://marriott.com/non/mauris/morbi/non/lectus/aliquam/sit.jpg', 'Highlights from Arizona Cardinals vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (78, 'https://usa.gov/nisl/nunc.png', 'Highlights from Dallas Cowboys vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (79, 'https://biglobe.ne.jp/et/tempus/semper/est/quam.html', 'Highlights from Buffalo Bills vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (80, 'http://webs.com/a/pede/posuere.png', 'Highlights from Baltimore Ravens vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (81, 'http://economist.com/eu/mi/nulla.xml', 'Highlights from Tampa Bay Buccaneers vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (82, 'https://walmart.com/odio/elementum/eu/interdum/eu/tincidunt/in.json', 'Highlights from Jacksonville Jaguars vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (83, 'https://flavors.me/nam/ultrices/libero/non/mattis/pulvinar.jsp', 'Highlights from Minnesota Vikings vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (84, 'http://cyberchimps.com/sapien/arcu/sed.jpg', 'Highlights from Green Bay Packers vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (85, 'http://google.ru/vestibulum/aliquet/ultrices/erat/tortor/sollicitudin/mi.xml', 'Highlights from Cincinnati Bengals vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (86, 'https://telegraph.co.uk/pharetra/magna.jpg', 'Highlights from Indianapolis Colts vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (87, 'https://issuu.com/gravida/nisi/at/nibh.json', 'Highlights from Kansas City Chiefs vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (88, 'http://sciencedaily.com/in/eleifend/quam/a.png', 'Highlights from Los Angeles Rams vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (89, 'https://about.me/ipsum/praesent/blandit/lacinia/erat.html', 'Highlights from Baltimore Ravens vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (90, 'http://examiner.com/ut/erat/curabitur.xml', 'Highlights from Arizona Cardinals vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (91, 'https://ow.ly/libero/convallis/eget/eleifend/luctus/ultricies.jsp', 'Highlights from Dallas Cowboys vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (92, 'https://indiatimes.com/lacus/curabitur/at/ipsum/ac.xml', 'Highlights from Las Vegas Raiders vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (93, 'https://wsj.com/lacus/purus/aliquet/at/feugiat/non.aspx', 'Highlights from Pittsburgh Steelers vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (94, 'http://taobao.com/posuere/cubilia/curae/nulla/dapibus.jsp', 'Highlights from Tennessee Titans vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (95, 'https://mediafire.com/mauris/laoreet/ut.js', 'Highlights from Cleveland Browns vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (96, 'https://drupal.org/vivamus/vestibulum/sagittis.xml', 'Highlights from Atlanta Falcons vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (97, 'http://360.cn/ultrices/libero/non/mattis/pulvinar.jpg', 'Highlights from New York Giants vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (98, 'http://prnewswire.com/quis/lectus/suspendisse/potenti/in.js', 'Highlights from Cincinnati Bengals vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (99, 'http://miibeian.gov.cn/magna/at/nunc.xml', 'Highlights from Green Bay Packers vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (100, 'https://ftc.gov/pede/venenatis/non/sodales/sed/tincidunt/eu.png', 'Highlights from Tennessee Titans vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (101, 'http://ifeng.com/ultrices/posuere/cubilia/curae/donec/pharetra.png', 'Highlights from New England Patriots vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (102, 'http://booking.com/ornare/consequat/lectus.js', 'Highlights from Los Angeles Rams vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (103, 'https://nationalgeographic.com/nisl.jsp', 'Highlights from Las Vegas Raiders vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (104, 'http://nps.gov/pretium/nisl.jsp', 'Highlights from Tampa Bay Buccaneers vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (105, 'http://xrea.com/fusce.js', 'Highlights from Arizona Cardinals vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (106, 'https://google.com.br/sed/interdum/venenatis/turpis/enim/blandit.xml', 'Highlights from Indianapolis Colts vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (107, 'https://lulu.com/sapien.js', 'Highlights from New Orleans Saints vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (108, 'http://fastcompany.com/interdum.jpg', 'Highlights from Green Bay Packers vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (109, 'https://cdc.gov/quam.html', 'Highlights from Carolina Panthers vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (110, 'https://goodreads.com/a/nibh/in/quis/justo/maecenas.aspx', 'Highlights from Buffalo Bills vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (111, 'http://cam.ac.uk/cras.json', 'Highlights from San Francisco 49ers vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (112, 'http://umn.edu/cubilia/curae.html', 'Highlights from New York Jets vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (113, 'http://topsy.com/fusce/congue/diam/id.jsp', 'Highlights from Pittsburgh Steelers vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (114, 'https://wired.com/pharetra/magna/vestibulum/aliquet/ultrices/erat.jsp', 'Highlights from Tennessee Titans vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (115, 'http://edublogs.org/curae/donec/pharetra/magna/vestibulum.html', 'Highlights from Philadelphia Eagles vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (116, 'http://elegantthemes.com/a/ipsum.aspx', 'Highlights from Los Angeles Rams vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (117, 'http://fema.gov/venenatis/tristique/fusce/congue/diam.aspx', 'Highlights from Seattle Seahawks vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (118, 'https://csmonitor.com/in/hac/habitasse/platea.png', 'Highlights from New England Patriots vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (119, 'http://china.com.cn/quis/justo.png', 'Highlights from New Orleans Saints vs. Tampa Bay Buccaneers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (120, 'https://examiner.com/amet/consectetuer/adipiscing/elit/proin.aspx', 'Highlights from Denver Broncos vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (121, 'https://123-reg.co.uk/magnis/dis/parturient/montes.json', 'Highlights from Dallas Cowboys vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (122, 'https://thetimes.co.uk/ridiculus/mus/vivamus/vestibulum/sagittis/sapien.png', 'Highlights from Kansas City Chiefs vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (123, 'https://yahoo.com/vivamus/tortor/duis/mattis.xml', 'Highlights from Indianapolis Colts vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (124, 'http://theguardian.com/donec.html', 'Highlights from Atlanta Falcons vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (125, 'http://time.com/aliquam/erat/volutpat.aspx', 'Highlights from Jacksonville Jaguars vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (126, 'https://ihg.com/ligula/suspendisse/ornare.json', 'Highlights from Denver Broncos vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (127, 'https://statcounter.com/sem/sed/sagittis/nam/congue/risus.jpg', 'Highlights from Baltimore Ravens vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (128, 'http://harvard.edu/lorem/quisque/ut/erat/curabitur.html', 'Highlights from New England Patriots vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (129, 'http://g.co/et/ultrices/posuere/cubilia/curae/duis/faucibus.json', 'Highlights from Cleveland Browns vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (130, 'http://youku.com/tellus/nisi/eu/orci/mauris/lacinia/sapien.jpg', 'Highlights from Miami Dolphins vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (131, 'https://ed.gov/curae/duis/faucibus/accumsan/odio.js', 'Highlights from New York Giants vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (132, 'https://yellowbook.com/condimentum/neque.js', 'Highlights from Los Angeles Chargers vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (133, 'http://google.pl/eros/vestibulum/ac/est/lacinia.json', 'Highlights from Arizona Cardinals vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (134, 'http://oaic.gov.au/sem.html', 'Highlights from Kansas City Chiefs vs. Green Bay Packers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (135, 'http://trellian.com/non/ligula/pellentesque/ultrices/phasellus/id/sapien.aspx', 'Highlights from Tennessee Titans vs. Los Angeles Rams');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (136, 'http://github.io/tristique/fusce/congue/diam.html', 'Highlights from Pittsburgh Steelers vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (137, 'http://wordpress.com/at/ipsum/ac/tellus.json', 'Highlights from Miami Dolphins vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (138, 'http://yahoo.com/id/mauris/vulputate/elementum/nullam.jpg', 'Highlights from Dallas Cowboys vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (139, 'https://kickstarter.com/viverra.xml', 'Highlights from Buffalo Bills vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (140, 'https://dailymail.co.uk/sollicitudin/ut/suscipit/a/feugiat/et/eros.png', 'Highlights from Pittsburgh Steelers vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (141, 'https://networkadvertising.org/consectetuer/adipiscing/elit/proin/interdum.json', 'Highlights from Tennessee Titans vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (142, 'https://auda.org.au/odio.aspx', 'Highlights from Washington Football Team vs. Tampa Bay Buccaneers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (143, 'https://163.com/dolor/vel.jsp', 'Highlights from New England Patriots vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (144, 'https://va.gov/integer/aliquet/massa.html', 'Highlights from Indianapolis Colts vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (145, 'https://nydailynews.com/amet/cursus.xml', 'Highlights from Minnesota Vikings vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (146, 'http://booking.com/ullamcorper/purus/sit/amet.html', 'Highlights from Carolina Panthers vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (147, 'http://blinklist.com/lacinia/nisi/venenatis/tristique.jsp', 'Highlights from Philadelphia Eagles vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (148, 'https://harvard.edu/pellentesque/eget/nunc/donec/quis/orci.aspx', 'Highlights from Green Bay Packers vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (149, 'https://utexas.edu/suspendisse/accumsan/tortor/quis/turpis/sed.jpg', 'Highlights from Kansas City Chiefs vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (150, 'https://independent.co.uk/donec/diam/neque/vestibulum/eget/vulputate.json', 'Highlights from San Francisco 49ers vs. Los Angeles Rams');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (151, 'http://nbcnews.com/amet/sapien/dignissim/vestibulum.html', 'Highlights from New England Patriots vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (152, 'https://home.pl/donec.aspx', 'Highlights from Indianapolis Colts vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (153, 'http://google.cn/consectetuer.json', 'Highlights from Baltimore Ravens vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (154, 'http://globo.com/dui/vel/nisl/duis/ac/nibh.jpg', 'Highlights from Houston Texans vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (155, 'http://nps.gov/tincidunt/nulla.png', 'Highlights from San Francisco 49ers vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (156, 'http://reverbnation.com/sem/mauris/laoreet/ut/rhoncus/aliquet/pulvinar.jpg', 'Highlights from Philadelphia Eagles vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (157, 'https://netscape.com/eget/vulputate/ut/ultrices/vel/augue/vestibulum.html', 'Highlights from Washington Football Team vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (158, 'http://examiner.com/eu/nibh.xml', 'Highlights from Cleveland Browns vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (159, 'https://weibo.com/ultrices/posuere/cubilia/curae/duis.json', 'Highlights from Minnesota Vikings vs. Green Bay Packers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (160, 'https://dropbox.com/tempus/sit/amet.jpg', 'Highlights from Miami Dolphins vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (161, 'https://feedburner.com/quis/turpis/eget/elit.json', 'Highlights from Cincinnati Bengals vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (162, 'https://mayoclinic.com/in/hac/habitasse/platea/dictumst/morbi/vestibulum.jsp', 'Highlights from Kansas City Chiefs vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (163, 'http://tinypic.com/phasellus/sit/amet/erat.jpg', 'Highlights from Arizona Cardinals vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (164, 'https://studiopress.com/lorem/integer/tincidunt/ante/vel.jpg', 'Highlights from Los Angeles Chargers vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (165, 'https://hud.gov/in/lectus.json', 'Highlights from Tampa Bay Buccaneers vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (166, 'http://fotki.com/eget/massa/tempor/convallis/nulla/neque/libero.js', 'Highlights from Chicago Bears vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (167, 'http://bandcamp.com/nisi/at.aspx', 'Highlights from Las Vegas Raiders vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (168, 'https://microsoft.com/sem/sed/sagittis.html', 'Highlights from Buffalo Bills vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (169, 'http://zdnet.com/metus.aspx', 'Highlights from Atlanta Falcons vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (170, 'http://narod.ru/turpis/integer/aliquet.xml', 'Highlights from Cincinnati Bengals vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (171, 'http://answers.com/dui/vel.aspx', 'Highlights from New York Jets vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (172, 'http://theguardian.com/suspendisse/accumsan/tortor/quis/turpis.json', 'Highlights from New York Giants vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (173, 'http://marriott.com/erat/tortor/sollicitudin/mi/sit/amet.json', 'Highlights from Miami Dolphins vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (174, 'https://technorati.com/eros/viverra/eget/congue/eget.js', 'Highlights from Tampa Bay Buccaneers vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (175, 'http://blog.com/consequat/lectus/in/est/risus/auctor.xml', 'Highlights from New England Patriots vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (176, 'https://weebly.com/pharetra/magna/ac.aspx', 'Highlights from Denver Broncos vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (177, 'https://dailymotion.com/volutpat/convallis.json', 'Highlights from San Francisco 49ers vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (178, 'http://yellowbook.com/risus/dapibus/augue.jsp', 'Highlights from Green Bay Packers vs. Los Angeles Rams');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (179, 'https://google.com.au/quam/pharetra/magna.html', 'Highlights from Baltimore Ravens vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (180, 'http://goo.gl/purus.js', 'Highlights from Washington Football Team vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (181, 'https://over-blog.com/metus/arcu/adipiscing/molestie/hendrerit/at/vulputate.xml', 'Highlights from Dallas Cowboys vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (182, 'http://g.co/turpis.xml', 'Highlights from Tampa Bay Buccaneers vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (183, 'http://mozilla.org/nibh/quisque.png', 'Highlights from Arizona Cardinals vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (184, 'https://virginia.edu/posuere.jpg', 'Highlights from Los Angeles Chargers vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (185, 'https://ed.gov/hendrerit/at/vulputate/vitae/nisl/aenean/lectus.aspx', 'Highlights from Detroit Lions vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (186, 'https://surveymonkey.com/et.js', 'Highlights from Philadelphia Eagles vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (187, 'http://umn.edu/a/feugiat/et/eros/vestibulum.aspx', 'Highlights from Indianapolis Colts vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (188, 'https://tamu.edu/sit.jpg', 'Highlights from Miami Dolphins vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (189, 'http://sbwire.com/sollicitudin/vitae/consectetuer.js', 'Highlights from Seattle Seahawks vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (190, 'http://mozilla.com/commodo/placerat/praesent/blandit/nam/nulla.html', 'Highlights from Washington Football Team vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (191, 'https://timesonline.co.uk/nulla/ac/enim/in/tempor/turpis.aspx', 'Highlights from Los Angeles Rams vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (192, 'https://nps.gov/imperdiet/sapien/urna/pretium/nisl/ut/volutpat.aspx', 'Highlights from Pittsburgh Steelers vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (193, 'https://opensource.org/augue/quam/sollicitudin/vitae/consectetuer.json', 'Highlights from Kansas City Chiefs vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (194, 'http://yahoo.com/vel/accumsan/tellus/nisi.xml', 'Highlights from New England Patriots vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (195, 'http://jigsy.com/eget/orci/vehicula/condimentum/curabitur.html', 'Highlights from Minnesota Vikings vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (196, 'http://si.edu/in/est.jpg', 'Highlights from Atlanta Falcons vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (197, 'http://jimdo.com/congue/etiam.jpg', 'Highlights from San Francisco 49ers vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (198, 'http://canalblog.com/elementum/in.aspx', 'Highlights from Cleveland Browns vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (199, 'http://ftc.gov/non/ligula/pellentesque/ultrices/phasellus/id.xml', 'Highlights from Dallas Cowboys vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (200, 'https://geocities.com/nulla/eget/eros.xml', 'Highlights from Seattle Seahawks vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (201, 'http://aol.com/lacus/at.jsp', 'Highlights from Tennessee Titans vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (202, 'https://nifty.com/ut/massa/quis/augue/luctus/tincidunt/nulla.xml', 'Highlights from Kansas City Chiefs vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (203, 'https://ameblo.jp/turpis/donec.html', 'Highlights from New Orleans Saints vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (204, 'https://webmd.com/mi/integer/ac/neque/duis/bibendum.html', 'Highlights from Denver Broncos vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (205, 'https://ted.com/semper/porta.html', 'Highlights from Los Angeles Chargers vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (206, 'http://patch.com/eu/massa/donec/dapibus/duis/at.xml', 'Highlights from Tampa Bay Buccaneers vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (207, 'https://github.com/hendrerit/at/vulputate/vitae/nisl/aenean.json', 'Highlights from Green Bay Packers vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (208, 'https://noaa.gov/tincidunt/ante/vel.json', 'Highlights from Los Angeles Rams vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (209, 'https://rambler.ru/justo/aliquam/quis/turpis.xml', 'Highlights from Kansas City Chiefs vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (210, 'http://icio.us/vestibulum/velit/id/pretium.aspx', 'Highlights from Indianapolis Colts vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (211, 'https://stumbleupon.com/dui/luctus/rutrum/nulla/tellus/in/sagittis.js', 'Highlights from Buffalo Bills vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (212, 'http://toplist.cz/donec/semper/sapien.aspx', 'Highlights from Detroit Lions vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (213, 'https://dedecms.com/fusce/posuere/felis/sed.xml', 'Highlights from Dallas Cowboys vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (214, 'https://blogspot.com/vitae/nisl.js', 'Highlights from Green Bay Packers vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (215, 'https://cargocollective.com/tincidunt/ante/vel/ipsum/praesent.xml', 'Highlights from Houston Texans vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (216, 'http://yelp.com/volutpat/dui/maecenas/tristique/est/et/tempus.html', 'Highlights from Miami Dolphins vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (217, 'https://reference.com/ipsum/primis/in/faucibus/orci/luctus.html', 'Highlights from Pittsburgh Steelers vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (218, 'http://businesswire.com/accumsan.aspx', 'Highlights from San Francisco 49ers vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (219, 'https://phpbb.com/parturient/montes/nascetur/ridiculus.json', 'Highlights from Cincinnati Bengals vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (220, 'http://arstechnica.com/ligula/vehicula/consequat.aspx', 'Highlights from New Orleans Saints vs. Tampa Bay Buccaneers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (221, 'https://cam.ac.uk/ut.html', 'Highlights from Las Vegas Raiders vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (222, 'https://bigcartel.com/eget.jsp', 'Highlights from Minnesota Vikings vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (223, 'https://reuters.com/fermentum/donec/ut/mauris.html', 'Highlights from Philadelphia Eagles vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (224, 'http://nbcnews.com/aenean/sit/amet/justo.jpg', 'Highlights from Los Angeles Rams vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (225, 'http://imageshack.us/orci/vehicula/condimentum/curabitur/in/libero/ut.jsp', 'Highlights from Tennessee Titans vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (226, 'http://webs.com/volutpat/eleifend.jpg', 'Highlights from Green Bay Packers vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (227, 'https://homestead.com/fusce/lacus.png', 'Highlights from Indianapolis Colts vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (228, 'http://marriott.com/vivamus/metus.jpg', 'Highlights from Atlanta Falcons vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (229, 'https://who.int/in/purus.jpg', 'Highlights from Buffalo Bills vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (230, 'http://squidoo.com/dui.js', 'Highlights from Tampa Bay Buccaneers vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (231, 'http://jigsy.com/eu/est/congue.png', 'Highlights from Cincinnati Bengals vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (232, 'http://canalblog.com/donec/vitae/nisi/nam/ultrices/libero.html', 'Highlights from Houston Texans vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (233, 'http://go.com/non/sodales.jpg', 'Highlights from New York Jets vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (234, 'http://prweb.com/congue/elementum/in.jpg', 'Highlights from Los Angeles Rams vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (235, 'http://samsung.com/in/sapien/iaculis/congue/vivamus/metus.jpg', 'Highlights from Philadelphia Eagles vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (236, 'https://hugedomains.com/non/quam/nec.aspx', 'Highlights from Chicago Bears vs. Seattle Seahawks');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (237, 'https://twitpic.com/suscipit/a/feugiat/et/eros.png', 'Highlights from Las Vegas Raiders vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (238, 'https://pbs.org/ligula/vehicula/consequat/morbi/a/ipsum.jpg', 'Highlights from Kansas City Chiefs vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (239, 'http://purevolume.com/primis/in/faucibus.jpg', 'Highlights from Dallas Cowboys vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (240, 'http://bigcartel.com/quis/justo/maecenas/rhoncus.jpg', 'Highlights from Miami Dolphins vs. New Orleans Saints');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (241, 'http://list-manage.com/sit.json', 'Highlights from Buffalo Bills vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (242, 'https://creativecommons.org/ac/neque/duis/bibendum/morbi.png', 'Highlights from New Orleans Saints vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (243, 'https://youtu.be/accumsan/felis/ut/at.xml', 'Highlights from Chicago Bears vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (244, 'http://odnoklassniki.ru/elit/ac/nulla/sed/vel/enim/sit.xml', 'Highlights from Cincinnati Bengals vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (245, 'https://fema.gov/vestibulum.json', 'Highlights from Las Vegas Raiders vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (246, 'http://google.fr/bibendum/morbi/non.jpg', 'Highlights from Arizona Cardinals vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (247, 'https://booking.com/dolor.json', 'Highlights from New England Patriots vs. Jacksonville Jaguars');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (248, 'https://fotki.com/aliquet/pulvinar/sed.js', 'Highlights from Tennessee Titans vs. Miami Dolphins');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (249, 'http://pcworld.com/ac/est/lacinia/nisi/venenatis/tristique/fusce.js', 'Highlights from Tampa Bay Buccaneers vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (250, 'https://joomla.org/auctor/sed/tristique/in.json', 'Highlights from Philadelphia Eagles vs. Washington Football Team');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (251, 'https://drupal.org/tortor/id/nulla.js', 'Highlights from Los Angeles Chargers vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (252, 'http://networkadvertising.org/orci/vehicula/condimentum/curabitur/in.jsp', 'Highlights from San Francisco 49ers vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (253, 'https://ifeng.com/ullamcorper/augue/a/suscipit/nulla.jsp', 'Highlights from Seattle Seahawks vs. Detroit Lions');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (254, 'https://is.gd/orci/luctus.html', 'Highlights from Los Angeles Rams vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (255, 'http://biblegateway.com/justo/morbi/ut.jsp', 'Highlights from Green Bay Packers vs. Minnesota Vikings');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (256, 'https://deliciousdays.com/duis/consequat/dui.xml', 'Highlights from Pittsburgh Steelers vs. Cleveland Browns');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (257, 'https://wikispaces.com/magnis.json', 'Highlights from Kansas City Chiefs vs. Denver Broncos');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (258, 'https://studiopress.com/justo/etiam/pretium/iaculis/justo.json', 'Highlights from Dallas Cowboys vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (259, 'https://etsy.com/et/magnis/dis.html', 'Highlights from New Orleans Saints vs. Atlanta Falcons');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (260, 'https://tiny.cc/ut/nunc/vestibulum/ante/ipsum/primis.jpg', 'Highlights from Tampa Bay Buccaneers vs. Carolina Panthers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (261, 'http://virginia.edu/vitae.js', 'Highlights from Minnesota Vikings vs. Chicago Bears');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (262, 'http://themeforest.net/magnis/dis/parturient/montes.html', 'Highlights from Cleveland Browns vs. Cincinnati Bengals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (263, 'http://devhub.com/viverra/eget/congue/eget.aspx', 'Highlights from Jacksonville Jaguars vs. Indianapolis Colts');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (264, 'http://wisc.edu/mi/integer/ac/neque/duis/bibendum/morbi.html', 'Highlights from Detroit Lions vs. Green Bay Packers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (265, 'https://toplist.cz/et/magnis/dis/parturient/montes/nascetur/ridiculus.xml', 'Highlights from Tennessee Titans vs. Houston Texans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (266, 'http://youtube.com/ligula/nec/sem/duis/aliquam/convallis/nunc.aspx', 'Highlights from Miami Dolphins vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (267, 'http://wix.com/in/congue/etiam/justo.aspx', 'Highlights from Washington Football Team vs. New York Giants');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (268, 'https://myspace.com/vivamus/vestibulum/sagittis/sapien/cum/sociis.jsp', 'Highlights from Pittsburgh Steelers vs. Baltimore Ravens');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (269, 'https://geocities.com/aliquam/lacus/morbi.js', 'Highlights from Buffalo Bills vs. New York Jets');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (270, 'http://themeforest.net/luctus/cum/sociis/natoque/penatibus/et.js', 'Highlights from Seattle Seahawks vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (271, 'http://baidu.com/mattis/pulvinar/nulla/pede/ullamcorper.png', 'Highlights from San Francisco 49ers vs. Los Angeles Rams');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (272, 'https://instagram.com/dui/luctus/rutrum/nulla/tellus/in/sagittis.xml', 'Highlights from Las Vegas Raiders vs. Los Angeles Chargers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (273, 'http://umn.edu/vivamus/metus.jsp', 'Highlights from Cincinnati Bengals vs. Las Vegas Raiders');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (274, 'http://prlog.org/condimentum/curabitur.html', 'Highlights from Buffalo Bills vs. New England Patriots');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (275, 'http://edublogs.org/mattis/pulvinar/nulla/pede/ullamcorper/augue/a.jsp', 'Highlights from Tampa Bay Buccaneers vs. Philadelphia Eagles');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (276, 'https://archive.org/ultricies/eu/nibh.jpg', 'Highlights from San Francisco 49ers vs. Dallas Cowboys');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (277, 'https://dedecms.com/velit/vivamus/vel/nulla/eget/eros/elementum.aspx', 'Highlights from Kansas City Chiefs vs. Pittsburgh Steelers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (278, 'http://fastcompany.com/amet.aspx', 'Highlights from Los Angeles Rams vs. Arizona Cardinals');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (279, 'http://xing.com/metus.js', 'Highlights from Cincinnati Bengals vs. Tennessee Titans');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (280, 'https://ftc.gov/elementum/ligula.html', 'Highlights from San Francisco 49ers vs. Green Bay Packers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (281, 'http://ftc.gov/massa/quis/augue/luctus/tincidunt/nulla.html', 'Highlights from Los Angeles Rams vs. Tampa Bay Buccaneers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (282, 'http://rakuten.co.jp/donec/odio/justo/sollicitudin/ut/suscipit/a.png', 'Highlights from Kansas City Chiefs vs. Buffalo Bills');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (283, 'http://people.com.cn/convallis/nulla/neque/libero/convallis/eget/eleifend.json', 'Highlights from Cincinnati Bengals vs. Kansas City Chiefs');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (284, 'http://tripod.com/velit/eu/est/congue/elementum/in.png', 'Highlights from Los Angeles Rams vs. San Francisco 49ers');																					
INSERT INTO Game_Highlight (game_id, link, description) VALUES (285, 'http://intel.com/vel.jsp', 'Highlights from Los Angeles Rams vs. Cincinnati Bengals');																					


INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (1,'CeeDee Lamb makes a catch for a gain of 78 yards','04:26',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (1,'Tom Brady scrambles for a gain of 38 yards','14:02',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (1,'Cade Otton makes a catch for a gain of 45 yards','13:33',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (1,'Giovani Bernard rushes for a gain of 74 yards','01:37',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (1,'T.Y. Hilton makes a catch for a gain of 35 yards','03:47',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (2,'Parker Hesse makes a catch for a gain of 87 yards','06:36',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (2,'Zach Pascal makes a catch for a loss of 5 yards','13:52',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (2,'Boston Scott rushes for a gain of 40 yards','01:50',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (2,'Zach Pascal makes a catch for a gain of 33 yards','06:45',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (2,'Kyle Pitts makes a catch for a gain of 42 yards','01:06',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (3,'Isaiah Hodgins makes a catch for a gain of 14 yards','14:20',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (3,'Quintin Morris makes a catch for a gain of 69 yards','11:03',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (3,'Josh Allen scrambles for a gain of 31 yards','04:16',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (3,'Dawson Knox makes a catch for a gain of 37 yards','02:19',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (3,'Kenny Pickett scrambles for a gain of 12 yards','11:58',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (4,'Tommy Tremble makes a catch for a gain of 5 yards','14:44',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (4,'James Robinson rushes for a gain of 41 yards','13:37',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (4,'Garrett Wilson makes a catch for a gain of 85 yards','00:13',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (4,'Corey Davis makes a catch for a gain of 16 yards','07:30',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (4,'Ian Thomas makes a catch for a loss of 4 yards','09:37',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (5,'JaMarr Chase makes a catch for a gain of 35 yards','03:13',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (5,'Samaje Perine rushes for a gain of 70 yards','06:07',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (5,'Kirk Cousins throws a pass for a gain of 47 yards','07:54',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (5,'Alexander Mattison rushes for a gain of 20 yards','13:52',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (5,'Hayden Hurst makes a catch for a gain of 3 yards','01:28',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (6,'Zack Moss rushes for a gain of 9 yards','14:05',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (6,'Marquise Goodwin makes a catch for a gain of 10 yards','01:35',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (6,'Godwin Igwebuike rushes for a gain of 72 yards','06:13',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (6,'Michael Dickson plays for a gain of 61 yards','09:08',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (6,'Geno Smith throws a pass for a gain of 41 yards','05:45',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (7,'Geoff Swaim makes a catch for a gain of 88 yards','02:48',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (7,'Malik Willis throws a pass for a loss of 3 yards','12:08',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (7,'Trey McBride makes a catch for a gain of 11 yards','06:38',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (7,'Corey Clement rushes for a gain of 83 yards','00:03',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (7,'Rondale Moore makes a catch for a gain of 70 yards','01:10',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (8,'James Mitchell makes a catch for a gain of 28 yards','12:49',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (8,'DJ Chark makes a catch for a gain of 69 yards','09:10',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (8,'Deebo Samuel makes a catch for a gain of 9 yards','14:13',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (8,'Shane Zylstra makes a catch for a gain of 48 yards','09:09',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (8,'Jordan Mason rushes for a gain of 36 yards','04:13',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (9,'James Robinson rushes for a gain of 3 yards','05:53',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (9,'Jamal Agnew makes a catch for a gain of 30 yards','07:53',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (9,'Evan Engram makes a catch for a gain of 53 yards','07:51',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (9,'Troy Hairston plays for a gain of 3 yards','10:38',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (9,'Marvin Jones makes a catch for a loss of 10 yards','00:13',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (10,'Larry Rountree rushes for a gain of 31 yards','01:35',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (10,'DeAndre Carter makes a catch for a gain of 16 yards','05:35',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (10,'Dax Milne makes a catch for a gain of 10 yards','04:38',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (10,'Sony Michel rushes for a gain of 9 yards','00:04',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (10,'Austin Ekeler rushes for a gain of 33 yards','13:10',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (11,'Jerick McKinnon rushes for a gain of 18 yards','13:48',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (11,'Demetric Felton rushes for a gain of 24 yards','07:01',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (11,'Jacoby Brissett scrambles for a gain of 84 yards','06:52',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (11,'Jerick McKinnon rushes for a gain of 47 yards','06:45',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (11,'Noah Gray makes a catch for a touchdown','04:17',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (12,'Brandon Johnson makes a catch for a gain of 32 yards','13:47',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (12,'Brett Rypien throws a pass for a gain of 35 yards','10:53',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (12,'Darius Slayton makes a catch for a gain of 54 yards','09:55',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (12,'Lawrence Cager makes a catch for a gain of 51 yards','01:58',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (12,'Chris Myarick plays for a loss of 4 yards','00:45',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (13,'Romeo Doubs makes a catch for a gain of 5 yards','07:01',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (13,'Juwann Winfree makes a catch for a gain of 7 yards','12:22',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (13,'Randall Cobb makes a catch for a loss of 7 yards','14:29',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (13,'Christian Watson makes a catch for a gain of 21 yards','04:57',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (13,'Nick Vannett makes a catch for a gain of 3 yards','08:49',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (14,'Marcus Jones plays for a gain of 27 yards','00:51',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (14,'Salvon Ahmed rushes for a gain of 51 yards','09:33',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (14,'Trent Sherfield makes a catch for a gain of 25 yards','04:26',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (14,'Pierre Strong rushes for a loss of 3 yards','00:21',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (14,'DeVante Parker makes a catch for a gain of 27 yards','04:43',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Brandon Powell makes a catch for a gain of 19 yards','01:15',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Lance McCutcheon makes a catch for a gain of 16 yards','06:26',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Austin Trammell makes a catch for a loss of 9 yards','06:46',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Equanimeous St. Brown makes a catch for a gain of 8 yards','05:34',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Cam Akers rushes for a gain of 77 yards','10:33',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (15,'Lance McCutcheon makes a catch for a gain of 69 yards','05:58',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (16,'Kenyan Drake rushes for a gain of 82 yards','09:21',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (16,'Brandon Bolden rushes for a gain of 1 yards','06:34',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (16,'Josh Oliver makes a catch for a loss of 3 yards','03:12',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (17,'Sterling Shepard makes a catch for a gain of 76 yards','04:21',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (17,'David Sills makes a catch for a gain of 5 yards','10:18',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (17,'Sam Howell scrambles for a gain of 68 yards','06:33',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (17,'Carson Wentz scrambles for a gain of 77 yards','10:47',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (17,'Antonio Gibson rushes for a loss of 6 yards','01:26',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (18,'Khalil Shakir makes a catch for a gain of 30 yards','01:15',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (18,'Jamison Crowder makes a catch for a loss of 7 yards','09:02',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (18,'Salvon Ahmed rushes for a gain of 77 yards','13:31',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (18,'James Cook rushes for a gain of 3 yards','10:07',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (18,'Tanner Conner makes a catch for a gain of 55 yards','05:26',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (19,'TreQuan Smith makes a catch for a gain of 12 yards','10:03',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (19,'Stephen Sullivan makes a catch for a gain of 29 yards','14:19',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (19,'Jordan Howard rushes for a loss of 7 yards','12:13',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (19,'Dwayne Washington rushes for a gain of 44 yards','01:32',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (19,'Mark Ingram rushes for a loss of 2 yards','02:34',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (20,'Darrynton Evans rushes for a loss of 10 yards','14:49',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (20,'Dante Pettis makes a catch for a gain of 56 yards','08:10',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (20,'Trayveon Williams rushes for a loss of 6 yards','01:00',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (20,'Tee Higgins makes a catch for a gain of 21 yards','11:52',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (20,'Tyler Boyd makes a catch for a gain of 58 yards','02:34',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (21,'O.J. Howard makes a catch for a gain of 30 yards','10:28',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (21,'Jack Conklin plays for a gain of 13 yards','03:31',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (21,'Troy Hairston plays for a gain of 11 yards','02:35',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (21,'Troy Hairston plays for a gain of 85 yards','00:07',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (21,'Chris Conley makes a catch for a gain of 67 yards','00:21',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (22,'Van Jefferson makes a catch for a gain of 5 yards','08:54',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (22,'Baker Mayfield scrambles for a gain of 79 yards','09:04',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (22,'Jake Gervase plays for a touchdown','12:55',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (22,'Nick Foles throws a pass for a touchdown','04:27',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (22,'Jordan Wilkins rushes for a gain of 90 yards','07:43',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (23,'Eric Saubert makes a catch for a gain of 52 yards','13:51',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (23,'James Robinson rushes for a loss of 10 yards','05:25',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (23,'Jamycal Hasty rushes for a loss of 4 yards','10:47',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (23,'C.J. Beathard throws a pass for a gain of 16 yards','03:15',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (23,'Latavius Murray rushes for a gain of 43 yards','12:51',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (24,'Zach Wilson throws a pass for a gain of 73 yards','12:20',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (24,'Tyquan Thornton makes a catch for a gain of 51 yards','10:41',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (24,'C.J. Uzomah makes a catch for a gain of 64 yards','07:40',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (24,'Ty Montgomery makes a catch for a gain of 27 yards','01:40',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (24,'Lawrence Cager makes a catch for a gain of 89 yards','01:32',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (25,'Josh Johnson throws a pass for a gain of 75 yards','00:31',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (25,'Josh Johnson throws a pass for a gain of 48 yards','04:00',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (25,'Jimmy Garoppolo scrambles for a gain of 30 yards','13:49',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (25,'Charlie Woerner makes a catch for a gain of 8 yards','01:28',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (25,'Jordan Mason rushes for a gain of 27 yards','06:44',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (26,'Jesper Horsted makes a catch for a gain of 6 yards','13:43',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (26,'Mack Hollins makes a catch for a gain of 32 yards','03:28',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (26,'Darren Waller makes a catch for a gain of 46 yards','12:07',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (26,'Pat Freiermuth makes a catch for a gain of 16 yards','12:21',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (26,'Cody White makes a catch for a gain of 78 yards','03:04',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (27,'Anthony Firkser makes a catch for a gain of 8 yards','12:49',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (27,'KeShawn Vaughn rushes for a gain of 85 yards','14:04',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (27,'Scott Miller makes a catch for a gain of 90 yards','12:20',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (27,'Feleipe Franks makes a catch for a loss of 2 yards','10:16',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (27,'Kyle Rudolph makes a catch for a gain of 30 yards','01:32',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (28,'Tyson Williams rushes for a gain of 69 yards','08:38',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (28,'Ty Chandler rushes for a gain of 90 yards','00:34',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (28,'David Blough scrambles for a gain of 10 yards','01:28',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (28,'Rondale Moore makes a catch for a gain of 47 yards','09:10',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (28,'Trace McSorley scrambles for a gain of 52 yards','05:40',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (29,'Peyton Hendershot makes a catch for a gain of 30 yards','01:00',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (29,'Bryan Anger plays for a gain of 81 yards','06:29',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (29,'Donald Parham makes a catch for a touchdown','06:26',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (29,'Jalen Guyton makes a catch for a loss of 3 yards','13:44',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (29,'Jake Ferguson makes a catch for a loss of 2 yards','10:38',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (30,'Treylon Burks makes a catch for a gain of 63 yards','02:53',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (30,'D.K. Metcalf makes a catch for a gain of 20 yards','12:40',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (30,'Chigoziem Okonkwo makes a catch for a gain of 8 yards','12:26',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (30,'Nick Westbrook-Ikhine makes a catch for a gain of 61 yards','14:36',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (30,'Ryan Tannehill throws a pass for a gain of 31 yards','04:42',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (31,'Mecole Hardman makes a catch for a gain of 57 yards','11:20',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (31,'Rashod Bateman makes a catch for a gain of 26 yards','08:42',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (31,'Tylan Wallace makes a catch for a loss of 4 yards','05:39',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (31,'JuJu Smith-Schuster makes a catch for a gain of 70 yards','01:18',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (31,'Jody Fortson makes a catch for a loss of 10 yards','14:48',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (32,'Jason Cabinda plays for a loss of 4 yards','12:35',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (32,'Tom Kennedy makes a catch for a gain of 67 yards','14:01',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (32,'Sammy Watkins makes a catch for a loss of 9 yards','14:48',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (32,'Jamaal Williams rushes for a gain of 51 yards','14:04',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (32,'Jason Cabinda plays for a gain of 65 yards','04:54',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (33,'Teagan Quitoriano makes a catch for a gain of 83 yards','08:48',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (33,'Dameon Pierce rushes for a gain of 44 yards','08:23',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (33,'Donta Foreman rushes for a gain of 23 yards','14:51',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (33,'Brevin Jordan makes a catch for a gain of 41 yards','04:45',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (33,'Rex Burkhead rushes for a gain of 85 yards','06:09',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (34,'Nick Vannett makes a catch for a gain of 26 yards','00:08',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (34,'Richie James makes a catch for a gain of 41 yards','08:45',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (34,'Drake London makes a catch for a loss of 10 yards','13:10',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (34,'KhaDarel Hodge makes a catch for a gain of 19 yards','13:24',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (34,'MyCole Pruitt makes a catch for a gain of 36 yards','01:00',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (35,'Curtis Samuel makes a catch for a gain of 66 yards','11:28',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (35,'Curtis Samuel makes a catch for a touchdown','08:55',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (35,'Cole Beasley makes a catch for a gain of 34 yards','11:26',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (35,'Terry McLaurin makes a catch for a gain of 70 yards','01:14',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (35,'Terry McLaurin makes a catch for a gain of 30 yards','07:14',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (36,'Justin Fields scrambles for a gain of 72 yards','06:37',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (36,'Deshaun Watson scrambles for a gain of 83 yards','14:57',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (36,'Daylen Baldwin makes a catch for a loss of 7 yards','04:46',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (36,'Velus Jones Jr. makes a catch for a gain of 4 yards','07:05',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (36,'Trevon Wesco makes a catch for a gain of 9 yards','02:52',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (37,'Gunner Olszewski makes a catch for a gain of 22 yards','02:42',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (37,'Jaylen Warren rushes for a gain of 49 yards','09:04',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (37,'Jaylen Warren rushes for a loss of 5 yards','02:44',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (37,'Chris Evans rushes for a gain of 77 yards','02:07',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (37,'Connor Heyward makes a catch for a gain of 32 yards','12:35',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (38,'Julius Chestnut rushes for a gain of 63 yards','13:47',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (38,'Jelani Woods makes a catch for a gain of 82 yards','14:59',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (38,'Julius Chestnut rushes for a gain of 54 yards','07:21',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (38,'Kylen Granson makes a catch for a gain of 3 yards','02:39',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (38,'Geoff Swaim makes a catch for a gain of 19 yards','10:52',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (39,'Kyler Murray scrambles for a gain of 54 yards','10:23',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (39,'Christian Kirk makes a catch for a gain of 40 yards','12:33',4);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (39,'Chris Manhertz makes a catch for a gain of 66 yards','05:30',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (39,'David Blough scrambles for a gain of 40 yards','14:47',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (39,'Travis Etienne rushes for a gain of 13 yards','06:38',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (40,'James Mitchell makes a catch for a touchdown','05:37',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (40,'Charlie Kolar makes a catch for a gain of 55 yards','11:14',1);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (40,'Craig Reynolds rushes for a loss of 10 yards','12:40',3);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (40,'Quintez Cephus makes a catch for a gain of 89 yards','02:37',2);														
INSERT INTO Play_by_Play (game_id, play_summary, time, quarter) VALUES (40,'Shane Zylstra makes a catch for a loss of 7 yards','02:43',2);		


INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (426,'Concussion','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (536,'Muscle Tear','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (537,'Hamstring Strain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (164,'Back Injury','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (346,'Fractured Bone','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (161,'Hamstring Strain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (5,'Torn ACL','out for Season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (529,'Concussion','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (137,'Concussion','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (385,'Shoulder Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (340,'Knee Injury','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (220,'Muscle Tear','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (611,'Concussion','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (361,'Muscle Tear','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (431,'Groin Strain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (374,'Back Injury','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (354,'Groin Strain','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (359,'Groin Strain','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (333,'Shoulder Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (422,'Groin Strain','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (6,'Muscle Tear','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (62,'Knee Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (147,'Fractured Bone','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (418,'Concussion','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (496,'Knee Injury','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (21,'Muscle Tear','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (224,'Hamstring Strain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (280,'Ankle Sprain','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (239,'Muscle Tear','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (606,'Back Injury','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (356,'Groin Strain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (474,'Groin Strain','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (297,'Fractured Bone','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (500,'Muscle Tear','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (270,'Torn ACL','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (424,'Shoulder Injury','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (258,'Ankle Sprain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (38,'Groin Strain','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (86,'Muscle Tear','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (324,'Back Injury','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (596,'Muscle Tear','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (420,'Fractured Bone','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (396,'Shoulder Injury','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (217,'Muscle Tear','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (399,'Ankle Sprain','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (221,'Groin Strain','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (103,'Concussion','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (441,'Torn ACL','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (171,'Hamstring Strain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (371,'Torn ACL','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (615,'Muscle Tear','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (248,'Shoulder Injury','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (436,'Back Injury','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (564,'Concussion','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (435,'Concussion','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (469,'Groin Strain','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (81,'Shoulder Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (613,'Groin Strain','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (84,'Groin Strain','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (197,'Fractured Bone','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (275,'Groin Strain','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (470,'Hamstring Strain','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (622,'Fractured Bone','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (7,'Knee Injury','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (446,'Shoulder Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (294,'Shoulder Injury','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (320,'Torn ACL','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (179,'Knee Injury','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (120,'Torn ACL','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (284,'Knee Injury','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (553,'Hamstring Strain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (517,'Knee Injury','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (77,'Fractured Bone','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (449,'Back Injury','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (568,'Groin Strain','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (534,'Hamstring Strain','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (473,'Fractured Bone','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (264,'Back Injury','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (22,'Groin Strain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (51,'Knee Injury','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (190,'Fractured Bone','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (369,'Torn ACL','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (397,'Muscle Tear','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (550,'Muscle Tear','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (358,'Concussion','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (623,'Concussion','6 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (235,'Knee Injury','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (106,'Concussion','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (61,'Groin Strain','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (592,'Hamstring Strain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (115,'Muscle Tear','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (477,'Muscle Tear','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (107,'Torn ACL','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (492,'Ankle Sprain','2 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (372,'Fractured Bone','1 week');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (249,'Fractured Bone','5 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (183,'Torn ACL','3 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (223,'Groin Strain','4 weeks');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (575,'Back Injury','out for season');
INSERT INTO Player_Injuries (player_id, injury, duration) VALUES (569,'Torn ACL','4 weeks');


INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(1,577,0,0,0,0,1,58);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(1,574,0,0,1,140,3,78);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(1,165,0,0,1,113,3,82);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(1,177,0,0,0,0,0,6);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(1,168,0,0,0,0,0,57);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(2,501,0,0,0,143,1,140),
(2,505,0,0,0,0,1,4),
(2,504,0,0,3,160,1,118),
(2,28,0,0,2,171,0,142),
(2,41,0,0,0,0,2,153),
(2,31,0,0,0,0,3,82);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(3,518,0,0,0,0,0,0),
(3,515,0,0,1,63,0,5),
(3,81,0,0,0,0,3,128),
(3,76,0,0,0,0,3,89),
(3,69,0,0,2,64,2,61);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(4,93,0,0,0,0,1,167),
(4,90,1,382,1,116,0,0),
(4,100,0,0,0,0,2,96),
(4,481,0,0,1,34,2,60),
(4,494,0,0,0,0,3,4);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(5,130,0,0,0,43,0,125),
(5,140,0,0,0,0,3,181),
(5,403,0,0,0,131,3,62),
(5,413,0,0,0,0,1,111),
(5,407,0,0,0,0,0,55);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(6,565,0,0,0,0,3,76),
(6,560,0,0,0,0,0,0),
(6,273,0,448,0,3,0,0),
(6,285,0,0,0,0,0,6),
(7,14,0,0,0,0,0,57);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(7,19,0,0,0,0,1,80),
(7,4,0,0,2,126,1,5),
(7,604,0,0,0,0,1,83),
(7,599,0,0,0,0,1,153),
(8,533,0,0,1,44,3,100),
(8,546,0,0,0,0,3,62),
(8,220,0,0,0,0,0,29),
(8,215,0,0,0,0,0,99),
(8,208,1,429,0,178,0,0),
(9,259,0,0,0,0,0,122),
(9,264,0,0,0,0,1,156),
(9,292,0,0,0,73,3,97),
(9,296,0,0,0,0,0,4),
(10,340,0,0,2,156,0,64),
(10,353,0,0,0,0,2,178),
(10,613,0,0,1,70,2,199),
(10,625,0,0,0,0,3,157),
(11,307,2,358,3,122,0,0),
(11,317,0,0,0,0,2,154),
(11,311,2,348,0,12,0,0),
(11,150,0,0,0,165,0,16),
(11,147,3,153,3,179,0,0),
(12,194,0,0,0,0,0,0),
(12,199,0,0,0,0,1,56),
(12,184,0,0,1,73,2,172),
(12,472,0,0,0,0,1,112),
(12,467,0,0,0,0,3,137),
(13,446,0,0,0,0,1,146),
(13,451,0,0,0,0,3,110),
(13,436,5,162,2,27,0,0),
(13,229,0,0,2,100,3,100),
(13,242,0,0,0,0,2,83);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(13,232,0,0,0,0,2,157),
(14,394,0,0,0,0,2,161),
(14,389,3,293,0,97,0,0),
(14,382,4,354,0,56,0,0),
(14,419,0,0,0,152,3,168),
(14,429,0,0,0,0,1,48),
(14,423,0,0,0,0,3,104),
(15,376,0,0,0,0,0,0),
(15,373,0,0,0,0,0,185),
(15,360,3,103,0,106,0,0),
(15,124,0,0,0,0,3,154),
(15,121,0,0,0,0,2,42),
(15,108,0,0,3,102,0,144),
(16,324,0,0,1,198,3,108),
(16,334,0,0,0,0,1,167),
(16,60,0,0,0,0,2,160),
(16,55,3,230,3,170,0,0),
(16,48,0,0,1,97,1,165),
(17,613,0,0,3,171,3,181),
(17,625,0,0,0,0,2,97),
(17,472,0,0,0,0,0,134),
(17,467,0,0,0,0,2,159),
(18,81,0,0,0,0,0,93),
(18,76,0,0,0,0,2,95),
(18,69,0,0,1,132,3,153),
(18,394,0,0,0,0,1,176),
(18,389,4,79,3,187,0,0),
(19,93,0,0,0,0,2,124),
(19,90,5,28,1,183,0,0),
(19,446,0,0,0,0,3,71),
(19,451,0,0,0,0,3,192),
(19,436,1,403,0,171,0,0),
(20,124,0,0,0,0,0,74),
(20,121,0,0,0,0,3,78),
(20,130,0,0,2,182,2,118),
(20,140,0,0,0,0,1,154),
(21,150,0,0,3,10,0,180),
(21,147,1,156,2,195,0,0),
(21,259,0,0,0,0,2,174),
(21,264,0,0,0,0,0,6),
(21,249,1,199,1,166,0,0),
(22,376,0,0,0,0,0,0),
(22,373,0,0,0,0,3,39),
(22,273,5,487,0,66,0,0),
(22,285,0,0,0,0,2,87),
(22,276,0,0,0,137,0,199),
(23,194,0,0,0,0,0,0),
(23,199,0,0,0,0,2,94);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(23,292,0,0,3,69,1,41),
(23,296,0,0,0,0,1,83),
(24,419,0,0,3,93,0,41),
(24,429,0,0,0,0,1,122),
(24,423,0,0,0,0,0,170),
(24,481,0,0,2,26,1,55),
(24,494,0,0,0,0,3,87),
(25,533,0,0,0,52,1,129),
(25,546,0,0,0,0,2,1),
(25,501,0,0,3,163,0,86),
(25,505,0,0,0,0,2,48),
(26,324,0,0,3,177,1,116),
(26,334,0,0,0,0,3,33),
(26,518,0,0,0,0,0,0),
(26,515,0,0,0,167,2,4),
(27,577,0,0,0,0,1,152),
(27,574,0,0,2,89,2,29),
(27,584,0,0,0,0,1,188),
(27,28,0,0,1,132,1,198),
(27,41,0,0,0,0,3,67),
(28,14,0,0,0,0,1,172),
(28,19,0,0,0,0,2,93),
(28,403,0,0,1,129,2,121),
(28,413,0,0,0,0,1,7),
(29,165,0,0,2,72,1,58),
(29,177,0,0,0,0,0,180),
(29,340,0,0,0,20,2,72),
(29,353,0,0,0,0,3,9),
(29,343,0,0,0,0,0,0),
(30,604,0,0,0,0,3,51),
(30,599,0,0,0,0,0,25),
(30,592,0,0,2,135,2,129),
(30,565,0,0,0,0,2,139),
(30,560,0,0,0,0,0,0),
(31,60,0,0,0,0,2,10),
(31,55,1,306,0,161,0,0),
(31,48,0,0,2,146,1,23),
(31,307,2,178,3,190,0,0),
(31,317,0,0,0,0,3,150),
(32,229,0,0,0,197,3,66),
(32,242,0,0,0,0,1,44),
(32,220,0,0,0,0,3,174),
(32,215,0,0,0,0,2,85),
(33,93,0,0,0,0,1,161),
(33,90,2,421,3,132,0,0),
(33,100,0,0,0,0,2,89),
(33,259,0,0,0,0,3,109),
(33,264,0,0,0,0,2,26),
(33,249,4,176,1,73,0,0),
(34,28,0,0,2,16,1,189),
(34,41,0,0,0,0,2,76),
(34,472,0,0,0,0,2,178);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(34,467,0,0,0,0,3,94),
(35,81,0,0,0,0,2,92),
(35,76,0,0,0,0,1,158),
(35,69,0,0,0,61,0,75),
(35,613,0,0,1,101,0,77),
(35,625,0,0,0,0,2,125),
(36,150,0,0,1,43,0,39),
(36,147,2,51,0,64,0,0),
(36,157,0,0,0,0,0,147),
(36,124,0,0,0,0,3,56),
(36,121,0,0,0,0,3,70),
(36,108,0,0,3,57,0,139),
(37,130,0,0,1,155,1,52),
(37,140,0,0,0,0,2,200),
(37,134,0,0,0,0,3,79),
(37,518,0,0,0,0,0,0),
(37,515,0,0,2,67,3,136),
(37,525,0,0,0,0,0,0),
(38,604,0,0,0,0,3,111),
(38,599,0,0,0,0,1,9),
(38,592,0,0,1,9,2,1),
(38,273,0,33,2,146,0,0),
(38,285,0,0,0,0,2,187),
(39,14,0,0,0,0,3,69),
(39,19,0,0,0,0,0,119),
(39,4,0,0,3,70,3,161),
(39,292,0,0,0,62,2,154),
(39,296,0,0,0,0,1,191),
(40,60,0,0,0,0,3,84),
(40,55,4,469,2,199,0,0),
(40,220,0,0,0,0,0,113),
(40,215,0,0,0,0,3,168),
(40,208,3,310,1,107,0,0),
(41,340,0,0,0,22,0,12),
(41,353,0,0,0,0,2,168),
(41,307,3,169,2,0,0,0),
(41,317,0,0,0,0,3,49),
(42,446,0,0,0,0,2,184),
(42,451,0,0,0,0,3,145),
(42,419,0,0,0,54,0,9),
(42,429,0,0,0,0,0,193),
(43,194,0,0,0,0,0,0),
(43,199,0,0,0,0,3,17),
(43,184,0,0,2,153,0,63),
(43,481,0,0,3,184,0,105),
(43,494,0,0,0,0,0,121),
(43,484,0,0,0,0,3,164),
(44,324,0,0,1,192,3,28),
(44,334,0,0,0,0,2,110),
(44,394,0,0,0,0,0,73),
(44,389,0,424,0,49,0,0),
(45,403,0,0,2,80,2,6),
(45,413,0,0,0,0,0,169),
(45,565,0,0,0,0,2,61),
(45,560,0,0,0,0,0,0),
(46,376,0,0,0,0,0,0),
(46,373,0,0,0,0,1,182),
(46,360,2,359,3,57,0,0),
(46,577,0,0,0,0,0,163);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(46,574,0,0,3,87,2,183),
(47,229,0,0,3,115,2,154),
(47,242,0,0,0,0,3,143),
(47,533,0,0,1,7,2,28),
(47,546,0,0,0,0,2,104),
(48,165,0,0,0,137,3,196),
(48,177,0,0,0,0,0,157),
(48,501,0,0,0,50,1,127),
(48,505,0,0,0,0,0,120),
(48,504,0,0,0,115,0,133),
(49,130,0,0,2,139,0,68),
(49,140,0,0,0,0,0,154),
(49,292,0,0,3,74,0,184),
(49,296,0,0,0,0,1,41),
(49,295,0,0,0,0,1,136),
(50,613,0,0,3,18,2,77),
(50,625,0,0,0,0,2,127),
(50,616,5,53,1,29,0,0),
(50,28,0,0,3,143,0,66),
(50,41,0,0,0,0,3,4),
(51,81,0,0,0,0,0,200),
(51,76,0,0,0,0,3,24),
(51,259,0,0,0,0,2,130),
(51,264,0,0,0,0,2,79),
(51,249,1,81,1,17,0,0),
(52,165,0,0,3,8,1,64),
(52,177,0,0,0,0,0,114),
(52,93,0,0,0,0,3,175),
(52,90,3,491,1,103,0,0),
(52,100,0,0,0,0,2,196),
(53,124,0,0,0,0,1,58),
(53,121,0,0,0,0,0,136),
(53,108,0,0,2,106,3,147),
(53,220,0,0,0,0,2,114),
(53,215,0,0,0,0,2,26),
(53,208,2,195,1,193,0,0),
(54,150,0,0,1,68,1,32),
(54,147,5,88,3,28,0,0),
(54,403,0,0,3,52,1,113);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(54,413,0,0,0,0,0,54),
(55,273,3,184,0,5,0,0),
(55,285,0,0,0,0,2,163),
(55,394,0,0,0,0,1,130),
(55,389,0,473,0,4,0,0),
(55,382,0,350,0,114,0,0),
(56,307,1,136,3,54,0,0),
(56,317,0,0,0,0,1,119),
(56,311,4,393,3,61,0,0),
(56,501,0,0,0,171,0,197),
(56,505,0,0,0,0,1,164),
(57,472,0,0,0,0,0,136),
(57,467,0,0,0,0,0,121),
(57,446,0,0,0,0,2,145),
(57,451,0,0,0,0,2,156),
(57,436,0,208,1,87,0,0),
(58,481,0,0,2,130,3,3),
(58,494,0,0,0,0,2,41),
(58,604,0,0,0,0,1,39),
(58,599,0,0,0,0,3,28),
(58,592,0,0,3,165,0,87),
(59,14,0,0,0,0,2,139),
(59,19,0,0,0,0,2,138),
(59,4,0,0,0,33,1,18),
(59,376,0,0,0,0,0,0),
(59,373,0,0,0,0,1,116),
(60,565,0,0,0,0,3,134),
(60,560,0,0,0,0,0,0),
(60,533,0,0,3,155,0,16),
(60,546,0,0,0,0,0,20),
(60,536,2,78,3,162,0,0),
(61,60,0,0,0,0,0,80),
(61,55,0,220,0,78,0,0),
(61,194,0,0,0,0,0,0),
(61,199,0,0,0,0,2,11),
(61,184,0,0,3,49,2,39),
(62,229,0,0,1,131,2,45),
(62,242,0,0,0,0,0,68),
(62,518,0,0,0,0,0,0),
(62,515,0,0,1,96,2,79),
(63,577,0,0,0,0,3,158),
(63,574,0,0,2,191,1,192),
(63,419,0,0,0,141,3,172),
(63,429,0,0,0,0,3,147),
(64,340,0,0,3,178,1,195),
(64,353,0,0,0,0,0,142),
(64,343,0,0,0,0,0,0),
(64,324,0,0,0,94,2,33),
(64,334,0,0,0,0,1,108),
(65,376,0,0,0,0,0,0),
(65,373,0,0,0,0,1,83),
(65,565,0,0,0,0,3,71),
(65,560,0,0,0,0,0,0),
(65,553,0,0,2,160,3,62),
(66,28,0,0,2,10,2,126);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(66,41,0,0,0,0,1,0),
(66,31,0,0,0,0,3,126),
(66,481,0,0,2,77,2,126),
(66,494,0,0,0,0,3,194),
(67,501,0,0,0,12,0,129),
(67,505,0,0,0,0,0,94),
(67,504,0,0,3,167,2,85),
(67,93,0,0,0,0,0,84),
(67,90,0,205,0,60,0,0),
(68,229,0,0,1,163,1,185),
(68,242,0,0,0,0,0,187),
(68,232,0,0,0,0,1,41),
(68,130,0,0,2,63,0,115),
(68,140,0,0,0,0,1,122),
(69,518,0,0,0,0,0,0),
(69,515,0,0,2,114,1,96),
(69,525,0,0,0,0,0,0),
(69,194,0,0,0,0,0,0),
(69,199,0,0,0,0,0,87),
(70,403,0,0,2,184,2,156),
(70,413,0,0,0,0,3,7),
(70,220,0,0,0,0,1,166),
(70,215,0,0,0,0,1,78),
(70,208,2,433,3,108,0,0),
(71,419,0,0,3,103,3,135),
(71,429,0,0,0,0,0,22),
(71,259,0,0,0,0,2,74),
(71,264,0,0,0,0,3,27),
(71,249,1,106,2,175,0,0),
(72,604,0,0,0,0,3,103),
(72,599,0,0,0,0,0,34),
(72,592,0,0,1,18,3,16),
(72,292,0,0,1,143,1,61),
(72,296,0,0,0,0,3,41),
(72,295,0,0,0,0,1,169),
(73,577,0,0,0,0,1,123),
(73,574,0,0,0,57,1,180),
(73,394,0,0,0,0,2,25),
(73,389,0,247,3,196,0,0),
(73,382,1,471,3,63,0,0);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(74,446,0,0,0,0,3,10),
(74,451,0,0,0,0,1,187),
(74,613,0,0,1,71,0,163),
(74,625,0,0,0,0,3,136),
(75,124,0,0,0,0,2,23),
(75,121,0,0,0,0,2,168),
(75,108,0,0,3,137,1,5),
(75,324,0,0,3,115,2,158),
(75,334,0,0,0,0,2,177),
(75,328,0,0,0,0,1,31),
(76,340,0,0,1,165,1,108),
(76,353,0,0,0,0,2,129),
(76,150,0,0,2,56,3,189),
(76,147,2,102,0,121,0,0),
(76,157,0,0,0,0,3,74),
(77,14,0,0,0,0,0,70),
(77,19,0,0,0,0,3,71),
(77,4,0,0,2,152,1,5),
(77,533,0,0,1,77,0,99),
(77,546,0,0,0,0,2,109),
(77,536,0,25,1,187,0,0),
(78,165,0,0,1,196,0,71),
(78,177,0,0,0,0,2,61),
(78,472,0,0,0,0,1,6),
(78,467,0,0,0,0,3,34),
(79,81,0,0,0,0,2,27),
(79,76,0,0,0,0,0,168),
(79,69,0,0,2,147,0,162),
(79,307,1,321,1,15,0,0),
(79,317,0,0,0,0,3,61),
(79,311,0,397,2,82,0,0),
(80,60,0,0,0,0,3,143),
(80,55,3,248,0,175,0,0),
(80,48,0,0,3,79,3,10),
(80,273,1,407,0,167,0,0),
(80,285,0,0,0,0,1,5),
(80,276,0,0,3,133,1,92);
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds) VALUES
(81,577,0,0,0,0,0,117),
(81,574,0,0,2,77,1,30),
(81,584,0,0,0,0,1,42),
(81,501,0,0,0,84,3,186),
(81,505,0,0,0,0,0,106),
(82,292,0,0,1,179,3,28),
(82,296,0,0,0,0,0,179),
(82,394,0,0,0,0,0,60),
(82,389,4,311,0,186,0,0),
(83,403,0,0,0,117,3,92),
(83,413,0,0,0,0,0,6),
(83,407,0,0,0,0,2,13),
(83,93,0,0,0,0,2,163),
(83,90,2,455,3,49,0,0),
(83,100,0,0,0,0,0,54),
(84,229,0,0,0,16,2,87),
(84,242,0,0,0,0,0,33),
(84,232,0,0,0,0,0,76),
(84,124,0,0,0,0,2,97),
(84,121,0,0,0,0,1,134),
(84,108,0,0,1,91,3,162);