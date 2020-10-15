CREATE TABLE ##GetAllObjectLinksTemp (id int, objectLinkName varchar(100))

INSERT INTO ##GetAllObjectLinksTemp (id, objectLinkName)
VALUES (-1, 'Choose...')

INSERT INTO ##GetAllObjectLinksTemp (id, objectLinkName)
SELECT TOP 100 id, (ownerPropertyName + '<cfoutput>#Request.const_linked_objects_symbol#</cfoutput>' + relatedPropertyName) as 'objectLinkName'
FROM objectLinks
ORDER BY ownerPropertyName, relatedPropertyName;

SELECT * FROM ##GetAllObjectLinksTemp

DROP TABLE ##GetAllObjectLinksTemp
