from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


schedule = Blueprint('schedule', __name__)

# Get all games from the DB
@schedule.route('/schedule', methods=['GET'])
def get_schedule():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT home_team_abbr, home_score, away_score, away_team_abbr, game_id FROM Game')

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all games from the DB for a specific team
@schedule.route('/schedule/<team_abbr>', methods=['GET'])
def get_team_schedule(team_abbr):

    query = f"SELECT * FROM Team_Game JOIN Game ON Team_Game.game_id = Game.game_id WHERE team_abbr =  '{team_abbr}'"
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


# Get all teams
@schedule.route('/schedule/teams', methods=['GET'])
def get_teams():

    query = f"SELECT team_abbr FROM NFLTeams"
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

# Get all games from the DB for specific weeks
@schedule.route('/week/<weekstart>/<weekend>', methods=['GET'])
def get_week_schedule(weekstart, weekend):

    query = f"SELECT * FROM Game WHERE week_num >= '{weekstart}' AND week_num <= '{weekend}'"
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

# Edit a specific game
@schedule.route('/schedule', methods=['PUT'])
def update_score():
    
    the_data = request.json

    game_id = the_data['game_id']
    home_score = the_data['home_score']
    away_score = the_data['away_score']

    current_app.logger.info(the_data)

    # Corrected SQL query using parameterized inputs
    the_query = """
    UPDATE Game 
    SET home_score = %s, away_score = %s 
    WHERE game_id = %s;
    """

    current_app.logger.info(the_query)

    # Executing the query with parameters
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (home_score, away_score, game_id))
    db.get_db().commit()

    return f"Successfully edited game #{game_id}!"

# delete a game from schedule
@schedule.route('/schedule/<int:game_id>', methods=['DELETE'])
def delete_record(game_id):
    
    # Create a cursor to execute the delete query
    cursor = db.get_db().cursor()
    cursor.execute("DELETE FROM Game WHERE game_id = %s", (game_id,))

    db.get_db().commit()

    return f"Successfully deleted game!"

# add a new game
@schedule.route('/schedule', methods=['POST'])
def add_new_game():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    home_team_abbr = the_data['home_team_abbr']
    away_team_abbr = the_data['away_team_abbr']
    winner = the_data['winner']
    loser = the_data['loser']
    home_score = the_data['home_score']
    away_score = the_data['away_score']
    yards_leader = the_data['yards_leader']
    td_leader = the_data['td_leader']
    pass_yds_leader = the_data['pass_yds_leader']
    week_num = the_data['week_num']
    ticket_price = the_data['ticket_price']




   # Constructing the query with manual quotes for string fields
    query = 'INSERT INTO Game (home_team_abbr, away_team_abbr, winner, loser, home_score, away_score, yards_leader, td_leader, pass_yds_leader, week_num, ticket_price) VALUES ('
    query += "'" + home_team_abbr + "', '"
    query += away_team_abbr + "', '"
    query += winner + "', '"
    query += loser + "', "
    query += str(home_score) + ", "
    query += str(away_score) + ", '"
    query += yards_leader + "', '"
    query += td_leader + "', '"
    query += pass_yds_leader + "', "
    query += str(week_num) + ", "
    query += str(ticket_price) + ')'
    current_app.logger.info(query)

    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'