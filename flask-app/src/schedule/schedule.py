from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


schedule = Blueprint('schedule', __name__)

# Get all games from the DB
@schedule.route('/schedule', methods=['GET'])
def get_schedule():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Team_Game')

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


    # Get all games from the DB
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


# Get all teams from the DB
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