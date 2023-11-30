CREATE DATABASE GAMEDAYMETRICS;
USE GAMEDAYMETRICS;
CREATE TABLE NFLTeams(
   team_id  INT PRIMARY KEY AUTO_INCREMENT,
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
   team_id  int,
   pick_num int UNIQUE,
   year int,
   PRIMARY KEY (team_id, pick_num),
   CONSTRAINT FOREIGN KEY (team_id) REFERENCES NFLTeams(team_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Game (
   game_id int PRIMARY KEY AUTO_INCREMENT,
   home_team_id int NOT NULL,
   INDEX(home_team_id),
   away_team_id int NOT NULL,
   INDEX(away_team_id),
   winner int NOT NULL,
   INDEX(winner),
   loser int NOT NULL,
   INDEX(loser),
   home_score int,
   away_score int,
   yards_leader varchar(50),
   td_leader varchar(50),
   int_leader varchar(50),
   CONSTRAINT FOREIGN KEY (home_team_id) REFERENCES NFLTeams(team_id) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT FOREIGN KEY (away_team_id) REFERENCES NFLTeams(team_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Team_Game(
   team_id int,
   game_id int,
   PRIMARY KEY (team_id, game_id),
   CONSTRAINT FOREIGN KEY (team_id) REFERENCES NFLTeams(team_id) ON DELETE RESTRICT ON UPDATE CASCADE,
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
   team_id int NOT NULL,
   INDEX (team_id),
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
   CONSTRAINT FOREIGN KEY (team_id) REFERENCES NFLTeams(team_id) ON DELETE RESTRICT ON UPDATE CASCADE
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

-- Insert statements for NFLTeams
INSERT INTO NFLTeams (name, division, conference, salary_cap, third_conv_rate, redzone_eff,
                      avg_ticket_price, wins, losses)
VALUES ('New England Patriots', 'AFC East', 'AFC', 185000000, 0.42, 0.65, 75.0, 11, 5);

INSERT INTO NFLTeams (name, division, conference, salary_cap, third_conv_rate, redzone_eff,
                      avg_ticket_price, wins, losses)
VALUES ('Green Bay Packers', 'NFC North', 'NFC', 175000000, 0.48, 0.75, 80.0, 12, 4);

-- Insert statements for Team_Picks
INSERT INTO Team_Picks (team_id, pick_num, year)
VALUES (1, 32, 2022);

INSERT INTO Team_Picks (team_id, pick_num, year)
VALUES (2, 15, 2022);

-- Insert statements for Game
INSERT INTO Game (home_team_id, away_team_id, winner, loser, home_score, away_score, yards_leader,
                  td_leader, int_leader)
VALUES (1, 2, 1, 2, 28, 24, 'Aaron Rodgers', 'Aaron Jones', 'Jaire Alexander');

-- Insert statements for Team_Game
INSERT INTO Team_Game (team_id, game_id)
VALUES (1, 1);

INSERT INTO Team_Game (team_id, game_id)
VALUES (2, 1);

-- Insert statements for Game_Highlight
INSERT INTO Game_Highlight (game_id, link, description)
VALUES (1, 'https://example.com/highlight1', 'Amazing touchdown by Aaron Jones');

-- Insert statements for Play_by_Play
INSERT INTO Play_by_Play (game_id, play_summary)
VALUES (1, 'Touchdown pass from Tom Brady to Rob Gronkowski');

-- Insert statements for Players
INSERT INTO Players (team_id, games_played, total_tds_line, total_tds_odds, school,
                     tackle_eff, qbr, total_yds_line, total_yds_odds, shuttle_time, name, position,
                     pass_yards_total, rush_yards_total, rec_yards_total, rush_tds_total, pass_tds_total,
                     rec_tds_total, forty_time, bench_presses)
VALUES (1, 16, '10', '2.5:1', 'Michigan', 0.85, 103.2, '1500', '5:1', 4.2, 'Tom Brady',
        'QB', 4500, 50, 0, 2, 40, 0, 5.0, 225);

INSERT INTO Players (team_id, games_played, total_tds_line, total_tds_odds, school, tackle_eff, qbr, total_yds_line,
                     total_yds_odds, shuttle_time, name, position, pass_yards_total, rush_yards_total,
                     rec_yards_total, rush_tds_total, pass_tds_total, rec_tds_total, forty_time, bench_presses)
VALUES (2, 16, '15', '2:1', 'California', 0.75, 110.5, '1200', '4:1', 4.4, 'Aaron Rodgers', 'QB', 4200, 20,
        0, 3, 35, 0, 4.8, 210);

-- Insert statements for Player_Injuries
INSERT INTO Player_Injuries (player_id, injury, duration)
VALUES (1, 'Sprained Ankle', '2 weeks');

-- Insert statements for Player_Game_Stats
INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds)
VALUES (1, 1, 3, 350, 0, 0, 0, 0);

INSERT INTO Player_Game_Stats (game_id, player_id, pass_tds, pass_yds, rush_tds, rush_yds, rec_tds, rec_yds)
VALUES (1, 2, 2, 300, 0, 25, 0, 0);






