from flask import Blueprint, request, jsonify, make_response, current_app
import json, urllib
from src import db


players = Blueprint('players', __name__)

# Get all player names
@players.route('/players/all_names', methods=['GET'])
def get_player_names():
    query = f"SELECT DISTINCT player_name FROM Players ORDER BY player_name"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get specific player from the DB
@players.route('/players/<name>', methods=['GET'])
def get_players(name):
    decoded_name = urllib.parse.unquote(name)
    query = f"SELECT * FROM Players WHERE player_name = '{decoded_name}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

 # Get specific player from the DB using id
@players.route('/players/use_id/<player_id>', methods=['GET'])
def get_players_with_id(player_id):
    query = f"SELECT * FROM Players WHERE player_id = '{player_id}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# passing leaderboard
@players.route('/players/passing_leaders', methods=['GET'])
def get_passing_leaderboard():
    query = f"SELECT player_name, pass_yards_total FROM Players ORDER BY pass_yards_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# rushing leaderboard
@players.route('/players/rushing_leaders', methods=['GET'])
def get_rushing_leaderboard():
    query = f"SELECT player_name, rush_yards_total FROM Players ORDER BY rush_yards_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# receiving leaderboard
@players.route('/players/receiving_leaders', methods=['GET'])
def get_receiving_leaderboard():
    query = f"SELECT player_name, rec_yards_total FROM Players ORDER BY rec_yards_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# pass touchdown leaderboard
@players.route('/players/pass_touchdown_leaders', methods=['GET'])
def get_pass_touchdown_leaderboard():
    query = f"SELECT player_name, pass_tds_total FROM Players ORDER BY pass_tds_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# receiving touchdown leaderboard
@players.route('/players/receiving_touchdown_leaders', methods=['GET'])
def get_receiving_touchdown_leaderboard():
    query = f"SELECT player_name, rec_tds_total FROM Players ORDER BY rec_tds_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# rush touchdown leaderboard
@players.route('/players/rush_touchdown_leaders', methods=['GET'])
def get_rush_touchdown_leaderboard():
    query = f"SELECT player_name, rush_tds_total FROM Players ORDER BY rush_tds_total DESC LIMIT 10"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# player injuries in a game
@players.route('/players/injuries/<player_id>', methods=['GET'])
def get_player_injuries(player_id):
    query = f"SELECT player_name, injury, duration FROM Player_Injuries JOIN Players ON Player_Injuries.player_id = Players.player_id WHERE Player_Injuries.player_id = '{player_id}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# TDs line for all players 
@players.route('/players/total_tds_props/<player_id>', methods=['GET'])
def get_total_tds_props(player_id):
    query = f"SELECT total_tds_line FROM Players WHERE player_id = '{player_id}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# yards line for all players
@players.route('/players/total_yds_props/<player_id>', methods=['GET'])
def get_total_yds_props(player_id):
    query = f"SELECT total_yds_line FROM Players WHERE player_id = '{player_id}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# player game stats
@players.route('/players/game_stats/<player_id>', methods=['GET'])
def get_game_stats(player_id):
    query = f"SELECT * FROM Player_Game_Stats PGS JOIN Game G ON PGS.game_id = G.game_id WHERE P.player_id = '{player_id}'"
    current_app.logger.info(query)
    cursor = db.get_db().cursor()
    cursor.execute(query)

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# add a player injury
@players.route('/players/injuries', methods=['POST'])
def add_injury():
   # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    player_id = the_data['player_id']
    injury = the_data['injury']
    duration = the_data['duration']
 

   # Constructing the query with manual quotes for string fields
    query =  'INSERT INTO Player_Injuries (player_id, injury, duration) VALUES ('
    query += "'" + player_id + "', '"
    query += injury + "', '"
    query += duration + ')'
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

# delete an injury
@players.route('/players/injuries/<int:injury_id>', methods=['DELETE'])
def delete_injury(injury_id):
    
    # Create a cursor to execute the delete query
    cursor = db.get_db().cursor()
    cursor.execute("DELETE FROM Player_Injuries WHERE injury_id = %s", (injury_id,))

    db.get_db().commit()

    return f"Successfully deleted injury!"

# Edit a specific game
@players.route('/players/injuries', methods=['PUT'])
def update_injury():
    the_data = request.json

    injury = the_data['injury']
    duration = the_data['duration']
    injury_id = the_data['injury_id']

    current_app.logger.info(the_data)

    # Corrected SQL query using parameterized inputs
    the_query = """
    UPDATE Player_Injuries 
    SET injury = %s, duration = %s 
    WHERE injury_id = %s;
    """

    current_app.logger.info(the_query)

    # Executing the query with parameters
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (injury, duration, injury_id))
    db.get_db().commit()

    return f"Successfully edited injury #{injury_id}!"