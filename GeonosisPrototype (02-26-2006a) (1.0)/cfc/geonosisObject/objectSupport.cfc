<cfcomponent displayname="Object Support Code" name="objectSupport">
	<cffunction name="init" access="public" returntype="struct">
		<cfscript>
			this.vars = StructNew();
		</cfscript>

		<cfreturn this>
	</cffunction>

	<cffunction name="parseQueryString" access="public" returntype="string">
		<cfscript>
			var n = '';
			var v = '';
			var a = -1;
			var ar = -1;
			var i = -1;
			var m = -1;
			var q = -1;
			var st = -1;

			try {
				if (Len(CGI.QUERY_STRING) gt 0) {
					ar = ListToArray(CGI.QUERY_STRING, '&');
					m = ArrayLen(ar);
					for (i = 1; i lte m; i = i + 1) {
						a = ListToArray(ar[i], '=');
						if (ArrayLen(a) eq 2) {
							n = URLDecode(TRIM(a[1]));
							v = URLDecode(TRIM(a[2]));
							this.vars[n] = v;
						}
					}
				} else {
					for (s in URL) {
						this.vars[s] = URLDecode(URL[s]);
					}

					for (s in FORM) {
						this.vars[s] = URLDecode(FORM[s]);
					}
				}
			} catch (Any e) {
			}
		</cfscript>

		<cfdump var="#URL#" label="URL - parseQueryString" expand="No">
		<cfdump var="#FORM#" label="FORM - parseQueryString" expand="No">
		<cfdump var="#this#" label="this - parseQueryString" expand="No">
	</cffunction>

	<cfscript>
		function makeURL(ar_vars, ar_vals) {
			var i = -1;
			var n = '';
			var v = '';
			var _ch = '';
			var _url = '';
	
			_url = 'http://' & CGI.SERVER_NAME & CGI.SCRIPT_NAME;
			if ( (IsArray(ar_vars)) AND (IsArray(ar_vals)) ) {
				for (i = 1; i lte ArrayLen(ar_vars); i = i + 1) {
					_ch = '?';
					if (i gt 1) {
						_ch = '&';
					}
					n = ar_vars[i];
					v = ar_vals[i];
					_url = _url & _ch & TRIM(n) & '=' & URLEncodedFormat(TRIM(v));
				}
			}
			return _url;
		}
		
		function fieldMetricsFromQuery(qQ) {
			metrics = StructNew();

			metrics.size = 50;
			metrics.maxlength = 50;
			try {
				if (IsDefined("qQ")) {
					if (IsQuery(qQ)) {
						if (qQ.recordCount eq 1) {
							if (UCASE(qQ.TYPE_NAME) eq UCASE('varchar')) {
								metrics.maxlength = qQ.LENGTH;
								metrics.size = Min(metrics.maxlength, 50);
							} else if (UCASE(qQ.TYPE_NAME) eq UCASE('int')) {
								metrics.maxlength = qQ.PRECISION;
								metrics.size = metrics.maxlength + 2;
							} else if (UCASE(qQ.TYPE_NAME) eq UCASE('text')) {
								metrics.maxlength = qQ.PRECISION;
							//	metrics.size = metrics.maxlength + 2; // default the size but use the max length from the schema...
							}
						}
					}
				}
			} catch(Any e) {
			}
			return metrics;
		}
	</cfscript>

</cfcomponent>
