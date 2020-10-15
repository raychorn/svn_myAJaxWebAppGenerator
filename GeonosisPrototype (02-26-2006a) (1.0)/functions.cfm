<!--- BEGIN: Common Code common to all AJAX apps --->
<cfinclude template="core/cfajax.cfm">

<cffunction name="sqlChooseWrapperWithResults">
	<cfargument name="_sql_" required="yes" type="string">
	<cfargument name="_tempTableName_" required="yes" type="string">
	<cfargument name="_parmsWithTypes_" required="yes" type="string">
	<cfargument name="_parmsWithNoTypes_" required="yes" type="string">

	<cfset var sql_ChooseWrapperWithResults = "">
	
	<cfsavecontent variable="sql_ChooseWrapperWithResults">
		<cfoutput>
			CREATE TABLE #_tempTableName_# (#_parmsWithTypes_#)
			
			INSERT INTO #_tempTableName_# (#_parmsWithNoTypes_#)
			VALUES (-1, '#Request.const_Choose_symbol#')
			
			INSERT INTO #_tempTableName_# (#_parmsWithNoTypes_#)
				#PreserveSingleQuotes(_sql_)#
			
			SELECT * FROM #_tempTableName_#

			DROP TABLE #_tempTableName_#
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn sql_ChooseWrapperWithResults>
</cffunction>
<!--- END! Common Code common to all AJAX apps --->


<cffunction name="objectLookUp">
	<cfargument name="_validTypes_" required="yes" type="string">

	<cfscript>
		var _where_clause = '';
		var j = -1;
		var _sql_statement = '';
		var _queryObj = '';
		var errorMsg = '';
	</cfscript>
	
	<cftry>
		<cfscript>
			j = ListFindNoCase(_validTypes_, 'validTypes', ',');
			if (j gt 0) {
				_validTypes_ = ListDeleteAt(_validTypes_, j, ',');
			}
			_where_clause = _where_clause & 'WHERE (objectClassID in (#_validTypes_#))';
		</cfscript>
	
		<cfsavecontent variable="sql_qGetClassesOfType">
			<cfoutput>
				SELECT className
				FROM objectClassDefinitions	
				#Request.const_replace_pattern#
				ORDER BY className
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = ReplaceNoCase(sql_qGetClassesOfType, Request.const_replace_pattern, _where_clause);
			Request.commonCode.safely_execSQL('Request.qGetObjectOfType', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>

	<cfreturn Request.qGetObjectOfType>
</cffunction>

<cffunction name="objectsLookUp">
	<cfargument name="_className_" required="yes" type="string">
	<cfargument name="_searchParm_" type="string" default="">

	<cfscript>
		var _where_clause = '';
		var j = -1;
		var _sql_statement = '';
		var _queryObj = '';
		var sql_GetObjectsForType = '';

		_where_clause = _where_clause & "WHERE (objectClassDefinitions.className = '#_className_#')";
		if (Len(_searchParm_) gt 0) {
			_where_clause = _where_clause & " AND (objects.objectName LIKE '%#Request.commonCode.filterQuotesForSQL(_searchParm_)#%')";
		}
	</cfscript>

	<cftry>
		<cfif 1>
			<cfsavecontent variable="sql_GetObjectsForType">
				<cfoutput>
					SELECT TOP 100 objects.id, objects.objectName
					FROM objects INNER JOIN
					     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
					#Request.const_replace_pattern#
					ORDER BY objects.objectName
				</cfoutput>
			</cfsavecontent>

			<cfset sql_qGetObjectsForType = sqlChooseWrapperWithResults(sql_GetObjectsForType, 'GetObjectsForTypeTemp', 'id int, objectName varchar(7000)', 'id, objectName')>
		<cfelse>
			<cfsavecontent variable="sql_qGetObjectsForType">
				<cfoutput>
					CREATE TABLE ##GetObjectsForTypeTemp (id int, objectName varchar(7000))
					
					INSERT INTO ##GetObjectsForTypeTemp (id, objectName)
					VALUES (-1, '#Request.const_Choose_symbol#')
					
					INSERT INTO ##GetObjectsForTypeTemp (id, objectName)
					SELECT TOP 100 objects.id, objects.objectName
					FROM objects INNER JOIN
					     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
					#Request.const_replace_pattern#
					ORDER BY objects.objectName
					
					SELECT * FROM ##GetObjectsForTypeTemp
		
					DROP TABLE ##GetObjectsForTypeTemp
				</cfoutput>
			</cfsavecontent>
		</cfif>

		<cfscript>
			_sql_statement = ReplaceNoCase(sql_qGetObjectsForType, Request.const_replace_pattern, _where_clause);
			Request.commonCode.safely_execSQL('Request.qGetObjectsForType', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
		
		<cfreturn Request.qGetObjectsForType>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="makeNewType">
	<cfargument name="_typeName_" required="yes" type="string">
	<cfargument name="_typePath_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qCheckForType = '';
		var sql_qInsertNewType = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qCheckForType">
			<cfoutput>
				SELECT objectClassID
				FROM objectClassDefinitions
				WHERE (className = '#_typeName_#')
			</cfoutput>
		</cfsavecontent>
	
		<cfsavecontent variable="sql_qInsertNewType">
			<cfoutput>
				INSERT INTO objectClassDefinitions
				            (className, classPath)
				VALUES ('#_typeName_#', '#_typePath_#');
				
				<cfinclude template="cfc/geonosisObject/cfinclude_qGetObjectTypes.cfm">
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qCheckForType;
			Request.commonCode.safely_execSQL('Request.qCheckForType', Request.DSN, _sql_statement);
			if ( (NOT Request.dbError) AND (IsDefined("Request.qCheckForType")) ) {
				if (Request.qCheckForType.recordCount eq 0) {
					// insert the new type because it does not yet exist...
					_sql_statement = sql_qInsertNewType;
					Request.commonCode.safely_execSQL('Request.qInsertNewType', Request.DSN, _sql_statement);
	
					if (Request.dbError) {
						_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
						return _queryObj;
					}
				}
			} else if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qCheckForType>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="makeNewObject">
	<cfargument name="_cid_" required="yes" type="string">
	<cfargument name="_cName_" required="yes" type="string">
	<cfargument name="_s_wwNewObjectName_" required="yes" type="string">
	<cfargument name="_s_wwNewPublishedVersion_" required="yes" type="string">
	<cfargument name="_s_wwNewEditVersion_" required="yes" type="string">
	<cfargument name="_s_wwNewCreatedBy_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qInsertNewObject = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qInsertNewObject">
			<cfoutput>
				INSERT INTO objects
				       (objectClassID, objectName, publishedVersion, editVersion, created, createdBy, updated)
				VALUES (#_cid_#,'#Request.commonCode.filterQuotesForSQL(_s_wwNewObjectName_)#',#_s_wwNewPublishedVersion_#,#_s_wwNewEditVersion_#,GetDate(),'#Request.commonCode.filterQuotesForSQL(_s_wwNewCreatedBy_)#',GetDate());
				<cfinclude template="cfc/geonosisObject/cfinclude_qGetAllObjects.cfm">
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qInsertNewObject;
			Request.commonCode.safely_execSQL('Request.qInsertNewObject', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qInsertNewObject>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetObjectToEdit">
	<cfargument name="_oid_" required="yes" type="string">
	<cfargument name="_oName_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qGetObjectToEdit = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetObjectToEdit">
			<cfoutput>
				SELECT *
				FROM objects
				WHERE (id = #_oid_#)
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetObjectToEdit;
			Request.commonCode.safely_execSQL('Request.qGetObjectToEdit', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetObjectToEdit>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="saveEditedObject">
	<cfargument name="_oid_" required="yes" type="string">
	<cfargument name="_cid_" required="yes" type="string">
	<cfargument name="_cName_" required="yes" type="string">
	<cfargument name="_s_wwNewObjectName_" required="yes" type="string">
	<cfargument name="_s_wwNewPublishedVersion_" required="yes" type="string">
	<cfargument name="_s_wwNewEditVersion_" required="yes" type="string">
	<cfargument name="_s_wwNewCreatedBy_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qUpdateAnObject = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qUpdateAnObject">
			<cfoutput>
				UPDATE objects
				SET objectClassID = #_cid_#, 
				objectName = '#Request.commonCode.filterQuotesForSQL(_s_wwNewObjectName_)#',
				publishedVersion = #_s_wwNewPublishedVersion_#,
				editVersion = #_s_wwNewEditVersion_#,
				updated = GetDate(),
				updatedBy = '#Request.commonCode.filterQuotesForSQL(_s_wwNewCreatedBy_)#'
				WHERE (id = #_oid_#)
				<cfinclude template="cfc/geonosisObject/cfinclude_qGetAllObjects.cfm">
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qUpdateAnObject;
			Request.commonCode.safely_execSQL('Request.qUpdateAnObject', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qUpdateAnObject>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformObjectLinker">
	<cfargument name="_ownerID_" required="yes" type="string">
	<cfargument name="_relatedID_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qGetObjectData = '';
		var sql_qMakeObjectLink = '';
		var sql_qCheckObjectLink = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetObjectData">
			<cfoutput>
				DECLARE @s_ownerPropertyName varchar(50)
				DECLARE @s_relatedPropertyName varchar(50)
				
				CREATE TABLE ##GetObjectDataTemp (ownerID int, ownerPropertyName varchar(50), relatedID int, relatedPropertyName varchar(50))
				
				SELECT @s_ownerPropertyName = (SELECT objectName FROM objects WHERE (id = #_ownerID_#))
				SELECT @s_relatedPropertyName = (SELECT objectName FROM objects WHERE (id = #_relatedID_#))
				
				INSERT INTO ##GetObjectDataTemp (ownerID, ownerPropertyName, relatedID, relatedPropertyName)
					VALUES (#_ownerID_#, @s_ownerPropertyName, #_relatedID_#, @s_relatedPropertyName)
					
				SELECT * FROM ##GetObjectDataTemp
				
				DROP TABLE ##GetObjectDataTemp
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetObjectData;
			Request.commonCode.safely_execSQL('Request.qGetObjectData', Request.DSN, _sql_statement);
		</cfscript>
		
		<cfif (Request.dbError)>
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			</cfscript>
		<cfelse>
			<cfsavecontent variable="sql_qCheckObjectLink">
				<cfoutput>
					SELECT id, ownerPropertyName, relatedPropertyName
					FROM objectLinks
					WHERE (ownerId = #Request.qGetObjectData.ownerID#) AND (relatedId = #Request.qGetObjectData.relatedID#)
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qCheckObjectLink;
				Request.commonCode.safely_execSQL('Request.qCheckObjectLink', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif ( (NOT Request.dbError) AND (IsDefined("Request.qCheckObjectLink")) )>
				<cfif (Request.qCheckObjectLink.recordCount eq 0)>
					<cfsavecontent variable="sql_qMakeObjectLink">
						<cfoutput>
							INSERT INTO objectLinks
							       (ownerId, relatedId, ownerPropertyName, relatedPropertyName, ownerAutoload, relatedAutoload, displayOrder, startVersion, lastVersion, created, 
							       createdBy, updated)
							VALUES (#Request.qGetObjectData.ownerID#,#Request.qGetObjectData.relatedID#,'#Request.commonCode.filterQuotesForSQL(Request.qGetObjectData.ownerPropertyName)#','#Request.commonCode.filterQuotesForSQL(Request.qGetObjectData.relatedPropertyName)#',0,0,0,0,0,GetDate(),'#Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn)#',GetDate());
							<cfinclude template="cfc/geonosisObject/cfinclude_qGetAllObjectLinks.cfm">
						</cfoutput>
					</cfsavecontent>
				<cfelse>
					<cfset _queryObj = Request.commonCode.sql_ErrorMessage(-999, 'ERROR...', 'Cannot Link two Objects that are already linked.')>
					<cfreturn _queryObj>
				</cfif>
			<cfelse>
				<cfset _queryObj = Request.commonCode.sql_ErrorMessage(-999, 'ERROR...', 'There seems to be a problem with the database.')>
				<cfreturn _queryObj>
			</cfif>
			
			<cfscript>
				_sql_statement = sql_qMakeObjectLink;
				Request.commonCode.safely_execSQL('Request.qMakeObjectLink', Request.DSN, _sql_statement);
				
				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				}
			</cfscript>
		</cfif>
	
		<cfreturn Request.qMakeObjectLink>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformCreateAttribute">
	<cfargument name="_objectID_" required="yes" type="string">
	<cfargument name="_objName_" required="yes" type="string">
	<cfargument name="_objValue_" required="yes" type="string">
	<cfargument name="_objBy_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var sql_qMakeAttribute = '';
		var sql_qMakeAttributeVerify = '';
		var _sql_statement = '';
	</cfscript>

	<cftry>
		<cfset _objValue_ = URLDecode(_objValue_)>
		<cfif (Len(_objValue_) gt 7000)>
			<cfsavecontent variable="sql_qMakeAttribute">
				<cfoutput>
					INSERT INTO objectAttributes
					       (objectID, attributeName, valueText, displayOrder, startVersion, lastVersion, created, createdBy, updated)
					VALUES (#_objectID_#,'#Request.commonCode.filterQuotesForSQL(_objName_)#','#Request.commonCode.filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#Request.commonCode.filterQuotesForSQL(_objBy_)#',GetDate());
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfsavecontent variable="sql_qMakeAttribute">
				<cfoutput>
					INSERT INTO objectAttributes
					       (objectID, attributeName, valueString, displayOrder, startVersion, lastVersion, created, createdBy, updated)
					VALUES (#_objectID_#,'#Request.commonCode.filterQuotesForSQL(_objName_)#','#Request.commonCode.filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#Request.commonCode.filterQuotesForSQL(_objBy_)#',GetDate());
				</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfsavecontent variable="sql_qMakeAttributeVerify">
			<cfoutput>
				SELECT TOP 100 *
				FROM objectAttributes
				WHERE (objectID = #_objectID_#)
				ORDER BY attributeName
			</cfoutput>
		</cfsavecontent>
		
		<cfscript>
			_sql_statement = sql_qMakeAttribute & sql_qMakeAttributeVerify;
			Request.commonCode.safely_execSQL('Request.qMakeAttribute', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qMakeAttribute>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetAllAttributesForObject">
	<cfargument name="_objectID_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetAttributesForObject = '';
		var sql_GetAttributesForObject = '';
	</cfscript>

	<cftry>
		<cfif 1>
			<cfsavecontent variable="sql_GetAttributesForObject">
				<cfoutput>
					SELECT TOP 100 id, attributeName
					FROM objectAttributes
					WHERE (objectID = #_objectID_#)
					ORDER BY attributeName
				</cfoutput>
			</cfsavecontent>

			<cfset sql_qGetAttributesForObject = sqlChooseWrapperWithResults(sql_GetAttributesForObject, 'GetAllAttributesForObjectTemp', 'id int, attributeName varchar(7000)', 'id, attributeName')>
		<cfelse>
			<cfsavecontent variable="sql_qGetAttributesForObject">
				<cfoutput>
					CREATE TABLE ##GetAllAttributesForObjectTemp (id int, attributeName varchar(7000))
					
					INSERT INTO ##GetAllAttributesForObjectTemp (id, attributeName)
					VALUES (-1, '#Request.const_Choose_symbol#')
					
					INSERT INTO ##GetAllAttributesForObjectTemp (id, attributeName)
						SELECT TOP 100 id, attributeName
						FROM objectAttributes
						WHERE (objectID = #_objectID_#)
						ORDER BY attributeName
					
					SELECT * FROM ##GetAllAttributesForObjectTemp
					
					DROP TABLE ##GetAllAttributesForObjectTemp
				</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfscript>
			_sql_statement = sql_qGetAttributesForObject;
			Request.commonCode.safely_execSQL('Request.qGetAttributesForObject', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetAttributesForObject>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="CheckObjectLinkerValidity">
	<cfargument name="_objectID1_" required="yes" type="string">
	<cfargument name="_objectID2_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qCheckObjectLinkerValidity = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qCheckObjectLinkerValidity">
			<cfoutput>
				SELECT id
				FROM objectLinks
				WHERE ( (ownerId = #_objectID1_#) AND (relatedId = #_objectID2_#) ) OR ( (ownerId = #_objectID2_#) AND (relatedId = #_objectID1_#) )
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qCheckObjectLinkerValidity;
			Request.commonCode.safely_execSQL('Request.qCheckObjectLinkerValidity', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qCheckObjectLinkerValidity>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetAttributeToEdit">
	<cfargument name="_aid_" required="yes" type="string">
	<cfargument name="_aName_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetAttributeToEdit = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetAttributeToEdit">
			<cfoutput>
				SELECT *
				FROM objectAttributes
				WHERE (id = #_aid_#)
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetAttributeToEdit;
			Request.commonCode.safely_execSQL('Request.qGetAttributeToEdit', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetAttributeToEdit>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="performSaveAttribute">
	<cfargument name="_objectID_" required="yes" type="string">
	<cfargument name="_attrID_" required="yes" type="string">
	<cfargument name="_objName_" required="yes" type="string">
	<cfargument name="_objValue_" required="yes" type="string">
	<cfargument name="_objBy_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qSaveAttribute = '';
		var sql_qSaveAttributeVerify = '';
	</cfscript>

	<cftry>
		<cfset _objValue_ = URLDecode(_objValue_)>
		<cfsavecontent variable="sql_qSaveAttribute">
			<cfoutput>
				UPDATE objectAttributes
				SET attributeName = '#Request.commonCode.filterQuotesForSQL(_objName_)#', 
					<cfif (Len(_objValue_) gt 7000)>
						valueString = '', 
						valueText = '#Request.commonCode.filterQuotesForSQL(_objValue_)#', 
					<cfelse>
						valueString = '#Request.commonCode.filterQuotesForSQL(_objValue_)#', 
						valueText = '', 
					</cfif>
					updated = GetDate(), 
					updatedBy = '#Request.commonCode.filterQuotesForSQL(_objBy_)#'
				WHERE (id = #_attrID_#)
			</cfoutput>
		</cfsavecontent>

		<cfsavecontent variable="sql_SaveAttributeVerify">
			<cfoutput>
				SELECT TOP 100 id, attributeName
				FROM objectAttributes
				WHERE (objectID = #_objectID_#)
				ORDER BY attributeName
			</cfoutput>
		</cfsavecontent>
		
		<cfset sql_qSaveAttributeVerify = sqlChooseWrapperWithResults(sql_SaveAttributeVerify, 'GetSaveAttributeVerifyTemp', 'id int, attributeName varchar(7000)', 'id, attributeName')>

		<cfscript>
			_sql_statement = sql_qSaveAttribute & sql_qSaveAttributeVerify;
			Request.commonCode.safely_execSQL('Request.qSaveAttribute', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qSaveAttribute>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformAttributeCreatorSearch">
	<cfargument name="_objectID_" required="yes" type="string">
	<cfargument name="_searchPattern_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetAttributesNamed = '';
		var sql_GetAttributesNamed = '';
	</cfscript>

	<cftry>
		<cfif 1>
			<cfsavecontent variable="sql_GetAttributesNamed">
				<cfoutput>
					SELECT id, attributeName
					FROM objectAttributes
					WHERE (objectID = #_objectID_#) AND (attributeName LIKE '%#Request.commonCode.filterQuotesForSQL(_searchPattern_)#%')
					ORDER BY attributeName
				</cfoutput>
			</cfsavecontent>

			<cfset sql_qGetAttributesNamed = sqlChooseWrapperWithResults(sql_GetAttributesNamed, 'GetAttributesNamedTemp', 'id int, attributeName varchar(7000)', 'id, attributeName')>
		<cfelse>
			<cfsavecontent variable="sql_qGetAttributesNamed">
				<cfoutput>
					CREATE TABLE ##GetAttributesNamedTemp (id int, attributeName varchar(7000))
					
					INSERT INTO ##GetAttributesNamedTemp (id, attributeName)
					VALUES (-1, '#Request.const_Choose_symbol#')
					
					INSERT INTO ##GetAttributesNamedTemp (id, attributeName)
						SELECT id, attributeName
						FROM objectAttributes
						WHERE (objectID = #_objectID_#) AND (attributeName LIKE '%#Request.commonCode.filterQuotesForSQL(_searchPattern_)#%')
						ORDER BY attributeName
					
					SELECT * FROM ##GetAttributesNamedTemp
		
					DROP TABLE ##GetAttributesNamedTemp
				</cfoutput>
			</cfsavecontent>
		</cfif>
	
		<cfscript>
			_sql_statement = sql_qGetAttributesNamed;
			Request.commonCode.safely_execSQL('Request.qGetAttributesNamed', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetAttributesNamed>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetLinkableTypes">

	<cfscript>
		var _sql_statement = '';
		var sql_qGetLinkableTypes = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetLinkableTypes">
			<cfoutput>
				<cfinclude template="cfc/geonosisObject/cfinclude_qGetObjectTypes.cfm">
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetLinkableTypes;
			Request.commonCode.safely_execSQL('Request.qGetLinkableTypes', Request.DSN, _sql_statement);
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			} else {
				_sql_statement = "SELECT * FROM Request.qGetLinkableTypes WHERE (cnt > 0)";
				Request.commonCode.safely_execSQL('Request.qGetActualLinkableTypes', '', _sql_statement);
				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				} else {
					return Request.qGetActualLinkableTypes;
				}
			}
		</cfscript>
	
		<cfreturn Request.qGetLinkableTypes>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetObjectLinkFromID">
	<cfargument name="_objectLinkID_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetObjectLinkFromID = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetObjectLinkFromID">
			<cfoutput>
				SELECT id, ownerId, relatedId, ownerPropertyName, relatedPropertyName, ownerAutoload, relatedAutoload, displayOrder, startVersion, lastVersion, created, 
				       createdBy, updated, updatedBy
				FROM objectLinks
				WHERE (id = #_objectLinkID_#)
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetObjectLinkFromID;
			Request.commonCode.safely_execSQL('Request.qGetObjectLinkFromID', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetObjectLinkFromID>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformSaveLinkObject">
	<cfargument name="_objectLinkID_" required="yes" type="string">
	<cfargument name="_sOWNERPROPERTYNAME_" required="yes" type="string">
	<cfargument name="_sRELATEDPROPERTYNAME_" required="yes" type="string">
	<cfargument name="_sOWNERAUTOLOAD_" required="yes" type="string">
	<cfargument name="_sRELATEDAUTOLOAD_" required="yes" type="string">
	<cfargument name="_sDISPLAYORDER_" required="yes" type="string">
	<cfargument name="_sSTARTVERSION_" required="yes" type="string">
	<cfargument name="_sLASTVERSION_" required="yes" type="string">
	<cfargument name="_sCREATEDBY_UPDATEDBY_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetObjectLinkFromID = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qUpdateObjectLinkFromID">
			<cfoutput>
				UPDATE objectLinks
				SET ownerPropertyName = '#_sOWNERPROPERTYNAME_#', 
					relatedPropertyName = '#_sRELATEDPROPERTYNAME_#', 
					ownerAutoload = #_sOWNERAUTOLOAD_#, 
					relatedAutoload = #_sRELATEDAUTOLOAD_#, 
					displayOrder = #_sDISPLAYORDER_#, 
					startVersion = #_sSTARTVERSION_#, 
					lastVersion = #_sLASTVERSION_#, 
					updated = GetDate(), 
				    updatedBy = '#_sCREATEDBY_UPDATEDBY_#'
				WHERE (id = #_objectLinkID_#);
				
				SELECT * FROM objectLinks
				WHERE (id = #_objectLinkID_#);
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qUpdateObjectLinkFromID;
			Request.commonCode.safely_execSQL('Request.qUpdateObjectLinkFromID', Request.DSN, _sql_statement);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qUpdateObjectLinkFromID>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetDbSchemaForTable">
	<cfargument name="_tableName_" required="yes" type="string">

	<cfscript>
		var _queryObj = -1;
		var _sql_statement = '';
		var sql_qGetDbSchemaForTable = '';
	</cfscript>

	<cftry>
		<cfscript>
			GetDbSchemaForTable(_tableName_);
	
			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}
		</cfscript>
	
		<cfreturn Request.qGetDbSchemaForTable>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformObjectLinkerDeleteLink">
	<cfargument name="_ID_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qDeleteObjectLink = '';
		var sql_qCheckObjectLink = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qDeleteObjectLink">
			<cfoutput>
				DELETE FROM objectLinks
				WHERE (id = #_ID_#)
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qDeleteObjectLink;
			Request.commonCode.safely_execSQL('Request.qDeleteObjectLink', Request.DSN, _sql_statement);
		</cfscript>
		
		<cfif (Request.dbError)>
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			</cfscript>
		<cfelse>
			<cfsavecontent variable="sql_qCheckObjectLink">
				<cfoutput>
					<cfinclude template="cfc/geonosisObject/cfinclude_qGetAllObjectLinks.cfm">
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qCheckObjectLink;
				Request.commonCode.safely_execSQL('Request.qCheckObjectLink', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfset _queryObj = Request.commonCode.sql_ErrorMessage(-999, 'ERROR...', 'There seems to be a problem with the database.')>
				<cfreturn _queryObj>
			</cfif>
		</cfif>
	
		<cfreturn Request.qCheckObjectLink>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformDeleteObjectsAttribute">
	<cfargument name="_attributeID_" required="yes" type="string">
	<cfargument name="_objectID_" type="string" default="">

	<cfscript>
		var _sql_statement = '';
		var _queryObj = '';
		var sql_GetAttributesForObject = '';
		var sql_qGetAttributesForObject = '';
	</cfscript>

	<cftry>
		<cfscript>
			Request.commonCode.GeonosisDeleteObjectsAttribute(_attributeID_);
		</cfscript>
		
		<cfif (Request.dbError)>
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			</cfscript>
		</cfif>

		<cfif (Len(_objectID_) gt 0)>
			<cfsavecontent variable="sql_GetAttributesForObject">
				<cfoutput>
					SELECT TOP 100 id, attributeName
					FROM objectAttributes
					WHERE (objectID = #_objectID_#)
					ORDER BY attributeName
				</cfoutput>
			</cfsavecontent>

			<cfset sql_qGetAttributesForObject = sqlChooseWrapperWithResults(sql_GetAttributesForObject, 'GetAllAttributesForObjectTemp', 'id int, attributeName varchar(7000)', 'id, attributeName')>

			<cfscript>
				_sql_statement = sql_qGetAttributesForObject;
				Request.commonCode.safely_execSQL('Request.qCheckObjectsAttribute', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfset _queryObj = Request.commonCode.sql_ErrorMessage(-999, 'ERROR...', 'There seems to be a problem with the database.')>
				<cfreturn _queryObj>
			</cfif>
		</cfif>
	
		<cfreturn Request.qCheckObjectsAttribute>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformDeleteObject">
	<cfargument name="_objectID_" required="yes" type="string">
	<cfargument name="_bool_" type="boolean" default="true">

	<cfscript>
		var _sql_statement = '';
		var _queryObj = '';
		var sql_GetAllObjects = '';
	</cfscript>

	<cftry>
		<cfscript>
			Request.commonCode.GeonosisPerformDeleteObject(_objectID_);
		</cfscript>
		
		<cfif (Request.dbError)>
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			</cfscript>
		</cfif>

		<cfif (_bool_)>
			<cfsavecontent variable="sql_qGetAllObjects">
				<cfoutput>
					<cfinclude template="cfc/geonosisObject/cfinclude_qGetAllObjects.cfm">
				</cfoutput>
			</cfsavecontent>

			<cfscript>
				_sql_statement = sql_qGetAllObjects;
				Request.commonCode.safely_execSQL('Request.qGetAllObjects', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfset _queryObj = Request.commonCode.sql_ErrorMessage(-999, 'ERROR...', 'There seems to be a problem with the database.')>
				<cfreturn _queryObj>
			</cfif>
		</cfif>
	
		<cfreturn Request.qGetAllObjects>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="GetVerificatonForObjectDelete">
	<cfargument name="_objectID_" required="yes" type="string">

	<cfscript>
		var _sql_statement = '';
		var sql_qGetVForObjectDelete = '';
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfsavecontent variable="sql_qGetVForObjectDelete">
			<cfoutput>
				DECLARE @cnt_links as int
				SELECT @cnt_links = (SELECT COUNT(id) AS cnt FROM objectLinks WHERE (ownerId = #_objectID_#) OR (relatedId = #_objectID_#))
				
				DECLARE @cnt_attrs as int
				SELECT @cnt_attrs = (SELECT COUNT(id) AS cnt FROM objectAttributes WHERE (objectID = #_objectID_#))
				
				SELECT @cnt_links as 'cnt_links', @cnt_attrs as 'cnt_attrs', (@cnt_links + @cnt_attrs) as 'cnt_total'
			</cfoutput>
		</cfsavecontent>
	
		<cfscript>
			_sql_statement = sql_qGetVForObjectDelete;
			Request.commonCode.safely_execSQL('Request.qGetVForObjectDelete', Request.DSN, _sql_statement);
		</cfscript>
		
		<cfif (Request.dbError)>
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			</cfscript>
		</cfif>
	
		<cfreturn Request.qGetVForObjectDelete>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="DetermineUserLogInState">
	<cfscript>
		var _queryObj = '';
		var bool_isUserLoggedIn = false;
	</cfscript>

	<cftry>
		<cfscript>
			if (IsDefined("Client.bool_isUserLoggedIn")) {
				bool_isUserLoggedIn = Client.bool_isUserLoggedIn;
			}
			_queryObj = QueryNew('id, LOGIN_STATE');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'LOGIN_STATE', bool_isUserLoggedIn, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformUserLogIn">
	<cfargument name="_sUserName_" required="yes" type="string">
	<cfargument name="_sPassword_" required="yes" type="string">

	<cfscript>
		var data = -1;
		var _queryObj = '';
		var _password = '';
		var _sql_statement = '';
		var bool_isError = false;
		var bool_isUserLoggedIn = false;
	</cfscript>

	<cftry>
		<cfscript>
			if ( (UCASE(_sUserName_) eq UCASE(Request.const_superUser_account)) AND (UCASE(_sPassword_) eq UCASE(Request.const_superUser_password)) ) {
				Client.bool_isUserLoggedIn = true;
				Client.userNameLoggedIn = _sUserName_;
			} else {
				_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles("WHERE (username = '#_sUserName_#') AND ( (Len(begindt) = 0) OR (begindt <= GetDate()) ) AND ( (Len(enddt) = 0) OR (GetDate() <= enddt) ) AND (Len(password) > 0)");
				Request.commonCode.GeonosisExecSQL('qGetValidUserObjectForNamedUser', _sql_statement);

				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				}
				
			//	Request.commonCode.cf_log(Application.applicationname, 'Information', 'DEBUG: [#_sql_statement#], [#Request.dbError#], [#Request.qGetValidUserObjectForNamedUser.recordCount#]');

				if (IsQuery(Request.qGetValidUserObjectForNamedUser)) {
					if (Request.qGetValidUserObjectForNamedUser.recordCount eq 1) {
						data = Request.commonCode.decodeEncodedEncryptedString(URLDecode(Request.qGetValidUserObjectForNamedUser.password));
						if (IsDefined("data.plaintext")) {
							_password = data.plaintext;
						} else {
							bool_isError = true;
						}

					//	Request.commonCode.cf_log(Application.applicationname, 'Information', 'DEBUG: [bool_isError=#bool_isError#], [_sUserName_=#_sUserName_#], [q.username=#Request.qGetValidUserObjectForNamedUser.username#], [_password=#_password#], [#URLDecode(Request.qGetValidUserObjectForNamedUser.password)#], [#Request.commonCode.explainStruct(data, false)#]');
						
						if ( (UCASE(_sUserName_) eq UCASE(Request.qGetValidUserObjectForNamedUser.username)) AND (_sPassword_ eq _password) ) {
							Client.bool_isUserLoggedIn = true;
							Client.userNameLoggedIn = _sUserName_;
						}
					} else {
						// +To-Do: email the user and tell them their password has not been activated yet and that someone attempted to log-in...
					}
				}
			}
			
			if (IsDefined("Client.bool_isUserLoggedIn")) {
				bool_isUserLoggedIn = Client.bool_isUserLoggedIn;
			}
			_queryObj = QueryNew('id, LOGIN_STATE');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'LOGIN_STATE', bool_isUserLoggedIn, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformUserLogoff">
	<cfscript>
		var _queryObj = '';
		var bool_isUserLoggedIn = false;
	</cfscript>

	<cftry>
		<cfscript>
			Client.bool_isUserLoggedIn = false;
			Client.userNameLoggedIn = '';

			_queryObj = QueryNew('id, LOGIN_STATE');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'LOGIN_STATE', bool_isUserLoggedIn, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformRetrievePassword">
	<cfargument name="_sUserName_" required="yes" type="string">
	<cfargument name="_bUsageFlag_" type="boolean" default="False">  <!--- _bUsageFlag_ when True causes an Activation message to be sent whenever a new user account is found in the Database, else False means use the default behavior of Forgot Password. --->

	<cfscript>
		var _queryObj = '';
		var sPassword = '';
		var mailError = false;
		var errorMsg = '';

		var sEmailReason = '';
		var sEmailSubject = '';
	</cfscript>

	<cfscript>
		if (UCASE(_sUserName_) eq UCASE(Request.const_superUser_account)) {
			sPassword = Request.const_superUser_password;
		}
		
		if (_bUsageFlag_) {
			sEmailSubject = 'A new #Request.const_productName_symbol# User Account has been created for you which you must activate.';
			sEmailReason = 'A new user account has been created for you which you must activate prior to being able to login and use it';
		} else {
			sEmailSubject = 'This is your #Request.const_productName_symbol# password, as requested.';
			sEmailReason = 'You have requested to retrieve your password from our server(s)';
		}
	</cfscript>

	<cfsavecontent variable="_html">
		<cfoutput>
			This email was sent from #Request.const_trademark_symbol#.<br>
			<br>
			#sEmailReason# however due to security concerns we cannot send your password to you as doing so might allow others to intercept your password.<br>
			<br>
			<UL>
				<LI><b>Click on the Change Password Link below.</b></LI>
				<LI><b>Enter and confirm your new password.</b></LI>
				<LI><b>Click the [Submit] button.</b></LI>
			</UL>
			<br>
			<a href="#Request.commonCode.fullyQualifiedURLPrefix()#/changePassword.cfm?emailAddress=#URLEncodedFormat(Request.commonCode.encodedEncryptedString(_sUserName_))#" target="_blank"><b>Change Password</b></a>
			<br><br>
			In case you have received this email in error you may cancel your User Account by clicking <a href="#Request.commonCode.fullyQualifiedURLPrefix()#/terminateAccount.cfm?emailAddress=#URLEncodedFormat(Request.commonCode.encodedEncryptedString(_sUserName_))#" target="_blank"><b>here</b></a>.
			<br><br>
			Thank you.<br>
			<br><br>
			The #Request.const_trademark_symbol# Server Support Team.
		</cfoutput>
	</cfsavecontent>

	<cfif (Request.bool_isDevServer)>
		<cfset path = GetDirectoryFromPath(GetBaseTemplatePath())>
		<cfset path = path & 'emails\' & ListGetAt(path, ListLen(path, '\'), '\')>
		<cfscript>
			Request.commonCode.ensureDirectoryTreeExists(path);
		</cfscript>
		<cffile action="WRITE" file="#path & '\' & ReplaceList(_sUserName_, '@,.', '_,_') & '_email.html'#" output="#_html#" attributes="Normal" addnewline="Yes" fixnewline="No">
	</cfif>
	
	<cfif (Request.bool_isDevUser)>
		<cftry>
			<cfmail to="#_sUserName_#" from="raychorn@sbcglobal.net" subject="#sEmailSubject#" replyto="do-not-reply@contentopia.net" type="HTML">
				#_html#
			</cfmail>
	
			<cfcatch>
				<cfset mailError = true>
			</cfcatch>
		</cftry>
	</cfif>

	<cftry>
		<cfscript>
			_queryObj = QueryNew('id, password, mailError');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'password', sPassword, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'mailError', mailError, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformSetNewPassword">
	<cfargument name="_sUserName_" required="yes" type="string">
	<cfargument name="_sNewPassword_" required="yes" type="string">
	<cfargument name="_sConfirmPassword_" required="yes" type="string">

	<cfscript>
		var _queryObj = '';
		var errorMsg = '';
		var hasPasswordBeenSet = false;
		var _sql_statement = '';
		var bool_accepted = true;
	</cfscript>

	<cfif (0)>
		<cflog file="#Application.applicationname#" type="Information" text="(PerformSetNewPassword.1) [_sUserName_=#_sUserName_#], [_sNewPassword_=#_sNewPassword_#], [_sConfirmPassword_=#_sConfirmPassword_#]">
	</cfif>
	
	<cfscript>
		if (_sNewPassword_ eq _sConfirmPassword_) {
			_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles("WHERE ( (Len(begindt) = 0) OR (begindt <= GetDate()) ) AND ( (Len(enddt) = 0) OR (GetDate() <= enddt) ) AND (username = '#_sUserName_#')");

			Request.commonCode.GeonosisExecSQL('qGetValidUserObjectForNamedUser', _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

			if (IsQuery(Request.qGetValidUserObjectForNamedUser)) {
				if (Request.qGetValidUserObjectForNamedUser.recordCount eq 1) {
					// we now have the record id we need to modify... (Request.qGetValidUserObjectForNamedUser.passwordaid is the attribute id for the password record or -1 if it is null)
					if (IsDefined("Request.qGetValidUserObjectForNamedUser.passwordaid")) {
						if (Request.qGetValidUserObjectForNamedUser.passwordaid neq -1) {
							_queryObj = Request.commonCode.GeonosisModifyAttrValue(Request.qGetValidUserObjectForNamedUser.passwordaid, URLEncodedFormat(Request.commonCode.encodedEncryptedString(_sNewPassword_))); // store the password as an encrypted string...

							if (Request.dbError) {
								return _queryObj;
							} else {
								hasPasswordBeenSet = true;
							}
						} else {
							// make the password attributes as it is missing...
							_queryObj = Request.commonCode.GeonosisCreateAttributeForLoggedInUserIfPossible(Request.const_UserPassword_symbol, Request.qGetValidUserObjectForNamedUser.id, URLEncodedFormat(Request.commonCode.encodedEncryptedString(_sNewPassword_)));
			
							if (Request.dbError) {
								return _queryObj;
							} else {
								hasPasswordBeenSet = true;
							}
						}
					} else {
						// make the password attributes as it is missing...
						_queryObj = Request.commonCode.GeonosisCreateAttributeForLoggedInUserIfPossible(Request.const_UserPassword_symbol, Request.qGetValidUserObjectForNamedUser.id, URLEncodedFormat(Request.commonCode.encodedEncryptedString(_sNewPassword_)));
		
						if (Request.dbError) {
							return _queryObj;
						} else {
							hasPasswordBeenSet = true;
						}
					}
					
					if (hasPasswordBeenSet) {
						_queryObj = Request.commonCode.GeonosisCreateAttributeForLoggedInUserIfPossible(Request.const_UserPasswordDate_symbol, Request.qGetValidUserObjectForNamedUser.id, Request.commonCode.formattedDateTimeTZ(Now()));
		
						if (Request.dbError) {
							return _queryObj;
						}
					}
				}
			}
		} else {
			errorMsg = 'Both passwords entered must match however they do not at this time.  PLS try again.';
			_queryObj = Request.commonCode.sql_ErrorMessage(-990, 'Data Validation ERROR...', URLEncodedFormat(errorMsg));
			return _queryObj;
		}
	</cfscript>

	<cfif 0>
		<cflog file="#Application.applicationname#" type="Information" text="(PerformSetNewPassword.1) [_sUserName_=#_sUserName_#], [_sNewPassword_=#_sNewPassword_#], [_sConfirmPassword_=#_sConfirmPassword_#]">
	</cfif>
	
	<cftry>
		<cfscript>
			_queryObj = QueryNew('id, isPasswordAccepted');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'isPasswordAccepted', bool_accepted, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfif 0>
				<cflog file="#Application.applicationname#" type="Error" text="(PerformSetNewPassword) [#errorMsg#]">
			</cfif>
			
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="AddNewRole2RoleManager">
	<cfargument name="_sRoleName_" required="yes" type="string">

	<cfscript>
		var _queryObj = '';
		var _objectClassID = -1;
		var sql_qGetAllRolesForUser = '';
		var sql_qIsProposedRoleUnique = '';
		var sql_qEnsureRoleClassExists = '';
		var sql_qInsertRoleClass = '';
		var sql_qInsertRoleObject = '';
		var bool_allowLogging = false;
	</cfscript>

	<cfsavecontent variable="sql_qGetAllRolesForUser">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					#Request.commonCode.sql_GetAllRolesForUser()#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfsavecontent variable="sql_qIsProposedRoleUnique">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					#PreserveSingleQuotes(sql_qGetAllRolesForUser)#
						AND (objects.objectName = '#_sRoleName_#')
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	
	<cfsavecontent variable="sql_qEnsureRoleClassExists">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					SELECT objectClassID
					FROM objectClassDefinitions
					WHERE (className = '#Request.const_GeonosisROLES_symbol#')
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="sql_qInsertRoleClass">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					INSERT INTO objectClassDefinitions
					       (className, classPath)
					VALUES ('#Request.const_GeonosisROLES_symbol#','#Request.const_GeonosisROLES_symbol#');
					SELECT @@IDENTITY as 'objectClassID';
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="sql_qInsertRoleObject">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					INSERT INTO objects
					       (objectClassID, objectName, publishedVersion, editVersion, created, createdBy, updated, updatedBy)
					VALUES (#Request.const_replace_pattern#,'#_sRoleName_#',0,0,GetDate(),'#Client.userNameLoggedIn#',GetDate(),'#Client.userNameLoggedIn#');
					#PreserveSingleQuotes(sql_qGetAllRolesForUser)#
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cftry>
		<cfscript>
			if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (AddNewRole2RoleManager->#_sRoleName_#) Len(Trim(sql_qIsProposedRoleUnique)) = [' & Len(Trim(sql_qIsProposedRoleUnique)) & ']');

			if (Len(Trim(sql_qIsProposedRoleUnique)) gt 0) {
				_sql_statement = sql_qIsProposedRoleUnique;
				Request.commonCode.safely_execSQL('Request.qIsProposedRoleUnique', Request.DSN, _sql_statement);
	
				if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '2.0 (AddNewRole2RoleManager->#_sRoleName_#) _sql_statement = [' & _sql_statement & ']' & ', Request.dbError = [' & Request.dbError & ']');
		
				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (AddNewRole2RoleManager.1)', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				}
	
				if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '3.0 (AddNewRole2RoleManager->#_sRoleName_#)' & ', IsQuery(Request.qIsProposedRoleUnique) = [' & IsQuery(Request.qIsProposedRoleUnique) & ']');

				if (IsQuery(Request.qIsProposedRoleUnique)) {
					if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '3.1 (AddNewRole2RoleManager->#_sRoleName_#)' & ', Request.qIsProposedRoleUnique.recordCount = [' & Request.qIsProposedRoleUnique.recordCount & ']');
					if (Request.qIsProposedRoleUnique.recordCount eq 0) {
						_sql_statement = sql_qEnsureRoleClassExists;
						Request.commonCode.safely_execSQL('Request.qEnsureRoleClassExists', Request.DSN, _sql_statement);

						if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '4.0 (AddNewRole2RoleManager->#_sRoleName_#) _sql_statement = [' & _sql_statement & ']' & ', Request.dbError = [' & Request.dbError & ']');
	
						if (Request.dbError) {
							_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (AddNewRole2RoleManager.2)', URLEncodedFormat(Request.moreErrorMsg));
							return _queryObj;
						} else if (IsQuery(Request.qEnsureRoleClassExists)) {
							_objectClassID = -1; // establish the default in case of an error...

							if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '4.1 (AddNewRole2RoleManager->#_sRoleName_#)' & ', Request.qEnsureRoleClassExists.recordCount = [' & Request.qEnsureRoleClassExists.recordCount & ']');
							if (Request.qEnsureRoleClassExists.recordCount eq 0) {
								_sql_statement = sql_qInsertRoleClass;
								Request.commonCode.safely_execSQL('Request.qInsertRoleClass', Request.DSN, _sql_statement);

								if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '5.0 (AddNewRole2RoleManager->#_sRoleName_#) _sql_statement = [' & _sql_statement & ']' & ', Request.dbError = [' & Request.dbError & ']');

								if (Request.dbError) {
									_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (AddNewRole2RoleManager.2)', URLEncodedFormat(Request.moreErrorMsg));
									return _queryObj;
								} else if (Request.qInsertRoleClass.recordCount gt 0) {
									_objectClassID = Request.qInsertRoleClass.objectClassID;
								}
							} else {
								_objectClassID = Request.qEnsureRoleClassExists.objectClassID;
							}

							if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '5.2 (AddNewRole2RoleManager->#_sRoleName_#)' & ', _objectClassID = [' & _objectClassID & ']');

							if (_objectClassID gt 0) {
								_sql_statement = Replace(sql_qInsertRoleObject, Request.const_replace_pattern, _objectClassID);
								Request.commonCode.safely_execSQL('Request.qInsertRoleObject', Request.DSN, _sql_statement);
	
								if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '6.0 (AddNewRole2RoleManager->#_sRoleName_#) _sql_statement = [' & _sql_statement & ']' & ', Request.dbError = [' & Request.dbError & ']');
	
								if (Request.dbError) {
									_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (AddNewRole2RoleManager.4)', URLEncodedFormat(Request.moreErrorMsg));
									return _queryObj;
								}
								
								return Request.qInsertRoleObject;
							}
						} else {
							_queryObj = Request.commonCode.sql_ErrorMessage(-990, 'SQL Db ERROR... (AddNewRole2RoleManager.6)', URLEncodedFormat('Database general failure - cannot obtain a Query Object from the Database.'));
							return _queryObj;
						}
					} else {
						_queryObj = Request.commonCode.sql_ErrorMessage(-1, 'Primary Key Constraint Violation...', URLEncodedFormat('Cannot create a duplicate Role Name using the supplied value of "#_sRoleName_#".'));
						return _queryObj;
					}
				} else {
					_queryObj = Request.commonCode.sql_ErrorMessage(-990, 'SQL Db ERROR... (AddNewRole2RoleManager.7)', URLEncodedFormat('Database general failure - cannot obtain a Query Object from the Database.'));
					return _queryObj;
				}
				return Request.qIsProposedRoleUnique;
			} else {
				_queryObj = Request.commonCode.sql_ErrorMessage(-990, 'SQL Formation ERROR... (AddNewRole2RoleManager.A)', URLEncodedFormat('Cannot form the proper SQL Statement due to a login failure - kindly logoff and login to correct this problem.'));
				return _queryObj;
			}

			if (bool_allowLogging) Request.commonCode.cf_log(Application.applicationname, 'Information', '10.0 (AddNewRole2RoleManager->#_sRoleName_#)');
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="RemoveRoleFromRoleManager">
	<cfargument name="_objectID_" required="yes" type="string">

	<cfscript>
		var _queryObj = '';
	</cfscript>

	<cftry>
		<cfscript>
			PerformDeleteObject(_objectID_);

			_sql_statement = Request.commonCode.sql_GetAllRolesForUser();
			Request.commonCode.safely_execSQL('Request.qGetAllRolesForUser', Request.DSN, _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (AddNewRole2RoleManager.1)', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

			return Request.qGetAllRolesForUser;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformProcessAddUser">
	<cfargument name="_sUserName_" required="yes" type="string">
	<cfargument name="_sUsersName_" required="yes" type="string">
	<cfargument name="_UserRoleID_" required="yes" type="string">
	<cfargument name="_UserRoleName_" required="yes" type="string">
	<cfargument name="_BeginDtMM_" required="yes" type="string">
	<cfargument name="_BeginDtDD_" required="yes" type="string">
	<cfargument name="_BeginDtYYYY_" required="yes" type="string">
	<cfargument name="_EndDtMM_" required="yes" type="string">
	<cfargument name="_EndDtDD_" required="yes" type="string">
	<cfargument name="_EndDtYYYY_" required="yes" type="string">

	<cfscript>
		var i = -1;
		var j = -1;
		var _db = '';
		var _errorMsg = '';
		var _queryObj = '';
		var _objectID = -1;
		var fmt_EndDt = '';
		var fmt_BeginDt = '';
		var dt_EndDt = '';
		var dt_TempDt = '';
		var isBeginDt = false;
		var isEndDt = false;
		var isNowBetweenDates = false;
		var dt_BeginDt = '';
		var fmt_PromptDt = '';
		var _objectClassID = -1;
		var sql_qInsertNewType = '';
		var sql_qMakeObjectLink = '';
		var bool_userWasAdded = false;
		var sql_qCheckObjectLink = '';
		var sql_qInsertUserObject = '';
		var sql_qGetAllUserObjects = '';
		var sql_qEnsureUserClassExists = '';
		var sql_qEnsureUserNameExists = '';
		
		// BEGIN: Create a GeonosisUser
		//		Check to see if the Class named GeonosisUser exists, if not then create it & return the ClassID.
		//		Check to see if the User exists, if not then create it & return the User ID via the objectID.
		//		ObjectLink the User object to the User Role Object.
		//		Check to see if all the Attributes exist, if not then create them or update their values.
		// END!
	</cfscript>

	<cfsavecontent variable="sql_qEnsureUserClassExists">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					SELECT objectClassID
					FROM objectClassDefinitions
					WHERE (className = '#Request.const_GeonosisUSERS_symbol#')
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="sql_qInsertNewType">
		<cfoutput>
			INSERT INTO objectClassDefinitions
			            (className, classPath)
			VALUES ('#Request.const_GeonosisUSERS_symbol#', '#Request.const_GeonosisUSERS_symbol#');
			SELECT @@IDENTITY as 'objectClassID';
		</cfoutput>
	</cfsavecontent>

	<cfsavecontent variable="sql_qInsertUserObject">
		<cfoutput>
			<cfif (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn"))>
				<cfif (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0)>
					INSERT INTO objects
					       (objectClassID, objectName, publishedVersion, editVersion, created, createdBy, updated, updatedBy)
					VALUES (#Request.const_replace_pattern#,'#Request.commonCode.filterQuotesForSQL(_sUserName_)#',0,0,GetDate(),'#Client.userNameLoggedIn#',GetDate(),'#Client.userNameLoggedIn#');
					SELECT @@IDENTITY as 'ID';
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>

	<cftry>
		<cfscript>
			_sql_statement = sql_qEnsureUserClassExists;
			Request.commonCode.safely_execSQL('Request.qEnsureUserClassExists', Request.DSN, _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.1)', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			} else if (NOT IsQuery(Request.qEnsureUserClassExists)) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.2)', 'IsQuery() failed to determine Request.qEnsureUserClassExists a Query Object.');
				return _queryObj;
			} else if (Request.qEnsureUserClassExists.recordCount eq 0) {
				_sql_statement = sql_qInsertNewType;
				Request.commonCode.safely_execSQL('Request.qEnsureUserClassExists', Request.DSN, _sql_statement);

				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.3)', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				} else {
					_objectClassID = Request.qEnsureUserClassExists.objectClassID;
				}
			} else {
				_objectClassID = Request.qEnsureUserClassExists.objectClassID;
			}

		//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.1) [_objectClassID=(#_objectClassID#)], [_sql_statement=(#_sql_statement#)]');
			
			if (_objectClassID neq -1) {
				sql_qEnsureUserNameExists = '';
				if ( (IsDefined("Client.bool_isUserLoggedIn")) AND (IsDefined("Client.userNameLoggedIn")) ) {
					if ( (Client.bool_isUserLoggedIn) AND (Len(Client.userNameLoggedIn) gt 0) ) {
						sql_qEnsureUserNameExists = Request.commonCode.sql_GetAllObjectsForClassID(_objectClassID, 'USERNAME') & " AND (objectName = '#_sUserName_#')";
					}
				}

				_sql_statement = sql_qEnsureUserNameExists;
				Request.commonCode.safely_execSQL('Request.qEnsureUserNameExists', Request.DSN, _sql_statement);

			//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.2) [Request.qEnsureUserNameExists.recordCount=(#Request.qEnsureUserNameExists.recordCount#)], [_sql_statement=(#_sql_statement#)], [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)]');
				
				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.4)', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				} else if (NOT IsQuery(Request.qEnsureUserNameExists)) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.5)', 'IsQuery() failed to determine Request.qEnsureUserClassExists a Query Object.');
					return _queryObj;
				} else if (Request.qEnsureUserNameExists.recordCount eq 0) {
					_sql_statement = Replace(sql_qInsertUserObject, Request.const_replace_pattern, _objectClassID);
					Request.commonCode.safely_execSQL('Request.qEnsureUserNameExists', Request.DSN, _sql_statement);
	
				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.2a) [Request.qEnsureUserNameExists.recordCount=(#Request.qEnsureUserNameExists.recordCount#)], [_sql_statement=(#_sql_statement#)], [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)]');
				
					if (Request.dbError) {
						_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.6)', URLEncodedFormat(Request.moreErrorMsg));
						return _queryObj;
					} else {
						bool_userWasAdded = true;
						_objectID = Request.qEnsureUserNameExists.ID;
					}
				} else {
					_objectID = Request.qEnsureUserNameExists.ID;
				}
			}

		//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.3) [_objectID=(#_objectID#)], [_UserRoleID_=(#_UserRoleID_#)]');
		</cfscript>

		<cfsavecontent variable="sql_qCheckObjectLink">
			<cfoutput>
				SELECT id, ownerPropertyName, relatedPropertyName
				FROM objectLinks
				WHERE (ownerId = #_objectID#) AND (relatedId = #_UserRoleID_#)
			</cfoutput>
		</cfsavecontent>

		<cfsavecontent variable="sql_qMakeObjectLink">
			<cfoutput>
				INSERT INTO objectLinks
				       (ownerId, relatedId, ownerPropertyName, relatedPropertyName, ownerAutoload, relatedAutoload, displayOrder, startVersion, lastVersion, created, 
				       createdBy, updated)
				VALUES (#_objectID#,#_UserRoleID_#,'#Request.commonCode.filterQuotesForSQL(_sUserName_)#','#Request.commonCode.filterQuotesForSQL(_UserRoleName_)#',0,0,0,0,0,GetDate(),'#Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn)#',GetDate());
			</cfoutput>
		</cfsavecontent>

		<cfscript>
			if ( (_objectID neq -1) AND (bool_userWasAdded) ) {
				_sql_statement = sql_qCheckObjectLink;
				Request.commonCode.safely_execSQL('Request.qCheckObjectLink', Request.DSN, _sql_statement);

			//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.4) [Request.qCheckObjectLink.recordCount=(#Request.qCheckObjectLink.recordCount#)], [_sql_statement=(#_sql_statement#)], [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)], [IsQuery(Request.qCheckObjectLink)=(#IsQuery(Request.qCheckObjectLink)#)]');

				if (Request.dbError) {
				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.4a) [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)]');
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.7)', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				} else if (NOT IsQuery(Request.qCheckObjectLink)) {
				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.4b) [IsQuery(Request.qCheckObjectLink)=(#IsQuery(Request.qCheckObjectLink)#)]');
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.8)', 'IsQuery() failed to determine Request.qCheckObjectLink a Query Object.');
					return _queryObj;
				} else if (Request.qCheckObjectLink.recordCount eq 0) {
					_sql_statement = sql_qMakeObjectLink;
					Request.commonCode.safely_execSQL('Request.qMakeObjectLink', Request.DSN, _sql_statement);

					if ( (IsDefined("Request.qMakeObjectLink")) AND (IsQuery(Request.qMakeObjectLink)) ) {
						_db = _db & '[Request.qMakeObjectLink.recordCount=(#Request.qMakeObjectLink.recordCount#)], ';
					}
				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.5) #_db# [_sql_statement=(#_sql_statement#)], [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)]');

					if (Request.dbError) {
						_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR... (PerformProcessAddUser.9)', URLEncodedFormat(Request.moreErrorMsg));
						return _queryObj;
					}
				}

			//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.6) [(Len(_BeginDtYYYY_) gt 0)=(#(Len(_BeginDtYYYY_) gt 0)#)], [(Len(_BeginDtMM_) gt 0)=(#(Len(_BeginDtMM_) gt 0)#)], [(Len(_BeginDtDD_) gt 0)=(#(Len(_BeginDtDD_) gt 0)#)]');

				isBeginDt = false;
				if ( (Len(_BeginDtYYYY_) gt 0) AND (Len(_BeginDtMM_) gt 0) AND (Len(_BeginDtDD_) gt 0) ) {
					dt_BeginDt = CreateDate(_BeginDtYYYY_, _BeginDtMM_, _BeginDtDD_);
					isBeginDt = true;
				}

				isEndDt = false;
				if ( (Len(_EndDtYYYY_) gt 0) AND (Len(_EndDtMM_) gt 0) AND (Len(_EndDtDD_) gt 0) ) {
					dt_EndDt = CreateDate(_EndDtYYYY_, _EndDtMM_, _EndDtDD_);
					isEndDt = true;
				}

				if ( (isBeginDt) AND (isEndDt) ) {
					if (DateCompare(dt_EndDt, dt_BeginDt) lt 0) {
						dt_TempDt = dt_BeginDt;
						dt_BeginDt = dt_EndDt;
						dt_EndDt = dt_TempDt;
					}
				}
				
				if (isBeginDt) {
					fmt_BeginDt = DateFormat(dt_BeginDt, 'mm/dd/yyyy');
					_queryObj = Request.commonCode.GeonosisCreateAttribute(_objectID, Request.const_UserBeginDate_symbol, fmt_BeginDt, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));
	
					if (Request.dbError) {
						return _queryObj;
					}
				}

			//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.7) [(Len(_EndDtYYYY_) gt 0)=(#(Len(_EndDtYYYY_) gt 0)#)], [(Len(_EndDtMM_) gt 0)=(#(Len(_EndDtMM_) gt 0)#)], [(Len(_EndDtDD_) gt 0)=(#(Len(_EndDtDD_) gt 0)#)]');
				
				if (isEndDt) {
					fmt_EndDt = DateFormat(dt_EndDt, 'mm/dd/yyyy');
					_queryObj = Request.commonCode.GeonosisCreateAttribute(_objectID, Request.const_UserEndDate_symbol, fmt_EndDt, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));
	
					if (Request.dbError) {
						return _queryObj;
					}
				}

				_db = _db & 'Now() = [' & DateFormat(Now(), 'mm/dd/yyyy') & ']';
				
				isNowBetweenDates = true;
				if (isBeginDt) {
					// dt_BeginDt must be before Now()...
					_db = _db & ', dt_BeginDt = [#fmt_BeginDt#]';
					if (DateCompare(dt_BeginDt, Now()) gte 0) {
						isNowBetweenDates = false;
					}
				}
				
				if (isEndDt) {
					// dt_EndDt must be after Now()...
					_db = _db & ', dt_EndDt = [#fmt_EndDt#]';
					if (DateCompare(dt_EndDt, Now()) lte 0) {
						isNowBetweenDates = false;
					}
				}

				if (isNowBetweenDates) {
					// Prompt the new user to activate their account and stamp the date the prompt was sent...
					_queryObj = PerformRetrievePassword(_sUserName_, true);
					
					if (IsDefined("_queryObj.mailError")) {
						if (NOT _queryObj.mailError) {
							// write the attribute to track the last time the prompt was sent...
							fmt_PromptDt = Request.commonCode.formattedDateTimeTZ(Now());
							_queryObj = Request.commonCode.GeonosisCreateAttribute(_objectID, Request.const_UserPasswordPrompt_symbol, fmt_PromptDt, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));
			
							if (Request.dbError) {
								return _queryObj;
							}
						}
					}
				} else {
					Request.commonCode.cf_log(Application.applicationname, 'Information', 'DEBUG: Activation email was NOT sent. [#_db#]');
				}
				
				_queryObj = Request.commonCode.GeonosisCreateAttribute(_objectID, Request.const_UserProperName_symbol, _sUsersName_, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));

				if (Request.dbError) {
					return _queryObj;
				}
			} else {
				_queryObj = Request.commonCode.sql_ErrorMessage(-989, 'WARNING', URLEncodedFormat('Cannot add a user that already exists - try to edit or delete this user and then you may add this user.'));
				return _queryObj;
			}

			_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles();
			Request.commonCode.GeonosisExecSQL('qGetAllUserObjects', _sql_statement);

		//	Request.commonCode.cf_log(Application.applicationname, 'Information', '(Information.8) [Request.qGetAllUserObjects.recordCount=(#Request.qGetAllUserObjects.recordCount#)], [Request.qGetAllUserObjects.columnList=(#Request.qGetAllUserObjects.columnList#)], [_sql_statement=(#_sql_statement#)], [Request.dbError=(#Request.dbError#)], [Request.moreErrorMsg=(#Request.moreErrorMsg#)], [IsQuery(Request.qCheckObjectLink)=(#IsQuery(Request.qCheckObjectLink)#)]');

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

			return Request.qGetAllUserObjects;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="_errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, true)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(_errorMsg) eq 0)>
				<cfsavecontent variable="_errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
			//	Request.commonCode.cf_log(Application.applicationname, 'Error', '(Error.1) [_errorMsg=(#_errorMsg#)]');

				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(_errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformUserMgrConfirmationAction">
	<cfargument name="_action_" required="yes" type="string">
	<cfargument name="_objectID_" required="yes" type="string">
	<cfargument name="_sUserName_" required="yes" type="string">
	<cfargument name="_UserRoleID_" required="yes" type="string">
	<cfargument name="_UserRoleName_" required="yes" type="string">
	<cfargument name="_BeginDtMM_" required="yes" type="string">
	<cfargument name="_BeginDtDD_" required="yes" type="string">
	<cfargument name="_BeginDtYYYY_" required="yes" type="string">
	<cfargument name="_EndDtMM_" required="yes" type="string">
	<cfargument name="_EndDtDD_" required="yes" type="string">
	<cfargument name="_EndDtYYYY_" required="yes" type="string">

	<cfscript>
		var i = -1;
		var _queryObj = '';
		var fmtBeginDt = '';
		var fmtEndDt = '';
		var dtBeginDt = '';
		var dtEndDt = '';
		var isBeginDt = false;
		var isEndDt = false;
		var dtTempDt = '';
		var _sql_statement = '';
		var bool_isUserBeginDateAttr = false;
		var bool_isUserEndDateAttr = false;
		var bool_addBeginDateAttr = false;
		var bool_removeBeginDateAttr = false;
		var bool_addEndDateAttr = false;
		var bool_removeEndDateAttr = false;
	</cfscript>

	<cftry>
		<cfscript>
		//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformUserMgrConfirmationAction->[_action_=#_action_#])');

			if (UCASE(_action_) eq 'EDIT') {
				_sql_statement = Request.commonCode.sql_GetAllObjectsLinkedToAnObjectByID(_objectID_, true);
			} else if (UCASE(_action_) eq 'DELETE') {
				_sql_statement = Request.commonCode.sql_GetAllObjectsLinkedToAnObjectByID(_objectID_, true);
			}
			Request.commonCode.safely_execSQL('Request.qGetAllObjectsLinkedToAnObjectByID', Request.DSN, _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
			//	Request.commonCode.cf_log(Application.applicationname, 'Error', '1.0 (PerformUserMgrConfirmationAction->[#Request.moreErrorMsg#])');
				return _queryObj;
			} else {
				if (UCASE(_action_) eq 'EDIT') {
					// BEGIN: Handle the add/remove a named attribute based on the presence or absence of an associated value...
					isBeginDt = false;
					if ( (Len(_BeginDtYYYY_) gt 0) AND (Len(_BeginDtMM_) gt 0) AND (Len(_BeginDtDD_) gt 0) ) {
						dtBeginDt = CreateDate(_BeginDtYYYY_, _BeginDtMM_, _BeginDtDD_);
						isBeginDt = true;
					}
	
					isEndDt = false;
					if ( (Len(_EndDtYYYY_) gt 0) AND (Len(_EndDtMM_) gt 0) AND (Len(_EndDtDD_) gt 0) ) {
						dtEndDt = CreateDate(_EndDtYYYY_, _EndDtMM_, _EndDtDD_);
						isEndDt = true;
					}
	
					if ( (isBeginDt) AND (isEndDt) ) {
						if (DateCompare(dtEndDt, dtBeginDt) lt 0) {
							dtTempDt = dtBeginDt;
							dtBeginDt = dtEndDt;
							dtEndDt = dtTempDt;
						}
					}

					fmtBeginDt = '';
					if (isBeginDt) {
						fmtBeginDt = DateFormat(dtBeginDt, 'mm/dd/yyyy');
					}

				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformUserMgrConfirmationAction->[fmtBeginDt=#fmtBeginDt#])');
					
					fmtEndDt = '';
					if (isEndDt) {
						fmtEndDt = DateFormat(dtEndDt, 'mm/dd/yyyy');
					}

				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformUserMgrConfirmationAction->[fmtEndDt=#fmtEndDt#])');
					
					for (i = 1; i lte Request.qGetAllObjectsLinkedToAnObjectByID.recordCount; i = i + 1) {
						if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.typeName[i]) eq UCASE('objectAttributes')) {
							if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.objectName[i]) eq UCASE('UserBeginDate')) {
								bool_isUserBeginDateAttr = true;
							} else if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.objectName[i]) eq UCASE('UserEndDate')) {
								bool_isUserEndDateAttr = true;
							}
						}
					}

				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformUserMgrConfirmationAction->[bool_isUserBeginDateAttr=#bool_isUserBeginDateAttr#], [bool_isUserEndDateAttr=#bool_isUserEndDateAttr#])');

					// Add a named attribute when the named attributes does not exist but the value does exist.
					if (bool_isUserBeginDateAttr) {
						if (Len(fmtBeginDt) eq 0) {
							bool_removeBeginDateAttr = true;
						}
					} else {
						if (Len(fmtBeginDt) gt 0) {
							bool_addBeginDateAttr = true;
						}
					}
					if (bool_isUserEndDateAttr) {
						if (Len(fmtEndDt) eq 0) {
							bool_removeEndDateAttr = true;
						}
					} else {
						if (Len(fmtEndDt) gt 0) {
							bool_addEndDateAttr = true;
						}
					}

				//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformUserMgrConfirmationAction->[bool_addBeginDateAttr=#bool_addBeginDateAttr#], [bool_removeBeginDateAttr=#bool_removeBeginDateAttr#], [bool_addEndDateAttr=#bool_addEndDateAttr#], [bool_removeEndDateAttr=#bool_removeEndDateAttr#])');

					// Remove a named attribute when the named attribute does exist but there is no value for it.
					// END! Handle the add/remove a named attribute based on the presence or absence of an associated value...
					
					// BEGIN: Allow the various parameters to be changed...
					for (i = 1; i lte Request.qGetAllObjectsLinkedToAnObjectByID.recordCount; i = i + 1) {
						if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.typeName[i]) eq UCASE('objectAttributes')) {
							// BEGIN: Update the appropriate Attribute Value...
							if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.objectName[i]) eq UCASE('UserBeginDate')) {
								Request.commonCode.GeonosisModifyAttrValue(Request.qGetAllObjectsLinkedToAnObjectByID.objectid[i], fmtBeginDt);
							} else if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.objectName[i]) eq UCASE('UserEndDate')) {
								Request.commonCode.GeonosisModifyAttrValue(Request.qGetAllObjectsLinkedToAnObjectByID.objectid[i], fmtEndDt);
							}
							// END! Update the appropriate Attribute Value...
						} else if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.typeName[i]) eq UCASE('GeonosisUSERS')) {
							// BEGIN: Update the Object Name as needed...
							Request.commonCode.GeonosisModifyObjectName(Request.qGetAllObjectsLinkedToAnObjectByID.objectid[i], _sUserName_);
							// END! Update the Object Name as needed...
						} else if (UCASE(Request.qGetAllObjectsLinkedToAnObjectByID.typeName[i]) eq UCASE('objectLinks')) {
							// BEGIN: Do we need to remove an old link to a Role and link to a different Role ?
							if (Request.qGetAllObjectsLinkedToAnObjectByID.objectid[i] neq _UserRoleID_) {
								// BEGIN: This means the chosen role is different than the one that is linked in the Db so remove the current role and link the new role...
								Request.commonCode.GeonosisPerformDeleteObjectsLinks(Request.qGetAllObjectsLinkedToAnObjectByID.objectid[i]);
								Request.commonCode.GeonosisMakeObjectLink(_objectID_, _UserRoleID_, _sUserName_, _UserRoleName_);
								// END! This means the chosen role is different than the one that is linked in the Db so remove the current role and link the new role...
							}
							// END! Do we need to remove an old link to a Role and link to a different Role ?
						}
					}
					if (bool_addBeginDateAttr) {
						Request.commonCode.GeonosisAddAttrValue(_objectID_, 'UserBeginDate', fmtBeginDt, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));
					}
					if (bool_addEndDateAttr) {
						Request.commonCode.GeonosisAddAttrValue(_objectID_, 'UserEndDate', fmtEndDt, Request.commonCode.filterQuotesForSQL(Client.userNameLoggedIn));
					}
					// END! Allow the various parameters to be changed...
				} else if (UCASE(_action_) eq 'DELETE') {
					// BEGIN: Delete the user object and all associated objects...
					Request.commonCode.GeonosisDeleteObjectAttrsLinksAndSelfById(Request.qGetAllObjectsLinkedToAnObjectByID);
					// END! Delete the user object and all associated objects...
				}
			}
			
			// BEGIN: Refresh the records from the database...
			_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles();
			Request.commonCode.GeonosisExecSQL('qGetAllUserObjects', _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

			return Request.qGetAllUserObjects;
			// END! Refresh the records from the database...
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PopulateUserManager">

	<cfscript>
		var _queryObj = '';
		var _sql_statement = '';
	</cfscript>

	<cftry>
		<cfscript>
			// BEGIN: Refresh the records from the database...
			_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles();
			Request.commonCode.GeonosisExecSQL('qGetAllUserObjects', _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

		//	Request.commonCode.cf_log(Application.applicationname, 'Information', 'DEBUG: [#_sql_statement#], [#Request.qGetAllUserObjects.recordCount#]');
			
			return Request.qGetAllUserObjects;
			// END! Refresh the records from the database...
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="PerformDeleteAllCheckedUsers">
	<cfargument name="_idList_" required="yes" type="string">

	<cfscript>
		var i = -1;
		var n = -1;
		var ar = -1;
		var _queryObj = '';
		var _objectID_ = -1;
		var _sql_statement = '';
	</cfscript>

	<cftry>
		<cfscript>
		//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformDeleteAllCheckedUsers->[_idList_=#_idList_#])');

			// BEGIN: Delete each of the objectIDs from the list then fetch the complete list from the Db...
			ar = ListToArray(_idList_, ',');
			n = ArrayLen(ar);
			for (i = 1; i lte n; i = i + 1) {
				_objectID_ = ar[i];

				_sql_statement = Request.commonCode.sql_GetAllObjectsLinkedToAnObjectByID(_objectID_, true);
				Request.commonCode.safely_execSQL('Request.qGetAllObjectsLinkedToAnObjectByID', Request.DSN, _sql_statement);

			//	Request.commonCode.cf_log(Application.applicationname, 'Information', '1.0 (PerformDeleteAllCheckedUsers->[_objectID_=#_objectID_#], [Request.dbError=#Request.dbError#])');
	
				if (Request.dbError) {
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				} else {
					// BEGIN: Delete the user object and all associated objects...
					Request.commonCode.GeonosisDeleteObjectAttrsLinksAndSelfById(Request.qGetAllObjectsLinkedToAnObjectByID);
					// END! Delete the user object and all associated objects...
				}
			}
			// END! Delete each of the objectIDs from the list then fetch the complete list from the Db...

			// BEGIN: Refresh the records from the database...
			_sql_statement = Request.commonCode.GeonosisGetAllUsersWithLinkedAttrsAndRoles();
			Request.commonCode.GeonosisExecSQL('qGetAllUserObjects', _sql_statement);

			if (Request.dbError) {
				_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				return _queryObj;
			}

			return Request.qGetAllUserObjects;
			// END! Refresh the records from the database...
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						IsStruct(cfcatch) = [#IsStruct(cfcatch)#]
						IsSimpleValue(cfcatch) = [#IsSimpleValue(cfcatch)#]
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>

</cffunction>

<cffunction name="PerformTerminateAccount">
	<cfargument name="_sUserName_" required="yes" type="string">

	<cfscript>
		var _queryObj = '';
		var bool_accepted = true;
	</cfscript>

	<cftry>
		<cfscript>
			_queryObj = QueryNew('id, isAccountTerminated');
			QueryAddRow(_queryObj, 1);
			QuerySetCell(_queryObj, 'id', _queryObj.recordCount, _queryObj.recordCount);
			QuerySetCell(_queryObj, 'isAccountTerminated', bool_accepted, _queryObj.recordCount);
			return _queryObj;
		</cfscript>

		<cfcatch type="Any">
			<cfsavecontent variable="errorMsg">
				<cfoutput>
					#Request.commonCode.explainError(cfcatch, false)#
				</cfoutput>
			</cfsavecontent>
			<cfif (Len(Trim(errorMsg)) eq 0)>
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						cfcatch.type = [#cfcatch.type#]
						cfcatch.message = [#cfcatch.message#]
						cfcatch.detail = [#cfcatch.detail#]
						cfcatch.ErrNumber = [#cfcatch.ErrNumber#]
					</cfoutput>
				</cfsavecontent>
			</cfif>

			<cflog file="#Application.applicationname#" type="Error" text="(PerformSetNewPassword) [#errorMsg#]">
			
			<cfscript>
				_queryObj = Request.commonCode.sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
				return _queryObj;
			</cfscript>
		</cfcatch>
	</cftry>
</cffunction>
