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

    the_query = 'UPDATE Game SET '
    the_query += 'home_score = "' + home_score + '", '
    the_query += 'away_score = "' + away_score + '", '
    the_query += 'WHERE game_id = {0};'.format(game_id)

    current_app.logger.info(the_query)
    
    cursor = db.get_db().cursor()
    cursor.execute(the_query)
    cursor.execute(order_query)
    db.get_db().commit()

    return "successfully edited game #{0}!".format(game_id)