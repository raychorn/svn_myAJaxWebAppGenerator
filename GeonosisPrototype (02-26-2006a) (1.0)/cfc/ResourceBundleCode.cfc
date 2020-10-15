<cfcomponent displayname="Internationalization (Resources) Code" name="ResourceBundleCode">

	<cfscript>
		this.locale = 'EN';
		this.iniPath = '';

		this.const_undefined_symbol = 'undefined';
	</cfscript>

	<cfscript>
		function initResources(aLocale, aPath) {
			this.locale = aLocale;
			this.iniPath = aPath;
		//	cf_log(Application.applicationname, 'Information', 'initResources(aLocale = [#aLocale#], aPath = [#aPath#])');
			if (NOT FileExists(this.iniPath)) {
				SetProfileString(this.iniPath, this.locale, 'Creation-Date', formattedDateTimeTZ(Now()));
			}
		}

		function _getResourceByName(aName, aDefault) {
			var aVal = '';
			
			if (NOT FileExists(this.iniPath)) {
				SetProfileString(this.iniPath, this.locale, aName, this.const_undefined_symbol);
			}
			aVal = GetProfileString(this.iniPath, this.locale, aName);
			if ( (Len(aVal) eq 0) OR (aVal eq this.const_undefined_symbol) ) {
				if (Len(aDefault) eq 0) {
					aDefault = this.const_undefined_symbol;
				}
				SetProfileString(this.iniPath, this.locale, aName, aDefault);
				aVal = GetProfileString(this.iniPath, this.locale, aName);
			}
			return aVal;
		}

		function getResourceByName(aName) {
			return _getResourceByName(aName, this.const_undefined_symbol);
		}

		function getResourceByNameWithDefault(aName, aDefault) {
			return _getResourceByName(aName, aDefault);
		}
	</cfscript>

</cfcomponent>
