-----------------------------------------------------
--Authors: Banks Cargill
--Date: 2/20/2020
--Description:  SQL queries for implementing the backend
--							of our Memory Palace webpage
-----------------------------------------------------


----------------------  NEW.HTML   ----------------------------- 

--- Query to add a new palace to the database                ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

INSERT INTO palaces (name, description)
VALUES
(:nameInput, :descriptionInput);


---------------------   VIEW.HTML   -----------------------------

--- Query to populate the dropdown menu on view.html				 ---

SELECT palace_id, name FROM palaces;


--- Query for when the user selects a palace from the 			 ---
--- dropdown menu on view.html and presses the view button	 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

SELECT name, description FROM palaces WHERE name = :inputPalaceId;

SELECT name, first_chunk_value, second_chunk_value, m_person.person, m_action.action FROM loci 
JOIN chunks ON chunks.loci_id = loci.loci_id
JOIN chunks_mnemo ON chunks.chunk_id = chunks_mnemo.chunk_id
JOIN mnemonics AS m_person ON chunks_mnemo.first_mnemo = m_person.mnemo_id 
JOIN mnemonics AS m_action ON chunks_mnemo.second_mnemo = m_action.mnemo_id
ORDER BY loci.loci_id;

--- Query for when the user selects a palace from the 			 ---
--- dropdown menu on view.html and presses the delete button ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

DELETE FROM palaces WHERE name = :inputName;


--------------------------  EDIT.HTML   ------------------------

--- Query for populating form with placeholder text 			   ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

SELECT name, first_chunk_value, second_chunk_value, m_person.person, m_action.action FROM loci 
JOIN chunks ON chunks.loci_id = loci.loci_id 
JOIN chunks_mnemo ON chunks.chunk_id = chunks_mnemo.chunk_id
JOIN mnemonics AS m_person ON chunks_mnemo.first_mnemo = m_person.mnemo_id 
JOIN mnemonics AS m_action ON chunks_mnemo.second_mnemo = m_action.mnemo_id
WHERE loci.loci_id = :inputLociId;

--- Updating the loci name entered		 											 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- inputLociId will be passed from the previous page			   ---

UPDATE loci 
SET name = :inputName
WHERE loci_id = :inputLociId 

--- Updating the chunk's data that is entered  							 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- inputLociId will be passed from the previous page			   ---
--- This will also update chunks_mnemo table due to the 		 ---
--- cascade																									 ---

UPDATE chunks
SET first_chunk_value = :inputFirstValue,
second_chunk_value = :inputSecondValue
WHERE loci_id = :inputLociId;

--- Updating the mnemonic 																	 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

UPDATE mnemonics
SET person = :inputPerson,
action = :inputAction
WHERE mnemo_id = :inputMnemoId;

--- Adding a new mnemonic 																	 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

INSERT INTO mnemonics (mnemo_id, person, action)
VALUES (:inputMnemoId, :inputPerson, :inputAction)


--------------------------  LOCI.HTML   ------------------------

--- Adding a new loci 																	     ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- inputPalaceId needs to be passed from the previous page  ---

INSERT INTO loci (palace_id, name)
VALUES
(:inputPalaceId, :inputName);

--- Need to fetch the loci_id after it has been added				 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

SELECT loci_id FROM loci WHERE palace_id = :inputPalaceId AND name = :inputName;

--- Adding a new chunk 																	     ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- loci_id will be fetched with the select statement above  ---

INSERT INTO chunks (first_chunk_value, second_chunk_value, loci_id)
VALUES
(:inputFirstValue, :inputSecondValue, :inputLociId);


--- Need to fetch the chunk_id after it is inserted			     ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- loci_id will be fetched with the select statement above  ---

SELECT chunk_id FROM chunks WHERE loci_id = :inputLociId;

--- Insert into chunks_mnemo table													 ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- loci_id will be fetched with the select statement above  ---

INSERT INTO chunks_mnemo (chunk)id, first_mnemo, second_mnemo)
VALUES
(chunk_id, :inputFirst_mnemo, :inputSecond_mnemo);

--- Update a given loci 																	   ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
UPDATE loci SET name = :inputLociName WHERE loci_id = :inputLociId;

UPDATE chunks SET first_chunk_value = :inputFirstChunkValue, second_chunk_value = :inputSecondChunkValue
WHERE chunk_id = :inputChunkId;

UPDATE chunks_mnemo SET first_mnemo = :inputFirst_mnemo, second_mnemo = :inputSecond_mnemo
WHERE chunk_id = :inputChunkId;

--- Delete a given loci 																	   ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---

DELETE FROM loci WHERE loci_id = :inputLociId;



--------------------------  MNEMOS.HTML   ------------------------

--- View mnemos				  																     ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- inputPalaceId needs to be passed from the previous page  ---

SELECT * FROM mnemonics ORDER BY mnemo_id;


--- update mnemonics 																	     ---
--- Colon ':' is used to denote the variables that will have ---
--- data from the backend programming language 							 ---
--- inputPalaceId needs to be passed from the previous page  ---

UPDATE mnemonics SET person = :inputPerson, action = :inputAction 
WHERE mnemo_id = :inputMnemoId












