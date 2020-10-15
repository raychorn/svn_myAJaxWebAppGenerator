<cfprocessingdirective pageencoding="utf-8">
<!--- Send the error report --->
<cfset aConfig = StructNew()>

<cfscript>
	aConfig.mailserver = '';
	aConfig.owneremail = 'raychorn@hotmail.com';
</cfscript>

<cfsavecontent variable="mail">
<cfoutput>
#Request.commonCode.getResourceByName("errorOccured")#:<br>
<table border="1" width="100%">
	<tr>
		<td>#Request.commonCode.getResourceByName("date")#:</td>
		<td>#dateFormat(now(),"m/d/yy")# #timeFormat(now(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td>#Request.commonCode.getResourceByName("scriptName")#:</td>
		<td>#cgi.script_name#?#cgi.query_string#</td>
	</tr>
	<tr>
		<td>#Request.commonCode.getResourceByName("browser")#:</td>
		<td>#error.browser#</td>
	</tr>
	<tr>
		<td>#Request.commonCode.getResourceByName("referer")#:</td>
		<td>#error.httpreferer#</td>
	</tr>
	<tr>
		<td>#Request.commonCode.getResourceByName("message")#:</td>
		<td>#error.message#</td>
	</tr>
	<tr>
		<td>#Request.commonCode.getResourceByName("type")#:</td>
		<td>#error.type#</td>
	</tr>
	<cfif structKeyExists(error,"rootcause")>
	<tr>
		<td>#Request.commonCode.getResourceByName("rootCause")#:</td>
		<td><cfdump var="#error.rootcause#"></td>
	</tr>
	</cfif>
	<tr>
		<td>#Request.commonCode.getResourceByName("tagContext")#:</td>
		<td><cfdump var="#error.tagcontext#"></td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>

<cfif aConfig.mailserver is "">
	<cfmail to="#aConfig.owneremail#" from="#aConfig.owneremail#" type="html" subject="Error Report">#mail#</cfmail>
<cfelse>
	<cfmail to="#aConfig.owneremail#" from="#aConfig.owneremail#" type="html" subject="Error Report"
			server="#aConfig.mailserver#" username="#aConfig.mailusername#" password="#aConfig.mailpassword#">#mail#</cfmail>
</cfif>

<cfmodule template="tags/layout.cfm">

	<cfoutput>
	<div class="date">#Request.commonCode.getResourceByName("errorpageheader")#</div>
	<div class="body">
	<p>
	#Request.commonCode.getResourceByName("errorpagebody")#
	</p>
	<cfif isUserInRole("admin")>
		<cfoutput>#mail#</cfoutput>
	</cfif>
	</div>
	</cfoutput>
	
</cfmodule>