/*
Although XML could be stored as simple text, plain text representation means having no knowledge
of the structure built into an XML document. You could decompose the text, store it in multiple
relational tables, and use relational technologies to manipulate the data. Relational structures
are quite static and not so easy to change. Think of dynamic or volatile XML structures. 
Storing XML data in a native XML data type solves these problems, enabling functionality attached to 
the type that can accommodate support for a wide variety of XML technologies.

XML type limitations
- XML type is not treated like character types
- Does not support comparison (except to NULL)
- No equality comparison
- No ORDER BY, GROUP BY
- No built in functions except ISNULL and COALESCE
- Cannot be used as a KEY Column
- Cannot be used in a UNIQUE Constraint
- Cannot be declared with COLLATE
- Uses XML encodings
- Always stored as UNICODE UCS-2

An XML data type includes five methods that accept XQuery as a parameter.
The methods support querying (the query() method), retrieving atomic values (the value() method),
checking existence (the exist() method), modifying sections within the XML data (the modify() method) 
as opposed to overwriting the whole thing, and shredding XML data into multiple rows in a result 
set (the nodes() method).

-------------------------------------------
Using the XML Data Type for Dynamic Schema
-------------------------------------------
You create the schema collection by using the 'CREATE XML SCHEMA COLLECTION' T-SQL Statement.
Creating the schema is a task that should not be taken lightly.  If you make an error in the
schema, some invalid data might be accepted and some valid data might be rejected.
 
*/