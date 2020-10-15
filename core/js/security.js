function analyzePassword(s) {
	var i = -1;
	var ch = -1;
	var alphaCount = 0;
	var numericCount = 0;
	var specialCount = 0;
	var o = new Object();
	
	for (i = 0; i < s.length; i++) {
		ch = s.charCodeAt(i);
		alphaCount += (((ch >= 65) && (ch <= 90)) ? 1 : 0);
		alphaCount += (((ch >= 97) && (ch <= 122)) ? 1 : 0);
		numericCount += (((ch >= 48) && (ch <= 57)) ? 1 : 0);
		specialCount += (((ch >= 33) && (ch <= 47)) ? 1 : 0);
		specialCount += (((ch >= 58) && (ch <= 64)) ? 1 : 0);
		specialCount += (((ch >= 123) && (ch <= 126)) ? 1 : 0);
	}
	o.sInput = s;
	o.alphaCount = alphaCount;
	o.numericCount = numericCount;
	o.specialCount = specialCount;
	return o;
}

function _isWeakPassword(ap) {
	return ( ( (ap.alphaCount == 0) || (ap.numericCount == 0) || (ap.specialCount == 0) ) && (ap.sInput.trim().length < 8) );
}

function isWeakPassword(s) {
	var ap = analyzePassword(s);
	
	return _isWeakPassword(ap);
}

function _isMediumPassword(ap) {
	return ( ( ( (ap.alphaCount > 0) && (ap.numericCount > 0) ) || ( (ap.alphaCount > 0) && (ap.specialCount > 0) ) && (ap.sInput.trim().length > 4) ) || ( (ap.sInput.trim().length >= 8) && (ap.sInput.trim().length < 12) ) );
}

function isMediumPassword(s) {
	var ap = analyzePassword(s);
	
	return (_isWeakPassword(ap) && _isMediumPassword(ap));
}

function _isStrongPassword(ap) {
	return ( ( (ap.alphaCount > 0) || (ap.numericCount > 0) || (ap.specialCount > 0) ) && (ap.sInput.trim().length >= 12) );
}

function isStrongPassword(s) {
	var ap = analyzePassword(s);
	
	return (_isMediumPassword(ap) && _isStrongPassword(ap));
}

function isPasswordValid(s) {
	return (s.trim().length > 0);
}
				
function ratePassword(s, _div_password_rating, _td_password_rating, _span_password_rating) {
	var bool_isPasswordValid = isPasswordValid(s);
	var ap = -1;
	var cObj1 = $('user_user_change_password_newPassword');
	var cObj2 = $('user_user_change_password_confirmPassword');

	var cObj = $(_span_password_rating);
	var tdObj = $(_td_password_rating);

	if (bool_isPasswordValid) {
		// rate the password...
		ap = analyzePassword(s);
		// display the rating...
		if ( (cObj != null) && (tdObj != null) ) {
			if (_isStrongPassword(ap)) {
				tdObj.style.background = 'lime';
				cObj.innerHTML = '(Strong)';
				disableWidgetByID(_div_password_rating, false);
			} else if (_isMediumPassword(ap)) {
				tdObj.style.background = 'cyan';
				cObj.innerHTML = '(Medium)';
				disableWidgetByID(_div_password_rating, false);
			} else if (_isWeakPassword(ap)) {
				tdObj.style.background = 'yellow';
				cObj.innerHTML = '(Weak)';
				disableWidgetByID(_div_password_rating, false);
			} else {
				tdObj.style.background = '';
				cObj.innerHTML = '(Not Rated)';
				disableWidgetByID(_div_password_rating, true);
			}
		}
	} else {
		if ( (cObj != null) && (tdObj != null) ) {
			tdObj.style.background = '';
			cObj.innerHTML = '(Not Rated)';
			disableWidgetByID(_div_password_rating, true);
		}
	}
	return true;
}

