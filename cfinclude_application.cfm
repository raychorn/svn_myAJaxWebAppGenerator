<!--- cfinclude_application.cfm --->

<cfscript>
	Request.title = "Geonosis&trade;";
	
	Request.const_user_admin_role = 'Admin';

	Randomize(Right('#GetTickCount()#', 9), Request.const_SHA1PRNG);
</cfscript>

<cferror type="exception" template="error.cfm">
