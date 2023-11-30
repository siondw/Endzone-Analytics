CREATE DATABASE GAMEDAYMETRICS;
USE GAMEDAYMETRICS;
CREATE TABLE NFLTeams(
   abbr  varchar(3) PRIMARY KEY AUTO_INCREMENT,
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
   abbr  varchar(3),
   pick_num int UNIQUE,
   year int,
   PRIMARY KEY (abbr, pick_num),
   CONSTRAINT FOREIGN KEY (abbr) REFERENCES NFLTeams(abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Game (
   game_id int PRIMARY KEY AUTO_INCREMENT,
   home_abbr varchar(3) NOT NULL,
   INDEX(home_abbr),
   away_abbr int NOT NULL,
   INDEX(away_abbr),
   winner int NOT NULL,
   INDEX(winner),
   loser int NOT NULL,
   INDEX(loser),
   home_score int,
   away_score int,
   yards_leader varchar(50),
   td_leader varchar(50),
   int_leader varchar(50),
   CONSTRAINT FOREIGN KEY (home_abbr) REFERENCES NFLTeams(abbr) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT FOREIGN KEY (away_abbr) REFERENCES NFLTeams(abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Team_Game(
   abbr varchar(3),
   game_id int,
   PRIMARY KEY (abbr, game_id),
   CONSTRAINT FOREIGN KEY (abbr) REFERENCES NFLTeams(abbr) ON DELETE RESTRICT ON UPDATE CASCADE,
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
   play_summary varchar(200),
   PRIMARY KEY (game_id, play_summary),
   CONSTRAINT FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Players(
   player_id int PRIMARY KEY AUTO_INCREMENT,
   abbr varchar(3) NOT NULL,
   INDEX (abbr),
   games_played int,
   total_tds_line varchar(50),
   total_tds_odds varchar(50),
   school varchar (50),
   tackle_eff double,
   qbr double,
   total_yds_line varchar(50),
   total_yds_odds varchar(50),
   shuttle_time double,
   name varchar(50),
   position varchar (50),
   pass_yards_total int,
   rush_yards_total int,
   rec_yards_total int,
   rush_tds_total int,
   pass_tds_total int,
   rec_tds_total int,
   forty_time double,
   bench_presses int,
   CONSTRAINT FOREIGN KEY (abbr) REFERENCES NFLTeams(abbr) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Player_Injuries(
   player_id int,
   injury varchar(200),
   duration varchar(50),
   PRIMARY KEY (player_id, injury),
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