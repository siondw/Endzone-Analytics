# Project Overview:

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`.

## Endzone Analytics

Summary: This project is an NFL (National Football League) Statistic and Betting website that provides users with NFL statistics and allows them to see the prop bets for teams and players. The project uses Appsmith for the frontend interface and Flask for the backend server.

### Pages:

- Home Screen: Redirecting links to other pages such as Player Stats, Game Stats, Team Stats and even a special betting tab.

- Player Leaderboard/Search Screen: Shows the stat leaders for a specific stat and also has a search option to get specific player stats. 

- Player Dashboard Screen: Shows more in-depth Player Metrics, including statistics for games played, player props, combine metrics and injury reports (which can be edited by the coaching staff).

- Team Standings Screen: Shows the current team standings based on division.

- Team Statistics Screen: Shows a selected teams games played including scores, winners, losers and other game metrics.

- Edit Draft Picks Screen: This screen is for coaches to edit pick selections for the NFL draft.

- Edit Games Screen: This screen is for coaches to edit game statistics such as winner, loser, score, etc.

- Game Dashboard Screen: Shows more in-depth team statistics 
 
- Game by Team Screen: Shows the Games played based on a specific screen.

- Game by Week Screen: Shows the Games played by a certain week selected by the user


### Tech Stack

- Frontend: Appsmith
- Backend: Flask
- Database: MySQL

### Links

- Appsmith Repo: Link is [here](https://github.com/siondw/EA_Appsmith)
- Backend Repo: Link is [here](https://github.com/siondw/Endzone-Analytics)
- Demo Video: Link is [here](https://m.youtube.com/watch?v=YfkxJAHMxl8&feature=youtu.be)




