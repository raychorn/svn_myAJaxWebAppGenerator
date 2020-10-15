<cfcomponent name="commonCode" extends="primitiveCode">
	<cfscript>
		this.HEX = "0123456789ABCDEF";
		this.hexMask = BitSHLN(255, 24);  // FF000000
	</cfscript>

	<cfsavecontent variable="this.js_daysInMonthForYear">
		<cfoutput>
			<script language="JavaScript1.2" type="text/javascript">
			<!--
				function daysInMonthForYear(mm, yyyy) {
					var dates = new Object();
					
					<cfloop index="_iYear_" from="#Year(Now())#" to="#(Year(Now()) + 5)#">
						<cfloop index="_iMonth_" from="1" to="12">
							dates['#_iYear_#_#_iMonth_#'] = #DaysInMonth(CreateDate(_iYear_, _iMonth_, 1))#;
						</cfloop>
					</cfloop>
					
					return dates[yyyy + '_' + mm];
				}
			// --> 
			</script>
		</cfoutput>
	</cfsavecontent>

	<cfscript>
		function jsCode(s) {
			if (UCASE(s) eq UCASE('js_daysInMonthForYear')) {
				return this.js_daysInMonthForYear;
			}
			return '';
		}
		
		function _GetToken(str, index, delim) { // this is a faster GetToken() than GetToken()...
			var ar = -1;
			var retVal = '';
			ar = ListToArray(str, delim);
			try {
				retVal = ar[index];
			} catch (Any e) {
			}
			return retVal;
		}

		function isDevUser() {
			if (Find(Request.const_local_ip_address, CGI.REMOTE_ADDR) gt 0) {
				return true;
			} else {
				return false;
			}
		}

		function isDevServer() {
			if (FindNoCase(Request.const_local_server_name, CGI.SERVER_NAME) gt 0) {
				return true;
			} else {
				return false;
			}
		}

		function isBrowserIE() {
			if ( (FindNoCase('Opera', CGI.HTTP_USER_AGENT) gt 0) OR (FindNoCase('Gecko', CGI.HTTP_USER_AGENT) gt 0) OR (FindNoCase('Firefox', CGI.HTTP_USER_AGENT) gt 0) OR (FindNoCase('Netscape', CGI.HTTP_USER_AGENT) gt 0) OR ( (FindNoCase('MSIE 6', CGI.HTTP_USER_AGENT) eq 0) AND (FindNoCase('MSIE 7', CGI.HTTP_USER_AGENT) eq 0) ) ) {
				return false;
			} else {
				return true;
			}
		}

		function fullyQualifiedURLPrefix() {
			return 'http://' & CGI.SERVER_NAME & ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, '/'), '/');
		}

		function serverTimeZone(_currentTime) {
			return UCASE(Right(TimeFormat(_currentTime, "long"), 3));
		}

		function formattedDateTimeTZ(_currentTime) {
			var _thisDate = DateFormat(_currentTime, Request.const_formattedDate_pattern);
			var _timeZone = serverTimeZone(_currentTime);
			var _thisTime = LCASE(TimeFormat(_currentTime, Request.const_formattedTime_pattern));
			return _thisDate & " " & _thisTime & " " & _timeZone;
		}

		function num2Hex(n) {
			var i = -1;
			var hx = '';
			var mask = this.hexMask;
			var masked = 0;
			var shiftVal = 24;
			
			for (i = 1; i lte 4; i = i + 1) {
				masked = BitSHRN(BitAnd(n, mask), shiftVal);
				if (masked gt 0) {
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(BitSHRN(masked, 4), 15) + 1, 1)) + 16);
					hx = hx & Chr(Asc(Mid(this.HEX, BitAnd(masked, 15) + 1, 1)) + 16);
				}
				mask = BitSHRN(mask, 8);
				shiftVal = shiftVal - 8;
			}
			
			return Chr(Asc(Len(hx)) + 32) & hx;
		}
		
		function hex2num(h) {
			var i = -1;
			var n = -1;
			var x = -1;
			var ch = -1;
			var num = 0;
			
			n = Len(h);
			for (i = 1; i lte n; i = i + 1) {
				if (i gt 1) num = BitSHLN(num, 4);
				ch = Mid(h, i, 1);
				x = (Asc(ch) - 16) - Asc('0');
				if (x gt 9) {
					x = x - 7;
				}
				num = num + x;
			}
			return num;
		}
		
		function encodedEncryptedString(plainText) {
			var theKey = generateSecretKey(Request.const_encryption_method);
			var _encrypted = encrypt(plainText, theKey, Request.const_encryption_method, Request.const_encryption_encoding);
		//	cf_log(Application.applicationname, 'Information', 'DEBUG: [#num2Hex(Len(theKey))#], [#theKey#], [#num2Hex(Len(_encrypted))#], [#_encrypted#]');
			return num2Hex(Len(theKey)) & theKey & num2Hex(Len(_encrypted)) & _encrypted;
		}

		function computeChkSum(s) {
			var i = -1;
			var chkSum = 0;
			var n = Len(s);

			for (i = 1; i lte n; i = i + 1) {
				chkSum = chkSum + Asc(Mid(s, i, 1));
			}
			return chkSum;
		}
		
		function encodedEncryptedString2(plainText) {
			var enc = encodedEncryptedString(plainText);
			var h_chkSum = 0;
			
			h_chkSum = num2Hex(computeChkSum(enc));
			return num2Hex(Len(h_chkSum)) & h_chkSum & enc;
		}

		function decodeEncodedEncryptedString(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.keyLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data.theKey = Mid(eStr, i, data.keyLen);
			i = i + data.keyLen;
			data.isKeyValid = (Len(data.theKey) eq data.keyLen);
			data.i = i;

			data.encHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.encLen = hex2num(Mid(eStr, i, data.encHexLen));
			i = i + data.encHexLen;
			data.encrypted = Mid(eStr, i, data.encLen);
			i = i + data.encLen;
			data.isEncValid = (Len(data.encrypted) eq data.encLen);
			data.i = i - 1;

			data.iLen = Len(eStr);
			data.iValid = (data.i eq data.iLen);
			
			data.error = '';
			data.plaintext = '';
			try {
				data.plaintext = Decrypt(data.encrypted, data.theKey, Request.const_encryption_method, Request.const_encryption_encoding);
			} catch (Any e) {
				data.error = 'ERROR - cannot decrypt your encrypted data. ' & '[' & explainError(e, false) & ']' & ', [const_encryption_method=#Request.const_encryption_method#]' & ', [const_encryption_encoding=#Request.const_encryption_encoding#]';
			}

			return data;
		}

		function decodeEncodedEncryptedString2(eStr) {
			var i = 1;
			var data = StructNew();
			data.hexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data.chkSumLen = hex2num(Mid(eStr, i, data.hexLen));
			i = i + data.hexLen;
			data._chkSumHexLen = (Asc(Mid(eStr, i, 1)) - 32) - Asc('0');
			i = i + 1;
			data._chkSumHex = Mid(eStr, i, data._chkSumHexLen);
			i = i + data._chkSumHexLen;
			data._chkSum = hex2num(data._chkSumHex);
			data.enc = Mid(eStr, i, Len(eStr) - i + 1);
			data.chkSum = computeChkSum(data.enc);
			data.isChkSumValid = (data._chkSum eq data.chkSum);
			data.data = decodeEncodedEncryptedString(data.enc);
			return data;
		}

		function sql_getTableCols(p_tableName) {
			return "EXEC sp_columns @table_name = '#p_tableName#';";
		}

		function GetDbSchemaForTable(p_tableName) {
			safely_execSQL('Request.qGetDbSchemaForTable', Request.DSN, sql_getTableCols(p_tableName));
		}

		function indexForNamedQueryColumn(qQ, colName, findName) {
			var i = -1;
			var j = -1;

			if (IsQuery(qQ)) {
				for (j = 1; j lte qQ.recordCount; j = j + 1) {
					if (UCASE(qQ[colName][j]) eq UCASE(findName)) {
						i = j;
						break;
					}
				}
			}
			return i;
		}

		function structToQuery(st) {
			var s = '';
			var q = QueryNew('id, name, value');

			try {
				for (s in st) {
					QueryAddRow(q, 1);
					QuerySetCell(q, 'id', q.recordCount, q.recordCount);
					QuerySetCell(q, 'name', s, q.recordCount);
					QuerySetCell(q, 'value', st[s], q.recordCount);
				}
			} catch (Any e) {
			}
			return q;
		}
		
		function urlParmsFromQuery(q) {
			var i = -1;
			var p = '';
			var s = '';
			
			if (IsQuery(q)) {
				try {
					for (i = 1; i lte q.recordCount; i = i + 1) {
						s = '';
						if (i gt 1) {
							s = '&';
						}
						p = p & s & q.name[i] & '=' & q.value[i];
					}
				} catch (Any e) {
				}
			}
			return p;
		}
		
		function filterQuotesForSQL(s) {
			return ReplaceNoCase(s, "'", "''", 'all');
		}
	
		function js_location(url) {
			writeOutput('<script language="JavaScript1.2" type="text/javascript">');
			writeOutput('<!--');
			writeOutput('window.location.href = "' & url & '";');
			writeOutput('//-->');
			writeOutput('</script>');
		}
	
		function _explainError(_error, bool_asHTML, bool_includeStackTrace) {
			var e = '';
			var v = '';
			var vn = '';
			var i = -1;
			var k = -1;
			var bool_isError = false;
			var sCurrent = -1;
			var sId = -1;
			var sLine = -1;
			var sColumn = -1;
			var sTemplate = -1;
			var nTagStack = -1;
			var sMisc = '';
			var sMiscList = '';
			var _content = '<ul>';
			var _ignoreList = '<remoteAddress>, <browser>, <dateTime>, <HTTPReferer>, <diagnostics>, <TagContext>';
			var _specialList = '<StackTrace>';
			var content_specialList = '';
			var aToken = '';
			var special_templatesList = ''; // comma-delimited list or template keywords

		//	cf_log(Application.applicationname, 'Information', 'DEBUG: _explainError() [IsStruct(_error)=#IsStruct(_error)#], [_ignoreList=#_ignoreList#]');

			if (NOT IsBoolean(bool_asHTML)) {
				bool_asHTML = false;
			}
			
			if (NOT IsBoolean(bool_includeStackTrace)) {
				bool_includeStackTrace = false;
			}
			
			if (NOT bool_asHTML) {
				_content = '';
			}

			for (e in _error) {
				if (FindNoCase('<#e#>', _ignoreList) eq 0) {
					try {
						if (0) {
							v = '--- UNKNOWN --';
							vn = "_error." & e;
			
							if (IsDefined(vn)) {
								v = Evaluate(vn);
							}
						} else {
							v = _error[e];
						}
					} catch (Any ee) {
						v = '--- ERROR --';
					}
	
					if (FindNoCase('<#e#>', _specialList) neq 0) {
						if (NOT bool_asHTML) {
							content_specialList = content_specialList & '#e#=#v#, ';
						} else {
							v = '<textarea cols="100" rows="20" readonly style="font-size: 10px;">#v#</textarea>';
							content_specialList = content_specialList & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					} else {
						if (NOT bool_asHTML) {
							_content = _content & '#e#=#v#,';
						} else {
							_content = _content & '<li><b>#e#</b>&nbsp;#v#</li>';
						}
					}
				}
			//	cf_log(Application.applicationname, 'Information', 'DEBUG: [#e#=#v#,])');
			}
			if (bool_includeStackTrace) {
				nTagStack = ArrayLen(_error.TAGCONTEXT);
				if (NOT bool_asHTML) {
					_content = _content &	'The contents of the tag stack are: nTagStack = [#nTagStack#], ';
				} else {
					_content = _content &	'<li><p><b>The contents of the tag stack are: nTagStack = [#nTagStack#] </b>';
				}
				if (nTagStack gt 0) {
					for (i = 1; i neq nTagStack; i = i + 1) {
						bool_isError = false;
						try {
							sCurrent = _error.TAGCONTEXT[i];
						} catch (Any e2) {
							bool_isError = true;
							break;
						}
						if (NOT bool_isError) {
							sMiscList = '';
							for (sMisc in sCurrent) {
								if (NOT bool_asHTML) {
									sMiscList = ListAppend(sMiscList, ' [#sMisc#=#sCurrent[sMisc]#] ', ' | ');
								} else {
									sMiscList = sMiscList & '<b><small>[#sMisc#=#sCurrent[sMisc]#]</small></b><br>';
								}
							}
							if (NOT bool_asHTML) {
								_content = _content & sMiscList & '.';
							} else {
								_content = _content & '<br>' & sMiscList & '.';
							}
						}
					}
				}
				if (bool_asHTML) {
					_content = _content & '</p></li>';
				}
				_content = _content & content_specialList;
				if (bool_asHTML) {
					_content = _content & '</ul>';
				} else {
					_content = _content & ',';
				}
			}
			
			return _content;
		}

		function explainError(_error, bool_asHTML) {
		//	cf_log(Application.applicationname, 'Information', 'DEBUG: explainError() [IsStruct(_error)=#IsStruct(_error)#], [IsSimpleValue(cfcatch)=#IsSimpleValue(cfcatch)#]');
			return _explainError(_error, bool_asHTML, false);
		}

		function explainErrorWithStack(_error, bool_asHTML) {
			return _explainError(_error, bool_asHTML, true);
		}

		function explainStruct(st, bool_asHTML) {
			var _db = '';
			var v = '';
			
			if (bool_asHTML) {
				_db = _db & '</OL>';
			}

			for (m in st) {
				try {
					v = st[m];
				} catch (Any e) {
					v = '--- ERROR --';
				}

				if (NOT bool_asHTML) {
					_db = _db & '#m#=#v#,';
				} else {
					_db = _db & '<li><b>#m#</b>&nbsp;#v#</li>';
				}
			}

			if (bool_asHTML) {
				_db = _db & '</OL>';
			}
			return _db;
		}
		
		function ensureDirectoryTreeExists(fPath) {
			var i = -1;
			var _path = '';
			var ar = ListToArray(fPath, '\');
			var n = ArrayLen(ar);
			
			for (i = 1; i lte n; i = i + 1) {
				_path = _path & ar[i];
				if (NOT DirectoryExists(_path)) {
					cf_directoryCreate(_path);
				}
				_path = _path & '\';
			}
		}
		
		function captureMemoryMetrics() {
			var qMetrics = QueryNew('id, freeMemory, totalMemory, maxMemory, percentFreeAllocated, percentAllocated');
			var runtime = CreateObject('java','java.lang.Runtime').getRuntime();
			var freeMemory = runtime.freeMemory() / 1024 / 1024;
			var totalMemory = runtime.totalMemory() / 1024 / 1024;
			var maxMemory = runtime.maxMemory() / 1024 / 1024;
			var percentFreeAllocated = Round((freeMemory / totalMemory) * 100);
			var percentAllocated = Round((totalMemory / maxMemory ) * 100);
			
			QueryAddRow(qMetrics, 1);
			QuerySetCell(qMetrics, 'freeMemory', Round(freeMemory), qMetrics.recordCount);
			QuerySetCell(qMetrics, 'totalMemory', Round(totalMemory), qMetrics.recordCount);
			QuerySetCell(qMetrics, 'maxMemory', Round(maxMemory), qMetrics.recordCount);
	
			QuerySetCell(qMetrics, 'percentFreeAllocated', percentFreeAllocated, qMetrics.recordCount);
			QuerySetCell(qMetrics, 'percentAllocated', percentAllocated, qMetrics.recordCount);
			
			return qMetrics;
		}

		function objectForType(objType) {
			var anObj = -1;
			var bool_isError = false;
			var dotPath = objType;
			var _sql_statement = '';
			var thePath = '';

			bool_isError = cf_directory('Request.qDir', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), objType & '.cfc', true);
			if (NOT bool_isError) {
				bool_isError = cf_directory('Request.qDir2', ListDeleteAt(CGI.CF_TEMPLATE_PATH, ListLen(CGI.CF_TEMPLATE_PATH, '\'), '\'), 'commonCode.cfc', true);
			//	writeOutput(cf_dump(Request.qDir, 'Request.qDir', false));
			//	writeOutput(cf_dump(Request.qDir2, 'Request.qDir2', false));
				thePath = Trim(ReplaceNoCase(ReplaceNoCase(Request.qDir.DIRECTORY, Request.qDir2.DIRECTORY, ''), '\', '.'));
			}

		//	writeOutput('<small>A. thePath = [#thePath#]</small><br>');
			if (Len(thePath) gt 0) {
				thePath = thePath & '.';
			}
			dotPath = thePath & dotPath;
			if (Left(dotPath, 1) eq '.') {
				dotPath = Right(dotPath, Len(dotPath) - 1);
			}
		//	writeOutput('<small>B. thePath = [#thePath#], dotPath = [#dotPath#]</small><br>');

			Request.err_objectFactory = false;
			Request.err_objectFactoryMsg = '';
			try {
			   anObj = CreateObject("component", dotPath).init();
			} catch(Any e) {
				Request.err_objectFactory = true;
				Request.err_objectFactoryMsg = 'The object factory was unable to create the object for type "#objType#".';
				writeOutput('<font color="red"><b>#Request.err_objectFactoryMsg# [dotPath=#dotPath#] (#explainError(e, true)#)</b></font><br>');
			}
			return anObj;
		}

		function secondsToHHMMSS(secs) {
			var hh = -1;
			var mm = -1;
			var ss = -1;
			var _secs = -1;
			var m = -1;
	
			m = (60 * 60);
			hh = Int(secs / m);
			_secs = secs - (hh * m);
			if (hh lt 10) {
				hh = '0' & hh;
			}
	
			m = 60;
			mm = Int(_secs / m);
			_secs = _secs - (mm * m);
			if (mm lt 10) {
				mm = '0' & mm;
			}
	
			ss = _secs;
			if (ss lt 10) {
				ss = '0' & ss;
			}
	
			return hh & ':' & mm & ':' & ss & ' (#secs# secs)';
		}
	</cfscript>
</cfcomponent>
