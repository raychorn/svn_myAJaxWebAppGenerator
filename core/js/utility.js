_cache_disabled_objects = [];

_dict_hilited_objects = DictonaryObj.getInstance();

_dict_checked_objects = DictonaryObj.getInstance();

_current_user_manager_page = 1;

_stack_user_in_focus = [];

_cache_confirmation_dialog_actions = [];

_stack_disabled_objects = [];

function focusOnWidget(obj) {
	if (obj != null) {
		try {
			obj.focus();
		} catch(e) {
		} finally {
		}
	}
}

function focusOnWidgetByID(id) {
	return focusOnWidget($(id));
}

function setObjectDisplayStyleForObj(obj, bool) {
	if (obj != null) { 
		obj.style.display = ((bool == true) ? const_inline_style : const_none_style); 
	}
}

function setObjectDisplayStyleById(id, bool) {
	return setObjectDisplayStyleForObj($(id), bool);
}

function innerHTMLForObj(obj, sContent) {
	if (obj != null) {
		obj.innerHTML = sContent;
	}
}

function innerHTMLForObjByID(id, sContent) {
	return innerHTMLForObj($(id), sContent);
}

function toggleObjectDisplayStyleById(id) {
	var obj = $(id); 
	if (obj != null) { 
		obj.style.display = ((obj.style.display == const_none_style) ? const_inline_style : const_none_style); 
	}
}

function disableWidget(obj, bool) {
	if (obj != null) {
		obj.disabled = ((bool == true) ? true : false);
	}
}

function disableWidgetByID(id, bool) {
	var obj = -1;
	obj = $(id);
	disableWidget(obj, bool);
}

function disableWidgets2Stack(id) {
	disableAllChildrenForObjById(id, true);
	_stack_disabled_objects.push(id);
}

function enableStackedWidgets() {
	var id = '';
	while (_stack_disabled_objects.length > 0) {
		id = _stack_disabled_objects.pop();
		disableAllChildrenForObjById(id, false);
	}
}

function disableWidgetsFromDict(aDict) {
	var i = -1;
	var obj = -1;

	if (aDict.getKeys) {
		var keys = aDict.getKeys();
		for (i = 0; i < keys.length; i++) {
			disableWidget($(keys[i]), aDict.getValueFor(keys[i]));
		}
	}
}

function disableAllChildrenForObj(obj, bool) {
	var aChildObj = -1;
	
	if (obj != null) {
		var sfEls = obj.getElementsByTagName("*");
		for (var i = 0; i < sfEls.length; i++) {
			aChildObj = sfEls[i];
			aChildObj.disabled = bool;
		}
	}
}

function disableAllChildrenForObjById(id, bool) {
	bool = ((bool == false) ? false : true);
	var obj = $(id);
	if (obj != null) { 
		disableAllChildrenForObj(obj, bool);
	}
}

function disabledChildrenForObj(obj) {
	var aChildObj = -1;
	var aDict = DictonaryObj.getInstance();
	
	if (obj != null) {
		var sfEls = obj.getElementsByTagName("*");
		for (var i = 0; i < sfEls.length; i++) {
			aChildObj = sfEls[i];
			if (aChildObj.disabled) {
				aDict.push(aChildObj.id, aChildObj.disabled);
			}
		}
	}
	return aDict;
}

function disabledChildrenForObjById(id) {
	var obj = $(id);
	if (obj != null) { 
		return disabledChildrenForObj(obj);
	}
	return DictonaryObj.getInstance();
}

function setTitleForObj(obj, t) {
	if (obj != null) { 
		obj.title = t;
	}
}

function setTitleForObjById(id, t) {
	setTitleForObj($(id), t);
}

function getTitleForObj(obj) {
	if (obj != null) {
		return obj.title;
	}
}

function getTitleForObjById(id) {
	return getTitleForObj($(id));
}

function selectionsSetSelectedUsingObj(obj, bool) {
	var i = -1;
	if (obj != null) {
		bool = ((bool == false) ? bool : true);
		for (i = 0; i < obj.options.length; i++) {
			obj.options[i].selected = bool;
		}
	}
}

function selectionsSetSelectedById(id, bool) {
	return selectionsSetSelectedUsingObj($(id), bool);
}

function selectionsFirstSelectedUsingObj(obj, bool) {
	if (obj != null) {
		bool = ((bool == false) ? bool : true);
		if (obj.options.length > 0) {
			obj.options[0].selected = bool;
		}
	}
}

function selectionsFirstSelectedById(id, bool) {
	return selectionsFirstSelectedUsingObj($(id), bool);
}

function selectionsItemSelectedForObj(obj, text, bool_textOrValue) {
	var i = -1;
	var s = '';
	bool_textOrValue = (((bool_textOrValue == null) || (bool_textOrValue == true)) ? true : false); // if true then use text else use value...
	
	if ( (obj != null) && (obj.type.toUpperCase() == const_select_one_symbol.toUpperCase()) ) {
		for (i = 0; i < obj.options.length; i++) {
			s = ((bool_textOrValue) ? obj.options[i].text : obj.options[i].value);
			if (bool_textOrValue) {
				s = obj.options[i].text;
				try {
					s = s.toUpperCase();
				} catch(e) {
				} finally {
				}
				try {
					text = text.toUpperCase();
				} catch(e) {
				} finally {
				}
			} else {
				s = obj.options[i].value;
			}
		//	alert('obj.id = [' + obj.id + ']' + ', obj.options.length = [' + obj.options.length + ']' + ', s = [' + s + ']' + ', s.length = [' + s.length + ']' + ', text = [' + text + ']' + ', bool_textOrValue = [' + bool_textOrValue + ']');
			if (s == text) {
				obj.options[i].selected = true;
			} else {
				obj.options[i].selected = false;
			}
		}
	}
}

function selectionsItemSelectedById(id, value, bool_textOrValue) {
	return selectionsItemSelectedForObj($(id), value, bool_textOrValue);
}

function copySelectionsFromObj2Obj(sObj, dObj, exFunc) {
	var i = -1;
	var o = -1;
	var bool = false;
	
	if ( (sObj != null) && (dObj != null) ) {
		while (dObj.options.length) {
			dObj.options[0] = null;
		}
		for (i = 0; i < sObj.options.length; i++) {
			bool = (((exFunc != null) && (typeof exFunc == const_function_symbol)) ? exFunc(sObj.options[i].text) : true);
			if (bool) {
				o = new Option(sObj.options[i].text, sObj.options[i].value);
				dObj.options[dObj.options.length] = o;
			}
		}
	}
}

function copySelectionsFromObj2ObjById(sId, dId) {
	return copySelectionsFromObj2Obj($(sId), $(DId));
}

function _getSelectionsFromObj(obj) {
	var i = -1;
	var a = [];
	var aa = [];

	if ( (obj != null) && (obj.options.length != null) ) {
		for (i = 0; i <= obj.options.length; i++) {
			try {
				if (obj.options[i].selected == true) {
					aa[aa.length] = obj.options[i].value;
				}
			} catch(e) {
			} finally {
			}
		}
		a[0] = obj.id;
		a[1] = aa;
	}
	return a;
}

function _getTextFromSelectionObjByValue(obj, value) {
	var i = -1;
	var text = '';

	if ( (obj != null) && (obj.options.length != null) ) {
		for (i = 0; i <= obj.options.length; i++) {
			try {
				if (obj.options[i].value == value) {
					text = obj.options[i].text;
					break;
				}
			} catch(e) {
				break;
			} finally {
			}
		}
	}
	return text;
}

function _getTextFromSelectionObjIdByValue(id, value) {
	return _getTextFromSelectionObjByValue($(id), value);
}

function _getSelectionsFromObjByID(id) {
	return _getSelectionsFromObj($(id));
}

function removeAllOptionsByID(id) {
	var mObj = $(id);
	if (mObj != null) {
		while (mObj.options.length > 0) {
			mObj.options[0] = null;
		}
	}
}

function setLinearOptionsByID(id, alpha, omega) {
	var i = -1;
	var mObj = $(id);
	if (mObj != null) {
		for (i = alpha; i <= omega; i++) {
			o = new Option(i, i);
			mObj.options[mObj.options.length] = o;
		}
	}
}

function AddAnOptionByID(id, value, text) {
	var mObj = $(id);
	if (mObj != null) {
		o = new Option(text, value);
		mObj.options[mObj.options.length] = o;
	}
}

function debugAjaxObject(anObject, bool_silent) {
	var i = -1;
	var j = -1;
	var obj = -1;
	var _db = '';
	var _msg = '';

	for (i = 0; i < anObject.length; i++) {
		obj = anObject[i];
		for (j in obj) {
			_db += 'anObject[' + i + '] = [' + j + ']' + ', obj.' + j + ' = [' + obj[j] + ']' + '\n';
		}
	}
	_msg = 'anObject.length = [' + anObject.length + ']' + '\n' + _db;

	if (bool_silent) {
		DHTMLWindowsObj.jsWindow(aDHTMLObj1.id,_msg,800,400,5,10);
	} else {
		alert(_msg);
	}
}

function handlePossibleSQLError(anObject, func) {
	var bool_isError = false;
	var obj = -1;
	var _msg = '';

	if (anObject.length == 1) {
		obj = anObject[0];
		if (obj.ID < -1) {
			_msg = 'ID: ' + obj.ID + '<br>' + obj.ERRORTITLE + '<br>' + obj.ERRORMSG;
			bool_isError = true;
		}
	}
	if (bool_isError) {
		if (1) {
			_alert(_msg);
		} else {
			debugAjaxObject(anObject, true);
		}
	} else {
		func(anObject);
	}
}

function removeOpenedGUIFromStack(id) {
	var i = -1;
	var ar = [];
	if (stack_opened_GUIs) {
		for (i = 0; i < stack_opened_GUIs.length; i++) {
			if (stack_opened_GUIs[i].gui_id.trim().toUpperCase() != id.trim().toUpperCase()) {
				ar.push(stack_opened_GUIs[i]);
			} else {
				setObjectDisplayStyleById(stack_opened_GUIs[i].gui_id, false);
				disableWidgetByID(stack_opened_GUIs[i].btn_id, false);
			}
		}
	}
	stack_opened_GUIs = ar;
}

function removeAllOpenedGUIsFromStack() {
	var o = -1;
	if (stack_opened_GUIs) {
		while (stack_opened_GUIs.length) {
			o = stack_opened_GUIs.pop();
			setObjectDisplayStyleById(o.gui_id, false);
			disableWidgetByID(o.btn_id, false);
			disableAllChildrenForObjById(o.gui_id, false);
		}
	}
}

function addOpenedGUI2Stack(btn_id, gui_id) {
	var o = new Object();
	if (stack_opened_GUIs) {
		o.btn_id = btn_id;
		o.gui_id = gui_id;
		stack_opened_GUIs.push(o);
	}
}

function validateProperNames(s, id) {
	var a = s.split(' ');
	if (a.length > 0) {
		a[0] = a[0].substring(0, 1).toUpperCase() + a[0].substring(1, a[0].length).toLowerCase();
	}
	if (a.length > 1) {
		a[1] = a[1].substring(0, 1).toUpperCase() + a[1].substring(1, a[1].length).toLowerCase();
	}
	DWRUtil.setValue(id, a.join(' '));
	return true;
}

function processSelectPrevNextPage(divName, pgNum, rowPerPage, bool_direction, pgTotal) {
	bool_direction = ((bool_direction == true) ? bool_direction : false);
	var deltaPg = ((pgTotal == null) ? 1 : ((bool_direction) ? (pgTotal - pgNum) : (pgNum - 1)));
	var delta = ((bool_direction) ? deltaPg : -deltaPg);
	var i = -1;
	var cObj1 = '';
	var caObj1 = '';
	var cObj2 = '';
	var caObj2 = '';

	for (i = 1; i <= rowPerPage; i++) {
		cObj1 = $(divName + pgNum + '.' + i);
		cObj2 = $(divName + (pgNum + delta) + '.' + i);

		if ( (cObj1 != null) && (cObj2 != null) ) {
			cObj1.style.display = const_none_style;
			cObj2.style.display = const_inline_style;
		}
	}

	caObj1 = $(divName + pgNum + '.' + rowPerPage + 'a');
	caObj2 = $(divName + (pgNum + delta) + '.' + rowPerPage + 'a');
	if ( (caObj1 != null) && (caObj2 != null) ) {
		caObj1.style.display = const_none_style;
		caObj2.style.display = const_inline_style;
	}
	_current_user_manager_page += delta;
}

function performSelectNextPage(divName, pgNum, rowPerPage) {
	var retVal = -1;
	retVal = processSelectPrevNextPage(divName, pgNum, rowPerPage, true);
	return retVal;
}

function performSelectPrevPage(divName, pgNum, rowPerPage) {
	var retVal = -1;
	retVal = processSelectPrevNextPage(divName, pgNum, rowPerPage, false);
	return retVal;
}

function performToggleAllPages(divName, curPage, numPages, rowPerPage) {
	var i = -1;
	var j = -1;
	for (i = 1; i <= numPages; i++) {
		if (i != curPage) {
			for (j = 1; j <= rowPerPage; j++) {
				toggleObjectDisplayStyleById(divName + i + '.' + j);
			}
			toggleObjectDisplayStyleById(divName + i + '.' + j + 'a');
		}
	}
}

function performSelectFirstPage(divName, pgNum, rowPerPage, pgTotal) {
	var retVal = -1;
	retVal = processSelectPrevNextPage(divName, pgNum, rowPerPage, false, pgTotal);
	return retVal;
}

function performSelectLastPage(divName, pgNum, rowPerPage, pgTotal) {
	var retVal = -1;
	retVal = processSelectPrevNextPage(divName, pgNum, rowPerPage, true, pgTotal);
	return retVal;
}

function fetchDataFromGridSpans(divName, ar) {
	var spanPrefix = 'span_userManager_user_grid' + divName;
	var i = -1;
	var cObj = -1;
	var v = '';
	var oDict = DictonaryObj.getInstance();
//	var _db = '';
	
//	_db += 'spanPrefix = [' + spanPrefix + ']' + ', ar.length = [' + ar.length + ']' + '\n' + 'ar = [' + ar + ']';
	for (i = 0; i < ar.length; i++) {
		cObj = $(spanPrefix + '_' + ar[i]);
		if (cObj != null) {
			v = cObj.innerHTML.stripHTML();
			oDict.push(cObj.id, v);
		}
	}
//	alert('fetchDataFromGridSpans(divName = [' + divName + '], ar = [' + ar + '])' + '\n' + _db);
	return oDict;
}

function copyDataIntoFORMUsing(_fDict, _oDict, _divEditor, b_isDelete) {
	var i = -1;
	var k = -1;
	var ar = [];
	var arName = [];
	var arDate = [];
	var val = '';
	var _val = '';
	var wName = '';
	var arVal = [];
	var cObj = -1;
	var dObj = -1;
	var repName = '';
	var wName2 = '';
	var bool_textOrValue = false;
	
	function exceptMetaRoles(s) {
		return ( ( (s.toUpperCase() == const_Choose_symbol.toUpperCase()) || (s.toUpperCase() == const_AddRole_symbol.toUpperCase()) ) ? false : true);
	}

	function myInt(s) {
		var i = -1;
		try { 
			i = parseInt(s);
			alert('myInt(' + s + ') = [' + i + ']');
		} catch(e) { 
			jsErrorExplainer(e, 'parseInt', true);
		} finally { 
		}
		return i;
	}

	b_isDelete = ((b_isDelete == true) ? true : false);
	repName = _divEditor.clipCaselessReplace('Editor', '');

	ar = _oDict.getKeys();
	for (i = 0; i < ar.length; i++) {
		val = _oDict.getValueFor(ar[i]);
		wName = _fDict.getValueFor(ar[i]);
		arVal = wName.split(';');
		if (arVal.length > 1) {
			arDate = val.split('/');
			for (k = 0; k < arVal.length; k++) {
				cObj = $(arVal[k]);
				wName2 = cObj.id;
				wName2 = wName2.clipCaselessReplace(repName, _divEditor);
				dObj = $(wName2);
				if ( (cObj != null) && (dObj != null) ) {
					if (cObj.type.toUpperCase() == const_text_symbol.toUpperCase()) {
						dObj.value = val;
					} else if (cObj.type.toUpperCase() == const_select_one_symbol.toUpperCase()) {
						copySelectionsFromObj2Obj(cObj, dObj);
						_val = -1;
						arName = dObj.id.split('_');
						bool_textOrValue = true;
						if (arName[arName.length - 1].toUpperCase() == 'MM') {
							_val = ((arDate.length == 3) ? parseInt(arDate[0]) : val);
							bool_textOrValue = false;
						} else if (arName[arName.length - 1].toUpperCase() == 'DD') {
							_val = ((arDate.length == 3) ? parseInt(arDate[1]) : val);
						} else if (arName[arName.length - 1].toUpperCase() == 'YYYY') {
							_val = ((arDate.length == 3) ? parseInt(arDate[2]) : val);
						}
						if (_val > 0) {
						//	alert('dObj.id = [' + dObj.id + ']' + ', arName = [' + arName + ']' + ', _val = [' + _val + ']' + ', bool_textOrValue = [' + bool_textOrValue + ']');
							selectionsItemSelectedForObj(dObj, _val, bool_textOrValue);
						} else {
							selectionsFirstSelectedUsingObj(dObj, true);
						}
						dObj.disabled = b_isDelete;
					}
				}
			}
		} else {
			cObj = $(wName);
			wName2 = cObj.id;
			wName2 = wName2.clipCaselessReplace(repName, _divEditor);
			dObj = $(wName2);
			if ( (cObj != null) && (dObj != null) ) {
				if (cObj.type.toUpperCase() == const_text_symbol.toUpperCase()) {
					dObj.value = val;
				} else if (cObj.type.toUpperCase() == const_select_one_symbol.toUpperCase()) {
					copySelectionsFromObj2Obj(cObj, dObj, exceptMetaRoles);
					if (val.length > 0) {
						selectionsItemSelectedForObj(dObj, val);
					} else {
						selectionsFirstSelectedUsingObj(dObj, true);
					}
				}
				dObj.disabled = b_isDelete;
			}
		}
	}
}

function popHilitedObjects(aDict) {
	var i = -1;
	var arIDs = ((aDict.getKeys) ? aDict.getKeys() : []);

	for (i = 0; i < arIDs.length; i++) {
		cObj = $(arIDs[i]);
		if (cObj != null) {
			cObj.innerHTML = aDict.getValueFor(cObj.id);
		}
	}
}

function prepFORMvalues(divName, dictSpec, divPrefix, divEditor, bool_isDelete) {
	var i = -1;
	var j = -1;
	var k = -1;
	var n = -1;
	var aVal = '';
	var cVal = '';
	var arVal = [];
	var cDict = DictonaryObj.getInstance(dictSpec);
	var fDict = DictonaryObj.getInstance();
	var arList = cDict.getKeys();
	var oDict = fetchDataFromGridSpans(divName, arList);
	var keys1 = oDict.getKeys();
	var keys2 = [];
	var cObj = -1;

//	alert('fDict = [' + fDict + ']' + '\n' + 'oDict = [' + oDict + ']' + '\n' + 'cDict = [' + cDict + ']' + '\n' + 'arList = [' + arList + ']' + '\n' + 'keys1 = [' + keys1 + ']' + '\n');
	for (i = 0; i < arList.length; i++) {
		for (j = 0; j < keys1.length; j++) {
			if (keys1[j].toUpperCase().indexOf(arList[i].toUpperCase()) != -1) {
				fDict.push(keys1[j], arList[i]);
				break;
			}
		}
		aVal = cDict.getValueFor(arList[i]);
		arVal = aVal.split(';');
		if (arVal.length > 1) {
			for (k = 0; k < arVal.length; k++) {
				arVal[k] = divPrefix + arVal[k];
			}
			aVal = arVal.join(';');
		} else {
			aVal = divPrefix + aVal
		}
		cDict.put(arList[i], aVal);
	}
	keys2 = fDict.getKeys();
	for (n = 0; n < keys2.length; n++) {
		aVal = fDict.getValueFor(keys2[n]);
		cVal = cDict.getValueFor(aVal);
		fDict.put(keys2[n], cVal);
	}

	popHilitedObjects(_dict_hilited_objects);
	_dict_hilited_objects = DictonaryObj.getInstance();
	for (j = 0; j < keys1.length; j++) {
		cObj = $(keys1[j]);
		if (cObj != null) {
			_dict_hilited_objects.push(cObj.id, cObj.innerHTML);
			cObj.innerHTML = '<u>' + cObj.innerHTML + '</u>';  // highlight the selected record...
		}
	}
	copyDataIntoFORMUsing(fDict, oDict, divEditor, bool_isDelete);
}

function initCheckUserFor(id, bool) {
	bool = ((bool == true) ? true : false);
	if (_dict_checked_objects.getValueFor(id)) {
		_dict_checked_objects.put(id, false);
	} else {
		if (bool) {
			_dict_checked_objects.push(id, false);
		} else {
			_dict_checked_objects.put(id, true);
		}
	}
}

function performCheckUser(id) {
	var bool = false;
	
	initCheckUserFor(id);

	var cbObj = $(id);
	if (cbObj != null) {
		bool = _dict_checked_objects.getValueFor(id);
		cbObj.checked = ((bool) ? true : false);
	}
}

function performCheckAllUsers(id) {
	var i = -1;
	var cbObj = -1;
	var ar = _dict_checked_objects.getKeys();

	for (i = 0; i < ar.length; i++) {
		cbObj = $(ar[i]);
		if (cbObj != null) {
			cbObj.checked = ((_dict_checked_objects.getValueFor(cbObj.id) == true) ? false : true);
			_dict_checked_objects.put(cbObj.id, cbObj.checked);
		}
	}
}

function html_PopulateUserManagerWithUsers(anObject) {
	// anObject is a standard AJAX returned object...
	var _html = '';
	var pageNum = -1;
	var numPages = -1;
	var i = -1;
	var currentRow = -1;
	var delta = -1;
	var rowSelector = -1;
	var iRem = -1;
	var iDelta = -1;
	var cbID = '';
	var _user_in_focus = '';
	var _bool_isDevUser = false; // bool_isDevUser;

	function locatePageThatContainsUserNamed(aUserName, anObj) {
		var _iRem = -1;
		var _pageNum = 1;
		
		for (var i = 0; i < anObj.length; i++) {
			if (anObject[i].USERNAME == aUserName) {
				break;
			}
			_iRem = ((i + 1) % const_num_rows_user_mgr);
			if (_iRem == 0) {
				_pageNum++;
			}
		}
		return _pageNum;
	}
	
	_html += '<table width="100%" cellpadding="-1" cellspacing="-1">';
	_html += '<tr bgcolor="silver">';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass" style="display: ' + ((_bool_isDevUser) ? const_inline_style : const_none_style) + ';">(Page.Row)</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">UserName</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">User\'s Name</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">User Role</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">Password</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">Begin Date</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">End Date</span>';
	_html += '</td>';
	_html += '<td align="center">';
	_html += '<span class="normalStatusBoldClass">Action(s)</span>';
	_html += '</td>';
	_html += '</tr>';

	if (anObject.length) {
		pageNum = 1;
		numPages = Math.ceil(anObject.length / const_num_rows_user_mgr);

		iDelta = const_num_rows_user_mgr - (anObject.length % const_num_rows_user_mgr);
		
		if (iDelta == const_num_rows_user_mgr) { // nothing to show on this page so reduce the page count...
			iDelta -= const_num_rows_user_mgr;
			_current_user_manager_page--;
			if (_current_user_manager_page < 1) {
				_current_user_manager_page = 1;
			}
		}
		
		if (_stack_user_in_focus.length > 0) {
			_user_in_focus = _stack_user_in_focus.pop();
			// BEGIN: Predict which page the _stack_user_in_focus is on and then make that the page in view...
			_current_user_manager_page = locatePageThatContainsUserNamed(_user_in_focus, anObject);
			// END! Predict which page the _stack_user_in_focus is on and then make that the page in view...
		}

		for (i = -1; i < (anObject.length + iDelta); i++) {
			currentRow = i;
			delta = 0;
			iRem = ((currentRow + 1) % const_num_rows_user_mgr);
			if (iRem == 0) {
				delta = const_num_rows_user_mgr;
			}
	
			rowSelector = pageNum + '.' + (iRem + delta);

			_html += '<tr' + ((i == -1) ? '' : ' id="_pg' + rowSelector + '"') + ' style="display: ' + (((pageNum == _current_user_manager_page) || (i == -1)) ? const_inline_style : const_none_style) + ';" bgcolor="' + ((i == -1) ? 'silver' : (((currentRow % 2) == 0) ? '#FFFF80' : '#80FFFF')) + '">';
			_html += '<td align="left">';
			_html += '<span class="normalStatusBoldClass" style="display: ' + ((_bool_isDevUser) ? const_inline_style : const_none_style) + ';">' + ((i < anObject.length) ? '(' + rowSelector + ')' : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span' + ((i == -1) ? '' : ' id="span_userManager_user_grid_pg' + rowSelector + '_USERNAME') + '" class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? anObject[i].USERNAME : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span' + ((i == -1) ? '' : ' id="span_userManager_user_grid_pg' + rowSelector + '_USERPROPERNAME') + '" class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? anObject[i].USERPROPERNAME : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span' + ((i == -1) ? '' : ' id="span_userManager_user_grid_pg' + rowSelector + '_ROLENAME') + '" class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? anObject[i].ROLENAME : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? ((anObject[i].PASSWORD.length > 0) ? '(**)' : '(*NO PASSWORD*)') : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span' + ((i == -1) ? '' : ' id="span_userManager_user_grid_pg' + rowSelector + '_begindt') + '" class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? anObject[i].BEGINDT : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="center">';
			_html += '<span' + ((i == -1) ? '' : ' id="span_userManager_user_grid_pg' + rowSelector + '_enddt') + '" class="normalStatusBoldClass">' + (((i < anObject.length) && (i > -1)) ? anObject[i].ENDDT : '&nbsp;') + '</span>';
			_html += '</td>';
			_html += '<td align="' + ((i == -1) ? 'right' : 'center') + '">';

			if (i == -1) {
				_html += '<input id="cb_userManager_user_grid_checkAll" type="checkbox" class="buttonMenuClass" title="Select All Users" style="margin-left: -18px;" onClick="performCheckAllUsers(this.id); var _idList = getCheckedUsersArray(); disableWidgetByID(\'btn_userManager_user_grid_deleteAll\', ((_idList.length > 0) ? false : true)); return true;">';
				_html += '&nbsp;<b>Select All Users</b>';
			} else if (i < anObject.length) {
				cbID = 'cb_userManager_user_grid_check_' + rowSelector + '_' + anObject[i].ID;
				initCheckUserFor(cbID, true); // init as false...
				_html += '<input type="checkbox" id="' + cbID + '" class="buttonMenuClass" title="Select User" onClick="performCheckUser(this.id); var _idList = getCheckedUsersArray(); disableWidgetByID(\'btn_userManager_user_grid_deleteAll\', ((_idList.length > 0) ? false : true)); return true;">';
				_html += '&nbsp;';
				_html += '<input type="button" id="btn_userManager_user_grid_delete_' + rowSelector + '_' + anObject[i].ID + '" value="[-]" class="buttonMenuClass" title="Delete User" onclick="performDeleteUser(this.id, \'_pg' + rowSelector + '\', \'USERNAME=UserName,UserProperName=UserProperName,ROLENAME=UserRole,begindt=BeginDt_MM;BeginDt_DD;BeginDt_YYYY,enddt=EndDt_MM;EndDt_DD;EndDt_YYYY\', \'userManager_\', \'userManagerEditor_\'); return false;">';
				_html += '&nbsp;';
				_html += '<input type="button" id="btn_userManager_user_grid_edit_' + rowSelector + '_' + anObject[i].ID + '" value="[*]" class="buttonMenuClass" title="Edit User" onclick="performEditUser(this.id, \'_pg' + rowSelector + '\', \'USERNAME=UserName,UserProperName=UserProperName,ROLENAME=UserRole,begindt=BeginDt_MM;BeginDt_DD;BeginDt_YYYY,enddt=EndDt_MM;EndDt_DD;EndDt_YYYY\', \'userManager_\', \'userManagerEditor_\'); return false;">';
			} else {
				_html += '&nbsp;';
			}
			_html += '</td>';
			_html += '</tr>';

			if ( (i > -1) && (iRem == 0) ) {
				_html += '<tr id="_pg' + rowSelector + 'a" style="display: ' + ((pageNum == _current_user_manager_page) ? const_inline_style : const_none_style) + ';" bgcolor="silver">';
				_html += '<td colspan="7">';
				_html += '<table width="100%" border="0" cellpadding="-1" cellspacing="-1">';
				_html += '<tr>';
				_html += '<td width="20%" align="center">';
				_html += '<input ' + ((pageNum == 1) ? 'disabled' : '') + ' id="_userManager_user_grid_pg' + rowSelector + '_First" type="button" value="|<" class="buttonMenuClass" title="' + ((pageNum != 1) ? 'First Page' : '') + '" onclick="performSelectFirstPage(\'_pg\', ' + pageNum + ', ' + const_num_rows_user_mgr + ', ' + numPages + '); return false;">';
				_html += '</td>';
				_html += '<td width="20%" align="center">';
				_html += '<input ' + ((pageNum == 1) ? 'disabled' : '') + ' id="_userManager_user_grid_pg' + rowSelector + '_Prev" type="button" value="<" class="buttonMenuClass" title="' + ((pageNum != 1) ? 'Prev Page' : '') + '" onclick="performSelectPrevPage(\'_pg\', ' + pageNum + ', ' + const_num_rows_user_mgr + '); return false;">';
				_html += '</td>';
				_html += '<td width="20%" align="center">';
				_html += '<input ' + ((pageNum == numPages) ? 'disabled' : '') + ' id="_userManager_user_grid_pg' + rowSelector + '_Next" type="button" value=">" class="buttonMenuClass" title="' + ((pageNum != numPages) ? 'Next Page' : '') + '" onclick="performSelectNextPage(\'_pg\', ' + pageNum + ', ' + const_num_rows_user_mgr + '); return false;">';
				_html += '</td>';
				_html += '<td width="20%" align="center">';
				_html += '<input ' + ((pageNum == numPages) ? 'disabled' : '') + ' id="_userManager_user_grid_pg' + rowSelector + '_Last" type="button" value=">|" class="buttonMenuClass" title="' + ((pageNum != numPages) ? 'Last Page' : '') + '" onclick="performSelectLastPage(\'_pg\', ' + pageNum + ', ' + const_num_rows_user_mgr + ', ' + numPages + '); return false;">';
				_html += '</td>';
				_html += '<td width="20%" align="right">';
				_html += '<input type="button" id="btn_userManager_user_grid_deleteAll" disabled value="[Delete All]" class="buttonMenuClass" title="Delete All Checked Users" style="display: inline; margin-right: 20px;" onclick="var _idList = getCheckedUsersArray(); if (_idList.length > 0) { disableWidgets2Stack(\'\'); disableWidgets2Stack(\'_adder\'); popupConfirmationDialog(performDeleteAllCheckedUsers); } else { alert(\'Choose some users before clicking this button.\'); }; return false;">';
				_html += '<input type="button" value="|<>|" class="buttonMenuClass" title="Toggle All Pages" style="display: none;" onclick="performToggleAllPages(\'_pg\', ' + pageNum + ', ' + numPages + ', ' + const_num_rows_user_mgr + '); return false;">';
				_html += '</td>';
				_html += '</tr>';
				_html += '</table>';
				_html += '</td>';
				_html += '</tr>';
				
				pageNum += ((i == -1) ? 0 : 1);
				
				_html += '';
				_html += '';
			}
		}
	}
	
	_html += '</table>';
	
	return _html;
}
				
function performConfirmationDialogClick(cObj) {
	var divName = '';
	var ar = [];
	var i = -1;
	var arCopy = [];
	var j = -1;
	var dObj = -1;
	var f = -1;
	var t = '';
	
	if (cObj != null) {
		ar = cObj.id.split('_');
		j = 0;
		for (i = 1; i < ar.length - 1; i++) {
			arCopy[j] = ar[i];
			j++;
		}
		divName = 'div_' + arCopy.join('_');
		setObjectDisplayStyleById(divName, false);
		enableStackedWidgets();
		if (ar[ar.length - 1].toUpperCase() != const_cancel_symbol.toUpperCase()) {
			f = _cache_confirmation_dialog_actions['btn_confirmation_dialog_confirm'];
			t = typeof f;
			if (t.toUpperCase() == const_function_symbol.toUpperCase()) {
				_cache_confirmation_dialog_actions['btn_confirmation_dialog_confirm'] = null;
				f();
			}
		}
	}
}

function popupConfirmationDialog(callbackFunc) {
	var cObj = -1;
	var t = typeof callbackFunc;
	if (t.toUpperCase() == const_function_symbol.toUpperCase()) {
		_cache_confirmation_dialog_actions['btn_confirmation_dialog_confirm'] = callbackFunc;
		cObj = $('div_confirmation_dialog');
		if (cObj != null) {
			setObjectDisplayStyleForObj(cObj, true);
			innerHTMLForObjByID('span_confirmation_dialog_title', 'Confirm Delete All');
			innerHTMLForObjByID('span_confirmation_dialog_prompt', 'Are you sure you want to confirm this action ?');
		//	cObj.style.top = '100px';
		//	cObj.style.left = '100px';
		//	cObj.style.width = '400px';
		//	cObj.style.height = '200px';
		}
	}
}
