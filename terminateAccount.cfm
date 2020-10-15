<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfparam name="emailAddress" type="string" default="">

<cfscript>
	bool_isError = false;
	if (Len(emailAddress) gt 0) {
		data = Request.commonCode.decodeEncodedEncryptedString(URLDecode(emailAddress));
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

<cfoutput>
	<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<LINK rel="STYLESHEET" type="text/css" href="StyleSheet.css"> 
		<title>#Request.const_trademark_symbol# - Terminate Account for (#emailAddress#)</title>
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

			function performTerminateAccount() {
				var objUserName = $('user_user_terminate_account_UserName'); 
				if (objUserName != null) { 
					disableAllChildrenForObjById('div_user_terminate_account', true);
					DWREngine._execute(_cfscriptLocation, null, 'PerformTerminateAccount', objUserName.value, handlePerformTerminateAccountResults);
				}
			}

			function _handlePerformTerminateAccountResults(anObject) {
			//	debugAjaxObject(anObject, true);
				disableAllChildrenForObjById('div_user_terminate_account', false);
				var mObj = $('span_user_terminate_account_status_message');
				if (mObj != null) {
					flushGUIObjectChildrenForObj(mObj);
					var bool = ((anObject[0].ISACCOUNTTERMINATED.trim().toUpperCase() == 'FALSE') ? false : true);
					if (bool) {
						mObj.innerHTML = 'INFO: Your account has been terminated.  Have a nice day.';
					} else {
						mObj.innerHTML = 'WARNING: Your account has NOT been terminated.  PLS try again later-on.';
					}
				}
			}

			function handlePerformTerminateAccountResults(anObject) {
				return handlePossibleSQLError(anObject, _handlePerformTerminateAccountResults);
			}
		//-->
		</script>
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			function onLoadEventHandler() {
				DWRUtil.useLoadingMessage();
				DWREngine._errorHandler =  errorHandler;
			}
		//-->
		</script>
	</head>
	
	<body onLoad="onLoadEventHandler()">

		<div id="div_user_terminate_account" style="display: inline;">
			<table width="400" cellpadding="-1" cellspacing="-1" border="1" class="paperBgColorClass">
				<tr>
					<td>
						<table width="100%" cellpadding="-1" cellspacing="-1">
							<tr>
								<td bgcolor="silver" align="center">
									<span class="boldPromptTextClass"><NOBR>(#Request.const_trademark_symbol#) Terminate Account</NOBR></span>
								</td>
								<td bgcolor="silver" align="center" style="display: none;">
									<input type="button" name="user_user_terminate_account_close" id="user_user_terminate_account_close" value="[X]" class="buttonMenuClass" onclick="return false;">
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
														<td>
															<input readonly disabled type="text" name="user_user_terminate_account_UserName" id="user_user_terminate_account_UserName" class="textClass" size="40" maxlength="255" value="#emailAddress#">
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<br>
															<span id="span_user_terminate_account_status_message" class="onholdStatusBoldClass"></span>
														</td>
													</tr>
													<tr>
														<td align="center" colspan="2">
															<input disabled type="button" name="user_user_terminate_account_btn_terminate" id="user_user_terminate_account_btn_terminate" value="[Terminate]" class="buttonClass" onclick="performTerminateAccount(); return false;">
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
	
		<script language="JavaScript1.2" type="text/javascript">
		<!--
			var aDHTMLObj1 = DHTMLWindowsObj.getInstance();
			var aDHTMLObj2 = DHTMLWindowsObj.getInstance();
			var t = aDHTMLObj1.asHTML() + aDHTMLObj2.asHTML();
			document.write(t);
		// --> 
		</script>
	</body>
	</html>
</cfoutput>
