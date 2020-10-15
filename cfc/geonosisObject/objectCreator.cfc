<cfcomponent displayname="Object Creator Code" name="objectCreator" extends="objectSupport">
	<cffunction name="init" access="public" returntype="struct">
		<cfscript>
			super.init();
			this.vars = StructNew();
		</cfscript>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="jsCode" access="public" returntype="string">
		<cfsavecontent variable="_html">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					function objectCreator_getGUIObjectInstanceById(id) {
						return $(id);
					}

					function objectCreator_getSelectionsFromObj(obj) {
						return _getSelectionsFromObj(obj);
					 }

				//-->
				</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>

	<cffunction name="objectCreatorGUI" access="public" returntype="string">
		<cfset var _html = "">
		<cfsavecontent variable="_html">
			<cfoutput>
				<div id="div_abstract_objectCreatorMakeType" style="display: inline;">
					<div id="div_objectCreatorMakeType" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Object Type:</NOBR>&nbsp;</span>
						<input type="text" name="anObjectType" id="anObjectType" class="textClass" size="20" maxlength="30">
						<span class="boldPromptTextClass"><NOBR>Class Path:</NOBR>&nbsp;</span>
						<input type="text" name="anObjectPath" id="anObjectPath" class="textClass" size="20" maxlength="30">
						<input type="button" class="buttonClass" name="btn_makeType" id="btn_makeType" value="[Make Type]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anObjectType'); var obj2 = objectCreator_getGUIObjectInstanceById('anObjectPath'); if ( (obj != null) && (obj2 != null) ) { performCreateType(obj.value, obj2.value); }">
					</div>
				</div>
				<div id="div_abstract_objectCreatorAvailableType" style="display: inline;">
					<div id="div_objectCreatorAvailableType" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Available Type(s):</NOBR>&nbsp;</span>
						<cfinclude template="cfinclude_qGetAllTypes.cfm">
						<select id="availableTypes" name="availableTypes" class="textClass" size="5" onchange="workingWithObject(this.options[this.selectedIndex].value, this.options[this.selectedIndex].text); return false;">
							<cfscript>
								if (IsDefined("Request.qGetAllTypes")) {
									for (i = 1; i lte Request.qGetAllTypes.recordCount; i = i + 1) {
										writeOutput('<option value="#Request.qGetAllTypes.objectClassID[i]#">#Request.qGetAllTypes.className[i]#</option>');
									}
								}
							</cfscript>
						</select>
					</div>
				</div>
				<div id="div_abstract_objectCreatorWorkingWith" style="display: inline;">
					<div id="div_objectCreatorWorkingWith" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Working With Object Type:</NOBR>&nbsp;</span>
						<input readonly type="text" name="wwObjectType" id="wwObjectType" class="textClass" size="20" maxlength="30">
						&nbsp;
						<input readonly type="text" name="wwObjectClassID" id="wwObjectClassID" class="textClass" size="5" maxlength="5">
					</div>
				</div>
				<cfscript>
					Request.commonCode.GetDbSchemaForTable('objects');
					if (NOT Request.dbError) {
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForTable, 'Request.qGetDbSchemaForTable', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForObjectName', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('ObjectName'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForObjectName, 'Request.qGetDbSchemaForObjectName', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForPublishedVersion', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('PublishedVersion'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForPublishedVersion, 'Request.qGetDbSchemaForPublishedVersion', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForEditVersion', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('EditVersion'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForEditVersion, 'Request.qGetDbSchemaForEditVersion', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForCreatedBy', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('CreatedBy'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForCreatedBy, 'Request.qGetDbSchemaForCreatedBy', false));
					}
				</cfscript>
				<div id="div_abstract_objectCreatorMakeObject" style="display: inline;">
					<div id="div_objectCreatorMakeObject" style="display: inline;">
						<table width="250" cellpadding="-1" cellspacing="-1">
							<tr>
								<td bgcolor="silver" align="center">
									<span class="boldPromptTextClass"><NOBR>Class Name:</NOBR>&nbsp;</span>
									<span id="span_objectCreatorMakeObject_className" class="normalStatusBoldClass">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td>
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Object Name:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForObjectName")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForObjectName);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewObjectName" id="wwNewObjectName" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Pub Version:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForPublishedVersion")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForPublishedVersion);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewPublishedVersion" id="wwNewPublishedVersion" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Edit Version:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForEditVersion")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForEditVersion);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewEditVersion" id="wwNewEditVersion" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Created/Updated By:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForCreatedBy")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForCreatedBy);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewCreatedBy" id="wwNewCreatedBy" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<div id="div_objectCreatorMakeObject_btn_makeObject" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_makeObject" id="btn_makeObject" value="[Make Object]" onclick="var obj = objectCreator_getGUIObjectInstanceById('wwObjectClassID'); var obj2 = objectCreator_getGUIObjectInstanceById('wwObjectType'); if ( (obj != null) && (obj2 != null) ) { performCreateObject(obj.value, obj2.value, false); }">
									</div>
									<div id="div_objectCreatorMakeObject_btn_editObject" style="display: none;">
										<input disabled type="button" class="buttonClass" name="btn_editObject" id="btn_editObject" value="[Save Object]" onclick="var obj = objectCreator_getGUIObjectInstanceById('wwObjectClassID'); var obj2 = objectCreator_getGUIObjectInstanceById('wwObjectType'); if ( (obj != null) && (obj2 != null) ) { performCreateObject(obj.value, obj2.value, true); }">
									</div>
									<div id="div_objectCreatorMakeObject_btn_newObject" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_newObject" id="btn_newObject" value="[New Object]" onclick="performNewObject(); return false;">
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="div_abstract_objectCreatorSearchObjects" style="display: inline;">
					<div id="div_objectCreatorSearchObjects" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Search for Name:</NOBR>&nbsp;</span>
						<input disabled type="text" name="anObjectCreatorSearch" id="anObjectCreatorSearch" class="textClass" size="20" maxlength="30">
						<input disabled type="button" class="buttonClass" name="btn_performObjectCreatorSearch" id="btn_performObjectCreatorSearch" value="[Go]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorSearch'); if (obj != null) { performCreatorSearchUsing(obj.value); }">
					</div>
				</div>
				<div id="div_abstract_objectCreatorListObjects" style="display: inline;">
					<div id="div_objectCreatorListObjects" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Object Name:</NOBR>&nbsp;</span>
						<cfsavecontent variable="sql_qGetAllObjects">
							<cfinclude template="cfinclude_qGetAllObjects.cfm">
						</cfsavecontent>
						<cfscript>
							_sql_statement = sql_qGetAllObjects;
							Request.commonCode.safely_execSQL('Request.qGetAllObjects', Request.DSN, _sql_statement);
						</cfscript>
						<input type="hidden" name="anObjectCreatorID" id="anObjectCreatorID" value="">
						<select disabled name="anObjectCreatorName" id="anObjectCreatorName" class="textClass" onchange="populateObjectCreatorMakeObject(this.options[this.selectedIndex].value, this.options[this.selectedIndex].text); return false;">
							<cfscript>
								if (IsDefined("Request.qGetAllObjects")) {
									for (i = 1; i lte Request.qGetAllObjects.recordCount; i = i + 1) {
										writeOutput('<option value="#Request.qGetAllObjects.ID[i]#">#Request.qGetAllObjects.objectName[i]#</option>');
									}
								}
							</cfscript>
						</select>
						<input disabled type="button" class="buttonClass" name="btn_anObjectCreatorDelete" id="btn_anObjectCreatorDelete" value="[Delete Object]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); if (obj != null) { var sels = objectCreator_getSelectionsFromObj(obj); var obj_cid = objectCreator_getGUIObjectInstanceById('wwObjectClassID'); if (obj_cid != null) { performDeleteObject(sels, obj_cid.value); }; }; return false;">
						<span id="span_status_anObjectCreatorDelete" class="onholdStatusSmallBoldClass"></span>
					</div>
				</div>
				<cfscript>
					Request.commonCode.GetDbSchemaForTable('objectAttributes');
					if (NOT Request.dbError) {
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForTable, 'Request.qGetDbSchemaForTable', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForAttributeName', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('AttributeName'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForAttributeName, 'Request.qGetDbSchemaForAttributeName', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForAttributeValueString', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('ValueString'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForAttributeValueString, 'Request.qGetDbSchemaForAttributeValueString', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForAttributeValueText', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('ValueText'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForAttributeValueText, 'Request.qGetDbSchemaForAttributeValueText', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForCreatedBy', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('CreatedBy'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForCreatedBy, 'Request.qGetDbSchemaForCreatedBy', false));
					}
				</cfscript>
				<div id="div_abstract_objectCreatorMakeAttribute" style="display: inline;">
					<div id="div_objectCreatorMakeAttribute" style="display: inline;">
						<table width="450" cellpadding="-1" cellspacing="-1">
							<tr>
								<td bgcolor="silver" align="center">
									<span class="boldPromptTextClass"><NOBR>Object Name:</NOBR>&nbsp;</span>
									<span id="span_objectCreatorMakeAttribute_objectName" class="normalStatusBoldClass">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td>
									<input type="hidden" name="wwObjectAttributeID" id="wwObjectAttributeID" value="">
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Attribute Name:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForAttributeName")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForAttributeName);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewAttributeName" id="wwNewAttributeName" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Value:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													metricsValueString = StructNew();
													if (IsDefined("Request.qGetDbSchemaForAttributeValueString")) {
														metricsValueString = fieldMetricsFromQuery(Request.qGetDbSchemaForAttributeValueString);
													}
													metricsValueText = StructNew();
													if (IsDefined("Request.qGetDbSchemaForAttributeValueText")) {
														metricsValueText = fieldMetricsFromQuery(Request.qGetDbSchemaForAttributeValueText);
													}
													bool_useTextArea = false;
													metrics = metricsValueString;
													if ( (IsDefined("metricsValueString.maxlength")) AND (IsDefined("metricsValueText.maxlength")) ) {
														if (Max(metricsValueString.maxlength, metricsValueText.maxlength) gt 7000) {
															bool_useTextArea = true;
														} else {
															if (metricsValueText.maxlength eq Min(metricsValueString.maxlength, metricsValueText.maxlength)) {
																metrics = metricsValueText;
															}
														}
													}
												</cfscript>
												<cfif (bool_useTextArea)>
													<textarea disabled cols="50" rows="10" name="wwNewAttributeValue" id="wwNewAttributeValue" class="textClass"></textarea>
												<cfelseif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewAttributeValue" id="wwNewAttributeValue" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Created/Updated By:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForCreatedBy")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForCreatedBy);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="wwNewAttributeCreatedBy" id="wwNewAttributeCreatedBy" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<div id="div_objectCreatorMakeAttribute_btn_makeAttribute" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_makeAttribute" id="btn_makeAttribute" value="[Make Attribute]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); if (obj != null) { var objName = objectCreator_getGUIObjectInstanceById('wwNewAttributeName'); if (objName != null) { var objValue = objectCreator_getGUIObjectInstanceById('wwNewAttributeValue'); if (objValue != null) { var objBy = objectCreator_getGUIObjectInstanceById('wwNewAttributeCreatedBy'); if (objBy != null) { var sels = objectCreator_getSelectionsFromObj(obj); performCreateAttribute(sels, objName.value, URLEncode(objValue.value), objBy.value); }; }; }; };">
									</div>
									<div id="div_objectCreatorMakeAttribute_btn_editAttribute" style="display: none;">
										<input disabled type="button" class="buttonClass" name="btn_editAttribute" id="btn_editAttribute" value="[Save Attribute]" onclick="var objID = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); if (objID != null) { var obj = objectCreator_getGUIObjectInstanceById('wwObjectAttributeID'); if (obj != null) { var aid = obj.value; var objName = objectCreator_getGUIObjectInstanceById('wwNewAttributeName'); if (objName != null) { var objValue = objectCreator_getGUIObjectInstanceById('wwNewAttributeValue'); if (objValue != null) { var objBy = objectCreator_getGUIObjectInstanceById('wwNewAttributeCreatedBy'); if (objBy != null) { var sels = objectCreator_getSelectionsFromObj(objID); performSaveAttribute(sels, aid, objName.value, URLEncode(objValue.value), objBy.value); }; }; }; }; };">
									</div>
									<div id="div_objectCreatorMakeAttribute_btn_newAttribute" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_newAttribute" id="btn_newAttribute" value="[New Attribute]" onclick="performNewAttribute(); return false;">
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="div_abstract_objectCreatorListAttributes" style="display: inline;">
					<div id="div_objectCreatorListAttributes" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Search for Attribute Name:</NOBR>&nbsp;</span>
						<input disabled type="text" name="anAttributeCreatorSearch" id="anAttributeCreatorSearch" class="textClass" size="20" maxlength="30">
						<input disabled type="button" class="buttonClass" name="btn_performAttributeCreatorSearch" id="btn_performAttributeCreatorSearch" value="[Go]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anAttributeCreatorSearch'); if (obj != null) { var objL = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); if (objL != null) { var sels = objectCreator_getSelectionsFromObj(objL); performAttributeCreatorSearchUsing(sels, obj.value); }; };">
						<input type="hidden" name="anAttributeCreatorID" id="anAttributeCreatorID" value="">
					</div>
				</div>
				<div id="div_abstract_objectCreatorAttributeSelector" style="display: inline;">
					<div id="div_objectCreatorAttributeSelector" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Attribute Name:</NOBR>&nbsp;</span>
						<select disabled name="anAttributeCreatorName" id="anAttributeCreatorName" class="textClass" onchange="populateCreatorMakeAttribute(this.options[this.selectedIndex].value, this.options[this.selectedIndex].text); return false;">
						</select>
						<input disabled type="button" class="buttonClass" name="btn_anAttributeCreatorDelete" id="btn_anAttributeCreatorDelete" value="[Delete Attribute]" onclick="var obj = objectCreator_getGUIObjectInstanceById('anAttributeCreatorName'); if (obj != null) { var sels = objectCreator_getSelectionsFromObj(obj); var object = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); if (object != null) { var object_sels = objectCreator_getSelectionsFromObj(object); performDeleteObjectsAttribute(sels, object_sels); }; }; return false;">
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

</cfcomponent>
