CREATE DATABASE GameDayMetrics;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `GameDayMetrics` ;
CREATE SCHEMA IF NOT EXISTS `GameDayMetrics` DEFAULT CHARACTER SET latin1 ;
USE `GameDayMetrics` ;


GRANT ALL PRIVILEGES ON GameDayMetrics.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
USE GameDayMetrics;
CREATE TABLE NFLTeams(
   team_abbr  varchar(3) PRIMARY KEY AUTO_INCREMENT,
   name varchar(50),
   division varchar(50),
   conference varchar(50),
   salary_cap int,
   third_conv_rate DOUBLE,
   redzone_eff DOUBLE,
   avg_ticket_price DOUBLE,
   wins int,
   losses int,
   win_pct DOUBLE GENERATED ALWAYS AS (wins / (wins + losses)) STORED
);

CREATE TABLE Team_Picks(
   team_abbr  varchar(3),
   pick_id int AUTO_INCREMENT,
   pick_num int,
   year int,
   PRIMARY KEY (team_abbr, pick_id),
   CONSTRAINT FOREIGN KEY (team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Game (
   game_id int PRIMARY KEY AUTO_INCREMENT,
   home_team_abbr varchar(3) NOT NULL,
   INDEX(home_team_abbr),
   away_team_abbr varchar(3) NOT NULL,
   INDEX(away_team_abbr),
   winner int NOT NULL,
   INDEX(winner),
   loser int NOT NULL,
   INDEX(loser),
   home_score int,
   away_score int,
   yards_leader varchar(50),
   td_leader varchar(50),
   pass_yds_leader varchar(50),
   week_num char(1),
   ticket_price int,
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
   play_summary varchar(200),
   time varchar(10),
   quarter int,
   PRIMARY KEY (game_id, play_id),
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Players(
   player_id int PRIMARY KEY AUTO_INCREMENT,
   name varchar(50),
   team_abbr varchar(3) NOT NULL,
   INDEX (team_abbr),
   position varchar (4),
   qbr double,
   pass_yards_total int,
   rush_yards_total int,
   rec_yards_total int,
   rush_tds_total int,
   pass_tds_total int,
   rec_tds_total int,
   games_played int,
   total_tds_line varchar(50),
   total_tds_odds varchar(50),
   school varchar (50),
   total_yds_line varchar(50),
   total_yds_odds varchar(50),
   shuttle_time double,
   forty_time double,
   bench_presses int,
   CONSTRAINT FOREIGN KEY (team_abbr) REFERENCES NFLTeams(team_abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Player_Injuries(
   player_id int,
   injury_id int AUTO_INCREMENT,
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

INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('AZ', 'Arizona Cardinals', 'NFC West', 'NFC', 7863982, 0.46, 0.51, 94, 5, 12, 0.294);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('ATL', 'Atlanta Falcons', 'NFC South', 'NFC', 39410705, 0.34, 0.64, 112, 4, 13, 0.235);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('BAL', 'Baltimore Ravens', 'AFC North', 'AFC', 26727883, 0.34, 0.59, 95, 11, 6, 0.647);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('BUF', 'Buffalo Bills', 'AFC East', 'AFC', 1759639, 0.46, 0.54, 123, 10, 7, 0.588);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('CAR', 'Carolina Panthers', 'NFC South', 'NFC', 28756204, 0.38, 0.44, 81, 5, 12, 0.294);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('CHI', 'Chicago Bears', 'NFC North', 'NFC', 10672710, 0.47, 0.53, 66, 8, 9, 0.471);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('CIN', 'Cincinnati Bengals', 'AFC North', 'AFC', 10392379, 0.42, 0.62, 121, 10, 7, 0.588);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('CLE', 'Cleveland Browns', 'AFC North', 'AFC', 15166744, 0.41, 0.54, 100, 7, 10, 0.412);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('DAL', 'Dallas Cowboys', 'NFC East', 'NFC', 15767186, 0.51, 0.53, 134, 12, 5, 0.706);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('DEN', 'Denver Broncos', 'AFC West', 'AFC', 26620196, 0.38, 0.62, 60, 7, 10, 0.412);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('DET', 'Detroit Lions', 'NFC North', 'NFC', 31155299, 0.36, 0.61, 120, 3, 14, 0.176);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('GB', 'Green Bay Packers', 'NFC North', 'NFC', 22354690, 0.52, 0.63, 136, 13, 4, 0.765);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('HOU', 'Houston Texans', 'AFC South', 'AFC', 24725939, 0.47, 0.53, 119, 4, 13, 0.235);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('IND', 'Indianapolis Colts', 'AFC South', 'AFC', 24060729, 0.4, 0.61, 89, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('JAC', 'Jacksonville Jaguars', 'AFC South', 'AFC', 13932528, 0.46, 0.45, 129, 2, 15, 0.118);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('KC', 'Kansas City Chiefs', 'AFC West', 'AFC', 28888331, 0.52, 0.45, 98, 14, 3, 0.824);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('LV', 'Las Vegas Raiders', 'AFC West', 'AFC', 6143321, 0.41, 0.53, 100, 8, 9, 0.471);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('LAC', 'Los Angeles Chargers', 'AFC West', 'AFC', 15220613, 0.39, 0.52, 117, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('LAR', 'Los Angeles Rams', 'NFC West', 'NFC', 23093842, 0.47, 0.66, 96, 12, 5, 0.706);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('MIA', 'Miami Dolphins', 'AFC East', 'AFC', 34998831, 0.37, 0.45, 74, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('MIN', 'Minnesota Vikings', 'NFC North', 'NFC', 13680005, 0.44, 0.51, 138, 7, 10, 0.412);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('NE', 'New England Patriots', 'AFC East', 'AFC', 24577700, 0.41, 0.54, 73, 10, 7, 0.588);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('NO', 'New Orleans Saints', 'NFC South', 'NFC', 21294905, 0.46, 0.56, 72, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('NYG', 'New York Giants', 'NFC East', 'NFC', 22459705, 0.52, 0.61, 64, 6, 11, 0.353);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('NYJ', 'New York Jets', 'AFC East', 'AFC', 11087158, 0.43, 0.57, 81, 2, 15, 0.118);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('PHI', 'Philadelphia Eagles', 'NFC East', 'NFC', 8709819, 0.4, 0.51, 71, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('PIT', 'Pittsburgh Steelers', 'AFC North', 'AFC', 2147007, 0.53, 0.63, 130, 9, 8, 0.529);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('SF', 'San Francisco 49ers', 'NFC West', 'NFC', 13762192, 0.47, 0.48, 130, 6, 11, 0.353);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('SEA', 'Seattle Seahawks', 'NFC West', 'NFC', 39573185, 0.35, 0.49, 76, 12, 5, 0.706);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('TB', 'Tampa Bay Buccaneers', 'NFC South', 'NFC', 14431821, 0.38, 0.46, 117, 13, 4, 0.765);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('TEN', 'Tennessee Titans', 'AFC South', 'AFC', 30492076, 0.45, 0.53, 87, 12, 5, 0.706);
INSERT INTO 'NFLTeams' ('team_abbr', 'name', 'division', 'conference', 'salary_cap', 'third_conv_rate', 'redzone_eff', 'avg_ticket_price', 'wins', 'losses') VALUES ('WAS', 'Washington Commanders', 'NFC East', 'NFC', 20226615, 0.37, 0.46, 82, 7, 10, 0.412);