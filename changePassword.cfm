<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="emailAddress" type="string" default="">

<cfscript>
	bool_isError = false;
	_emailAddress = '';
	if (Len(emailAddress) gt 0) {
		_emailAddress = URLDecode(emailAddress);
		data = Request.commonCode.decodeEncodedEncryptedString(_emailAddress);
		if (IsDefined("data.plaintext")) {
			emailAddress = data.plaintext;
		} else {
			bool_isError = true;
		}
	} else {
		bool_isError = true;
	}
	if (bool_isError) {
		newURL = Request.commonCode.fullyQualifiedURLPrefix() & "/" & Request.const_index_cfm_symbol & "?nocache=" & CreateUUID();
		Request.commonCode.cf_location(newURL);
	}
</cfscript>

<cfif 0>
	<cfdump var="#data#" label="data - [#_emailAddress#]" expand="No">
</cfif>

<cfoutput>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
		<title>#Request.const_trademark_symbol# - Change Password for (#emailAddress#)</title>
		#Request.meta_vars#

		<script language="JavaScript1.2" src="js/MathAndStringExtend.js" type="text/javascript"></script>

		<script language="JavaScript1.2" type="text/javascript" src="core/engine.js"></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/util.js'></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/settings.js'></script>

		<script language="JavaScript1.2" type='text/javascript' src='core/js/security.js'></script>
		<script language="JavaScript1.2" type='text/javascript' src='core/js/utility.js'></script>

		<script language="JavaScript1.2" type="text/javascript">
		<!--
			/**************************************************************************/

			_cfscriptLocation = "#Request.commonCode.fullyQualifiedURLPrefix()#/functions.cfm";

			/**************************************************************************/

			function validatePassword(s, sOther) {
				var bool_isPasswordValid = isPasswordValid(s);
				var bool_isOtherPasswordPresent = (sOther != null);
				var bool_isOtherPasswordValid = (((bool_isOtherPasswordPresent) && (s == sOther)) ? true : false);
				var ap = -1;
				var cObj1 = $('user_user_change_password_newPassword');
				var cObj2 = $('user_user_change_password_confirmPassword');
				var bool_shallSubmitBtnBeDisabled = true;
				var bool_passwordsMatches = false;

				var cObj = $((bool_isOtherPasswordPresent) ? 'span_password_matches' : 'span_password_rating');
				var tdObj = $((bool_isOtherPasswordPresent) ? 'td_password_matches' : 'td_password_rating');
				if (bool_isPasswordValid) {
					// rate the password...
					ap = analyzePassword(s);
					// display the rating...
					if ( (cObj != null) && (tdObj != null) ) {
						if (bool_isOtherPasswordPresent) {
							if (s == sOther) {
								tdObj.style.background = 'lime';
								cObj.innerHTML = '(Matches)';
								disableWidgetByID('div_password_matches', false);
								bool_passwordsMatches = true;
							} else {
								tdObj.style.background = '';
								cObj.innerHTML = '(Does Not Match)';
								disableWidgetByID('div_password_matches', true);
								bool_passwordsMatches = false;
							}
						} else {
							if (_isStrongPassword(ap)) {
								tdObj.style.background = 'lime';
								cObj.innerHTML = '(Strong)';
								disableWidgetByID('div_password_rating', false);
							} else if (_isMediumPassword(ap)) {
								tdObj.style.background = 'cyan';
								cObj.innerHTML = '(Medium)';
								disableWidgetByID('div_password_rating', false);
							} else if (_isWeakPassword(ap)) {
								tdObj.style.background = 'yellow';
								cObj.innerHTML = '(Weak)';
								disableWidgetByID('div_password_rating', false);
							} else {
								tdObj.style.background = '';
								cObj.innerHTML = '(Not Rated)';
								disableWidgetByID('div_password_rating', true);
							}
						}
					}
				} else {
					if ( (cObj != null) && (tdObj != null) ) {
						if (bool_isOtherPasswordPresent) {
							tdObj.style.background = '';
							cObj.innerHTML = '(Does Not Match)';
							disableWidgetByID('div_password_matches', true);
							bool_passwordsMatches = false;
						} else {
							tdObj.style.background = '';
							cObj.innerHTML = '(Not Rated)';
							disableWidgetByID('div_password_rating', true);
						}
					}
				}

				bool_shallSubmitBtnBeDisabled = true;
				if ( (cObj1 != null) && (cObj2 != null) ) {
					bool_shallSubmitBtnBeDisabled = ( (cObj1.value.trim().length > 0) && (cObj2.value.trim().length > 0) );
				}

				if ( (bool_shallSubmitBtnBeDisabled == false) || (bool_passwordsMatches == false) ) {
					var mObj = $('span_user_change_password_status_message');
					if (mObj != null) {
					//	flushGUIObjectChildrenForObj(mObj);
						if (bool_isOtherPasswordValid == false) {
						//	mObj.innerHTML = 'WARNING: Password is not valid because it does not match or it is the first password entered.';
						} else {
						//	mObj.innerHTML = 'WARNING: Password is not valid because it does not contain the following characters ("a"-"z" or "A"-"Z" and "0"-"9" and any special characters). PLS enter a valid password.';
						}
					}

					disableWidgetByID('user_user_change_password_btn_getPassword', true);
					return true;
				} else {
					var mObj = $('span_user_change_password_status_message');
					if (mObj != null) {
						flushGUIObjectChildrenForObj(mObj);
						mObj.innerHTML = '';
					}
					
					disableWidgetByID('user_user_change_password_btn_getPassword', false);
					return false;
				}
				return true;
			}

			function performSetNewPassword() {
				var objUserName = $('user_user_change_password_UserName'); 
				var objNewPassword = $('user_user_change_password_newPassword'); 
				var objConfirmPassword = $('user_user_change_password_confirmPassword'); 
				if ( (objUserName != null) && (objNewPassword != null) && (objConfirmPassword != null) ) { 
					if (objNewPassword.value == objConfirmPassword.value) {
						disableAllChildrenForObjById('div_user_change_password', true);
						DWREngine._execute(_cfscriptLocation, null, 'PerformSetNewPassword', objUserName.value, objNewPassword.value, objConfirmPassword.value, handlePerformSetNewPasswordResults);
					} else {
						alert('Data Validation Error :: Both passwords must match however they do not at this time.  PLS try again.');
					}
				}
			}

			function _handlePerformSetNewPasswordResults(anObject) {
			//	debugAjaxObject(anObject, true);
				disableAllChildrenForObjById('div_user_change_password', false);
				var mObj = $('span_user_change_password_status_message');
				if (mObj != null) {
					flushGUIObjectChildrenForObj(mObj);
					var bool = ((anObject[0].ISPASSWORDACCEPTED.trim().toUpperCase() == 'FALSE') ? false : true);
					if (bool) {
						mObj.innerHTML = 'INFO: Your password change has been accepted.  You may login using your new password anytime.';
					} else {
						mObj.innerHTML = 'WARNING: Your password change has NOT been accepted.  PLS try again later-on.';
					}
				}
			}

			function handlePerformSetNewPasswordResults(anObject) {
				return handlePossibleSQLError(anObject, _handlePerformSetNewPasswordResults);
			}
		//-->
		</script>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function onLoadEventHandler() {
				DWRUtil.useLoadingMessage();
				DWREngine._errorHandler =  errorHandler;

				var mObj = $('user_user_change_password_newPassword');
				if (mObj != null) {
					mObj.focus();
				}
				
				disableWidgetByID('div_password_rating', true);
				disableWidgetByID('div_password_matches', true);
			}
		//-->
		</script>
	</head>
	
	<body onLoad="onLoadEventHandler()">

		<div id="div_user_change_password" style="display: inline;">
			<table width="400" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
				<tr>
					<td>
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td bgcolor="silver" align="center">
									<span class="boldPromptTextClass"><NOBR>(#Request.const_trademark_symbol#) Change Password</NOBR></span>
								</td>
								<td bgcolor="silver" align="center" style="display: none;">
									<input type="button" name="user_user_change_password_close" id="user_user_change_password_close" value="[X]" class="buttonMenuClass" onclick="return false;">
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
															<span class="boldPromptTextClass"><NOBR>UserName:</NOBR></span>
														</td>
														<td colspan="2">
															<input readonly disabled type="text" name="user_user_change_password_UserName" id="user_user_change_password_UserName" class="textClass" size="40" maxlength="255" value="#emailAddress#">
														</td>
													</tr>
													<tr>
														<td>
															<span class="boldPromptTextClass"><NOBR>New Password:</NOBR></span>&nbsp;<span title="The data entry field is Required." class="errorStatusBoldClass">(*)</span>
														</td>
														<td>
															<input type="password" name="user_user_change_password_newPassword" id="user_user_change_password_newPassword" size="30" maxlength="50" class="textClass" onkeyup="return validatePassword(this.value);">
														</td>
														<td id="td_password_rating" width="100px" align="center" style="border: thin solid silver;">
															<div id="div_password_rating"><span id="span_password_rating" class="normalStatusBoldClass">(Not Rated)</span></div>
														</td>
													</tr>

													<tr>
														<td>
															<span class="boldPromptTextClass"><NOBR>Confirm Password:</NOBR></span>&nbsp;<span title="The data entry field is Required." class="errorStatusBoldClass">(*)</span>
														</td>
														<td>
															<input type="password" name="user_user_change_password_confirmPassword" id="user_user_change_password_confirmPassword" size="30" maxlength="50" class="textClass" onkeyup="var obj = $('user_user_change_password_newPassword'); otherValue = ''; if (obj != null) { otherValue = obj.value; }; return validatePassword(this.value, otherValue);">
														</td>
														<td id="td_password_matches" width="100px" align="center" style="border: thin solid silver;">
															<div id="div_password_matches"><span id="span_password_matches" class="normalStatusBoldClass">(Does Not Match)</span></div>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<br>
															<span id="span_user_change_password_status_message" class="onholdStatusBoldClass"></span>
														</td>
													</tr>
													<tr>
														<td align="center" colspan="2">
															<input disabled type="button" name="user_user_change_password_btn_getPassword" id="user_user_change_password_btn_getPassword" value="[Submit]" class="buttonClass" onclick="performSetNewPassword(); return false;">
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
	</body>
	</html>
</cfoutput>
