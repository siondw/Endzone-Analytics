from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


players = Blueprint('players', __name__)

# Get specific player from the DB
@players.route('/players/<name>', methods=['GET'])
def get_players(name):
    query = f"SELECT * FROM Players WHERE player_name = '{name}'"
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

# passing leader board
@players.route('/players/passing_leaders', methods=['GET'])
def get_passing_leaderboard():
    query = f"SELECT player_name, pass_yards_total FROM Players ORDER BY pass_yards_total DESC LIMIT 10'"
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

# rushing leader board
@players.route('/players/rushing_leaders', methods=['GET'])
def get_passing_leaderboard():
    query = f"SELECT player_name, rush_yards_total FROM Players ORDER BY rush_yards_total DESC LIMIT 10'"
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

# receiving leader board
@players.route('/players/receiving_leaders', methods=['GET'])
def get_passing_leaderboard():
    query = f"SELECT player_name, rec_yards_total FROM Players ORDER BY rec_yards_total DESC LIMIT 10'"
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