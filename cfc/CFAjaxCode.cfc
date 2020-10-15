<cfcomponent displayname="CJAjax Code" name="CFAjaxCode" extends="commonCode">

	<cffunction name="sql_ErrorMessage" access="public" returntype="query">
		<cfargument name="_ID_" required="yes" type="string">
		<cfargument name="_msg1_" required="yes" type="string">
		<cfargument name="_msg2_" required="yes" type="string">

		<cfscript>
			var logReason = '';
			var qQ = QueryNew('id, errorTitle, errorMsg');
			QueryAddRow(qQ, 1);
			QuerySetCell(qQ, 'id', _ID_, qQ.recordCount);
			QuerySetCell(qQ, 'errorTitle', _msg1_, qQ.recordCount);
			_msg2_ = URLDecode(_msg2_);
			QuerySetCell(qQ, 'errorMsg', _msg2_, qQ.recordCount);

			logReason = 'Information';
			if (_ID_ lt 0) {
				logReason = 'Error';
			}
			cf_log(Application.applicationname, logReason, 'id = [#_ID_#], errorTitle=[#_msg1_#], errorMsg=[#_msg2_#])');
		</cfscript>

		<cfreturn qQ>
	
	</cffunction>
</cfcomponent>
