<cfcomponent displayname="Geonosis Code" name="GeonosisCode" extends="CFAjaxCode">
	<cfscript>
		this.const_objectAttributes_symbol = 'objectAttributes';
		this.const_objectLinks_symbol = 'objectLinks';
		this.const_GeonosisUSERS_symbol = 'GeonosisUSERS';
	</cfscript>

	<cffunction name="GeonosisDeleteObjectsAttribute">
		<cfargument name="_attributeID_" required="yes" type="string">
	
		<cfscript>
			var _sql_statement = '';
			var sql_qDeleteObjectsAttribute = '';
			var _queryObj = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qDeleteObjectsAttribute">
				<cfoutput>
					DELETE FROM objectAttributes
					WHERE (id = #_attributeID_#);
					
					SELECT 0 as 'ID';
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qDeleteObjectsAttribute;
				Request.commonCode.safely_execSQL('Request.qCheckObjectsAttribute', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
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

	<cffunction name="GeonosisPerformDeleteObject">
		<cfargument name="_objectID_" required="yes" type="string">
	
		<cfscript>
			var _sql_statement = '';
			var sql_qDeleteObject = '';
			var _queryObj = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qDeleteObject">
				<cfoutput>
					DELETE FROM objects
					WHERE (id = #_objectID_#)
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qDeleteObject;
				Request.commonCode.safely_execSQL('Request.qDeleteObject', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = Request.commonCode.sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
			
			<!--- 
			<cfreturn Request.qDeleteObject>
			 --->
	
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

	<cfscript>
		function GeonosisDeleteObjectAttrsLinksAndSelfById(qQ) {
			if (IsQuery(qQ)) {
				for (i = 1; i lte qQ.recordCount; i = i + 1) {
					if (UCASE(qQ.typeName[i]) eq UCASE(this.const_objectAttributes_symbol)) {
						GeonosisDeleteObjectsAttribute(qQ.objectid[i]);
					}
				}
				for (i = 1; i lte qQ.recordCount; i = i + 1) {
					if (UCASE(qQ.typeName[i]) eq UCASE(this.const_objectLinks_symbol)) {
						GeonosisPerformDeleteObjectsLinks(qQ.objectid[i]);
					}
				}
				for (i = 1; i lte qQ.recordCount; i = i + 1) {
					if (UCASE(qQ.typeName[i]) eq UCASE(this.const_GeonosisUSERS_symbol)) {
						GeonosisPerformDeleteObject(qQ.objectid[i], false);
					}
				}
			}
		}
	</cfscript>

	<cffunction name="sql_GetAllObjectsForClassID" access="public" returntype="string">
		<cfargument name="_ClassID_" required="yes" type="string">
		<cfargument name="_sColumnName_" required="yes" type="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				SELECT id AS 'ID', objectName AS '#_sColumnName_#'
				FROM objects
				WHERE (objectClassID = #_ClassID_#)
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="sql_GetAllObjectsOfType" access="public" returntype="string">
		<cfargument name="_sTypeName_" required="yes" type="string">
		<cfargument name="_sColumnName_" required="yes" type="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				SELECT objects.id as 'ID', objects.objectName as '#_sColumnName_#'
				FROM objects INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objectClassDefinitions.className = '#_sTypeName_#')
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="sql_GetAllObjectsOfTypeNamed" access="public" returntype="string">
		<cfargument name="_sTypeName_" required="yes" type="string">
		<cfargument name="_sColumnName_" required="yes" type="string">
		<cfargument name="_ObjectName_" required="yes" type="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				#sql_GetAllObjectsOfType(_sTypeName_, _sColumnName_)#
					AND (objects.objectName = '#_ObjectName_#')
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>

	</cffunction>
	
	<cffunction name="sql_GetAllObjectsByIdForTypeId" access="public" returntype="string">
		<cfargument name="_userObjectId_" required="yes" type="string">
		<cfargument name="_roleObjectId_" required="yes" type="string">
		<cfargument name="_sRoleIdColName_" required="yes" type="string">
		<cfargument name="_sRoleNameColName_" required="yes" type="string">
		<cfargument name="_sUserNameColName_" required="yes" type="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				SELECT userObject.id, roleObject.id AS '#_sRoleIdColName_#', roleObject.objectName AS '#_sRoleNameColName_#', userObject.objectName AS '#_sUserNameColName_#'
				FROM objects AS userObject INNER JOIN
				     objectLinks ON userObject.id = objectLinks.ownerId INNER JOIN
				     objects AS roleObject ON objectLinks.relatedId = roleObject.id
				WHERE (userObject.id = #_userObjectId_#) AND (roleObject.id = #_roleObjectId_#)
				ORDER BY userObject.objectName, roleObject.objectName
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="sql_GetAllObjectsAndAttrsByIdForTypeId" access="public" returntype="string">
		<cfargument name="_userObjectId_" required="yes" type="string">
		<cfargument name="_roleObjectId_" required="yes" type="string">
		<cfargument name="_sRoleIdColName_" required="yes" type="string">
		<cfargument name="_sRoleNameColName_" required="yes" type="string">
		<cfargument name="_sUserNameColName_" required="yes" type="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				SELECT userObject.id, roleObject.id AS '#_sRoleIdColName_#', roleObject.objectName AS '#_sRoleNameColName_#', userObject.objectName AS '#_sUserNameColName_#', objectAttributes.attributeName, 
				       ISNULL(objectAttributes.valueText, objectAttributes.valueString) AS 'attributeValue'
				FROM objects AS userObject INNER JOIN
				     objectLinks ON userObject.id = objectLinks.ownerId INNER JOIN
				     objects AS roleObject ON objectLinks.relatedId = roleObject.id LEFT OUTER JOIN
				     objectAttributes ON userObject.id = objectAttributes.objectID
				WHERE (userObject.id = #_userObjectId_#) AND (roleObject.id = #_roleObjectId_#)
				ORDER BY userObject.objectName, roleObject.objectName
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="sql_GetAllObjectsLinkedToAnObjectByID" access="public" returntype="string">
		<cfargument name="_objectID_" required="yes" type="string">
		<cfargument name="_boolIncludeLinks_" type="boolean" default="false">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				CREATE TABLE ##GetAllObjectsLinkedTemp (objectid int, typeName varchar(50), objectName varchar(7000)) 
				
				INSERT INTO ##GetAllObjectsLinkedTemp (objectid, typeName, objectName) 
				SELECT objects.id, objectClassDefinitions.className as 'typeName', objects.objectName
				FROM objects INNER JOIN
				     objectClassDefinitions ON objects.objectClassID = objectClassDefinitions.objectClassID
				WHERE (objects.id = #_objectID_#)
				
				INSERT INTO ##GetAllObjectsLinkedTemp (objectid, typeName, objectName) 
				SELECT objectAttributes.id, '#this.const_objectAttributes_symbol#' as 'typeName', objectAttributes.attributeName
				FROM objects INNER JOIN
				     objectAttributes ON objects.id = objectAttributes.objectID
				WHERE (objects.id = #_objectID_#)
				
				<cfif (_boolIncludeLinks_)>
					INSERT INTO ##GetAllObjectsLinkedTemp (objectid, typeName, objectName) 
					SELECT id, '#this.const_objectLinks_symbol#', ownerPropertyName
					FROM objectLinks
					WHERE (ownerId = #_objectID_#) OR (relatedId = #_objectID_#)
				</cfif>
				
				SELECT objectid, typeName, objectName FROM ##GetAllObjectsLinkedTemp 
				
				DROP TABLE ##GetAllObjectsLinkedTemp
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="sql_GetAllRolesForUser" access="public" returntype="string">

		<cfset var _sql_ = "">
		
		<cfsavecontent variable="_sql_">
			<cfoutput>
				#sql_GetAllObjectsOfType(Request.const_GeonosisROLES_symbol, 'ROLENAME')#
			</cfoutput>
		</cfsavecontent>

		<cfreturn _sql_>
	
	</cffunction>

	<cffunction name="GeonosisCreateAttribute" access="public" returntype="query">
		<cfargument name="_objectID_" required="yes" type="string">
		<cfargument name="_objName_" required="yes" type="string">
		<cfargument name="_objValue_" required="yes" type="string">
		<cfargument name="_objBy_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = -1;
			var sql_qMakeAttribute = '';
			var _sql_statement = '';
		</cfscript>
	
		<cftry>
			<cfset _objValue_ = URLDecode(_objValue_)>
			<cfif (Len(_objValue_) gt 7000)>
				<cfsavecontent variable="sql_qMakeAttribute">
					<cfoutput>
						INSERT INTO objectAttributes
						       (objectID, attributeName, valueText, displayOrder, startVersion, lastVersion, created, createdBy, updated)
						VALUES (#_objectID_#,'#filterQuotesForSQL(_objName_)#','#filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#filterQuotesForSQL(_objBy_)#',GetDate());
					</cfoutput>
				</cfsavecontent>
			<cfelse>
				<cfsavecontent variable="sql_qMakeAttribute">
					<cfoutput>
						INSERT INTO objectAttributes
						       (objectID, attributeName, valueString, displayOrder, startVersion, lastVersion, created, createdBy, updated)
						VALUES (#_objectID_#,'#filterQuotesForSQL(_objName_)#','#filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#filterQuotesForSQL(_objBy_)#',GetDate());
					</cfoutput>
				</cfsavecontent>
			</cfif>
		
			<cfsavecontent variable="sql_qMakeAttributeVerify">
				<cfoutput>
					SELECT @@IDENTITY as 'ID';
				</cfoutput>
			</cfsavecontent>
			
			<cfscript>
				_sql_statement = sql_qMakeAttribute & sql_qMakeAttributeVerify;
				safely_execSQL('Request.qMakeAttribute', Request.DSN, _sql_statement);
		
				if (Request.dbError) {
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				}
			</cfscript>
		
			<cfreturn Request.qMakeAttribute>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisGetAllUsersWithLinkedAttrsAndRoles" access="public" returntype="string">
		<cfargument name="_sWhereClause_" type="string" default="">

		<cfset var _sql_ = "">
		<cfsavecontent variable="_sql_">
			<cfoutput>
				CREATE TABLE ##GetAllUsersWithAttrsTemp (id int, username varchar(3500), roleid int, rolename varchar(3500), begindtaid int, begindt varchar(10), enddtaid int, enddt varchar(10), passwordaid int, password varchar(255), USERPROPERNAMEaid int, USERPROPERNAME varchar(255))
				
				INSERT INTO ##GetAllUsersWithAttrsTemp (id, username, roleid, rolename, begindt, enddt, password, USERPROPERNAME, begindtaid, enddtaid, passwordaid, USERPROPERNAMEaid)
					SELECT uo.id AS 'ID', uo.objectName AS 'USERNAME', ro.id as 'roleid', ro.objectName AS 'ROLENAME',
							ISNULL((SELECT TOP 1 valueString FROM objectAttributes WHERE (attributeName = '#Request.const_UserBeginDate_symbol#') AND (objectID = uo.id)), '') as 'begindt',
							ISNULL((SELECT TOP 1 valueString FROM objectAttributes WHERE (attributeName = '#Request.const_UserEndDate_symbol#') AND (objectID = uo.id)), '') as 'enddt',
							ISNULL((SELECT TOP 1 valueString FROM objectAttributes WHERE (attributeName = '#Request.const_UserPassword_symbol#') AND (objectID = uo.id)), '') as 'password',
							ISNULL((SELECT TOP 1 valueString FROM objectAttributes WHERE (attributeName = '#Request.const_UserProperName_symbol#') AND (objectID = uo.id)), '') as 'USERPROPERNAME',
							ISNULL((SELECT TOP 1 id FROM objectAttributes WHERE (attributeName = '#Request.const_UserBeginDate_symbol#') AND (objectID = uo.id)), -1) as 'begindtaid',
							ISNULL((SELECT TOP 1 id FROM objectAttributes WHERE (attributeName = '#Request.const_UserEndDate_symbol#') AND (objectID = uo.id)), -1) as 'enddtaid',
							ISNULL((SELECT TOP 1 id FROM objectAttributes WHERE (attributeName = '#Request.const_UserPassword_symbol#') AND (objectID = uo.id)), -1) as 'passwordaid',
							ISNULL((SELECT TOP 1 id FROM objectAttributes WHERE (attributeName = '#Request.const_UserProperName_symbol#') AND (objectID = uo.id)), -1) as 'USERPROPERNAMEaid'
					FROM objects AS ro INNER JOIN
					     objectClassDefinitions AS roc ON ro.objectClassID = roc.objectClassID RIGHT OUTER JOIN
					     objectLinks ON ro.id = objectLinks.relatedId RIGHT OUTER JOIN
					     objects AS uo INNER JOIN
					     objectClassDefinitions AS uoc ON uo.objectClassID = uoc.objectClassID ON objectLinks.ownerId = uo.id
					WHERE (uoc.className = '#Request.const_GeonosisUSERS_symbol#') AND (roc.className = '#Request.const_GeonosisROLES_symbol#')
				
				SELECT id, username, ISNULL(roleid,-1) as 'roleid', ISNULL(rolename,'') as 'rolename', begindt, enddt, password, USERPROPERNAME, begindtaid, enddtaid, passwordaid, USERPROPERNAMEaid FROM ##GetAllUsersWithAttrsTemp
				<cfif (Len(_sWhereClause_) gt 0)>#_sWhereClause_#</cfif>
				
				DROP TABLE ##GetAllUsersWithAttrsTemp
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _sql_>
	</cffunction>

	<cffunction name="GeonosisExecSQL" access="public" returntype="query">
		<cfargument name="_qName_" required="yes" type="string">
		<cfargument name="_sql_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = -1;
		</cfscript>
	
		<cftry>
			<cfscript>
				safely_execSQL('Request.' & _qName_, Request.DSN, _sql_);
		
				if (Request.dbError) {
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				}
			</cfscript>
		
			<cfreturn Request[_qName_]>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisPerformDeleteObjectsLinks">
		<cfargument name="_objectID_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qDeleteObjectLink = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qDeleteObjectLink">
				<cfoutput>
					DELETE FROM objectLinks
					WHERE (id = #_objectID_#)
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qDeleteObjectLink;
				safely_execSQL('Request.qDeleteObjectLink', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
				//	cf_log(Application.applicationname, 'Error', '1.0 (PerformDeleteObjectsLinks->#Request.moreErrorMsg#)');
					return _queryObj;
				</cfscript>
	
				<cfscript>
				//	cf_log(Application.applicationname, 'Information', '1.0 (PerformDeleteObjectsLinks->#_objectID_#)');
				</cfscript>
			</cfif>
		
			<!--- 
			<cfreturn Request.qGetAllObjects>
			 --->
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisModifyAttrValue">
		<cfargument name="_attrID_" required="yes" type="string">
		<cfargument name="_attrValue_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qModifyAttrValue = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qModifyAttrValue">
				<cfoutput>
					UPDATE objectAttributes
					SET <cfif (Len(_attrValue_) gt 7000)>valueText = '#_attrValue_#'<cfelse>valueString = '#_attrValue_#'</cfif>,
					<cfif (Len(_attrValue_) lt 7000)>valueText = ''<cfelse>valueString = ''</cfif>
					WHERE (id = #_attrID_#);
					
					SELECT @@IDENTITY as 'ID';
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qModifyAttrValue;
				safely_execSQL('Request.qModifyAttrValue', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
		
			<cfreturn Request.qModifyAttrValue>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisModifyObjectName">
		<cfargument name="_objectID_" required="yes" type="string">
		<cfargument name="_objectName_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qModifyObjectName = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qModifyObjectName">
				<cfoutput>
					UPDATE objects
					SET objectName = '#filterQuotesForSQL(_objectName_)#'
					WHERE (id = #_objectID_#);
					
					SELECT @@IDENTITY as 'ID';
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qModifyObjectName;
				safely_execSQL('Request.qModifyObjectName', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
		
			<cfreturn Request.qModifyObjectName>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisMakeObjectLink">
		<cfargument name="_objectID_" required="yes" type="string">
		<cfargument name="_UserRoleID_" required="yes" type="string">
		<cfargument name="_sUserName_" required="yes" type="string">
		<cfargument name="_UserRoleName_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qMakeObjectLink = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qMakeObjectLink">
				<cfoutput>
					INSERT INTO objectLinks
					       (ownerId, relatedId, ownerPropertyName, relatedPropertyName, ownerAutoload, relatedAutoload, displayOrder, startVersion, lastVersion, created, 
					       createdBy, updated)
					VALUES (#_objectID_#,#_UserRoleID_#,'#filterQuotesForSQL(_sUserName_)#','#filterQuotesForSQL(_UserRoleName_)#',0,0,0,0,0,GetDate(),'#filterQuotesForSQL(Client.userNameLoggedIn)#',GetDate());
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				_sql_statement = sql_qMakeObjectLink;
				safely_execSQL('Request.qMakeObjectLink', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
		
			<cfreturn Request.qMakeObjectLink>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisAddAttrValue">
		<cfargument name="_objectID_" required="yes" type="string">
		<cfargument name="_objName_" required="yes" type="string">
		<cfargument name="_objValue_" required="yes" type="string">
		<cfargument name="_objBy_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qAddAttrValue = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qAddAttrValue">
				<cfoutput>
					<cfif (Len(_objValue_) gt 7000)>
						INSERT INTO objectAttributes
						       (objectID, attributeName, valueText, displayOrder, startVersion, lastVersion, created, createdBy, updated)
						VALUES (#_objectID_#,'#filterQuotesForSQL(_objName_)#','#filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#filterQuotesForSQL(_objBy_)#',GetDate());
					<cfelse>
						INSERT INTO objectAttributes
						       (objectID, attributeName, valueString, displayOrder, startVersion, lastVersion, created, createdBy, updated)
						VALUES (#_objectID_#,'#filterQuotesForSQL(_objName_)#','#filterQuotesForSQL(_objValue_)#',0,0,0,GetDate(),'#filterQuotesForSQL(_objBy_)#',GetDate());
					</cfif>
					SELECT @@IDENTITY as 'ID';
				</cfoutput>
			</cfsavecontent>

			<cfscript>
				_sql_statement = sql_qAddAttrValue;
				safely_execSQL('Request.qAddAttrValue', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
		
			<cfreturn Request.qAddAttrValue>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="GeonosisRemoveAttr">
		<cfargument name="_attributeID_" required="yes" type="string">
	
		<cfscript>
			var _queryObj = '';
			var _sql_statement = '';
			var sql_qRemoveAttr = '';
		</cfscript>
	
		<cftry>
			<cfsavecontent variable="sql_qRemoveAttr">
				<cfoutput>
					DELETE FROM objectAttributes
					WHERE (id = #_attributeID_#);
					
					SELECT 0 as 'ID';
				</cfoutput>
			</cfsavecontent>

			<cfscript>
				_sql_statement = sql_qRemoveAttr;
				safely_execSQL('Request.qRemoveAttr', Request.DSN, _sql_statement);
			</cfscript>
			
			<cfif (Request.dbError)>
				<cfscript>
					_queryObj = sql_ErrorMessage(-999, 'SQL ERROR...', URLEncodedFormat(Request.moreErrorMsg));
					return _queryObj;
				</cfscript>
			</cfif>
		
			<cfreturn Request.qRemoveAttr>
	
			<cfcatch type="Any">
				<cfsavecontent variable="errorMsg">
					<cfoutput>
						#explainError(cfcatch, true)#
					</cfoutput>
				</cfsavecontent>
	
				<cfscript>
					_queryObj = sql_ErrorMessage(-998, 'CF ERROR...', URLEncodedFormat(errorMsg));
					return _queryObj;
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>

	<cfscript>
		function GeonosisCreateAttributeForLoggedInUserIfPossible(aName, uid, val) {
			var _queryObj = -1;
			var objByName = Request.const_AccountActivation_symbol;
			if (IsDefined("Client.userNameLoggedIn")) {
				objByName = Client.userNameLoggedIn;
			}
			_queryObj = GeonosisCreateAttribute(uid, aName, val, filterQuotesForSQL(objByName));

			if (Request.dbError) {
				return _queryObj;
			}

			return _queryObj;
		}
	</cfscript>

</cfcomponent>
