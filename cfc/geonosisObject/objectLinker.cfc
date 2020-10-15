<cfcomponent displayname="Object Linker Code" name="objectLinker" extends="objectSupport">
	<cffunction name="init" access="public" returntype="struct">
		<cfscript>
			super.init();
			this.vars = StructNew();
		</cfscript>
		
		<cfreturn this>
	</cffunction>

	<cfsavecontent variable="this.sql_qGetObjectTypes">
		<cfinclude template="cfinclude_qGetObjectTypes.cfm">
	</cfsavecontent>

	<cfsavecontent variable="this.sql_qGetAllObjectLinks">
		<cfoutput>
			<cfinclude template="cfinclude_qGetAllObjectLinks.cfm">
		</cfoutput>
	</cfsavecontent>

	<cffunction name="jsCode" access="public" returntype="string">
		<cfsavecontent variable="_html">
			<cfoutput>
				<script language="JavaScript1.2" type="text/javascript">
				<!--
					function objectLinker_locateItemsInArray(a, what, start) {
						var f = 0;
						if (start) {
							startWhere = start 
						}
						else {
							startWhere = 0;
						}
						for(f = startWhere; f < a.length; f++) {
							if(a[f].toString() == what.toString()) {
								return f;
							}
						}
						return -1;
					}

					function objectLinker_getGUIObjectInstanceById(id) {
						return $(id);
					}

					function objectLinker_getSelectionsFromObj(obj) {
						return _getSelectionsFromObj(obj);
;
					 }

					function objectLinker_chooseObjectType(newLoc) {
						var s = objectLinker_getSelectionsFromObj(newLoc);

						if (s.length > 0) {
							getObjectIdsFor(s.join(','));
						}
					 }
					 
					function objectLinker_removeArrayItem(a,i) {
						var j = a.length;
						for (; i < j; i++) {
							if (a[i] == null) {
								break;
							}
							a[i] = a[i + 1];
						}
						a[i] = null;
					}

					 function removeObject2LinkUsing(sels) {
					 	var _f = -1;
						var i = -1;
						var j = -1;
						var ar = [];
						var arSel = [];
						var aSel = -1;
						var _msg = '';
						var bool = false;
						var _cnt = 0;

					 	var obj = objectLinker_getGUIObjectInstanceById(sels[0]);
						if (obj != null) {
							arSel = sels[1];
							for (j = 0; j < arSel.length; j++) {
								ar = [];
								for (i = 0; i < obj.options.length; i++) {
									ar.push(obj.options[i].value);
								}
								aSel = arSel[j];
							//	alert('ar = ' + ar + '\n' + 'aSel = [' + aSel + ']');
								_f = objectLinker_locateItemsInArray(ar, aSel, 0);
								if (_f > -1) {
									obj.options[_f] = null;
									bool = true;
									_msg += '(' + aSel + ')';
									_cnt++;
								}
							}
						}
						if (bool) {
							window.status = 'INFO: Removed Object ID(s) ' + _msg + ' from the list of Objects to Link.';
						}
					 }

					 function objectLinker_anObjectList_statusHandler(s, bool) {
					 	var id = ((bool) ? 'span_objectPickerObjectsLinker_statusMsg' : 'span_objectPickerObjectsLinker_errorMsg');
						var obj = objectLinker_getGUIObjectInstanceById(id);
						if (obj != null) {
							flushGUIObjectChildrenForObj(obj);
							obj.innerHTML = s; 
						}
					 	var id = ((bool) ? 'span_objectPickerObjectsLinker_errorMsg' : 'span_objectPickerObjectsLinker_statusMsg');
						var obj = objectLinker_getGUIObjectInstanceById(id);
						if (obj != null) {
							flushGUIObjectChildrenForObj(obj);
							obj.innerHTML = ''; 
						}
					 }

					 function objectLinker_anObjectList_onchangeHandler(obj) {
					 	var sels = objectLinker_getSelectionsFromObj(obj);
						var ar = sels[1];
						var obj = objectLinker_getGUIObjectInstanceById('btn_removeObject2Link');
						if (obj != null) {
							obj.disabled = ((ar.length >= 1) ? false : true);
						}
						if (ar.length == 2) {
							DWREngine._execute(_cfscriptLocation, null, 'CheckObjectLinkerValidity', ar[0], ar[1], handleCheckObjectLinkerValidityResults);
						} else {
							obj = objectLinker_getGUIObjectInstanceById('btn_performObjectLinker');
							if (obj != null) {
								obj.disabled = ((ar.length == 2) ? false : true); 
							}
							if (ar.length != 2) {
								objectLinker_anObjectList_statusHandler('** WARNING: You must select 2 Objects to Link.' + ((ar.length > 2) ? '  Kindly select <i><u>only</u></i> 2 Objects.' : '  Kindly select <i><u>another</u></i> Object.'), false);
							}
						}
						return false;
					 }
					 
					function _handleCheckObjectLinkerValidityResults(anObject) {
						// BEGIN: Defer this block of code to a handler for an Ajax call to determine if the 2 selected objects are already linked... ?!?
						obj = objectLinker_getGUIObjectInstanceById('btn_performObjectLinker');
						if (obj != null) {
							obj.disabled = ((anObject.length > 0) ? true : false); 
						}
						if (anObject.length > 0) {
							objectLinker_anObjectList_statusHandler('** WARNING: Cannot Link the 2 selected Objects because they are <i><u>already</u></i> linked.', false);
						} else {
							objectLinker_anObjectList_statusHandler('** INFO: The 2 selected Objects may be linked. You may proceed...', true);
						}
						// END! Defer this block of code to a handler for an Ajax call to determine if the 2 selected objects are already linked... ?!?
					}
					
					function handleCheckObjectLinkerValidityResults(anObject) {
						return handlePossibleSQLError(anObject, _handleCheckObjectLinkerValidityResults);
					}
				//-->
				</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn _html>
	</cffunction>

	<cffunction name="objectPickerChooseClasses" access="public" returntype="string">
		<cfset var _html = "">
		<cfsavecontent variable="_html">
			<cfoutput>
				<div id="div_abstract_objectPickerChooseClasses" style="display: inline;">
					<div id="div_objectPickerChooseClasses" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Valid Type(s):</NOBR>&nbsp;</span>
						<cfscript>
							_nonZeroCount = 0;
							Request.commonCode.safely_execSQL('Request.qGetObjectTypes', Request.DSN, this.sql_qGetObjectTypes);
							if ( (NOT Request.dbError) AND (IsDefined("Request.qGetObjectTypes")) AND (IsDefined("Request.qGetObjectTypes.recordCount")) ) {
								_maxLen = 0;
								for (i = 1; i lte Request.qGetObjectTypes.recordCount; i = i + 1) {
									_maxLen = Max(_maxLen, Len(Request.qGetObjectTypes.className[i]));
									if (Request.qGetObjectTypes.cnt[i] gt 0) {
										_nonZeroCount = _nonZeroCount + 1;
									}
								}
							}
						</cfscript>
						<cfif (IsDefined("Request.qGetObjectTypes.recordCount"))>
							<select id="validTypes" name="validTypes" class="textClass" multiple size="#Min(_nonZeroCount, Request.qGetObjectTypes.recordCount)#" onchange="objectLinker_chooseObjectType(this); return false;">
								<cfscript>
									if ( (NOT Request.dbError) AND (IsDefined("Request.qGetObjectTypes")) ) {
										for (i = 1; i lte Request.qGetObjectTypes.recordCount; i = i + 1) {
											_selectedParm = '';
											if (Request.qGetObjectTypes.cnt[i] gt 0) {
												writeOutput('<option value="#Request.qGetObjectTypes.objectClassID[i]#"#_selectedParm#>#Request.qGetObjectTypes.className[i]#</option>');
											}
										}
									}
								</cfscript>
							</select>
						</cfif>
					</div>
				</div>
				<div id="div_abstract_objectPickerChooseObjects" style="display: inline;">
					<div id="div_objectPickerChooseObjects" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Object Type:</NOBR>&nbsp;</span>
						<select name="anObjectClass" id="anObjectClass" class="textClass" onchange="getObjectsForType(this.options[this.selectedIndex].value); return false;">
						</select>
					</div>
				</div>
				<div id="div_abstract_objectPickerChooseObjectsSearch" style="display: inline;">
					<div id="div_objectPickerChooseObjects2" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Search for Name:</NOBR>&nbsp;</span>
						<input type="text" name="anObjectSearch" id="anObjectSearch" class="textClass" size="20" maxlength="30">
						<input type="button" class="buttonClass" name="btn_performSearch" id="btn_performSearch" value="[Go]" onclick="var obj = objectLinker_getGUIObjectInstanceById('anObjectSearch'); if (obj != null) { performSearchUsing(obj.value); }">
						<span class="boldPromptTextClass"><NOBR>Object Name:</NOBR>&nbsp;</span>
						<select name="anObjectName" id="anObjectName" class="textClass" onchange="var ar = []; var obj = objectLinker_getGUIObjectInstanceById('anObjectList'); if (obj != null) { var sels = obj.options; for (var i = 0; i < sels.length; i++) { ar.push(sels[i].value); }; }; var v = this.options[this.selectedIndex].value; if (v > 0) { var _f = objectLinker_locateItemsInArray(ar, v, 0); if (_f == -1) { getObjectById(v); } else { window.status = 'WARNING: An instance of an Object cannot be linked to itself however it can be linked to a different instance of an Object.'; }  };  return false;">
						</select>
					</div>
				</div>
				<div id="div_abstract_objectPickerObjectsLinker" style="display: inline;">
					<div id="div_objectPickerObjectsLinker" style="display: inline;">
						<table cellpadding="-1" cellspacing="-1">
							<tr>
								<td>
									<span class="boldPromptTextClass"><NOBR>Object(s) To Link:</NOBR>&nbsp;</span>
									<select name="anObjectList" id="anObjectList" size="6" multiple class="textClass" onchange="objectLinker_anObjectList_onchangeHandler(this); return false;">
									</select>
								</td>
								<td>
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td>
												<input disabled type="button" class="buttonClass" name="btn_removeObject2Link" id="btn_removeObject2Link" value="[<<]" onclick="var obj = objectLinker_getGUIObjectInstanceById('anObjectList'); if (obj != null) { var sels = objectLinker_getSelectionsFromObj(obj); removeObject2LinkUsing(sels); this.disabled = true; var obj2 = objectLinker_getGUIObjectInstanceById('btn_performObjectLinker'); if (obj2 != null) { var objMsg1 = objectLinker_getGUIObjectInstanceById('span_objectPickerObjectsLinker_errorMsg'); if (objMsg1 != null) { flushGUIObjectChildrenForObj(objMsg1); objMsg1.innerHTML = ''; }; var objMsg2 = objectLinker_getGUIObjectInstanceById('span_objectPickerObjectsLinker_statusMsg'); if (objMsg2 != null) { flushGUIObjectChildrenForObj(objMsg2); objMsg2.innerHTML = ''; }; obj2.disabled = true; } }; return false;">
											</td>
										</tr>
										<tr>
											<td>
												<input disabled type="button" class="buttonClass" name="btn_performObjectLinker" id="btn_performObjectLinker" value="[Link]" onclick="var obj = objectLinker_getGUIObjectInstanceById('anObjectList'); if (obj != null) { var sels = objectLinker_getSelectionsFromObj(obj); performObjectLinkerUsing(sels); removeObject2LinkUsing(sels); this.disabled = true; var obj2 = objectLinker_getGUIObjectInstanceById('btn_removeObject2Link'); if (obj2 != null) { obj2.disabled = true; } }; return false;">
												<span id="span_objectPickerObjectsLinker_errorMsg" class="errorStatusBoldClass"></span>
												<span id="span_objectPickerObjectsLinker_statusMsg" class="normalStatusBoldClass"></span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="div_abstract_objectPickerObjectsLinked" style="display: inline;">
					<div id="div_objectPickerObjectsLinked" style="display: inline;">
						<span class="boldPromptTextClass"><NOBR>Object Link(s):</NOBR>&nbsp;</span>
						<cfscript>
							Request.commonCode.safely_execSQL('Request.qGetAllObjectLinks', Request.DSN, this.sql_qGetAllObjectLinks);
						</cfscript>
						<select name="anObjectLinksList" id="anObjectLinksList" class="textClass" onchange="var sels = objectLinker_getSelectionsFromObj(this); populateLinkObjectEditorUsing(sels); return false;">
							<cfscript>
								if ( (NOT Request.dbError) AND (IsDefined("Request.qGetAllObjectLinks")) ) {
									for (i = 1; i lte Request.qGetAllObjectLinks.recordCount; i = i + 1) {
										_optText = Request.qGetAllObjectLinks.OBJECTLINKNAME[i];
										writeOutput('<option value="#Request.qGetAllObjectLinks.id[i]#">#_optText#</option>');
									}
								}
							</cfscript>
						</select>
						<input disabled type="button" class="buttonClass" name="anObjectLinksDelete" id="anObjectLinksDelete" value="[Delete Object Link]" onclick="var obj = objectLinker_getGUIObjectInstanceById('anObjectLinksList'); if (obj != null) { var sels = objectLinker_getSelectionsFromObj(obj); performDeleteObjectLinks(sels); }; return false;">
					</div>
				</div>
				<cfscript>
					Request.commonCode.GetDbSchemaForTable('objectLinks');
					if (NOT Request.dbError) {
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForTable, 'Request.qGetDbSchemaForTable', false));
						msBegin = GetTickCount();

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForOwnerPropertyName', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('OwnerPropertyName'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForOwnerPropertyName, 'Request.qGetDbSchemaForOwnerPropertyName', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForRelatedPropertyName', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('RelatedPropertyName'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForRelatedPropertyName, 'Request.qGetDbSchemaForRelatedPropertyName', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForOwnerAutoload', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('OwnerAutoload'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForOwnerAutoload, 'Request.qGetDbSchemaForOwnerAutoload', false));

						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForRelatedAutoload', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('RelatedAutoload'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForRelatedAutoload, 'Request.qGetDbSchemaForRelatedAutoload', false));
						
						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForDisplayOrder', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('DisplayOrder'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForDisplayOrder, 'Request.qGetDbSchemaForDisplayOrder', false));
						
						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForStartVersion', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('StartVersion'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForStartVersion, 'Request.qGetDbSchemaForStartVersion', false));
						
						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForLastVersion', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('LastVersion'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForLastVersion, 'Request.qGetDbSchemaForLastVersion', false));
						
						Request.commonCode.safely_execSQL('Request.qGetDbSchemaForCreatedBy', '', "SELECT * FROM Request.qGetDbSchemaForTable WHERE (UPPER(COLUMN_NAME) = UPPER('CreatedBy'))");
					//	writeOutput(Request.commonCode.cf_dump(Request.qGetDbSchemaForCreatedBy, 'Request.qGetDbSchemaForCreatedBy', false));

						msEnd = GetTickCount();
						msElapsed = (msEnd - msBegin) / 1000;
					//	writeOutput('<span class="onholdStatusClass">DEBUG: Method_1 Executes in #Request.commonCode.secondsToHHMMSS(msElapsed)#.</span><br>');
					}
				</cfscript>
				<div id="div_abstract_objectPickerObjectLinkEditor" style="display: inline;">
					<div id="div_objectPickerObjectLinkEditor" style="display: inline;">
						<table width="350" cellpadding="-1" cellspacing="-1">
							<tr>
								<td bgcolor="silver" align="center">
									<span class="boldPromptTextClass"><NOBR>Object Link:</NOBR>&nbsp;</span>
									<span id="span_objectLinkEditor_linkName" class="normalStatusBoldClass">&nbsp;</span>
								</td>
							</tr>
							<tr>
								<td>
									<table width="100%" cellpadding="-1" cellspacing="-1">
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Owner Property Name:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForOwnerPropertyName")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForOwnerPropertyName);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorOwnerPropertyName" id="linkEditorOwnerPropertyName" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForOwnerPropertyName".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Related Property Name:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForRelatedPropertyName")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForRelatedPropertyName);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorRelatedPropertyName" id="linkEditorRelatedPropertyName" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForRelatedPropertyName".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Owner Autoload:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForOwnerAutoload")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForOwnerAutoload);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorOwnerAutoload" id="linkEditorOwnerAutoload" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForOwnerAutoload".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Related Autoload:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForRelatedAutoload")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForRelatedAutoload);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorRelatedAutoload" id="linkEditorRelatedAutoload" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForRelatedAutoload".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Display Order:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForDisplayOrder")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForDisplayOrder);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorDisplayOrder" id="linkEditorDisplayOrder" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForDisplayOrder".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Start Version:</NOBR></span>
											</td>
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForStartVersion")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForStartVersion);
													}
												</cfscript>
											<td align="left">
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorStartVersion" id="linkEditorStartVersion" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForStartVersion".</b></font>
												</cfif>
											</td>
										</tr>
										<tr>
											<td align="center">
												<span class="boldPromptTextClass"><NOBR>Last Version:</NOBR></span>
											</td>
											<td align="left">
												<cfscript>
													if (IsDefined("Request.qGetDbSchemaForLastVersion")) {
														metrics = fieldMetricsFromQuery(Request.qGetDbSchemaForLastVersion);
													}
												</cfscript>
												<cfif (IsDefined("metrics.size")) AND (IsDefined("metrics.maxlength"))>
													<input disabled type="text" name="linkEditorLastVersion" id="linkEditorLastVersion" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForLastVersion".</b></font>
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
													<input disabled type="text" name="linkEditorCreatedBy" id="linkEditorCreatedBy" class="textClass" size="#metrics.size#" maxlength="#metrics.maxlength#">
												<cfelse>
													<font color="red"><b>ERROR: Missing Query named "Request.qGetDbSchemaForCreatedBy".</b></font>
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<div id="div_objectPickerObjectLinkEditor_btn_SaveLinkObject" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_SaveLinkObject" id="btn_SaveLinkObject" value="[Save Link Object]" onclick="performSaveLinkObject(); return false;">
									</div>
									<div id="div_objectPickerObjectLinkEditor_btn_NewLinkObject" style="display: inline;">
										<input disabled type="button" class="buttonClass" name="btn_NewLinkObject" id="btn_NewLinkObject" value="[New Link Object]" onclick="performNewLinkObject(); return false;">
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn _html>
	</cffunction>

</cfcomponent>
