from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


products = Blueprint('teams', __name__)

# Get all the products from the database
@teams.route('/team', methods=['GET'])
def get_teams():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT team_abbr, name, division, conference,salary_cap,third_conv_rate,redzone_eff,avg_ticket_price,wins,losses,win_pct FROM NFLTeams')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)
