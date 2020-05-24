from flask import Flask, render_template, request, redirect
from db_connector.db_connector import connect_to_database, execute_query

webapp = Flask(__name__)  #create the web application

def list_palaces():
    """
    Loads the list of palaces for selection in the webapp header.
    Should be present in all routes
    """
    print("Fetching the list of palaces. Used in header")
    db_connection = connect_to_database()
    query = "SELECT `palace_id`, `name` FROM `palaces`;"
    rtn = execute_query(db_connection, query).fetchall()

    return rtn

@webapp.route('/')
@webapp.route('/index')
def home_page():
    """
    loads the homepage
    """
    context = {'list_palaces': list_palaces()}  # used in header

    return render_template('index.html', context=context)

@webapp.route('/new')
def new_palace():
    """
    loads the page to add a new palace to the database
    """
    context = {'list_palaces': list_palaces()}  # used in header

    return render_template('new.html', context=context)

@webapp.route('/new_palace', methods=['POST'])
def create_palace():
    """
    process the create a palace query sent from new_palace() and displays a confirmation message.
    """
    db_connection = connect_to_database()
    # create palace
    inputs = request.form.to_dict(flat=True)

    print("Creating a new Palace...")
    query = "INSERT INTO `palaces` (`name`, `description`) " \
            "VALUES('{}', '{}');".format(inputs['name'], inputs['desc'])

    # successfully created message and instructions
    message = 'Palace successfully created.'
    instruction = 'Select the palace in the dropdown above and click "VIEW" to add locus to it.'

    # error handler for mysql. Set error message to be displayed on webapp
    try:
        execute_query(db_connection, query).fetchall()
    except db_connection.IntegrityError as err:
        message = 'Could not create palace.'
        instruction = 'Palace name must be unique. Error: ' + str(err)

    context = {'list_palaces': list_palaces(), 'message': message,
               'instruction': instruction}

    return render_template('createPalace.html', context=context)

@webapp.route('/remove_palace/<pid>')
def remove_palace(pid):
    """
    Route to execute the delete palace query
    """
    db_connection = connect_to_database()
    query = f"DELETE FROM `palaces` WHERE `palace_id` = '{pid}'"
    execute_query(db_connection, query).fetchall()

    context = {'list_palaces': list_palaces()}

    return render_template('index.html', context=context)

@webapp.route('/view')  # homepage route
@webapp.route('/view/<palace_id>')
def view_palace(palace_id=1):
    """
    Route to view a selected palace. Default set to 1 only used if user clicks link in homepage
    """
    db_connection = connect_to_database()
    # get palace name and description
    query = "SELECT `name`, `description` FROM `palaces` WHERE `palace_id` ='{}'".format(palace_id)
    rtn = execute_query(db_connection, query).fetchall()

    # create context dictionary
    context = {'list_palaces': list_palaces(), 'palace_name': rtn[0][0], 'palace_desc': rtn[0][1], 'palace_id': palace_id}

    # get loci data
    query = "SELECT loci.loci_id, `name`, `first_chunk_value`, `second_chunk_value`, m_person.person, m_action.action "\
            "FROM `loci` JOIN `chunks` ON chunks.loci_id = loci.loci_id "\
            "JOIN `chunks_mnemo` ON chunks.chunk_id = chunks_mnemo.chunk_id "\
            "JOIN `mnemonics` AS m_person ON chunks_mnemo.first_mnemo = m_person.mnemo_id "\
            "JOIN `mnemonics` AS m_action ON chunks_mnemo.second_mnemo = m_action.mnemo_id "\
            "WHERE loci.palace_id = '{}' "\
            "ORDER BY loci.loci_id;".format(palace_id)
    rtn = execute_query(db_connection, query).fetchall()

    context['rows'] = rtn  # rows = loci data
    return render_template('view.html', context=context)

@webapp.route('/add_locus', methods=['POST'])
def add_loci():
    """
    Route to execute the query to add a locus to the database
    after user submits the form in the bottom of the view_palace route
    """
    db_connection = connect_to_database()
    inputs = request.form.to_dict(flat=True)
    print("Creating a new Locus...")

    # calls a stored procedure in the database
    query = "CALL add_loci('{}', '{}', '{}', '{}');".format(inputs['palace_id'], inputs['locus_name'], inputs['digitsA'],
                                                    inputs['digitsB'])
    # error handler for mysql
    try:
        execute_query(db_connection, query).fetchall()
    except db_connection.IntegrityError as err:
        message = 'Could not create Loci.'
        instruction = 'Loci name must be unique. Error: ' + str(err)
        context = {'list_palaces': list_palaces(), 'message': message,
                   'instruction': instruction}
        # using createPalace template just to display the error msg.
        return render_template('createPalace.html', context=context)

    return redirect("/view/"+inputs['palace_id'])


@webapp.route('/mnemos')
def mnemos():
    """
    Route to display the mnemonics table
    """
    db_connection = connect_to_database()
    query = "SELECT * FROM `mnemonics` ORDER BY `mnemo_id`"
    print('Executing queries to render mnemonics table.')
    rows = execute_query(db_connection, query).fetchall()
    rows = list(rows)  # convert tuple to list in order to delete the first element, -1, since we dont want users to edit this
    rows.pop(0)
    context = {'list_palaces': list_palaces(), 'rows': rows}

    return render_template('mnemos.html', context=context)

@webapp.route('/mnemos_filter')
def mnemos_filter():
    """
    Route to display the mnemonics table filtered for blank items
    """
    db_connection = connect_to_database()
    query = "SELECT * FROM `mnemonics` WHERE `person` IS NULL OR `action` IS NULL ORDER BY `mnemo_id`"
    print('Executing queries to render filtered mnemonics table.')
    rows = execute_query(db_connection, query).fetchall()
    rows = list(rows)  # convert tuple to list in order to delete the first element, -1, since we dont want users to edit this
    rows.pop(0)
    context = {'list_palaces': list_palaces(), 'rows': rows}

    return render_template('mnemos.html', context=context)


@webapp.route('/update_mnemo', methods=['POST'])
def update_mnemo():
    """
    Route to execute the query to process mnemomics update when the user submits the form
    in the mnemonics page
    """
    db_connection = connect_to_database()
    inputs = request.form.to_dict(flat=True)
    id = inputs['mnemo_id']
    # set the person action data in sql format to be uploaded to db
    prsn = 'NULL' if (inputs['person'] == 'None' or inputs['person'] == '') else "'" + inputs['person'] + "'"
    actn = 'NULL' if (inputs['action'] == 'None' or inputs['action'] == '') else "'" + inputs['action'] + "'"

    print('Query to update mnemo...')
    query = "UPDATE `mnemonics` SET `person` = {}, `action` = {} WHERE `mnemo_id` = {}".format(prsn, actn, id)
    execute_query(db_connection, query).fetchall()

    return redirect('/mnemos')

@webapp.route('/loci')
@webapp.route('/loci/<palace_id>')
def loci(palace_id=1):
    """
    Route to update or delete the loci of a palace.
    User arrives at this page after clicking "edit loci" in the view_palace route
    """
    db_connection = connect_to_database()
    print('Get palace name and desc')
    query = "SELECT `name`, `description` FROM `palaces` WHERE `palace_id` ='{}'".format(palace_id)
    rtn = execute_query(db_connection, query).fetchall()
    print('Get loci for selected palace')
    query = "SELECT loci.loci_id, chunks.chunk_id, loci.name, `first_chunk_value`, `second_chunk_value` FROM `loci` "\
            "JOIN `chunks` ON loci.loci_id = chunks.loci_id WHERE `palace_id` = {} ORDER BY loci.loci_id".format(palace_id)
    rows = execute_query(db_connection, query).fetchall()

    context = {'list_palaces': list_palaces(), 'palace_name': rtn[0][0], 'palace_desc': rtn[0][1],
               'palace_id': palace_id, 'rows': rows}

    return render_template('loci.html', context=context)


@webapp.route('/update_loci', methods=['POST'])
def update_loci():
    """
    Route to execute the query to process loci updates after user submits the form in the loci route
    """
    db_connection = connect_to_database()
    inputs = request.form.to_dict(flat=True)
    query = ""
    if inputs['the_action'] == 'upd':
        # calls a stored procedure in the db that updates the necessary multiple tables
        query = "CALL update_loci('{}', '{}', '{}', '{}', '{}');".format(inputs['locus_name'], inputs['loci_id'], inputs['chunk_id'], inputs['digitsA'], inputs['digitsB'])
        execute_query(db_connection, query).fetchall()
    elif inputs['the_action'] == 'del':
        query = f"DELETE FROM `loci` WHERE `loci_id` = {inputs['loci_id']}"

    print('Executing Query:', query)
    execute_query(db_connection, query).fetchall()

    return redirect('/loci/'+ inputs['palace_id'])
