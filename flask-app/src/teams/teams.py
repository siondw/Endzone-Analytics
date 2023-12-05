from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


teams = Blueprint('teams', __name__)

# Get standings
@teams.route('/teams', methods=['GET'])
def get_standings():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT team_name, SUM(wins), SUM(losses), `division` FROM NFLTeams GROUP BY `division`, `team_name` ORDER BY `division`, SUM(wins) DESC;')

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all the stats from the DB for a specific team
@teams.route('/teams/<team_abbr>', methods=['GET'])
def get_team_stats(team_abbr):

    # query = f"SELECT * FROM NFLTeams WHERE team_abbr = '{team_abbr}'"
    # current_app.logger.info(query)

    # cursor = db.get_db().cursor()
    # cursor.execute(query)

    query = f"SELECT * FROM NFLTeams NATURAL JOIN Team_Game NATURAL JOIN Game WHERE team_abbr =  '{team_abbr}'"
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