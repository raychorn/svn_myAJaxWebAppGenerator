<cfcomponent>

	<cffunction name="cf_log" access="public">
		<cfargument name="_someText_" type="string" required="yes">
		
		<cflog file="#Application.applicationName#" type="Information" text="#_someText_#">
	</cffunction>

	<cfscript>
		path = GetDirectoryFromPath(GetBaseTemplatePath());
		sitePrefix = ListGetAt(path, ListLen(path, "\"), "\");
		iniPath = path & sitePrefix & ".ini";
		if (NOT FileExists(iniPath)) {
			SetProfileString(iniPath, CGI.SERVER_NAME, 'AppName', 'Geonosis_v1');
			SetProfileString(iniPath, CGI.SERVER_NAME, 'DNS', 'CMS');
			SetProfileString(iniPath, CGI.SERVER_NAME, 'LOCALE', 'EN');
			SetProfileString(iniPath, CGI.SERVER_NAME, 'CLIENTSTORAGE', 'clientvars');
		}

		sAppName = sitePrefix & '_' & GetProfileString(iniPath, CGI.SERVER_NAME, 'AppName');
		sDNS = GetProfileString(iniPath, CGI.SERVER_NAME, 'DNS');
		sLOCALE = GetProfileString(iniPath, CGI.SERVER_NAME, 'LOCALE');
		sCLIENTSTORAGE = GetProfileString(iniPath, CGI.SERVER_NAME, 'CLIENTSTORAGE');
	</cfscript>
	
	<cfscript>
		This.name = sAppName;
		This.clientmanagement = "Yes";
		This.Sessionmanagement = "Yes";
		This.sessiontimeout = "#CreateTimeSpan(0,8,0,0)#";
		This.applicationtimeout = "#CreateTimeSpan(1,0,0,0)#";
		This.clientstorage = 'clientvars';
		This.loginstorage = "session";
		This.setclientcookies = "Yes";
		This.setdomaincookies = "No";
		This.scriptprotect = "All";
		
		this.const_SQL_DSNs = sDNS;
		this.count_SQL_DSNs = 1;

		this.sLOCALE = sLOCALE;
		this.path = path;

		function onError(Exception, EventName) {
			var commonCode = -1;
			var err_commonCode = false;
			var err_commonCodeMsg = '';
			var errorExplanation = '';
			
			if (IsDefined("commonCode")) {
				err_commonCode = false;
				err_commonCodeMsg = '';
				try {
				   commonCode = CreateObject("component", "cfc.GeonosisCode");
				} catch(Any e) {
					err_commonCode = true;
					err_commonCodeMsg = '(1) The commonCode component has NOT been created.';
					writeOutput('<font color="red"><b>#err_commonCodeMsg#</b></font><br>');
				}
				if (err_commonCode) {
					commonCode.cf_log(Application.applicationname, 'Error', '[#err_commonCodeMsg#]');
				} else {
					errorExplanation = commonCode.explainErrorWithStack(Exception, false);
				}
			}
		//	writeOutput(commonCode.cf_dump(Exception, 'Exception - [#EventName#]', false));
		//	html_errorExplanation = commonCode.explainError(Exception, false);
			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				commonCode.cf_log(Application.applicationname, 'Error', '[#EventName#] [#errorExplanation#]');
			}

			if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
				writeOutput('<h2>An unexpected error occurred.</h2>');
				writeOutput('<p>Error Event: #EventName#</p>');
				writeOutput('<p>Error details:<br>');
				if (FindNoCase("DEEPSPACENINE", CGI.SERVER_NAME) gt 0) {
					commonCode.cf_dump(Exception, EventName, false);
				} else {
					writeOutput(explainErrorWithStack(Exception, true));
				}
			}
		}

		function onSessionStart() {
			try {
				Session.started = now();
				if (NOT IsDefined("Application.sessions")) {
					Application.sessions = 0;
				}
				Application.sessions = Application.sessions + 1;
			} catch (Any e) {
			}
		}

		function onSessionEnd(SessionScope,ApplicationScope) {
			try {
				SessionScope.ended = now();
				SessionScope.sessionLength = -1;
				if (IsDefined("SessionScope.started")) {
					SessionScope.sessionLength = TimeFormat(SessionScope.ended - SessionScope.started, "H:mm:ss");
				}
				if (NOT IsDefined("Application.sessions")) {
					Application.sessions = 0;
				}
				Application.sessions = Application.sessions - 1;
				cf_log('Session #SessionScope.sessionid# ended. Length: #SessionScope.sessionLength# Active sessions: #Application.sessions#');
			} catch (Any e) {
			}
		}

	</cfscript>

	<cffunction name="onApplicationStart" access="public">
		<cftry>
			<!--- Test whether the DB is accessible by selecting some data. --->
			<cfquery name="testDB" dataSource="#GetToken(this.const_SQL_DSNs, this.count_SQL_DSNs, ",")#">
				SELECT TOP 1 * FROM objects
			</cfquery>
			<!--- If we get a database error, report an error to the user, log the
			      error information, and do not start the application. --->
			<cfcatch type="database">
				<cflog file="#This.Name#" type="error" text="(_onApplicationStart.1) #GetToken(this.const_SQL_DSNs, this.count_SQL_DSNs, ",")# DSN is not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
				<cfset this.count_SQL_DSNs = this.count_SQL_DSNs + 1>
				<cfif (this.count_SQL_DSNs gt ListLen(this.const_SQL_DSNs, ","))>
					<cfset this.count_SQL_DSNs = ListLen(this.const_SQL_DSNs, ",")>
				<cfelse>
					<cftry>
						<!--- Test whether the DB is accessible by selecting some data. --->
						<cfquery name="testDB" dataSource="#GetToken(this.const_SQL_DSNs, this.count_SQL_DSNs, ",")#">
							SELECT TOP 1 * FROM objects
						</cfquery>
						<!--- If we get a database error, report an error to the user, log the
						      error information, and do not start the application. --->
						<cfcatch type="database">
							<cfoutput>
								This application encountered an error<br>
								Unable to use the ColdFusion Data Source(s) named "#this.const_SQL_DSNs#"<br>
								Please contact support.
							</cfoutput>
							<cflog file="#This.Name#" type="error" text="(_onApplicationStart.2) #GetToken(this.const_SQL_DSNs, this.count_SQL_DSNs, ",")# DSN is not available. message: #cfcatch.message# Detail: #cfcatch.detail# Native Error: #cfcatch.NativeErrorCode#" >
							<cfreturn False>
						</cfcatch>
					</cftry>
				</cfif>
			</cfcatch>
		</cftry>

		<cflock timeout="60" throwontimeout="No" type="EXCLUSIVE" scope="APPLICATION">
			<cfscript>
				Application.DSN = GetToken(this.const_SQL_DSNs, this.count_SQL_DSNs, ",");
			</cfscript>
		</cflock>

		<cflog file="#This.Name#" type="Information" text="(_onApplicationStart.3) Application Started !">
		<!--- You do not have to lock code in the onApplicationStart method that sets
		      Application scope variables. --->
		<cfscript>
			Application.sessions = 0;
		</cfscript>
		<cfreturn True>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public">
		<cfargument name="ApplicationScope" required=true/>
		<cflog file="#This.Name#" type="Information" text="(_onApplicationEnd.1) Application #Arguments.ApplicationScope.applicationname# Ended" >
	</cffunction>

	<cffunction name="_onSessionEnd" access="private">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>

		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cflock name="AppLock" timeout="5" type="Exclusive">
			<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>
		</cflock>

		<cflog file="#This.Name#" type="Information" text="(_onSessionEnd.1) Session #Arguments.SessionScope.sessionid# ended. Length: #sessionLength# Active sessions: #Arguments.AppScope.sessions# [Client.bool_isUserLoggedIn=(#Client.bool_isUserLoggedIn#)],  [Client.userNameLoggedIn=(#Client.userNameLoggedIn#)]">

		<cfscript>
			Client.bool_isUserLoggedIn = false;
			Client.userNameLoggedIn = '';
		</cfscript>
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

					Request.const_local_server_name = Request.commonCode.getResourceByNameWithDefault('const_local_server_name', 'DeepSpaceNine');
					
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

		<cfif Request.allow_Logging>
			<cflog file="#This.Name#" type="Information" text="(_onRequestEnd.1) [_targetPage=#_targetPage#]">
		</cfif>

	</cffunction>
</cfcomponent>
