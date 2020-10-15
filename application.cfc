<cfcomponent>

	<cfinclude template="includes/cfinclude_explainError.cfm">
	<cfinclude template="includes/cfinclude_cflog.cfm">
	<cfinclude template="includes/cfinclude_cfdump.cfm">

	<cfscript>
		path = GetDirectoryFromPath(GetBaseTemplatePath());
		sitePrefix = ListGetAt(path, ListLen(path, "\"), "\");
		iniPath = path & sitePrefix & ".ini";
		SetProfileString(iniPath, CGI.SERVER_NAME, 'AppName', 'Geonosis_v1');
		SetProfileString(iniPath, CGI.SERVER_NAME, 'DSN', 'CMS');
		SetProfileString(iniPath, CGI.SERVER_NAME, 'LOCALE', 'EN');
		SetProfileString(iniPath, CGI.SERVER_NAME, 'CLIENTSTORAGE', 'clientvars');

		sAppName = sitePrefix & '_' & GetProfileString(iniPath, CGI.SERVER_NAME, 'AppName');
		sDSN = GetProfileString(iniPath, CGI.SERVER_NAME, 'DSN');
		sLOCALE = GetProfileString(iniPath, CGI.SERVER_NAME, 'LOCALE');
		sCLIENTSTORAGE = GetProfileString(iniPath, CGI.SERVER_NAME, 'CLIENTSTORAGE');
	</cfscript>
	
	<cfscript>
		if (NOT IsDefined("This.name")) {
			aa = ListToArray(CGI.SCRIPT_NAME, '/');
			subName = aa[1];
			if (Len(subName) gt 0) {
				subName = '_' & subName;
			}

			myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
			myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
			This.name = UCASE(myAppName);
		}
		This.clientManagement = "Yes";
		This.sessionManagement = "Yes";
		This.sessionTimeout = "#CreateTimeSpan(0,1,0,0)#";
		This.applicationTimeout = "#CreateTimeSpan(1,0,0,0)#";
		This.clientStorage = "clientvars";
		This.loginStorage = "session";
		This.setClientCookies = "Yes";
		This.setDomainCookies = "No";
		This.scriptProtect = "All";
		
		this.const_SQL_DSNs = sDSN;
		this.count_SQL_DSNs = 1;

		this.sLOCALE = sLOCALE;
		this.path = path;
	</cfscript>
	
	<cffunction name="onError">
	   <cfargument name="Exception" required=true/>
	   <cfargument type="String" name="EventName" required=true/>

	   <cfscript>
			var errorExplanation = '';
			var _db = '';
			var ar = -1;
			var i = -1;
			var n = -1;
			var t = -1;

			err_ajaxCode = false;
			err_ajaxCodeMsg = '';
			try {
				Request.commonCode = CreateObject("component", "cfc.cfajaxCode");
			} catch(Any e) {
				Request.commonCode = -1;
				err_ajaxCode = true;
				err_ajaxCodeMsg = '(1) The ajaxCode component has NOT been created.';
				writeOutput('<font color="red"><b>#err_ajaxCodeMsg#</b></font><br>');
				writeOutput(explainErrorWithStack(e, false));
			}
			if (err_ajaxCode) {
				if (IsStruct(Request.commonCode)) Request.commonCode.cf_log(Application.applicationname, 'Error', '[#err_ajaxCodeMsg#]');
			}

			if (IsStruct(Request.commonCode)) errorExplanation = Request.commonCode.explainErrorWithStack(Exception, false);
			
			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				if (IsStruct(Request.commonCode)) Request.commonCode.cf_log(Application.applicationname, 'Error', '[#EventName#] [#errorExplanation#]');
			}

			if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
				if (1) {
					_db = "An unexpected error occurred. (+++)" & Chr(13);
					_db = _db & "Error Event: #EventName#" & Chr(13);
					_db = _db & "Error details:" & Chr(13);

					if (FindNoCase("laptop.halsmalltalker.com", CGI.SERVER_NAME) gt 0) {
						if (IsStruct(Request.commonCode)) _db = _db & Request.commonCode.explainErrorWithStack(Exception, false) & Chr(13);
					} else {
						if (IsStruct(Request.commonCode)) _db = _db & Request.commonCode.explainErrorWithStack(Exception, false) & Chr(13);
					}
					writeOutput('<script language="JavaScript1.2" type="text/javascript">');
					ar = ListToArray(_db, Chr(13));
					n = ArrayLen(ar);
					for (i = 1; i lte n; i = i + 1) {
						t = Replace(Replace(ar[i], '"', "'", 'all'), Chr(10), '', 'all');
						writeOutput('if (!!_alert) _alert("#t#"); else alert("Error - Missing function named (_alert)."); ');
					}
					writeOutput('</script>');
				} else {
					writeOutput('<h2>An unexpected error occurred. (+++)</h2>');
					writeOutput('<p>Error Event: #EventName#</p>');
					writeOutput('<p>Error details:<br>');
					if (FindNoCase("laptop.halsmalltalker.com", CGI.SERVER_NAME) gt 0) {
					//	if (IsStruct(Request.commonCode)) Request.commonCode.cf_dump(Exception, EventName, false);
						if (IsStruct(Request.commonCode)) writeOutput(Request.commonCode.explainErrorWithStack(Exception, false));
					} else {
						if (IsStruct(Request.commonCode)) writeOutput(Request.commonCode.explainErrorWithStack(Exception, false));
					}
				}
			}
	   </cfscript>
	</cffunction>

	<cffunction name="onSessionStart">
	   <cfscript>
	      Session.started = now();
	      Session.shoppingCart = StructNew();
	      Session.shoppingCart.items =0;
	   </cfscript>
	      <cflock scope="Application" timeout="5" type="Exclusive">
	         <cfset Application.sessions = Application.sessions + 1>
	   </cflock>
		<cflog file="#Application.applicationName#" type="Information" text="Session #Session.sessionid# started. Active sessions: #Application.sessions#">
	</cffunction>

	<cffunction name="onSessionEnd">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>
	
		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cflock name="AppLock" timeout="5" type="Exclusive">
			<cfif (NOT IsDefined("Arguments.AppScope.sessions"))>
				<cfset ApplicationScope.sessions = 0>
			</cfif>
			<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>
		</cflock>

		<cflog file="#Arguments.AppScope.applicationName#" type="Information" text="Session #Arguments.SessionScope.sessionid# ended. Length: #sessionLength# Active sessions: #Arguments.AppScope.sessions#">
	</cffunction>

	<cffunction name="onApplicationStart" access="public">
		<cfif 0>
			<cftry>
				<!--- Test whether the DB is accessible by selecting some data. --->
				<cfquery name="testDB" dataSource="#Request.INTRANET_DS#">
					SELECT TOP 1 * FROM AvnUsers
				</cfquery>
				<!--- If we get a database error, report an error to the user, log the
				      error information, and do not start the application. --->
				<cfcatch type="database">
					<cfoutput>
						This application encountered an error<br>
						Unable to use the ColdFusion Data Source named "#Request.INTRANET_DS#"<br>
						Please contact support.
					</cfoutput>
					<cflog file="#This.Name#" type="error" text="#Request.INTRANET_DS# DSN is not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
					<cfreturn False>
				</cfcatch>
			</cftry>
		</cfif>

		<cflog file="#This.Name#" type="Information" text="Application Started">
		<!--- You do not have to lock code in the onApplicationStart method that sets
		      Application scope variables. --->
		<cfscript>
			Application.sessions = 0;
			Application.DSN = ListFirst(this.const_SQL_DSNs, ',');
		</cfscript>
		<cfreturn True>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public">
		<cfargument name="ApplicationScope" required=true/>
		<cflog file="#This.Name#" type="Information" text="Application #Arguments.ApplicationScope.applicationname# Ended" >
	</cffunction>

	<cffunction name="onRequestStart" access="public">
		<cfargument name = "_targetPage" required=true/>

		<cfset var bool = "True">
		<cfset var _item = "">
		<cfset var bool_fail_security_check = "False">
		<cfset var bool_bypass_security_check = "False">
		<!--- BEGIN: These are pages that are intended to be used without a referrer of any kind and therefore cannot be subject to this check... --->
		<cfset var lst_external_interfaces = "functions.cfm,debugAjaxObject.cfm,changePassword.cfm,terminateAccount.cfm">
		<!--- END! These are pages that are intended to be used without a referrer of any kind and therefore cannot be subject to this check... --->
		<cfset var _db = "">
		<cfset var aStruct = StructNew()>
		
		<cfset Request.allow_Logging = "False">

		<cfset 	Request.const_index_cfm_symbol = "index.cfm">

		<cflock timeout="60" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
			<cfscript>
				Request.DSN = Application.DSN;
				
				if (Len(Request.DSN) eq 0) {
					Application.DSN = GetProfileString(iniPath, CGI.SERVER_NAME, 'DSN');
					
					Request.DSN = Application.DSN;
				}
			</cfscript>
		</cflock>
<!--- +++ --->
		<cfset bool_fail_security_check = "False">

		<cfscript>
			if (NOT IsDefined("Request.commonCode")) {
				err_commonCode = false;
				err_commonCodeMsg = '';
				try {
				   Request.commonCode = CreateObject("component", "cfc.GeonosisCode");
				} catch(Any e) {
					err_commonCode = true;
					err_commonCodeMsg = '(2) The commonCode component has NOT been created.';
					writeOutput('<font color="red"><b>#err_commonCodeMsg#</b></font><br>');
				}
				
				if (NOT err_commonCode) {
					Request.const_formattedDate_pattern = "mm/dd/yyyy";
					Request.const_formattedTime_pattern = "hh:mm tt";

					Request.const_UserBeginDate_symbol = "UserBeginDate";
					Request.const_UserEndDate_symbol = "UserEndDate";

					Request.const_UserPassword_symbol = "UserPassword";
					Request.const_UserProperName_symbol = "UserProperName";
					Request.const_UserPasswordDate_symbol = "UserPasswordDate";
					Request.const_UserPasswordPrompt_symbol = "UserPasswordPrompt";
					
					Request.const_AccountActivation_symbol = "Account-Activation";

					Request.const_productName_symbol = "Geonosis";
					Request.const_trademark_symbol = Request.const_productName_symbol & "&trade;";
					
					Request.const_linked_objects_symbol = " <-> ";

					Request.const_SHA1PRNG = 'SHA1PRNG';
					Request.const_CFMX_COMPAT = 'CFMX_COMPAT';

					Request.const_encryption_method = 'BLOWFISH';
					Request.const_encryption_encoding = 'Hex';

					Request.const_user_admin_role = "AdminRole";

					Request.const_AddRole_symbol = "+/- Role(s)";
		
					Request.const_GeonosisUSERS_symbol = "GeonosisUSERS";
					Request.const_GeonosisROLES_symbol = "GeonosisROLES";

					Request.const_maxint_value = (2^31)-1; // this is a hard-value that never changes and should never change...
					
					Request.const_CR = Chr(13);

					Request.const_replace_pattern = "%+++%";

					Request.commonCode.initResources(this.sLOCALE, this.path & Application.applicationname & "-Resources.ini");
					
					Request.const_formattedDate_pattern = Request.commonCode.getResourceByNameWithDefault('const_formattedDate_pattern', "mm/dd/yyyy");
					Request.const_formattedTime_pattern = Request.commonCode.getResourceByNameWithDefault('const_formattedTime_pattern', "hh:mm tt");

					Request.const_local_ip_address = Request.commonCode.getResourceByNameWithDefault('const_local_ip_address', '192.168.');

					Request.const_local_server_name = Request.commonCode.getResourceByNameWithDefault('const_local_server_name', 'laptop.halsmalltalker.com');
					
					if (0) {
						xxx = Request.commonCode.num2hex(Request.const_maxint_value);
						xV = Mid(xxx, 1, 1);
						xL = (Asc(xV) - 32) - Asc('0');
						xH = Mid(xxx, 2, xL);
						Request.commonCode.cf_log(Application.applicationname, 'Information', 'DEBUG: [#xxx#], [#xV#], [#Asc(xV)#], [#(Asc(xV) - 32)#], [#Asc('0')#], [#xL#], [#xH#], [#Request.commonCode.hex2num(xH)#]');
					}

					aStruct = Request.commonCode.decodeEncodedEncryptedString2('R@ETADGARAHZ1Gu7zzEBNJs0vxao13e5g==RC@912761E613FD02FA9D65FCD533A5C86B994D1F338A4CC97A');
					if ( (aStruct.isChkSumValid) AND (Len(aStruct.data.plaintext) gt 0) ) {
						Request.const_superUser_account = aStruct.data.plaintext;
					}

					aStruct = Request.commonCode.decodeEncodedEncryptedString2('R@ETA@ECRAHO055EQ5ldEwxx0HAyA3rxw==RB@A2D1383F49331B2E084494A52179D808');
					if ( (aStruct.isChkSumValid) AND (Len(aStruct.data.plaintext) gt 0) ) {
						Request.const_superUser_password = aStruct.data.plaintext;
					}
		
					Request.const_num_rows_user_mgr = Request.commonCode.getResourceByNameWithDefault('const_num_rows_user_mgr', 12);

					Request.const_Choose_symbol = Request.commonCode.getResourceByNameWithDefault('const_Choose_symbol', "Choose...");

					Request.bool_show_verbose_SQL_errors = Request.commonCode.getResourceByNameWithDefault('bool_show_verbose_SQL_errors', true);

					Request.const_password_invalid_warning = Request.commonCode.getResourceByNameWithDefault('const_password_invalid_warning', 'WARNING: Password is not valid because it does not contain the following characters ("a"-"z" or "A"-"Z" and "0"-"9" and at least one special character). PLS enter a valid password.');
					
					Request.const_activate_account_message = Request.commonCode.getResourceByNameWithDefault('const_activate_account_message', 'INFO: Check your email inbox for an important message from our server support team.  You will find a link you need to click in order to activate your user account or to change your password.');
				}
			}

			Request.bool_isDevUser = Request.commonCode.isDevUser();
			Request.bool_isDevServer = Request.commonCode.isDevServer();
		</cfscript>

		<cfset Request.isUserAdminRole = IsUserInRole(Request.const_user_admin_role)>

		<cfif (NOT IsDefined("Request.cfinclude_application_loaded")) OR (NOT Request.cfinclude_application_loaded)>
			<cfinclude template="cfinclude_application.cfm">
		</cfif>
		
		<cfif (IsDefined("CGI.HTTP_REFERER")) AND (IsDefined("CGI.SCRIPT_NAME"))>
			<cfset bool_bypass_security_check = "False">
			<cfloop index="_item" list="#lst_external_interfaces#" delimiters=",">
				<cfset _item = Trim(_item)>
				<cfif (FindNoCase(_item, CGI.SCRIPT_NAME) gt 0)>
					<cfset bool_bypass_security_check = "True">
					<cfset _db = _db & "bool_bypass_security_check = [#bool_bypass_security_check#], ">
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif (NOT bool_bypass_security_check)>
				<cfif (FindNoCase(Request.const_index_cfm_symbol, CGI.SCRIPT_NAME) eq 0) AND (FindNoCase(Request.const_index_cfm_symbol, CGI.HTTP_REFERER) eq 0) AND (FindNoCase(CGI.SCRIPT_NAME, CGI.HTTP_REFERER) eq 0)>
					<cfset bool_fail_security_check = "True">
				</cfif>
			</cfif>

			<cfif (bool_fail_security_check)>
				<cfset newURL = "#Request.commonCode.fullyQualifiedURLPrefix()#/#Request.const_index_cfm_symbol#?nocache=#CreateUUID()#">
				<cflog file="#This.Name#" type="Information" text="(_onRequestStart.redirect) [newURL=#newURL#]">
				<cflocation url="#newURL#">
			</cfif>
		</cfif>

		<cfif Request.allow_Logging>
			<cflog file="#This.Name#" type="Information" text="(_onRequestStart.1) [bool_bypass_security_check=#bool_bypass_security_check#], [bool_fail_security_check=#bool_fail_security_check#] [_targetPage=#_targetPage#], [CGI.HTTP_REFERER=#CGI.HTTP_REFERER#], [CGI.SCRIPT_NAME=#CGI.SCRIPT_NAME#], |#_db#|">
		</cfif>

		<cfinclude template="cfinclude_meta_vars.cfm">
		
		<cfreturn bool>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>
	</cffunction>
</cfcomponent>
