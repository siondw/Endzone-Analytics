from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


teams = Blueprint('teams', __name__)

# Get standings for NFC
@teams.route('/standings/NFC', methods=['GET'])
def get_standings_NFC():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT team_name, SUM(wins), SUM(losses), `division` FROM NFLTeams WHERE `conference` = 'NFC' GROUP BY `division`, `team_name` ORDER BY `division`, SUM(wins) DESC;")

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get standings for NFC
@teams.route('/standings/AFC', methods=['GET'])
def get_standings_AFC():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT team_name, SUM(wins), SUM(losses), `division` FROM NFLTeams WHERE `conference` = 'AFC' GROUP BY `division`, `team_name` ORDER BY `division`, SUM(wins) DESC;")

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get all stats for a specific team
@teams.route('/teams/<team_abbr>', methods=['GET'])
def get_team_schedule(team_abbr):

    query = f"SELECT * FROM NFLTeams WHERE team_abbr = '{team_abbr}'"
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


# Gets team name from an abbreviation
@teams.route('/team_name/<team_abbr>', methods=['GET'])
def get_team_name(team_abbr):

    query = f"SELECT team_name FROM NFLTeams WHERE team_abbr = '{team_abbr}'"
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


# Gets all the picks
@teams.route('/picks', methods=['GET'])
def get_picks():

    query = f"SELECT team_name, pick_num, year, team_abbr, pick_id FROM NFLTeams NATURAL JOIN Team_Picks"
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


# Edit a specific pick
@teams.route('/picks/<pick_id>', methods=['PUT'])
def update_pick(pick_id):
    
    the_data = request.json

    team_abbr = the_data['team_abbr']

    current_app.logger.info(the_data)

    # Corrected SQL query using parameterized inputs
    the_query = """
    UPDATE Team_Picks 
    SET team_abbr = %s
    WHERE pick_id = %s;
    """

    current_app.logger.info(the_query)

    # Executing the query with parameters
    cursor = db.get_db().cursor()
    cursor.execute(the_query, (team_id, pick_id))
    db.get_db().commit()

    return f"Successfully edited pick #{pick_id}!"


# delete a pick
@teams.route('/picks/<int:pick_id>', methods=['DELETE'])
def delete_pick(pick_id):
    
    # Create a cursor to execute the delete query
    cursor = db.get_db().cursor()
    cursor.execute("DELETE FROM Team_Picks WHERE pick_id = %s", (pick_id))

    db.get_db().commit()

    return f"Successfully deleted pick!"


# add a new pick
@teams.route('/picks', methods=['POST'])
def add_new_pick():
    
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    team_abbr = the_data['team_abbr']
    pick_num = the_data['pick_num']
    year = the_data['year']

    # Constructing the query with manual quotes for string fields and without quotes for integers
    query = 'INSERT INTO Team_Picks (team_abbr, pick_num, year) VALUES ('
    query += "'" + team_abbr + "', "  # String value, so it's wrapped in quotes
    query += str(pick_num) + ", "     # Integer value, no quotes needed
    query += str(year) + ')'          # Integer value, no quotes needed
    current_app.logger.info(query)


    # Executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'