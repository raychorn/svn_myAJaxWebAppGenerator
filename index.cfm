<cfscript>
	anObjLinker = Request.commonCode.objectForType('objectLinker');
	if (NOT Request.err_objectFactory) {
	//	writeOutput(Request.commonCode.cf_dump(anObjLinker, 'anObjLinker', false));
	} else {
		anObjLinker = -1;
		writeOutput('<span class="errorStatusBoldClass">ObjectFactory threw an error - this is a problem. (#Request.err_objectFactoryMsg#)</span><br>');
	}

	anObjCreator = Request.commonCode.objectForType('objectCreator');
	if (NOT Request.err_objectFactory) {
	//	writeOutput(Request.commonCode.cf_dump(anObjCreator, 'anObjCreator', false));
	} else {
		anObjLinker = -1;
		writeOutput('<span class="errorStatusBoldClass">ObjectFactory threw an error - this is a problem. (#Request.err_objectFactoryMsg#)</span><br>');
	}
</cfscript>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script language="JavaScript1.2" src="js/MathAndStringExtend.js" type="text/javascript"></script>
		<script language="JavaScript1.2" src="js/dictionary_obj.js" type="text/javascript"></script>

		<cfoutput>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
			<title>#Request.const_trademark_symbol# (#Application.applicationname#</title>
			#Request.meta_vars#
		</cfoutput>
		
		<script language="JavaScript1.2" type="text/javascript" src="core/engine.js"></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/util.js'></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/settings.js'></script>

		<script language="JavaScript1.2" type='text/javascript' src='core/js/security.js'></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/js/utility.js'></script>

		<cfoutput>
			<cfif (IsStruct(Request.CommonCode))>
				#Request.CommonCode.js_daysInMonthForYear#
			</cfif>

			<script language="JavaScript1.2" type="text/javascript">
			<!--
				function _dispaySysMessages(s, t, bool_hideShow, taName) {
					if (taName.toUpperCase() == 'ta_menuHelperPanel'.toUpperCase()) {
						var taObj = _$(taName);
						if (!!taObj) {
							taObj.value += s;
						}
					} else {
						var cObj = $('div_sysMessages');
						var tObj = $('span_sysMessages_title');
						var sObj = $('span_sysMessages_body');
						var taObj = _$(taName);
						var s_ta = '';
						if ( (!!cObj) && (!!sObj) && (!!tObj) ) {
							bool_hideShow = ((bool_hideShow == true) ? bool_hideShow : false);
							s_ta = ((!!taObj) ? taObj.value : '');
							flushGUIObjectChildrenForObj(sObj);
							sObj.innerHTML = '<textarea id="' + taName + '" class="codeSmaller" cols="150" rows="30" readonly>' + ((s.length > 0) ? s_ta + '\n' : '') + s + '</textarea>';
							flushGUIObjectChildrenForObj(tObj);
							tObj.innerHTML = t;
							cObj.style.display = ((bool_hideShow) ? const_inline_style : const_none_style);
							cObj.style.position = 'absolute';
							cObj.style.left = 10 + 'px';
							cObj.style.top = 10 + 'px';
							cObj.style.width = (clientWidth() - 10) + 'px';
							cObj.style.height = (clientHeight() - 10) + 'px';
						}
					}
				}
				
				function dispaySysMessages(s, t) {
					return _dispaySysMessages(s, t, true, 'textarea_sysMessages_body');
				}
				
				function _alert(s) {
					return dispaySysMessages(s, 'DEBUG');
				}
	
				function dismissSysMessages() {
					return _dispaySysMessages('', '', false, 'textarea_sysMessages_body');
				}
				
				function _alertM(s) {
					return _dispaySysMessages('-->' + s + '\n', '', true, 'ta_menuHelperPanel');
				}
			//-->
			</script>

			<script language="JavaScript1.2" type="text/javascript">
			<!--
				var stack_opened_GUIs = [];
				
				var bool_isDevUser = #Request.bool_isDevUser#;
				
				var const_Choose_symbol = '#Request.const_Choose_symbol#';
				var const_AddRole_symbol = '#Request.const_AddRole_symbol#';
				var const_num_rows_user_mgr = #Request.const_num_rows_user_mgr#;

				var const_button_symbol = 'button';
				var const_inline_style = 'inline';
				var const_none_style = 'none';

				var const_wwNewObjectName = 'wwNewObjectName';
				var const_wwNewPublishedVersion = 'wwNewPublishedVersion';
				var const_wwNewEditVersion = 'wwNewEditVersion';
				var const_wwNewCreatedBy = 'wwNewCreatedBy';
					
				_cfscriptLocation = "#Request.commonCode.fullyQualifiedURLPrefix()#/functions.cfm";
	
				/**************************************************************************/
				
				function trim() {  
				 	var s = null;
					// trim white space from the left  
					s = this.replace(/^[\s]+/,"");  
					// trim white space from the right  
					s = s.replace(/[\s]+$/,"");  
					return s;
				}
				
				String.prototype.trim = trim;
				/**************************************************************************/

				function isEmailAddressValid(s) {
					var i = s.indexOf('.');
					var j = s.indexOf('@');
					var ch1 = '';
					var ch2 = '';
					var bool = false;

					ch1 = ((j > -1) ? s.charAt(j - 1) : '');
					ch2 = ((i > -1) ? s.charAt(i + 1) : '');
					bool = ( ( (i == -1) || (j == -1) ) || (i <= j) || ((Math.max(i ,j) - Math.min(i, j)) == 1) || (ch1.length == 0) || (ch2.length == 0) );
				//	window.status = 'j = [' + j + ']' + ', i = [' + i + ']' + ', ch1 = [' + ch1 + ']' + ', ch2 = [' + ch2 + ']' + ', s = [' + s + ']' + ', bool = [' + bool + ']';
					return bool;
				}
				
				function validateEmail(s) {
					var bool_isEmailAddressValid = isEmailAddressValid(s);
					if (bool_isEmailAddressValid) {
						var objUserName = $('user_login_UserName');
						if (objUserName != null) {
							objUserName.focus();
						}
						var mObj = $('span_user_login_status_message');
						if (mObj != null) {
							flushGUIObjectChildrenForObj(mObj);
							mObj.innerHTML = 'WARNING: Email address entered is invalid. PLS enter a valid internet email address.';
						}
						
						disableWidgetByID('user_login_btn_login', true);
						return false;
					} else {
						var bool_isPasswordValid = false;
						var pObj = $('user_login_Password');
						if (pObj != null) {
							bool_isPasswordValid = isPasswordValid(pObj.value);
						}

						if (bool_isPasswordValid) {
							var mObj = $('span_user_login_status_message');
							if (mObj != null) {
								flushGUIObjectChildrenForObj(mObj);
								mObj.innerHTML = '';
							}
							disableWidgetByID('user_login_btn_login', false);
							return true;
						} else {
							var mObj = $('span_user_login_status_message');
							if (mObj != null) {
								flushGUIObjectChildrenForObj(mObj);
								mObj.innerHTML = 'WARNING: The email address appears to be well-formed however the password must contain the following characters ("a"-"z" or "A"-"Z" and "0"-"9" and any special characters).';
							}
							disableWidgetByID('user_login_btn_login', true);
							return false;
						}
					}
				}
				
				function validateName(id, s) {
					var t = '';
					var i = -1;
					var j = -1;
					var aa = -1;
					var a = s.split(' ');
					for (i = 0; i < a.length; i++) {
						a[i] = a[i].substring(0, 1).toUpperCase() + a[i].substring(1, a[i].length).toLowerCase();

						aa = a[i].split('-');
						for (j = 0; j < aa.length; j++) {
							aa[j] = aa[j].substring(0, 1).toUpperCase() + aa[j].substring(1, aa[j].length).toLowerCase();
						}
						a[i] = aa.join('-');
					}
					t = a.join(' ');
					var cObj = $(id);
					if (cObj != null) {
						cObj.value = t;
					}
					return true;
				}

				function validateEmailUserManager(s, btn_action) {
					var bool_isEmailAddressValid = isEmailAddressValid(s);
					if (bool_isEmailAddressValid) {
						disableWidgetByID(btn_action, true);
					} else {
						disableWidgetByID(btn_action, false);
					}
				}

				function validateRoleUserManager(idUserRole, btnAction, _sels) {
					var bool_isuserRoleValid = false;
					var sels = ((_sels != null) ? _sels : _getSelectionsFromObjByID('userManager_UserRole'));
					var ar = sels[1];
					bool_isuserRoleValid = ((ar[0].length > 0) ? false : true);
					disableWidgetByID('userManager_addUser', (bool_isuserRoleValid));
				}

				function validatePassword(s, _div_password_rating, _td_password_rating, _span_password_rating) {
					var bool_isPasswordValid = ((isPasswordValid(s)) ? false : true);

					ratePassword(s, _div_password_rating, _td_password_rating, _span_password_rating);
					
					if (bool_isPasswordValid) {
						var pObj = $('user_login_Password');
						if (pObj != null) {
							pObj.focus();
						}
						var mObj = $('span_user_login_status_message');
						if (mObj != null) {
							flushGUIObjectChildrenForObj(mObj);
							mObj.innerHTML = '#Request.const_password_invalid_warning#';
						}
						
						disableWidgetByID('user_login_btn_login', true);
						return false;
					} else {
						var bool_isEmailAddressValid = isEmailAddressValid(s);
						if (bool_isEmailAddressValid) {
							var mObj = $('span_user_login_status_message');
							if (mObj != null) {
								flushGUIObjectChildrenForObj(mObj);
								mObj.innerHTML = '';
							}
							disableWidgetByID('user_login_btn_login', false);
							return true;
						} else {
							var mObj = $('span_user_login_status_message');
							if (mObj != null) {
								flushGUIObjectChildrenForObj(mObj);
								mObj.innerHTML = 'WARNING: Email address entered is invalid. PLS enter a valid internet email address.';
							}
							disableWidgetByID('user_login_btn_login', true);
							return false;
						}
					}
				}

				function validateEmail2(s) {
					var bool_isEmailAddressValid = isEmailAddressValid(s);
					if (bool_isEmailAddressValid) {
						var objUserName = $('user_user_forgot_password_UserName');
						if (objUserName != null) {
							objUserName.focus();
						}
						var mObj = $('user_user_forgot_password_status_message');
						if (mObj != null) {
							flushGUIObjectChildrenForObj(mObj);
							mObj.innerHTML = 'WARNING: Email address entered is invalid. PLS enter a valid internet email address.';
						}
						
						disableWidgetByID('user_user_forgot_password_btn_getPassword', true);
						return true;
					} else {
						var mObj = $('user_user_forgot_password_status_message');
						if (mObj != null) {
							flushGUIObjectChildrenForObj(mObj);
							mObj.innerHTML = '';
						}
						disableWidgetByID('user_user_forgot_password_btn_getPassword', false);
						return false;
					}
				}

				/**************************************************************************/

				function _populateUserManager(anObject) {
					var cObj = -1;
					var _html = '';

					_html = html_PopulateUserManagerWithUsers(anObject);
					cObj = $('div_userManager_user_grid');
					if (cObj != null) {
						flushGUIObjectChildrenForObj(cObj);
						cObj.innerHTML = _html;
					}
				}
								
				function validateRoleNames(s, id) {
					s = s.substring(0, 1).toUpperCase() + s.substring(1, s.length);
					DWRUtil.setValue(id, s);
					return true;
				}

				function disableSearchWidgets(bool) {
					disableWidgetByID('anObjectSearch', bool);
					disableWidgetByID('btn_performSearch', bool);
				}

				function disableWidgets(bool) {
					var obj_anObjectName = -1;
					var okay_to_enable = true;
					disableWidgetByID('validTypes', bool);
					disableWidgetByID('anObjectClass', bool);
					obj_anObjectName = objectLinker_getGUIObjectInstanceById('anObjectName');
					if (bool == false) {
						if ( (obj_anObjectName != null) && (obj_anObjectName.options.length == 0) ) {
							okay_to_enable = false;
						}
					}
					if (okay_to_enable) {
						disableSearchWidgets(bool);
					}
					disableWidget(obj_anObjectName, bool);
					disableWidgetByID('anObjectList', bool);
				}

				function disableWidgets2(bool) {
					disableAllChildrenForObjById('div_objectCreatorMakeType', bool);
					disableAllChildrenForObjById('div_objectCreatorAvailableType', bool);
					disableAllChildrenForObjById('div_objectCreatorWorkingWith', bool);
					disableAllChildrenForObjById('div_objectCreatorMakeObject', bool);
					disableAllChildrenForObjById('div_objectCreatorMakeObject_btn_makeObject', bool);
					disableAllChildrenForObjById('div_objectCreatorMakeObject_btn_editObject', bool);
					disableAllChildrenForObjById('div_objectCreatorListObjects', bool);
					disableAllChildrenForObjById('div_objectCreatorListAttributes', bool);
					disableAllChildrenForObjById('div_objectCreatorAttributeSelector', bool);
				}
								
				function getObjectIdsFor(s) {
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'objectLookUp', s, handleGetObjectIdsForResult);
				}
				
				function _handleGetObjectIdsForResult(anObject) {
					var i = -1;
					var j = -1;
					var obj = -1;
					var ar = [];

					ar.push(const_Choose_symbol);
					for (i = 0; i < anObject.length; i++) {
						obj = anObject[i];
						for (j in obj) {
							ar.push(obj[j]);
						}
					}
					DWRUtil.removeAllOptions("anObjectClass");
					DWRUtil.addOptions("anObjectClass", ar);
					disableWidgets(false);
					disableWidgets2(false);
				}
			
				function handleGetObjectIdsForResult(anObject) {
					return handlePossibleSQLError(anObject, _handleGetObjectIdsForResult);
				}
			
				function getObjectsForType(s) {
					var obj = objectLinker_getGUIObjectInstanceById('anObjectSearch');
					if (obj != null) { 
						obj.value = '';
					}
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'objectsLookUp', s, handleGetObjectsResults);
				}

				function _getCreatedObjectsResults(anObject) {
					DWRUtil.removeAllOptions("anObjectCreatorName");
					DWRUtil.addOptions("anObjectCreatorName", anObject, 'ID', 'OBJECTNAME');
					disableWidgets(false);
					disableWidgets2(false);
				}

				function getCreatedObjectsResults(anObject) {
					return handlePossibleSQLError(anObject, _getCreatedObjectsResults);
				}
				
				function _handleGetObjectsResults(anObject) {
					DWRUtil.removeAllOptions("anObjectName");
					DWRUtil.addOptions("anObjectName", anObject, 'ID', 'OBJECTNAME');
					disableWidgets(false);
					disableWidgets2(false);
				}
				
				function handleGetObjectsResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetObjectsResults);
				}

				function getObjectById(id) {
					var t = '';
					var a = [];
					var data = new Object();
					disableWidgets(true);
					disableWidgets2(true);
					var obj = objectLinker_getGUIObjectInstanceById('anObjectName');
					if (obj != null) {
						t = obj.options[obj.selectedIndex].text
					}
					data.id = id;
					data.val = id + ' - ' + t;
					a.push(data);
					DWRUtil.addOptions("anObjectList", a, 'id', 'val');
					disableWidgets(false);
					disableWidgets2(false);
				}

				function performCreatorSearchUsing(s) {
					var t = '';
					var obj = objectCreator_getGUIObjectInstanceById('availableTypes');
					if (obj != null) {
						t = obj.options[obj.selectedIndex].text
					}
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'objectsLookUp', t, s, getCreatedObjectsResults);
				}
				
				function performSearchUsing(s) {
					var t = '';
					var obj = objectLinker_getGUIObjectInstanceById('anObjectClass');
					if (obj != null) {
						t = obj.options[obj.selectedIndex].value
					}
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'objectsLookUp', t, s, handleGetObjectsResults);
				}
				
				function debugString2Chars(s) {
					var i = -1;
					var _ch = '';
					var _db = '';
					var _db2 = '';
					
					_db += 'Len() = [' + s.length + '] ';
				//	_db2 += '[';
					for (i = 0; i < Math.min(100, s.length); i++) {
						_ch = s.charAt(i);
					//	_db += '##' + i + ' = [' + s.charCodeAt(i) + '] (' + _ch + ')\n';
					//	_db += '(' + i + ') = [' + s.charCodeAt(i) + ']\n';
				//		_db2 += _ch;
					}
				//	_db2 += ']\n';
				//	return _db; // + _db2;
					return s; // + _db2;
				}
				
				function performCreateType(s, p) {
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'makeNewType', s, p, getMakeTypesResults);
				}

				function iterateOverAjaxObjectWithActions(anObject, isFunc, doFunc, specific_ar) {
					var i = -1;
					var j = -1;
					var obj = -1;

					for (i = 0; i < anObject.length; i++) {
						obj = anObject[i];
						for (j in ((specific_ar != null) ? specific_ar : obj)) {
							if ( (isFunc != null) && (isFunc(obj)) ) {
								if (doFunc != null) {
									doFunc(obj);
								}
							}
						}
					}
					return anObject;
				}

				function iterateOverAjaxObject(anObject, func) {
					var i = -1;
					var j = -1;
					var obj = -1;
					var ar = [];
					var anObj = -1;

					for (i = 0; i < anObject.length; i++) {
						obj = anObject[i];
						anObj = new Object;
						for (j in obj) {
							anObj[j] = obj[j];
						}
						if (func(anObj)) {
							ar.push(anObj);
						}
					}
					return ar;
				}

				function _getMakeTypesResults(anObject) {
					function hasLinks(o) {
						return o.CNT > 0;
					}
					var ar = iterateOverAjaxObject(anObject, hasLinks);

					DWRUtil.removeAllOptions("validTypes");
					DWRUtil.addOptions("validTypes", ar, 'OBJECTCLASSID', 'CLASSNAME');

					DWRUtil.removeAllOptions("availableTypes");
					DWRUtil.addOptions("availableTypes", anObject, 'OBJECTCLASSID', 'CLASSNAME');

					DWRUtil.setValue("anObjectType", "");
					DWRUtil.setValue("anObjectPath", "");
					disableWidgets(false);
					disableWidgets2(false);
				}

				function getMakeTypesResults(anObject) {
					return handlePossibleSQLError(anObject, _getMakeTypesResults);
				}

				function workingWithWidgetsArray() {
					var ar = [];

					ar.push(const_wwNewObjectName);
					ar.push(const_wwNewPublishedVersion);
					ar.push(const_wwNewEditVersion);
					ar.push(const_wwNewCreatedBy);
					ar.push('btn_makeObject');
					ar.push('btn_editObject');
					ar.push('anObjectCreatorSearch');
					ar.push('btn_performObjectCreatorSearch');
					ar.push('anObjectCreatorName');
					
					return ar;
				}
				
				function enableEditableWidgets() {
					var i = -1;
					var ar = workingWithWidgetsArray();
					for (i = 0; i < ar.length; i++) {
						disableWidgetByID(ar[i], false);
					}
				}
				
				function workingWithObject(cid, name) {
					var obj = objectCreator_getGUIObjectInstanceById('span_objectCreatorMakeObject_className'); 
					if (obj != null) {
						flushGUIObjectChildrenForObj(obj);
						obj.innerHTML = name;
					}
					enableEditableWidgets();

					DWRUtil.setValue("wwObjectType", name);
					DWRUtil.setValue("wwObjectClassID", cid);

					setObjectDisplayStyleById('div_objectCreatorMakeObject_btn_makeObject', true);

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_editObject');
					if (obj != null) { 
						obj.style.display = const_none_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_editObject');
						if (obj != null) { 
							obj.disabled = true;
						}
					}
					DWRUtil.setValue("anObjectCreatorID", "");
					DWRUtil.setValue("wwNewObjectName", "");
					DWRUtil.setValue("wwNewPublishedVersion", "");
					DWRUtil.setValue("wwNewEditVersion", "");
					DWRUtil.setValue("wwNewCreatedBy", "");

					disableAllChildrenForObjById('div_objectCreatorMakeAttribute', true);

					setObjectDisplayStyleById('div_objectCreatorMakeAttribute_btn_makeAttribute', true);

					setObjectDisplayStyleById('div_objectCreatorMakeAttribute_btn_editAttribute', false);

					obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorSearch');
					if (obj != null) { 
						performCreatorSearchUsing(obj.value);
					}
				}

				function _performCreateObject(_bool, _cid, _cName, _s_wwNewObjectName, _s_wwNewPublishedVersion, _s_wwNewEditVersion, _s_wwNewCreatedBy) {
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					if (_bool == false) {
						DWREngine._execute(_cfscriptLocation, null, 'makeNewObject', _cid, _cName, _s_wwNewObjectName, _s_wwNewPublishedVersion, _s_wwNewEditVersion, _s_wwNewCreatedBy, getMakeObjectResults);
					} else {
						var oid = '';
						var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorID'); 
						if (obj != null) {
							oid = obj.value;
						}
						DWREngine._execute(_cfscriptLocation, null, 'saveEditedObject', oid, _cid, _cName, _s_wwNewObjectName, _s_wwNewPublishedVersion, _s_wwNewEditVersion, _s_wwNewCreatedBy, getMakeObjectResults);
					}
				}

				function refreshNoAttributeChoice() {
					DWRUtil.setValue("wwNewAttributeName", "");
					DWRUtil.setValue("wwNewAttributeValue", "");
					DWRUtil.setValue("wwNewAttributeCreatedBy", "");

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_editAttribute');
					if (obj != null) { 
						obj.style.display = const_none_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_editAttribute');
						if (obj != null) { 
							obj.disabled = true;
						}
					}

					obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_makeAttribute');
					if (obj != null) { 
						obj.style.display = const_inline_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_makeAttribute');
						if (obj != null) { 
							obj.disabled = false;
						}
					}
				}
				
				function refresh_btn_anAttributeCreatorDelete(CNT_TOTAL, CNT_LINKS, CNT_ATTRS) {
					var obj_btnDelete = objectCreator_getGUIObjectInstanceById('btn_anObjectCreatorDelete');
					if (obj_btnDelete != null) { 
						var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorName');
						if (obj != null) { 
							var sels = objectCreator_getSelectionsFromObj(obj);
							var ar = sels[1];
							obj_btnDelete.disabled = (( (ar[0] > 0) && ( (CNT_TOTAL == null) || (CNT_TOTAL == 0) ) ) ? false : true);

							var objStatus = objectCreator_getGUIObjectInstanceById('span_status_anObjectCreatorDelete');
							if (objStatus != null) {
								flushGUIObjectChildrenForObj(objStatus);
								objStatus.innerHTML = ((CNT_LINKS == null) ? 0 : CNT_LINKS) + ' (Object Links)' + ' + ' + ((CNT_ATTRS == null) ? 0 : CNT_ATTRS) + ' (Attribute Links)' + ' = ' + ((CNT_TOTAL == null) ? 0 : CNT_TOTAL) + ' (Total)';
							}
						}
					}
				}

				function populateCreatorMakeAttribute(aid, aName) {
					if (aid > 0) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'GetAttributeToEdit', aid, aName, handleGetAttributeToEditResults);
					} else {
						DWRUtil.setValue("wwNewAttributeName", '');
						DWRUtil.setValue("wwNewAttributeValue", '');
						DWRUtil.setValue("wwNewAttributeCreatedBy", '');

						selectionsFirstSelectedById('anAttributeCreatorName', true);
						refresh_btn_anAttributeCreatorDelete();

						refreshNoAttributeChoice();
					//	window.status = 'WARNING: Unable to process a request for the selected item (' + aid + ', ' + aName + '), kindly choose another item from the list.';
					}
				}

				function _handleGetAttributeToEditResults(anObject) {
					var sCREATEDBY = '';
					var sUPDATEDBY = '';

					DWRUtil.setValue("wwObjectAttributeID", anObject[0].ID);
					DWRUtil.setValue("wwNewAttributeName", anObject[0].ATTRIBUTENAME);
					DWRUtil.setValue("wwNewAttributeValue", ((anObject[0].VALUESTRING.trim().length == 0) ? anObject[0].VALUETEXT : anObject[0].VALUESTRING));
					sCREATEDBY = anObject[0].CREATEDBY;
					sUPDATEDBY = anObject[0].UPDATEDBY;
					DWRUtil.setValue("wwNewAttributeCreatedBy", ((sUPDATEDBY.length == 0) ? sCREATEDBY : sUPDATEDBY));

					disableWidgets(false);
					disableWidgets2(false);

					disableAllChildrenForObjById('div_objectCreatorMakeAttribute', false);

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_makeAttribute');
					if (obj != null) { 
						obj.style.display = const_none_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_makeAttribute');
						if (obj != null) { 
							obj.disabled = true;
						}
					}

					setObjectDisplayStyleById('div_objectCreatorMakeAttribute_btn_editAttribute', true);
				}

				function handleGetAttributeToEditResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetAttributeToEditResults);
				}

				function refreshNoObjectChoice() {
					DWRUtil.setValue("wwNewObjectName", "");
					DWRUtil.setValue("wwNewPublishedVersion", "");
					DWRUtil.setValue("wwNewEditVersion", "");
					DWRUtil.setValue("wwNewCreatedBy", "");

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_editObject');
					if (obj != null) { 
						obj.style.display = const_none_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_editObject');
						if (obj != null) { 
							obj.disabled = true;
						}
					}

					obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_makeObject');
					if (obj != null) { 
						obj.style.display = const_inline_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_makeObject');
						if (obj != null) { 
							obj.disabled = false;
						}
					}
				}
				
				function populateObjectCreatorMakeObject(oid, oName) {
					if (oid > 0) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'GetObjectToEdit', oid, oName, handleGetObjectToEditResults);
					} else {
						DWRUtil.setValue("wwNewAttributeName", '');
						DWRUtil.setValue("wwNewAttributeValue", '');
						DWRUtil.setValue("wwNewAttributeCreatedBy", '');
						
						var obj = objectCreator_getGUIObjectInstanceById('span_objectCreatorMakeAttribute_objectName');
						if (obj != null) { 
							flushGUIObjectChildrenForObj(obj);
							obj.innerHTML = '';
						}
						
						DWRUtil.removeAllOptions("anAttributeCreatorName");

						selectionsFirstSelectedById('anAttributeCreatorName', true);
						refresh_btn_anAttributeCreatorDelete();

						refreshNoObjectChoice();
					//	window.status = 'WARNING: Unable to process a request for the selected item (' + oid + ', ' + oName + '), kindly choose another item from the list.';
					}
				}

				function _handleGetObjectToEditResults(anObject) {
					var sCREATEDBY = '';
					var sUPDATEDBY = '';

					DWRUtil.setValue("anObjectCreatorID", anObject[0].ID);
					DWRUtil.setValue("wwNewObjectName", anObject[0].OBJECTNAME);
					DWRUtil.setValue("wwNewPublishedVersion", anObject[0].PUBLISHEDVERSION);
					DWRUtil.setValue("wwNewEditVersion", anObject[0].EDITVERSION);
					sCREATEDBY = anObject[0].CREATEDBY;
					sUPDATEDBY = anObject[0].UPDATEDBY;
					DWRUtil.setValue("wwNewCreatedBy", ((sUPDATEDBY.length == 0) ? sCREATEDBY : sUPDATEDBY));

					DWRUtil.setValue("wwObjectAttributeID", '');
					DWRUtil.setValue("wwNewAttributeName", '');
					DWRUtil.setValue("wwNewAttributeValue", '');
					DWRUtil.setValue("wwNewAttributeCreatedBy", '');

					disableAllChildrenForObjById('div_objectCreatorMakeAttribute', true);

					disableWidgets(false);
					disableWidgets2(false);

					var obj = objectCreator_getGUIObjectInstanceById('span_objectCreatorMakeAttribute_objectName');
					if (obj != null) { 
						flushGUIObjectChildrenForObj(obj);
						obj.innerHTML = anObject[0].OBJECTNAME;
					}

					disableAllChildrenForObjById('div_objectCreatorMakeAttribute', false);

					setObjectDisplayStyleById('div_objectCreatorMakeAttribute_btn_makeAttribute', true);

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_editAttribute');
					if (obj != null) { 
						obj.style.display = const_none_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_editAttribute');
						if (obj != null) { 
							obj.disabled = true;
						}
					}
					
					setObjectDisplayStyleById('div_objectCreatorMakeObject_btn_makeObject', false);

					var obj = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_editObject');
					if (obj != null) { 
						obj.style.display = const_inline_style;
						obj = objectCreator_getGUIObjectInstanceById('btn_editObject');
						if (obj != null) { 
							obj.disabled = false;
						}
					}
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'GetAllAttributesForObject', anObject[0].ID, handleGetAllAttributesForObjectResults);
				}

				function handleGetObjectToEditResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetObjectToEditResults);
				}

				function _handleGetAllAttributesForObjectResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					var sels = [];
					var ar = [];
					var _id = -1;
					var obj = objectCreator_getGUIObjectInstanceById('anObjectCreatorName'); 
					if (obj != null) { 
						sels = objectCreator_getSelectionsFromObj(obj);
						ar = sels[1];
						_id = ar[0];
					}
					if (_id > 0) {
						DWREngine._execute(_cfscriptLocation, null, 'GetVerificatonForObjectDelete', _id, handleGetVerificatonForObjectDeleteResults);
					} else {
						disableWidgets(false);
						disableWidgets2(false);
						
						refresh_btn_anAttributeCreatorDelete();
					}
				}

				function _handleGetVerificatonForObjectDeleteResults(anObject) {
					disableWidgets(false);
					disableWidgets2(false);
					
					refresh_btn_anAttributeCreatorDelete(anObject[0].CNT_TOTAL, anObject[0].CNT_LINKS, anObject[0].CNT_ATTRS);
				}

				function handleGetVerificatonForObjectDeleteResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetVerificatonForObjectDeleteResults);
				}

				function handleGetAllAttributesForObjectResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetAllAttributesForObjectResults);
				}

				function _getMakeObjectResults(anObject) {
					DWRUtil.removeAllOptions("anObjectCreatorName");
					DWRUtil.addOptions("anObjectCreatorName", anObject, 'ID', 'OBJECTNAME');

					DWRUtil.setValue("anObjectCreatorID", "");
					DWRUtil.setValue("wwNewObjectName", "");
					DWRUtil.setValue("wwNewPublishedVersion", "");
					DWRUtil.setValue("wwNewEditVersion", "");
					DWRUtil.setValue("wwNewCreatedBy", "");
					
					DWREngine._execute(_cfscriptLocation, null, 'GetLinkableTypes', handleGetLinkableTypesResults);
				}

				function _handleGetLinkableTypesResults(anObject) {
					DWRUtil.removeAllOptions("validTypes");
					DWRUtil.addOptions("validTypes", anObject, 'OBJECTCLASSID', 'CLASSNAME');

					disableWidgets(false);
					disableWidgets2(false);
					enableEditableWidgets();
					var obj = objectCreator_getGUIObjectInstanceById('btn_editObject');
					if (obj != null) {
						obj.disabled = true;
					}
				}

				function handleGetLinkableTypesResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetLinkableTypesResults);
				}
				
				function getMakeObjectResults(anObject) {
					return handlePossibleSQLError(anObject, _getMakeObjectResults);
				}

				function performCreateObject(cid, cName, bool) {
					var i = -1;
					var obj = -1;
					var ar = workingWithWidgetsArray();
					var s_wwNewObjectName = '';
					var s_wwNewPublishedVersion = '';
					var s_wwNewEditVersion = '';
					var s_wwNewCreatedBy = '';

					for (i = 0; i < ar.length; i++) {
						obj = objectLinker_getGUIObjectInstanceById(ar[i]);
						if ( (obj != null) && (obj.type.trim().toUpperCase() != const_button_symbol.trim().toUpperCase()) ) {
							if (ar[i].trim().toUpperCase() == const_wwNewObjectName.trim().toUpperCase()) {
								s_wwNewObjectName = obj.value;
							} else if (ar[i].trim().toUpperCase() == const_wwNewPublishedVersion.trim().toUpperCase()) {
								s_wwNewPublishedVersion = obj.value;
							} else if (ar[i].trim().toUpperCase() == const_wwNewEditVersion.trim().toUpperCase()) {
								s_wwNewEditVersion = obj.value;
							} else if (ar[i].trim().toUpperCase() == const_wwNewCreatedBy.trim().toUpperCase()) {
								s_wwNewCreatedBy = obj.value;
							}
						}
						disableWidgetByID(ar[i], true);
					}
					_performCreateObject(bool, cid, cName, s_wwNewObjectName, s_wwNewPublishedVersion, s_wwNewEditVersion, s_wwNewCreatedBy);
				}

				function performCreateAttribute(sels, objName, objValue, objBy) {
					var ar = sels[1];
					if (ar.length == 1) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformCreateAttribute', ar[0], objName, objValue, objBy, handlePerformCreateAttributeResults);
					}
				}

				function _handlePerformCreateAttributeResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					disableWidgets(false);
					disableWidgets2(false);
				}

				function handlePerformCreateAttributeResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformCreateAttributeResults);
				}

				function performSaveAttribute(sels, aid, objName, objValue, objBy) {
					var ar = sels[1];
					if (ar.length == 1) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformSaveAttribute', ar[0], aid, objName, objValue, objBy, handlePerformSaveAttributeResults);
					}
				}

				function _handlePerformSaveAttributeResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					refreshNoAttributeChoice();

					disableWidgets(false);
					disableWidgets2(false);
				}

				function handlePerformSaveAttributeResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformSaveAttributeResults);
				}

				function performNewLinkObject() {
					DWRUtil.setValue("linkEditorOwnerPropertyName", "");
					DWRUtil.setValue("linkEditorRelatedPropertyName", "");
					DWRUtil.setValue("linkEditorOwnerAutoload", "");
					DWRUtil.setValue("linkEditorRelatedAutoload", "");
					DWRUtil.setValue("linkEditorDisplayOrder", "");
					DWRUtil.setValue("linkEditorStartVersion", "");
					DWRUtil.setValue("linkEditorLastVersion", "");
					DWRUtil.setValue("linkEditorCreatedBy", "");
					
					selectionsFirstSelectedById('anObjectLinksList', true);
					disableWidgetByID('anObjectLinksDelete', true);
					disableWidgetByID('btn_SaveLinkObject', true);
					
					var obj = objectLinker_getGUIObjectInstanceById('span_objectLinkEditor_linkName');
					if (obj != null) {
						flushGUIObjectChildrenForObj(obj);
						obj.innerHTML = '';
					}
					
					disableWidgetByID('btn_NewLinkObject', true);
				}
				
				function performNewObject() {
					DWRUtil.setValue("wwNewObjectName", "");
					DWRUtil.setValue("wwNewPublishedVersion", "");
					DWRUtil.setValue("wwNewEditVersion", "");
					DWRUtil.setValue("wwNewCreatedBy", "");

					var bool_isVisible_btn_editObject = false;
					var obj_btn_editObject = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_editObject');
					if (obj_btn_editObject != null) {
						if (obj_btn_editObject.style.display == const_inline_style) {
							bool_isVisible_btn_editObject = true;
						}
					}

					var bool_isVisible_btn_makeObject = false;
					var obj_btn_makeObject = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeObject_btn_makeObject');
					if (obj_btn_makeObject != null) {
						if (obj_btn_makeObject.style.display == const_inline_style) {
							bool_isVisible_btn_makeObject = true;
						}
					}

					if (bool_isVisible_btn_editObject) {
						if (obj_btn_makeObject != null) {
							obj_btn_makeObject.style.display = const_inline_style;
							disableAllChildrenForObj(obj_btn_makeObject, false);
						}
						if (obj_btn_editObject != null) {
							obj_btn_editObject.style.display = const_none_style;
							disableAllChildrenForObj(obj_btn_editObject, true);
						}
						selectionsFirstSelectedById('anObjectCreatorName', true);
					}
				}
				
				function performNewAttribute() {
					DWRUtil.setValue("wwNewAttributeName", "");
					DWRUtil.setValue("wwNewAttributeValue", "");
					DWRUtil.setValue("wwNewAttributeCreatedBy", "");
					
					var bool_isVisible_btn_makeAttribute = false;
					var obj_btn_makeAttribute = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_makeAttribute');
					if (obj_btn_makeAttribute != null) {
						if (obj_btn_makeAttribute.style.display == const_inline_style) {
							bool_isVisible_btn_makeAttribute = true;
						}
					}

					var bool_isVisible_btn_editAttribute = false;
					var obj_btn_editAttribute = objectCreator_getGUIObjectInstanceById('div_objectCreatorMakeAttribute_btn_editAttribute');
					if (obj_btn_editAttribute != null) {
						if (obj_btn_editAttribute.style.display == const_inline_style) {
							bool_isVisible_btn_editAttribute = true;
						}
					}
					
					if (bool_isVisible_btn_editAttribute) {
						if (obj_btn_makeAttribute != null) {
							obj_btn_makeAttribute.style.display = const_inline_style;
							disableAllChildrenForObj(obj_btn_makeAttribute, false);
						}
						if (obj_btn_editAttribute != null) {
							obj_btn_editAttribute.style.display = const_none_style;
							disableAllChildrenForObj(obj_btn_editAttribute, true);
						}
						selectionsFirstSelectedById('anAttributeCreatorName', true);
					}
				}
				
				function performObjectLinkerUsing(sels) {
					var ar = sels[1];
					if (ar.length == 2) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformObjectLinker', ar[0], ar[1], handlePerformObjectLinkerResults);
					}
				}

				function _handlePerformObjectLinkerResults(anObject) {
					DWRUtil.removeAllOptions("anObjectLinksList");
					DWRUtil.addOptions("anObjectLinksList", anObject, 'ID', 'OBJECTLINKNAME');

					var obj = objectLinker_getGUIObjectInstanceById('span_objectPickerObjectsLinker_errorMsg');
					if (obj != null) {
						flushGUIObjectChildrenForObj(obj);
						obj.innerHTML = '';
					}
					var obj = objectLinker_getGUIObjectInstanceById('span_objectPickerObjectsLinker_statusMsg');
					if (obj != null) {
						flushGUIObjectChildrenForObj(obj);
						obj.innerHTML = '';
					}
					
					disableWidgets(false);
					disableWidgets2(false);
				}
				
				function handlePerformObjectLinkerResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformObjectLinkerResults);
				}

				function performAttributeCreatorSearchUsing(sels, s) {
					var ar = sels[1];
					if (ar.length == 1) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformAttributeCreatorSearch', ar[0], s, handlePerformAttributeCreatorSearchResults);
					}
				}

				function _handlePerformAttributeCreatorSearchResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					disableWidgets(false);
					disableWidgets2(false);
				}
				
				function handlePerformAttributeCreatorSearchResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformAttributeCreatorSearchResults);
				}

				function populateLinkObjectEditorUsing(sels) {
					var id = sels[1][0];

					if (id > 0) {
						obj = objectLinker_getGUIObjectInstanceById('span_objectLinkEditor_linkName');
						objList = objectLinker_getGUIObjectInstanceById('anObjectLinksList');
						if ( (obj != null) && (objList != null) ) {
						//	alert(objList.options.length);
							for (var i = 0; i < objList.options.length; i++) {
								if (objList.options[i].value == id) {
									flushGUIObjectChildrenForObj(obj);
									obj.innerHTML = objList.options[i].text;
									break;
								}
							}
						}
						
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'GetObjectLinkFromID', id, handleGetObjectLinkFromIDResults);
					} else {
						var obj = objectCreator_getGUIObjectInstanceById('btn_SaveLinkObject');
						if (obj != null) { 
							obj.disabled = true;
						}
						
						obj = objectLinker_getGUIObjectInstanceById('anObjectLinksDelete');
						if (obj != null) {
							obj.disabled = true;
						}

						DWRUtil.setValue("linkEditorOwnerPropertyName", '');
						DWRUtil.setValue("linkEditorRelatedPropertyName", '');
						DWRUtil.setValue("linkEditorOwnerAutoload", '');
						DWRUtil.setValue("linkEditorRelatedAutoload", '');
						DWRUtil.setValue("linkEditorDisplayOrder", '');
						DWRUtil.setValue("linkEditorStartVersion", '');
						DWRUtil.setValue("linkEditorLastVersion", '');
						DWRUtil.setValue("linkEditorCreatedBy", '');

						disableAllChildrenForObjById('div_objectPickerObjectLinkEditor', true);
					}
				}
				
				function _handleGetObjectLinkFromIDResults(anObject) {
					DWRUtil.setValue("linkEditorOwnerPropertyName", anObject[0].OWNERPROPERTYNAME);
					DWRUtil.setValue("linkEditorRelatedPropertyName", anObject[0].RELATEDPROPERTYNAME);
					DWRUtil.setValue("linkEditorOwnerAutoload", anObject[0].OWNERAUTOLOAD);
					DWRUtil.setValue("linkEditorRelatedAutoload", anObject[0].RELATEDAUTOLOAD);
					DWRUtil.setValue("linkEditorDisplayOrder", anObject[0].DISPLAYORDER);
					DWRUtil.setValue("linkEditorStartVersion", anObject[0].STARTVERSION);
					DWRUtil.setValue("linkEditorLastVersion", anObject[0].LASTVERSION);

					var sCREATEDBY = '';
					var sUPDATEDBY = '';

					sCREATEDBY = anObject[0].CREATEDBY;
					sUPDATEDBY = anObject[0].UPDATEDBY;
					DWRUtil.setValue("linkEditorCreatedBy", ((sUPDATEDBY.length == 0) ? sCREATEDBY : sUPDATEDBY));
					
					disableWidgets(false);
					disableWidgets2(false);

					var obj = objectLinker_getGUIObjectInstanceById('btn_SaveLinkObject');
					if (obj != null) { 
						obj.disabled = false;
					}

					disableAllChildrenForObjById('div_objectPickerObjectLinkEditor', false);

					obj = objectLinker_getGUIObjectInstanceById('anObjectLinksDelete');
					if (obj != null) {
						obj.disabled = false;
					}
				}
				
				function handleGetObjectLinkFromIDResults(anObject) {
					return handlePossibleSQLError(anObject, _handleGetObjectLinkFromIDResults);
				}

				function performSaveLinkObject() {
					var sels = -1;
					var obj = objectLinker_getGUIObjectInstanceById('anObjectLinksList');
					if (obj != null) { 
						sels = objectLinker_getSelectionsFromObj(obj);
					}
					var id = sels[1][0];
					var sOWNERPROPERTYNAME = DWRUtil.getValue("linkEditorOwnerPropertyName");
					var sRELATEDPROPERTYNAME = DWRUtil.getValue("linkEditorRelatedPropertyName");
					var sOWNERAUTOLOAD = DWRUtil.getValue("linkEditorOwnerAutoload");
					var sRELATEDAUTOLOAD = DWRUtil.getValue("linkEditorRelatedAutoload");
					var sDISPLAYORDER = DWRUtil.getValue("linkEditorDisplayOrder");
					var sSTARTVERSION = DWRUtil.getValue("linkEditorStartVersion");
					var sLASTVERSION = DWRUtil.getValue("linkEditorLastVersion");
					var sCREATEDBY_UPDATEDBY = DWRUtil.getValue("linkEditorCreatedBy");

					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'PerformSaveLinkObject', id, sOWNERPROPERTYNAME, sRELATEDPROPERTYNAME, sOWNERAUTOLOAD, sRELATEDAUTOLOAD, sDISPLAYORDER, sSTARTVERSION, sLASTVERSION, sCREATEDBY_UPDATEDBY, handlePerformSaveLinkObjectResults);
				}
				
				function _handlePerformSaveLinkObjectResults(anObject) {
					DWRUtil.setValue("linkEditorOwnerPropertyName", anObject[0].OWNERPROPERTYNAME);
					DWRUtil.setValue("linkEditorRelatedPropertyName", anObject[0].RELATEDPROPERTYNAME);
					DWRUtil.setValue("linkEditorOwnerAutoload", anObject[0].OWNERAUTOLOAD);
					DWRUtil.setValue("linkEditorRelatedAutoload", anObject[0].RELATEDAUTOLOAD);
					DWRUtil.setValue("linkEditorDisplayOrder", anObject[0].DISPLAYORDER);
					DWRUtil.setValue("linkEditorStartVersion", anObject[0].STARTVERSION);
					DWRUtil.setValue("linkEditorLastVersion", anObject[0].LASTVERSION);

					var sCREATEDBY = '';
					var sUPDATEDBY = '';

					sCREATEDBY = anObject[0].CREATEDBY;
					sUPDATEDBY = anObject[0].UPDATEDBY;
					DWRUtil.setValue("linkEditorCreatedBy", ((sUPDATEDBY.length == 0) ? sCREATEDBY : sUPDATEDBY));

					disableWidgets(false);
					disableWidgets2(false);

					var obj = objectLinker_getGUIObjectInstanceById('btn_SaveLinkObject');
					if (obj != null) { 
						obj.disabled = false;
					}

					disableAllChildrenForObjById('div_objectPickerObjectLinkEditor', false);
				}
				
				function handlePerformSaveLinkObjectResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformSaveLinkObjectResults);
				}

				function performDeleteObject(sels, cid) {
					var ar = sels[1];
					if (ar.length == 1) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformDeleteObject', ar[0], handlePerformDeleteObjectResults);
					}
				}

				function _handlePerformDeleteObjectResults(anObject) {
					DWRUtil.removeAllOptions("anObjectCreatorName");
					DWRUtil.addOptions("anObjectCreatorName", anObject, 'ID', 'OBJECTNAME');

					refreshNoObjectChoice();

					disableWidgets(false);
					disableWidgets2(false);
				}

				function handlePerformDeleteObjectResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformDeleteObjectResults);
				}

				function performDeleteObjectsAttribute(sels, object_sels) {
					var ar = sels[1];
					var ar2 = object_sels[1];
					if ( (ar.length == 1) && (ar2.length == 1) ) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformDeleteObjectsAttribute', ar[0], ar2[0], handlePerformDeleteObjectsAttributeResults);
					}
				}

				function _handlePerformDeleteObjectsAttributeResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					disableWidgets(false);
					disableWidgets2(false);
				}

				function handlePerformDeleteObjectsAttributeResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformDeleteObjectsAttributeResults);
				}

				function performDeleteObjectLinks(sels) {
					var ar = sels[1];
					if (ar.length == 1) {
						window.status = '';
						disableWidgets(true);
						disableWidgets2(true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformObjectLinkerDeleteLink', ar[0], handlePerformObjectLinkerDeleteLinkResults);
					}
				}
				
				function _handlePerformObjectLinkerDeleteLinkResults(anObject) {
					DWRUtil.removeAllOptions("anAttributeCreatorName");
					DWRUtil.addOptions("anAttributeCreatorName", anObject, 'ID', 'ATTRIBUTENAME');

					disableWidgets(false);
					disableWidgets2(false);
				}
				
				function handlePerformObjectLinkerDeleteLinkResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformObjectLinkerDeleteLinkResults);
				}

				function _handlePerformObjectLinkerDeleteLinkResults(anObject) {
					DWRUtil.removeAllOptions("anObjectLinksList");
					DWRUtil.addOptions("anObjectLinksList", anObject, 'ID', 'OBJECTLINKNAME');

					DWRUtil.setValue("linkEditorOwnerPropertyName", '');
					DWRUtil.setValue("linkEditorRelatedPropertyName", '');
					DWRUtil.setValue("linkEditorOwnerAutoload", '');
					DWRUtil.setValue("linkEditorRelatedAutoload", '');
					DWRUtil.setValue("linkEditorDisplayOrder", '');
					DWRUtil.setValue("linkEditorStartVersion", '');
					DWRUtil.setValue("linkEditorLastVersion", '');
					DWRUtil.setValue("linkEditorCreatedBy", '');
					
					var obj = objectLinker_getGUIObjectInstanceById('anObjectLinksDelete');
					if (obj != null) { 
						obj.disabled = true;
					}

					disableWidgets(false);
					disableWidgets2(false);
				}
				
				function handlePerformObjectLinkerDeleteLinkResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformObjectLinkerDeleteLinkResults);
				}

				function dismissLoginForm() {
					var obj = $('div_user_login'); 
					var oBtn = $('btn_user_login'); 
					if ( (obj != null) && (oBtn != null) ) { 
						obj.style.display = const_none_style; 
						oBtn.disabled = false; 
					}
				}
				
				function dismissForgotPasswordForm() {
					setObjectDisplayStyleById('div_user_forgot_password', false);

					disableAllChildrenForObjById('div_user_login', false);
				}
				
				function showForgotPasswordForm() {
					setObjectDisplayStyleById('div_user_forgot_password', true);

					disableAllChildrenForObjById('div_user_login', true);

					disableAllChildrenForObjById('div_user_forgot_password', false);

					var obj = $('user_user_forgot_password_UserName'); 
					if (obj != null) { 
						obj.value = ''; 
						obj.focus(); 
					}
					var mObj = $('user_user_forgot_password_status_message');
					if (mObj != null) {
						flushGUIObjectChildrenForObj(mObj);
						mObj.innerHTML = '';
					}
				}
								
				function dismissUserManagerForm() {
					removeOpenedGUIFromStack('div_userManager');
					disableWidgetByID('btn_userManager', false);
				}
				
				function dismissRolesManagerForm() {
					removeOpenedGUIFromStack('div_rolesManager');
					disableAllChildrenForObjById('div_userManager', false);
					selectionsFirstSelectedById('userManager_UserRole', true);

					validateEmailUserManager(DWRUtil.getValue("userManager_UserName"), 'userManager_addUser');
					validateRoleUserManager('userManager_UserRole', 'userManager_addUser');
				}

				function dismissObjectManagerForm() {
					removeOpenedGUIFromStack('div_objectManager');
					disableWidgetByID('btn_objectManager', false);
				}
				
				function isUserLoggedIn() {
					window.status = '';
					disableWidgets(true);
					disableWidgets2(true);
					DWREngine._execute(_cfscriptLocation, null, 'DetermineUserLogInState', handleDetermineUserLogInStateResults);
				}
				
				function _handleDetermineUserLogInStateResults(anObject) {
					var bool_LOGIN_STATE = false;

					bool_LOGIN_STATE = ((anObject[0].LOGIN_STATE.trim().toUpperCase() == 'FALSE') ? false : true);

					setObjectDisplayStyleById('div_user_menu_login', ((bool_LOGIN_STATE) ? false : true));
					
					setObjectDisplayStyleById('div_user_menu_userManager', (bool_LOGIN_STATE == true));
					setObjectDisplayStyleById('div_user_menu_objectManager', (bool_LOGIN_STATE == true));
					
					setObjectDisplayStyleById('div_user_menu_logoff', (bool_LOGIN_STATE == true));
					return bool_LOGIN_STATE;
				}

				function handleDetermineUserLogInStateResults(anObject) {
					return handlePossibleSQLError(anObject, _handleDetermineUserLogInStateResults);
				}

				function performUserLogin(sUserName, sPassword) {
					disableAllChildrenForObjById('div_user_login', true);

					var mObj = $('span_user_login_status_message');
					if (mObj != null) {
						flushGUIObjectChildrenForObj(mObj);
						mObj.innerHTML = 'User Log-in BEING PROCESSED - PLS stand-by...';
					}
					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PerformUserLogIn', sUserName, sPassword, handlePerformUserLogInResults);
				}

				function _handlePerformUserLogInResults(anObject) {
					var bool = false;

					disableAllChildrenForObjById('div_user_login', false);

					var mObj = $('span_user_login_status_message');
					if (mObj != null) {
						bool = _handleDetermineUserLogInStateResults(anObject);
						flushGUIObjectChildrenForObj(mObj);
						mObj.innerHTML = ((bool == false) ? 'User Log-in FAILURE - PLS try again...' : 'User Log-in SUCCESS !');
						if (bool) {
							dismissLoginForm();
							setObjectDisplayStyleById('div_user_menu_objectManager', true);
						}
					}
				}

				function handlePerformUserLogInResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformUserLogInResults);
				}
				
				function performUserLogoff() {
					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PerformUserLogoff', handlePerformUserLogoffResults);
				}

				function _handlePerformUserLogoffResults(anObject) {

					var obj = $('div_user_menu_logoff'); 
					if (obj != null) { 
						obj.style.display = const_none_style; 
						this.disabled = true; 
					}
					_handleDetermineUserLogInStateResults(anObject);
					removeAllOpenedGUIsFromStack();
				}

				function handlePerformUserLogoffResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformUserLogoffResults);
				}

				function performRetrievePassword(sUserName) {
					disableAllChildrenForObjById('div_user_forgot_password', true);

					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PerformRetrievePassword', sUserName, handlePerformRetrievePasswordResults);
				}

				function _handlePerformRetrievePasswordResults(anObject) {
					var bool_mailError = ((anObject[0].MAILERROR.trim().toUpperCase() == 'FALSE') ? false : true);
					var bool_disableAll = false;
					var s_innerHTML = '';
					if (bool_mailError) {
						bool_disableAll = false;
						s_innerHTML = 'WARNING: It was not possible to retrieve your password.  PLS try again later-on.';
					} else {
						bool_disableAll = true;
						s_innerHTML = '#Request.const_activate_account_message#';
					}
					disableAllChildrenForObjById('div_user_forgot_password', false);

					var mObj = $('user_user_forgot_password_status_message');
					if (mObj != null) {
						flushGUIObjectChildrenForObj(mObj);
						mObj.innerHTML = s_innerHTML;
					}
					if (bool_mailError) {
						disableWidgetByID('user_user_forgot_password_btn_getPassword', false);
						disableWidgetByID('user_user_forgot_password_UserName', false);
					} else {
						disableWidgetByID('user_user_forgot_password_btn_getPassword', true);
						disableWidgetByID('user_user_forgot_password_UserName', true);
					}
					disableWidgetByID('user_user_forgot_password_close', false);
					disableWidgetByID('user_user_forgot_password_status_message', false);
				}

				function handlePerformRetrievePasswordResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformRetrievePasswordResults);
				}
				
				function resetCalendarDaysInMonth(id_prefix, mmSels, yyyySels) {
					var mm = -1;
					var ar_mmSels = [];
					var yyyy = -1;
					var ar_yyyySels = [];

					if (mmSels.length == 2) {
						ar_mmSels = mmSels[1];
						mm = ar_mmSels[0];
					}
					if (yyyySels.length == 2) {
						ar_yyyySels = yyyySels[1];
						yyyy = ar_yyyySels[0];
					}
					if ( (mm > -1) && (yyyy > -1) ) {
						var daysInMM = daysInMonthForYear(mm, yyyy);
	
						disableWidgetByID(id_prefix + 'DD', true);
						removeAllOptionsByID(id_prefix + 'DD');
						setLinearOptionsByID(id_prefix + 'DD', 1, daysInMM);
						disableWidgetByID(id_prefix + 'DD', false);
					}
				}
				
				function chooseUserRole(sels, idUserRole, btnAction) {
					var i = -1;
					var ar = [];
					if (sels.length == 2) {
						ar = sels[1];
						i = ar[0];
					}
					if (i != -1) {
						if (i == '+') {
							setObjectDisplayStyleById('div_rolesManager', true);
							addOpenedGUI2Stack('div_userManager', 'div_rolesManager');
							disableAllChildrenForObjById('div_userManager', true);
							focusOnWidgetByID('rolesManager_RoleName');
							disableWidgetByID('rolesManager_addRole', true);
							disableWidgetByID('rolesManager_removeRole', true);
							DWRUtil.setValue('rolesManager_RoleName', '');
						} else {
							validateRoleUserManager(idUserRole, btnAction, sels);
						}
					}
				}
				
				function _handleAddOrRemoveRoleInRoleManagerResults(anObject) {
					DWRUtil.removeAllOptions("rolesManager_CurrentRoles");
					DWRUtil.addOptions("rolesManager_CurrentRoles", anObject, 'ID', 'ROLENAME');
					
					DWRUtil.removeAllOptions('userManager_UserRole');
					AddAnOptionByID('userManager_UserRole', '', const_Choose_symbol);
					AddAnOptionByID('userManager_UserRole', '+', const_AddRole_symbol);
					DWRUtil.addOptions('userManager_UserRole', anObject, 'ID', 'ROLENAME');

					disableAllChildrenForObjById('div_rolesManager', false);
				}

				function removeRoleFromRoleManager(sels) {
					var ar = sels[1];
					if (ar.length == 1) {
						disableAllChildrenForObjById('div_rolesManager', true);
						DWRUtil.setValue('rolesManager_RoleName', _getTextFromSelectionObjIdByValue(sels[0], ar[0]));
	
						window.status = '';
						DWREngine._execute(_cfscriptLocation, null, 'RemoveRoleFromRoleManager', ar[0], handleRemoveRoleFromRoleManagerResults);
					} else {
						alert('Cannot remove a Role unless a Role is selected.');
					}
				}
				
				function _handleRemoveRoleFromRoleManagerResults(anObject) {
					return _handleAddOrRemoveRoleInRoleManagerResults(anObject);
				}

				function handleRemoveRoleFromRoleManagerResults(anObject) {
					return handlePossibleSQLError(anObject, _handleRemoveRoleFromRoleManagerResults);
				}

				function addNewRole2RoleManager(sRoleName) {
					disableAllChildrenForObjById('div_rolesManager', true);
					DWRUtil.setValue('rolesManager_RoleName', '');

					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'AddNewRole2RoleManager', sRoleName, handleAddNewRole2RoleManagerResults);
				}

				function _handleAddNewRole2RoleManagerResults(anObject) {
					return _handleAddOrRemoveRoleInRoleManagerResults(anObject);
				}

				function handleAddNewRole2RoleManagerResults(anObject) {
					return handlePossibleSQLError(anObject, _handleAddNewRole2RoleManagerResults);
				}
				
				function handleEvents_forRolesManager_CurrentRoles(obj) {
					var sels = _getSelectionsFromObj(obj);
					var ar = sels[1]; 
				//	window.status = 'ar.length = [' + ar.length + ']' + ', sels = [' + sels + ']' + ', ar = [' + ar + ']'; 
					disableWidgetByID('rolesManager_removeRole', ((ar.length == 1) ? false : true)); 
				}
				
				function performProcessAddUser() {
					var sUserName = DWRUtil.getValue("userManager_UserName");
					var sUsersName = DWRUtil.getValue("userManager_UserProperName");
					var selsUserRole = _getSelectionsFromObjByID('userManager_UserRole');
					var arUserRole = selsUserRole[1];
					var txtUserRole = _getTextFromSelectionObjIdByValue('userManager_UserRole', arUserRole[0]);
					var selsBeginDtMM = _getSelectionsFromObjByID('userManager_BeginDt_MM');
					var arBeginDtMM = selsBeginDtMM[1];
					var selsBeginDtDD = _getSelectionsFromObjByID('userManager_BeginDt_DD');
					var arBeginDtDD = selsBeginDtDD[1];
					var selsBeginDtYYYY = _getSelectionsFromObjByID('userManager_BeginDt_YYYY');
					var arBeginDtYYYY = selsBeginDtYYYY[1];
					var selsEndDtMM = _getSelectionsFromObjByID('userManager_EndDt_MM');
					var arEndDtMM = selsEndDtMM[1];
					var selsEndDtDD = _getSelectionsFromObjByID('userManager_EndDt_DD');
					var arEndDtDD = selsEndDtDD[1];
					var selsEndDtYYYY = _getSelectionsFromObjByID('userManager_EndDt_YYYY');
					var arEndDtYYYY = selsEndDtYYYY[1];

					disableAllChildrenForObjById('div_userManager', true);
					window.status = '';
					_stack_user_in_focus.push(sUserName);
					DWREngine._execute(_cfscriptLocation, null, 'PerformProcessAddUser', sUserName, sUsersName, arUserRole[0], txtUserRole, arBeginDtMM[0], arBeginDtDD[0], arBeginDtYYYY[0], arEndDtMM[0], arEndDtDD[0], arEndDtYYYY[0], handlePerformProcessAddUserResults);
				}

				function _handlePerformProcessAddUserResults(anObject) {
					// BEGIN: Refresh the user display...
					_populateUserManager(anObject);
					disableAllChildrenForObjById('div_userManager', false);
					// END! Refresh the user display...
				}

				function handlePerformProcessAddUserResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformProcessAddUserResults);
				}
				
				function initEditDeleteUser(btnId, divName, dictSpec, divPrefix, divEditor) {
					var s = '';
					disableAllChildrenForObjById('div_userManager_user_grid_adder', true);
					setObjectDisplayStyleById('div_userManager_user_grid_adder', false);
					setObjectDisplayStyleById('div_userManager_user_grid_editor', true);
					disableWidgetByID('btn_userManagerEditor_action', false);
					_cache_disabled_objects['div_userManager_user_grid'] = disabledChildrenForObjById('div_userManager_user_grid');
					disableAllChildrenForObjById('div_userManager_user_grid', true);
					disableWidgetByID('userManager_close', true);
					setTitleForObjById('btn_userManagerEditor_action', (s = getTitleForObjById(btnId)) + "' - Confirm the '" + s + ' action by clicking this button.');
					DWRUtil.setValue('btn_userManagerEditor_action', DWRUtil.getValue(btnId));
					DWRUtil.setValue('hidden_userManagerEditor_ID', btnId);
				}

				function performDeleteUser(btnId, divName, dictSpec, divPrefix, divEditor) {
					initEditDeleteUser(btnId, divName, dictSpec, divPrefix, divEditor);
				//	alert('divName = [' + divName + ']');
					prepFORMvalues(divName, dictSpec, divPrefix, divEditor, true);
				}

				function performEditUser(btnId, divName, dictSpec, divPrefix, divEditor) {
					initEditDeleteUser(btnId, divName, dictSpec, divPrefix, divEditor);
					prepFORMvalues(divName, dictSpec, divPrefix, divEditor, false);
				}
				
				function dismissUserEditorForm() {
					setObjectDisplayStyleById('div_userManager_user_grid_adder', true);
					disableAllChildrenForObjById('div_userManager_user_grid_adder', false);
					setObjectDisplayStyleById('div_userManager_user_grid_editor', false);
					disableWidgetByID('btn_userManagerEditor_action', false);
					disableWidgetByID('userManager_addUser', true);
					disableAllChildrenForObjById('div_userManager_user_grid', false);
					disableWidgetsFromDict(_cache_disabled_objects['div_userManager_user_grid']);
					_cache_disabled_objects['div_userManager_user_grid'].destructor();
					_cache_disabled_objects['div_userManager_user_grid'] = null;
					disableWidgetByID('userManager_close', false);
					setTitleForObjById('btn_userManagerEditor_action', '');
					DWRUtil.setValue('btn_userManagerEditor_action', '');
				}

				function performUserMgrConfirmationAction(btnObj, recordDescriptor) {
					var ar = [];
					var _action = '';
					var recID = -1;
					
					btnObj.disabled = true;
					ar = recordDescriptor.split('_');
					_action = ar[ar.length - 3];
					recID = ar[ar.length - 1];

					var sUserName = DWRUtil.getValue("userManagerEditor_UserName");

					var selsUserRole = _getSelectionsFromObjByID('userManagerEditor_UserRole');
					var arUserRole = selsUserRole[1];

					var txtUserRole = _getTextFromSelectionObjIdByValue('userManagerEditor_UserRole', arUserRole[0]);
					
					var selsBeginDt_MM = _getSelectionsFromObjByID('userManagerEditor_BeginDt_MM');
					var arBeginDt_MM = selsBeginDt_MM[1];

					var selsBeginDt_DD = _getSelectionsFromObjByID('userManagerEditor_BeginDt_DD');
					var arBeginDt_DD = selsBeginDt_DD[1];

					var selsBeginDt_YYYY = _getSelectionsFromObjByID('userManagerEditor_BeginDt_YYYY');
					var arBeginDt_YYYY = selsBeginDt_YYYY[1];

					var selsEndDt_MM = _getSelectionsFromObjByID('userManagerEditor_EndDt_MM');
					var arEndDt_MM = selsEndDt_MM[1];

					var selsEndDt_DD = _getSelectionsFromObjByID('userManagerEditor_EndDt_DD');
					var arEndDt_DD = selsEndDt_DD[1];

					var selsEndDt_YYYY = _getSelectionsFromObjByID('userManagerEditor_EndDt_YYYY');
					var arEndDt_YYYY = selsEndDt_YYYY[1];

					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PerformUserMgrConfirmationAction', _action, recID, sUserName, arUserRole[0], txtUserRole, arBeginDt_MM[0], arBeginDt_DD[0], arBeginDt_YYYY[0], arEndDt_MM[0], arEndDt_DD[0], arEndDt_YYYY[0], handlePerformUserMgrConfirmationActionResults);
				}

				function _handlePerformUserMgrConfirmationActionResults(anObject) {
					// BEGIN: Refresh the user display...
					// What page is currently in view ?
					dismissUserEditorForm();
					_populateUserManager(anObject);
					// END! Refresh the user display...
				}

				function handlePerformUserMgrConfirmationActionResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformUserMgrConfirmationActionResults);
				}

				function PerformPopulateUserManager() {
					disableWidgetByID('btn_userManager', true);
					
					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PopulateUserManager', handlePerformPopulateUserManagerResults);
				}

				function _handlePerformPopulateUserManagerResults(anObject) {
					_populateUserManager(anObject);
					disableWidgetByID('btn_userManager', false);
				}

				function handlePerformPopulateUserManagerResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformPopulateUserManagerResults);
				}

				function getCheckedUsersArray() {
					var i = -1;
					var ar = _dict_checked_objects.getKeys();
					var arParms = [];
					var _id = '';
					var _idList = [];

					for (i = 0; i < ar.length; i++) {
						arParms = ar[i].split('_');
						_id = arParms[arParms.length - 1];
						if (_dict_checked_objects.getValueFor(ar[i]) == true) {
							_idList.push(_id);
						}
					}
					return _idList;
				}

				function performDeleteAllCheckedUsers() {
					var _idList = getCheckedUsersArray();

					_cache_disabled_objects['div_userManager_user_grid'] = disabledChildrenForObjById('div_userManager_user_grid');
					disableAllChildrenForObjById('div_userManager_user_grid', true);

					window.status = '';
					DWREngine._execute(_cfscriptLocation, null, 'PerformDeleteAllCheckedUsers', _idList.join(','), handlePerformDeleteAllCheckedUsersResults);
				}

				function _handlePerformDeleteAllCheckedUsersResults(anObject) {
					_populateUserManager(anObject);
				//	disableWidgetByID('btn_userManager', false);
				}

				function handlePerformDeleteAllCheckedUsersResults(anObject) {
					return handlePossibleSQLError(anObject, _handlePerformDeleteAllCheckedUsersResults);
				}

				function performAbstract2ConcreteGUIMapping() {
					// BEGIN: Presentation Layer Definition goes here...
					// Presentation Layer maps abstract GUI widgets that lack a usable layout into a concrete GUI layout.
					// It is left up to the user of this code, typically a programmer, to define the way the abstract
					// GUI widgets are mapped into a real concrete layout.  You may use this example as a template
					// for doing this going forward.
					var abstract_to_concrete_mapping = []; // later-on this will become an object...
					// Notice the name of the abstract div versus the name of the concrete div - innerHTML is simply copied from the abstract to the concrete... slick, huh ?
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerChooseClasses', 'td_concrete_layout_validTypes']);
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerChooseObjects', 'td_concrete_layout_objectType']);
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerChooseObjectsSearch', 'td_concrete_layout_objectSearch']);
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerObjectsLinker', 'td_concrete_layout_objectsLinker']);
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerObjectsLinked', 'td_concrete_layout_objectsLinked']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorMakeType', 'td_concrete_layout_objectCreatorMakeType']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorAvailableType', 'td_concrete_layout_objectCreatorAvailableType']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorWorkingWith', 'td_concrete_layout_objectCreatorWorkingWith']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorMakeObject', 'td_concrete_layout_objectCreatorMakeObject']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorSearchObjects', 'td_concrete_layout_objectCreatorSearchObjects']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorListObjects', 'td_concrete_layout_objectCreatorListObjects']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorMakeAttribute', 'td_concrete_layout_objectCreatorMakeAttribute']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorListAttributes', 'td_concrete_layout_objectCreatorListAttributes']);
					abstract_to_concrete_mapping.push(['div_abstract_objectPickerObjectLinkEditor', 'td_concrete_layout_objectPickerObjectLinkEditor']);
					abstract_to_concrete_mapping.push(['div_abstract_objectCreatorAttributeSelector', 'td_concrete_layout_objectCreatorAttributeSelector']);
					// Actually perform the mapping...
					var aObj = -1;
					var cObj = -1;
					var ar = -1;
					for (var i = 0; i < abstract_to_concrete_mapping.length; i++) {
						ar = abstract_to_concrete_mapping[i];
						if (ar.length == 2) {
							aObj = $(ar[0]);
							cObj = $(ar[1]);
							if ( (aObj != null) && (cObj != null) ) {
								flushGUIObjectChildrenForObj(cObj);
								cObj.innerHTML = aObj.innerHTML;
								aObj.style.display = const_none_style;
							}
						}
					}
					var abstract_hidden_div_array = []; // later-on this will be added the the object...
					abstract_hidden_div_array.push('div_title_ObjectLinker');
					abstract_hidden_div_array.push('div_title_ObjectCreator');
					abstract_hidden_div_array.push('div_title_ConcreteLayout');

					for (i = 0; i < abstract_hidden_div_array.length; i++) {
						aObj = $(abstract_hidden_div_array[i]);
						if (aObj != null) {
							aObj.style.display = const_none_style;
						}
					}

					try {
						disableAllChildrenForObjById('div_objectPickerObjectLinkEditor', true);
					} catch(e) {
						jsErrorExplainer(e, 'A. performAbstract2ConcreteGUIMapping()' + ', (typeof disableAllChildrenForObjById) = [' + (typeof disableAllChildrenForObjById) + ']', true);
					} finally {
					}

					try {
						disableAllChildrenForObjById('div_objectCreatorMakeAttribute', true);
					} catch(e) {
						jsErrorExplainer(e, 'B. performAbstract2ConcreteGUIMapping()', true);
					} finally {
					}

					try {
						disableAllChildrenForObjById('div_objectCreatorMakeObject', true);
					} catch(e) {
						jsErrorExplainer(e, 'C. performAbstract2ConcreteGUIMapping()', true);
					} finally {
					}

					var obj = $('btn_peformMapping');
					if (obj != null) { 
						obj.disabled = true;
					}

					bool_performedAbstract2ConcreteGUIMapping = true;
					// END! Presentation Layer Definition goes here...
				}
				
				var bool_performedAbstract2ConcreteGUIMapping = false;
				
				function init() {
					DWRUtil.useLoadingMessage();
					DWREngine._errorHandler =  errorHandler;
					performAbstract2ConcreteGUIMapping();
				}
			//-->
			</script>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				self.onerror = reportError;
				
				function onLoadEventHandler() {
					init();
					disableSearchWidgets(true);
					focusOnWidget(objectCreator_getGUIObjectInstanceById('anObjectType'));
					PerformPopulateUserManager();

					disableWidgetByID('div_user_login_password_rating', true);
				//	isUserLoggedIn();
				}
			//-->
			</script>
			<cfif (IsStruct(anObjLinker))>
				#anObjLinker.jsCode()#
			</cfif>
			
			<cfif (IsStruct(anObjCreator))>
				#anObjCreator.jsCode()#
			</cfif>
		</cfoutput>
	</head>
	<cfoutput>
		<body onLoad="onLoadEventHandler()">
			<div id="div_sysMessages" style="display: none;">
				<table width="*" border="1" cellspacing="-1" cellpadding="-1" bgcolor="##FFFF80">
					<tr>
						<td>
							<table width="*" cellspacing="-1" cellpadding="-1">
								<tr bgcolor="silver">
									<td align="center">
										<span id="span_sysMessages_title" class="boldPromptTextClass"></span>
									</td>
									<td align="right">
										<button class="buttonClass" title="Click this button to dismiss this pop-up." onclick="dismissSysMessages(); return false;">[X]</button>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<span id="span_sysMessages_body" class="textClass"></span>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			
			<cfif 0>
				<!--- BEGIN: Test case for data encryption system... --->
				<cftry>
					<cfset eTest = Request.commonCode.encodedEncryptedString2("sisko@7660$boo")>
					<cfset aStruct = Request.commonCode.decodeEncodedEncryptedString2(eTest)>
					<cfdump var="#aStruct#" label="aStruct (#eTest#)" expand="No">

					<cfcatch type="Any">
						<cfdump var="#cfcatch#" label="cfcatch" expand="No">
					</cfcatch>
				</cftry>
				<!--- END! Test case for data encryption system... --->
			</cfif>
			<div id="div_title_ConcreteLayout" style="display: inline;">
				<table width="800" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<h1>Concrete Layout</h1>
						</td>
						<td>
							<input type="button" class="buttonClass" name="btn_peformMapping" id="btn_peformMapping" value="[Map the GUI]" onclick="performAbstract2ConcreteGUIMapping(); this.disabled = true; return false;">
						</td>
					</tr>
				</table>
			</div>
			<div id="div_user_menu" style="display: inline;">
				<table width="800" cellpadding="-1" cellspacing="-1">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr bgcolor="##0080FF">
									<td>
										<h3>GEONOSIS&trade; - AJAX Web App Generator and Content Management System</h3>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr bgcolor="silver">
									<td id="div_user_menu_login" style="display: <cfif (IsDefined("Client.bool_isUserLoggedIn"))><cfif (Client.bool_isUserLoggedIn)>none<cfelse>inline</cfif><cfelse>inline</cfif>;">
										<button id="btn_user_login" class="buttonMenuClass" onclick="var obj = $('div_user_login'); if (obj != null) { obj.style.display = const_inline_style; var objUserName = $('user_login_UserName'); var objPassword = $('user_login_Password'); if ( (objUserName != null) && (objPassword != null) ) { objUserName.value = ''; objUserName.focus(); objPassword.value = ''; }; this.disabled = true; }; return false">[Login]</button>
									</td>
									<td id="div_user_menu_userManager" style="display: <cfif (IsDefined("Client.bool_isUserLoggedIn"))><cfif (Client.bool_isUserLoggedIn)>inline<cfelse>none</cfif><cfelse>none</cfif>;">
										<button id="btn_userManager" class="buttonMenuClass" onclick="var obj = $('div_userManager'); if (obj != null) { obj.style.display = const_inline_style; this.disabled = true; addOpenedGUI2Stack(this.id, obj.id); selectionsFirstSelectedById('userManager_UserRole', true); }; return false">[User Manager]</button>
									</td>
									<td id="div_user_menu_objectManager" style="display: <cfif (IsDefined("Client.bool_isUserLoggedIn"))><cfif (Client.bool_isUserLoggedIn)>inline<cfelse>none</cfif><cfelse>none</cfif>;">
										<button id="btn_objectManager" class="buttonMenuClass" onclick="var obj = $('div_objectManager'); if (obj != null) { obj.style.display = const_inline_style; this.disabled = true; addOpenedGUI2Stack(this.id, obj.id); }; return false">[Object Manager]</button>
									</td>
									<td style="display: inline;">
										<span class="normalStatusBoldClass">
										<a href="" onclick="toggleObjectDisplayStyleById('td_toDo_list_body'); return false;">To-Do List</a>
										</span>
									</td>
								<cfif 0>
									<td style="display: inline;">
										<span class="normalStatusBoldClass">
										<a href="http://rayhorn.contentopia.net/rayhorn" target="_blank">[Author's Site]</a>
										</span>
									</td>
								</cfif>
									<td style="display: inline;">
										<span class="normalStatusBoldClass">
										<a href="http://rayhorn.contentopia.net/blog" target="_blank">[Author's Blog]</a>
										</span>
									</td>
									<td id="div_user_menu_logoff" style="display: <cfif (IsDefined("Client.bool_isUserLoggedIn"))><cfif (Client.bool_isUserLoggedIn)>inline<cfelse>none</cfif><cfelse>none</cfif>;">
										<button id="btn_user_logoff" class="buttonMenuClass" onclick="performUserLogoff(); return false">[Logoff]</button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_user_login" style="display: none;">
				<table width="600" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td bgcolor="silver" align="center">
										<span class="boldPromptTextClass"><NOBR>User Login</NOBR></span>
									</td>
									<td bgcolor="silver" align="center">
										<input type="button" name="user_login_close" id="user_login_close" value="[X]" class="buttonMenuClass" onclick="dismissLoginForm(); return false;">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td>
																<span class="boldPromptTextClass"><NOBR>UserName:</NOBR></span>&nbsp;<span title="The data entry field is Required." class="errorStatusBoldClass">(*)</span>
															</td>
															<td>
																<input type="text" name="user_login_UserName" id="user_login_UserName" class="textClass" size="40" maxlength="255" onkeyup="return validateEmail(this.value);">
															</td>
															<td>
																<span class="textClass"><NOBR><i>(use your valid Internet email address)</i></NOBR></span>
															</td>
														</tr>
														<tr>
															<td width="80px" align="left">
																<span class="boldPromptTextClass"><NOBR>Password:</NOBR></span>&nbsp;<span title="The data entry field is Required." class="errorStatusBoldClass">(*)</span>
															</td>
															<td width="220px" align="left">
																<table width="100%" cellpadding="-1" cellspacing="-1">
																	<td>
																		<input type="password" name="user_login_Password" id="user_login_Password" size="20" maxlength="30" class="textClass" onkeyup="return validatePassword(this.value, 'div_user_login_password_rating', 'td_user_login_password_rating', 'span_user_login_password_rating');">
																	</td>
																	<td width="100px" align="center" id="td_user_login_password_rating" style="border: thin solid silver;">
																		<div id="div_user_login_password_rating"><span id="span_user_login_password_rating" class="normalStatusBoldClass">(Not Rated)</span></div>
																	</td>
																</table>
															</td>
															<td width="200px" align="right">
																<table width="100%" cellpadding="-1" cellspacing="-1">
																	<tr>
																		<td>
																			<input disabled type="button" name="user_login_btn_login" id="user_login_btn_login" value="[Login]" class="buttonClass" onclick="var objUserName = $('user_login_UserName'); var objPassword = $('user_login_Password'); if ( (objUserName != null) && (objPassword != null) ) { objUserName.focus(); performUserLogin(objUserName.value, objPassword.value); }; return false;">
																		</td>
																		<td>
																			<input type="button" name="user_login_btn_reset" id="user_login_btn_reset" value="[Reset]" class="buttonClass" onclick="var objUserName = $('user_login_UserName'); var objPassword = $('user_login_Password'); var objBtn = $('user_login_btn_login'); if ( (objUserName != null) && (objPassword != null) && (objBtn != null) ) { objUserName.value = ''; objPassword.value = ''; objBtn.disabled = true; objUserName.focus(); }; return false;">
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td>
													<br>
													<span id="span_user_login_status_message" class="onholdStatusBoldClass"></span>
												</td>
											</tr>
											<tr>
												<td>
													<br>
													<span class="boldPromptTextClass"><NOBR>Don't have a user account just yet, go ahead and click this button --></NOBR></span>
													<input type="button" name="user_login_btn_register" id="user_login_register" value="[Register New User]" class="buttonClass">
												</td>
											</tr>
											<tr>
												<td>
													<br>
													<span class="boldPromptTextClass"><NOBR>Forgot your password ? Go ahead and click this button --></NOBR></span>
													<input type="button" name="user_login_btn_forgot" id="user_login_forgot" value="[Forgot Password]" class="buttonClass" onclick="showForgotPasswordForm(); return false;">
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_userManager" style="display: none;">
				<table width="800" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver" align="center">
													<span class="boldPromptTextClass"><NOBR>Geonosis User Manager</NOBR></span>
												</td>
												<td bgcolor="silver" align="right">
													<input type="button" name="userManager_close" id="userManager_close" value="[X]" class="buttonMenuClass" onclick="dismissUserManagerForm(); return false;">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<div id="div_userManager_user_grid" style="display: inline;">
													</div>
													<div id="div_userManager_user_grid_editor" style="display: none;">
														<table border="1" bgcolor="##FFFF80" width="100%" cellpadding="-1" cellspacing="-1">
															<tr>
																<td>
																	<table width="100%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td align="center">
																				<span class="boldPromptTextClass"><NOBR>Geonosis User Editor</NOBR></span>
																			</td>
																			<td align="right">
																				<input type="button" name="userManager_user_grid_editor_close" id="userManager_user_grid_editor_close" value="[X]" class="buttonMenuClass" onclick="dismissUserEditorForm(); return false;">
																			</td>
																		</tr>
																		<tr>
																			<td colspan="2">
																				<table width="100%" cellpadding="-1" cellspacing="-1">
																					<tr bgcolor="silver">
																						<td align="center">
																							<span class="normalStatusBoldClass">UserName</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">User's Name</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">User Role</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">Password</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">Begin Date</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">End Date</span>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass">Action</span>
																						</td>
																					</tr>
																					<tr>
																						<td align="center">
																							<input type="text" name="userManagerEditor_UserName" id="userManagerEditor_UserName" class="textClass" size="25" maxlength="255" onkeyup="var retVal = validateEmailUserManager(this.value, 'btn_userManagerEditor_action'); validateRoleUserManager('userManagerEditor_UserRole', 'btn_userManagerEditor_action'); return retVal;">
																						</td>
																						<td align="center">
																							<input type="text" name="userManagerEditor_UserProperName" id="userManagerEditor_UserProperName" class="textClass" size="25" maxlength="255" onblur="validateName(this.id, this.value); return true;">
																						</td>
																						<td align="center">
																							<select id="userManagerEditor_UserRole" name="userManagerEditor_UserRole" class="textClass" onchange="chooseUserRole(_getSelectionsFromObj(this), 'userManagerEditor_UserRole', 'btn_userManagerEditor_action'); return false;">
																							</select>
																						</td>
																						<td align="center">
																							<span class="normalStatusBoldClass"><i>(Encrypted)</i></span>
																						</td>
																						<td>
																							<table width="100%" cellpadding="-1" cellspacing="-1">
																								<tr>
																									<td>
																										<select id="userManagerEditor_BeginDt_MM" name="userManagerEditor_BeginDt_MM" class="textClass" onchange="resetCalendarDaysInMonth('userManagerEditor_BeginDt_', _getSelectionsFromObj(this), _getSelectionsFromObj($('userManagerEditor_BeginDt_YYYY'))); return false;">
																										</select>
																									</td>
																									<td>
																										<select id="userManagerEditor_BeginDt_DD" name="userManagerEditor_BeginDt_DD" class="textClass" onchange="return false;">
																										</select>
																									</td>
																									<td>
																										<select id="userManagerEditor_BeginDt_YYYY" name="userManagerEditor_BeginDt_YYYY" class="textClass" onchange="resetCalendarDaysInMonth('userManagerEditor_BeginDt_', _getSelectionsFromObj($('userManagerEditor_BeginDt_MM')), _getSelectionsFromObj(this)); return false;">
																										</select>
																									</td>
																								</tr>
																							</table>
																						</td>
																						<td>
																							<table width="100%" cellpadding="-1" cellspacing="-1">
																								<tr>
																									<td>
																										<select id="userManagerEditor_EndDt_MM" name="userManagerEditor_EndDt_MM" class="textClass" onchange="resetCalendarDaysInMonth('userManager_EndDt_', _getSelectionsFromObj(this), _getSelectionsFromObj($('userManager_EndDt_YYYY'))); return false;">
																										</select>
																									</td>
																									<td>
																										<select id="userManagerEditor_EndDt_DD" name="userManagerEditor_EndDt_DD" class="textClass" onchange="return false;">
																										</select>
																									</td>
																									<td>
																										<select id="userManagerEditor_EndDt_YYYY" name="userManagerEditor_EndDt_YYYY" class="textClass" onchange="resetCalendarDaysInMonth('userManager_EndDt_', _getSelectionsFromObj($('userManager_EndDt_MM')), _getSelectionsFromObj(this)); return false;">
																										</select>
																									</td>
																								</tr>
																							</table>
																						</td>
																						<td align="center">
																							<input type="hidden" name="hidden_userManagerEditor_ID" value="">
																							<input disabled type="button" name="btn_userManagerEditor_action" id="btn_userManagerEditor_action" value="[?]" class="buttonMenuClass" onclick="performUserMgrConfirmationAction(this, DWRUtil.getValue('hidden_userManagerEditor_ID')); return false;">
																						</td>
																					</tr>
																					<tr>
																						<td colspan="6">
																							<span class="textClass"><i>(Directions: The <b>[-] or [*]</b> button above will be enabled only when the UserName has been populated with a valid Internet Email Address.  The Begin Date is the date when this User is to have access to Geonosis using the specified <b>Role</b>.  The End Date is the date when this User is to be denied access to Geonosis.  Leave the End Date blank to allow this User to have access with no termination date.  UserNames must be composed of valid Internet email addresses because our servers will communicate with each user as-needed using their Internet EMail Address.)</i></span>
																						</td>
																					</tr>
																				</table>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</div>
													<hr width="80%" color="blue">
												</td>
											</tr>
											<tr>
												<td>
													<div id="div_userManager_user_grid_adder" style="display: inline;">
														<table width="100%" cellpadding="-1" cellspacing="-1">
															<tr bgcolor="silver">
																<td align="center">
																	<span class="normalStatusBoldClass">UserName</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">User's Name</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">User Role</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">Password</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">Begin Date</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">End Date</span>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass">Action</span>
																</td>
															</tr>
															<tr>
																<td>
																	<input type="text" name="userManager_UserName" id="userManager_UserName" class="textClass" size="25" maxlength="255" title="(Valid Internet email address only !)" onkeyup="var retVal = validateEmailUserManager(this.value, 'userManager_addUser'); validateRoleUserManager('userManager_UserRole', 'userManager_addUser'); return retVal;">
																</td>
																<!--- +++ --->
																<td>
																	<input type="text" name="userManager_UserProperName" id="userManager_UserProperName" class="textClass" size="25" maxlength="255" onblur="validateName(this.id, this.value); return true;">
																</td>
																<!--- +++ --->
																<td align="center">
																	<cfscript>
																		_sql_statement = Request.commonCode.sql_GetAllRolesForUser();
																		Request.commonCode.safely_execSQL('Request.qGetAllRolesForUser', Request.DSN, _sql_statement);
																	</cfscript>
	
																	<cfif (IsDefined("Request.qGetAllRolesForUser")) AND (IsQuery(Request.qGetAllRolesForUser))>
																		<select id="userManager_UserRole" name="userManager_UserRole" class="textClass" onchange="chooseUserRole(_getSelectionsFromObj(this), 'userManager_UserRole', 'userManager_addUser'); return false;">
																			<option value="">#Request.const_Choose_symbol#</option>
																			<option value="+">#Request.const_AddRole_symbol#</option>
																			<cfloop query="Request.qGetAllRolesForUser" startrow="1" endrow="#Request.qGetAllRolesForUser.recordCount#">
																				<option value="#Request.qGetAllRolesForUser.ID#">#Request.qGetAllRolesForUser.ROLENAME#</option>
																			</cfloop>
																		</select>
																	<cfelse>
																		<font color="red"><b>ERROR: Missing Query named "Request.qGetAllRolesForUser".</b></font>
																	</cfif>
																</td>
																<td align="center">
																	<span class="normalStatusBoldClass"><i>(Unassigned)</i></span>
																</td>
																<td>
																	<table width="100%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td>
																				<select id="userManager_BeginDt_MM" name="userManager_BeginDt_MM" class="textClass" onchange="resetCalendarDaysInMonth('userManager_BeginDt_', _getSelectionsFromObj(this), _getSelectionsFromObj($('userManager_BeginDt_YYYY'))); return false;">
																					<option value="">---</option>
																					<cfloop index="_iMonth_" from="1" to="12">
																						<cfset _selected = "">
																						<cfif (_iMonth_ eq Month(Now()))>
																							<cfset _selected = " selected">
																						</cfif>
																						<option#_selected# value="#_iMonth_#">#DateFormat(CreateDate(Year(Now()), _iMonth_, 1), "mmm")#</option>
																					</cfloop>
																				</select>
																			</td>
																			<td>
																				<select id="userManager_BeginDt_DD" name="userManager_BeginDt_DD" class="textClass" onchange="return false;">
																					<option value="">--</option>
																					<cfloop index="_iDay_" from="1" to="#DaysInMonth(Month(Now()))#">
																						<cfset _selected = "">
																						<cfif (_iDay_ eq Day(Now()))>
																							<cfset _selected = " selected">
																						</cfif>
																						<option#_selected# value="#_iDay_#">#_iDay_#</option>
																					</cfloop>
																				</select>
																			</td>
																			<td>
																				<select id="userManager_BeginDt_YYYY" name="userManager_BeginDt_YYYY" class="textClass" onchange="resetCalendarDaysInMonth('userManager_BeginDt_', _getSelectionsFromObj($('userManager_BeginDt_MM')), _getSelectionsFromObj(this)); return false;">
																					<option value="">----</option>
																					<cfloop index="_iYear_" from="#Year(Now())#" to="#(Year(Now()) + 5)#">
																						<cfset _selected = "">
																						<cfif (_iYear_ eq Year(Now()))>
																							<cfset _selected = " selected">
																						</cfif>
																						<option#_selected# value="#_iYear_#">#_iYear_#</option>
																					</cfloop>
																				</select>
																			</td>
																		</tr>
																	</table>
																</td>
																<td>
																	<table width="100%" cellpadding="-1" cellspacing="-1">
																		<tr>
																			<td>
																				<select id="userManager_EndDt_MM" name="userManager_EndDt_MM" class="textClass" onchange="resetCalendarDaysInMonth('userManager_EndDt_', _getSelectionsFromObj(this), _getSelectionsFromObj($('userManager_EndDt_YYYY'))); return false;">
																					<option selected value="">---</option>
																					<cfloop index="_iMonth_" from="1" to="12">
																						<cfset _selected = "">
																						<option#_selected# value="#_iMonth_#">#DateFormat(CreateDate(Year(Now()), _iMonth_, 1), "mmm")#</option>
																					</cfloop>
																				</select>
																			</td>
																			<td>
																				<select id="userManager_EndDt_DD" name="userManager_EndDt_DD" class="textClass" onchange="return false;">
																					<option selected value="">--</option>
																					<cfloop index="_iDay_" from="1" to="#DaysInMonth(Month(Now()))#">
																						<cfset _selected = "">
																						<option#_selected# value="#_iDay_#">#_iDay_#</option>
																					</cfloop>
																				</select>
																			</td>
																			<td>
																				<select id="userManager_EndDt_YYYY" name="userManager_EndDt_YYYY" class="textClass" onchange="resetCalendarDaysInMonth('userManager_EndDt_', _getSelectionsFromObj($('userManager_EndDt_MM')), _getSelectionsFromObj(this)); return false;">
																					<option selected value="">----</option>
																					<cfloop index="_iYear_" from="#Year(Now())#" to="#(Year(Now()) + 5)#">
																						<cfset _selected = "">
																						<option#_selected# value="#_iYear_#">#_iYear_#</option>
																					</cfloop>
																				</select>
																			</td>
																		</tr>
																	</table>
																</td>
																<td align="center">
																	<input disabled type="button" name="userManager_addUser" id="userManager_addUser" value="[+]" class="buttonMenuClass" onclick="performProcessAddUser(); return false;">
																</td>
															</tr>
															<tr>
																<td colspan="6">
																	<span class="textClass"><i>(Directions: The <b>[+]</b> button above will be enabled only when the UserName has been populated with a valid Internet Email Address.  The Begin Date is the date when this User is to have access to Geonosis using the specified <b>Role</b>.  The End Date is the date when this User is to be denied access to Geonosis.  Leave the End Date blank to allow this User to have access with no termination date.  UserNames must be composed of valid Internet email addresses because our servers will communicate with each user as-needed using their Internet EMail Address.)</i></span>
																</td>
															</tr>
														</table>
													</div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_rolesManager" style="display: none;">
				<table width="400" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver" align="center">
													<span class="boldPromptTextClass"><NOBR>Geonosis Roles Manager</NOBR></span>
												</td>
												<td bgcolor="silver" align="right">
													<input type="button" name="rolesManager_close" id="rolesManager_close" value="[X]" class="buttonMenuClass" onclick="dismissRolesManagerForm(); return false;">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<input type="text" name="rolesManager_RoleName" id="rolesManager_RoleName" class="textClass" size="40" maxlength="50" onkeyup="var bool = true; validateRoleNames(this.value, this.id); disableWidgetByID('rolesManager_addRole', ((this.value.length > 0) ? false : true)); return bool;">
												</td>
												<td>
													<input type="button" name="rolesManager_addRole" id="rolesManager_addRole" value="[>>]" class="buttonMenuClass" onclick="addNewRole2RoleManager(DWRUtil.getValue('rolesManager_RoleName')); return false;">
													<br>
													<cfset _disabled = "">
													<input#_disabled# type="button" name="rolesManager_removeRole" id="rolesManager_removeRole" value="[<<]" class="buttonMenuClass" onclick="removeRoleFromRoleManager(_getSelectionsFromObjByID('rolesManager_CurrentRoles')); return false;">
												</td>
												<td>
													<cfif (IsDefined("Request.qGetAllRolesForUser")) AND (IsQuery(Request.qGetAllRolesForUser))>
														<select id="rolesManager_CurrentRoles" name="rolesManager_CurrentRoles" class="textClass" size="10" onfocus="handleEvents_forRolesManager_CurrentRoles(this); return true;" onchange="handleEvents_forRolesManager_CurrentRoles(this); return true;">
															<cfloop query="Request.qGetAllRolesForUser" startrow="1" endrow="#Request.qGetAllRolesForUser.recordCount#">
																<option value="#Request.qGetAllRolesForUser.ID#">#Request.qGetAllRolesForUser.ROLENAME#</option>
															</cfloop>
														</select>
													<cfelse>
														<font color="red"><b>ERROR: Missing Query named "Request.qGetAllRolesForUser".</b></font>
													</cfif>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_user_forgot_password" style="display: none;">
				<table width="400" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td bgcolor="silver" align="center">
										<span class="boldPromptTextClass"><NOBR>Forgot Password</NOBR></span>
									</td>
									<td bgcolor="silver" align="center">
										<input type="button" name="user_user_forgot_password_close" id="user_user_forgot_password_close" value="[X]" class="buttonMenuClass" onclick="dismissForgotPasswordForm(); return false;">
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td>
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td>
																<span class="boldPromptTextClass"><NOBR>UserName:</NOBR></span>&nbsp;<span title="The data entry field is Required." class="errorStatusBoldClass">(*)</span>
															</td>
															<td>
																<input type="text" name="user_user_forgot_password_UserName" id="user_user_forgot_password_UserName" class="textClass" size="40" maxlength="255" onkeyup="return validateEmail2(this.value);">
															</td>
														</tr>
														<tr>
															<td colspan="2">
															<br>
															<span id="user_user_forgot_password_status_message" class="onholdStatusBoldClass"></span>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<span class="textClass"><i>(use your valid Internet email address - we will send your password to your email address)</i></span>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<input disabled type="button" name="user_user_forgot_password_btn_getPassword" id="user_user_forgot_password_btn_getPassword" value="[Give Me My Password]" class="buttonClass" onclick="var objUserName = $('user_user_forgot_password_UserName'); if (objUserName != null) { performRetrievePassword(objUserName.value); }; return false;">
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_toDo_List" style="display: inline;">
				<table width="800" cellpadding="-1" cellspacing="-1">
					<tr>
						<td id="td_toDo_list_body" style="display: none;">
							<OL> <!--- To-Do List --->
								<LI><b><strike>Complete Save function for Link Object Editor</strike></b></LI>
								<LI><b><i>Use Db Schema as guide for all forms, etc.</i></b>
									<UL>
										<LI><b><strike>SQL parms validation based on SQL Schema</strike></b></LI>
										<LI><b><i>FORMs automatically generated from SQL Schema</i></b></LI>
										<LI><b><i>Data entry validation based on SQL Schema</i></b></LI>
									</UL>
								</LI>
								<LI><b><strike>Allow Object Links to be deleted.</strike></b>
								</LI>
								<LI><b><strike>Allow Object Attributes to be deleted.</strike></b>
								</LI>
								<LI><b><strike>Allow Objects to be deleted but only after all Attributes and Links have been deleted.</strike></b>
								</LI>
								<LI><b><strike>Deploy Ajax Code Sample</strike></b>
									<UL>
										<LI><b><strike>Upload the sample CJAjax App to Macromedia</strike></b></LI>
										<LI><b>Rework the Protfolio site to use CJAjax and feature this sample</b></LI>
										<LI><b>Use original site design as a Flex 1.5 example.</b></LI>
										<LI><b>Deploy the Blog as a CFAjax app</b></LI>
									</UL>
								</LI>
								<LI><b><strike>User Authentication System</strike></b>
									<UL>
										<LI><b>Created/Update By based on current User ID</b></LI>
										<LI><b><strike>Use code from personal code library</strike></b></LI>
									</UL>
								</LI>
								<LI><b>User Management System</b>
									<UL>
										<LI><b>Allows users to be added to system along with User Role</b></LI>
										<LI><b>Session Management - when session ends, session time-out, track user who logged in via the ObjectID for the User object.</b></LI>
										<LI><b>Future Enhancements:</b>
											<UL>
												<LI><b>Modify User Manager to only pull a single page of users from the Db at a time based on the current page in view.</b></LI>
											</UL>
										</LI>
									</UL>
								</LI>
								<LI><b>Automatic URL Rewriter</b>
									<UL>
										<LI><b>Causes all externally accessed URLs to be recoded to hit the index.cfm rather than a possibly missing page.</b></LI>
									</UL>
								</LI>
								<LI><b>Geonosis Objects</b>
									<UL>
										<LI><b>GeonosisUSERS - Define Users</b>
											<UL>
												<LI><b>Attributes</b>
													<UL>
														<LI><b>UserName</b></LI>
														<LI><b>Password (encrypted)</b></LI>
														<LI><b>Begin Date</b></LI>
														<LI><b>End Date (assumed to be inactive when End Date is specified)</b></LI>
													</UL>
												</LI>
												<LI><b>ObjectLinks</b>
													<UL>
														<LI><b>GeonosisROLES</b></LI>
													</UL>
												</LI>
											</UL>
										</LI>
										<LI><b>GeonosisROLES - Define Roles</b>
											<UL>
												<LI><b>Attributes</b>
													<UL>
														<LI><b>RoleName</b></LI>
														<LI><b>Begin Date</b></LI>
														<LI><b>End Date (assumed to be inactive when End Date is specified)</b></LI>
													</UL>
												</LI>
												<LI><b>ObjectLinks</b>
													<UL>
														<LI><b>GeonosisUSERS</b></LI>
													</UL>
												</LI>
											</UL>
										</LI>
									</UL>
								</LI>
							</OL>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_objectManager" style="display: none;">
				<table width="600" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
					<tr>
						<td>
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td bgcolor="silver" align="center">
										<span class="boldPromptTextClass"><NOBR>Geonosis Object Manager</NOBR></span>
									</td>
									<td bgcolor="silver" align="right">
										<input type="button" name="objectManager_close" id="objectManager_close" value="[X]" class="buttonMenuClass" onclick="dismissObjectManagerForm(); return false;">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="990" border="1" class="paperBgColorClass" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver">
													<span class="boldPromptTextClass"><a href="" onclick="toggleObjectDisplayStyleById('td_object_linker_body'); return false;">Object Linker... (The Object Linker allows Objects to be Linked to other Objects.)</a></span>
												</td>
											</tr>
											<tr>
												<td id="td_object_linker_body" style="display: none;">
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td id="td_concrete_layout_validTypes">
															</td>
															<td id="td_concrete_layout_objectType">
															</td>
															<td id="td_concrete_layout_objectSearch">
															</td>
														</tr>
														<tr>
															<td id="td_concrete_layout_objectsLinker">
															</td>
															<td id="td_concrete_layout_objectsLinked">
															</td>
															<td id="td_concrete_layout_objectPickerObjectLinkEditor">
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<hr width="80%" color="blue">
							<table width="990" border="1" class="paperBgColorClass" cellpadding="-1" cellspacing="-1">
								<tr>
									<td>
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td bgcolor="silver">
													<span class="boldPromptTextClass"><a href="" onclick="toggleObjectDisplayStyleById('td_object_creator_body'); return false;">Object Creator... (The Object Creator allows Classes or Types of Objects to be Created as well as Object instances.)</a></span>
												</td>
											</tr>
											<tr>
												<td id="td_object_creator_body" style="display: none;">
													<table width="100%" cellpadding="-1" cellspacing="-1">
														<tr>
															<td id="td_concrete_layout_objectCreatorMakeType">
															</td>
															<td id="td_concrete_layout_objectCreatorAvailableType">
															</td>
															<td id="td_concrete_layout_objectCreatorWorkingWith">
															</td>
														</tr>
														<tr>
															<td id="td_concrete_layout_objectCreatorMakeObject">
															</td>
															<td colspan="2">
																<table width="100%" height="75" cellpadding="-1" cellspacing="-1">
																	<tr valign="top">
																		<td id="td_concrete_layout_objectCreatorSearchObjects">
																		</td>
																	</tr>
																	<tr valign="bottom">
																		<td id="td_concrete_layout_objectCreatorListObjects">
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
														<tr>
															<td id="td_concrete_layout_objectCreatorMakeAttribute">
															</td>
															<td colspan="2">
																<table width="100%" height="75" cellpadding="-1" cellspacing="-1">
																	<tr valign="top">
																		<td id="td_concrete_layout_objectCreatorListAttributes" colspan="2">
																		</td>
																	</tr>
																	<tr valign="bottom">
																		<td id="td_concrete_layout_objectCreatorAttributeSelector">
																		</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_confirmation_dialog" style="position: absolute; top: 150px; left: 200px; width: 300px; height: 80px; display: none;">
				<table width="300px" height="80px" border="1" bgcolor="##FFFF80" cellpadding="-1" cellspacing="-1">
					<tr>
						<td valign="top">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td valign="top">
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr bgcolor="##80FF80">
												<td align="center">
													<span id="span_confirmation_dialog_title" class="normalStatusBoldClass"></span>
												</td>
											</tr>
											<tr>
												<td align="left">
													<div style="margin-top: 20px;">
														<span id="span_confirmation_dialog_prompt" class="normalStatusBoldClass"></span>
													</div>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td valign="bottom">
										<table width="100%" cellpadding="-1" cellspacing="-1" style="margin-top: 20px;">
											<tr>
												<td align="left" width="50%">
													<input id="btn_confirmation_dialog_confirm" type="Button" class="buttonClass" title="Confirm the action." value="[Confirm]" onclick="performConfirmationDialogClick(this); return false;">
												</td>
												<td align="right" width="50%">
													<input id="btn_confirmation_dialog_cancel" type="Button" class="buttonClass" title="Cancel this Dialog." value="[Cancel]" onclick="performConfirmationDialogClick(this); return false;">
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="div_title_ObjectLinker" style="display: inline;">
				<h1>ObjectLinker</h1>
				<table>
					<tr>
						<td>
							<cfif (IsStruct(anObjLinker))>
								#anObjLinker.objectPickerChooseClasses()#
							</cfif>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="div_title_ObjectCreator" style="display: inline;">
				<h1>ObjectCreator</h1>
				<table>
					<tr>
						<td>
							<cfif (IsStruct(anObjCreator))>
								#anObjCreator.objectCreatorGUI()#
							</cfif>
						</td>
					</tr>
				</table>
			</div>
			
			<table width="100%" cellpadding="-1" cellspacing="-1">
				<tr>
					<td id="td_ajaxHelperPanel2" align="center" style="display: inline;">
						<table width="100%" border="1" bgcolor="##80FFFF" cellspacing="-1" cellpadding="-1" id="table_ajaxHelperPanel2" style="width: 800px;">
							<tr>
								<td align="center">
									<div id="div_application_debug_panel">
										<table width="100%" cellpadding="-1" cellspacing="-1">
											<tr>
												<td align="left" valign="top">
													<cfdump var="#Application#" label="Application Scope" expand="No">
												</td>
												<td align="left" valign="top">
													<cfdump var="#Session#" label="Session Scope" expand="No">
												</td>
												<td align="left" valign="top">
													<cfdump var="#CGI#" label="CGI Scope" expand="No">
												</td>
												<td align="left" valign="top">
													<cfdump var="#Request#" label="Request Scope" expand="No">
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

		</body>
	</cfoutput>
</html>