function errorHandler(message) {
	$('disabledZone').style.visibility = 'hidden';
	var jsee = jsErrorExplainer(message, 'errorHandler()', false);
    if (typeof message == "object" && message.name == "Error" && message.description) {
        _alert("(errorHandler.1) Error: " + message.description + '\n' + 'jsErrorExplainer = [' + jsee + ']');
    } else {
        _alert('(errorHandler.1) ' + message + '\n' + 'jsErrorExplainer = [' + jsee + ']');
    }
};

var errorCount = 0;
var email="raychorn@hotmail.com";
function reportError(msg,url,line) {
	var w = window.open("","error"+errorCount++,"resizable,status,width=625,height=400");
	var d = w.document;
	d.write('<div align=center>');
	d.write('<font size=7 face="helvetica"><B>');
	d.write('opps..... A JavaScript Error Has Occurred!');
	d.write('</b></font><br><hr size=4 width="80%">');
	d.write('<form action="mailto:'+email+'" method=post');
	d.write('enctype="text/plain">');
	d.write('<font size=3>');
	d.write('<i>Click the "Report Error" button to send a bug report.</I><br>');
	d.write('<input type="submit" value="Report Error">&nbsp;&nbsp;');
	d.write('<input type="button" value="Dismiss" onClick="self.close()">');
	d.write('</div><div align=right>');
	d.write('<br>Your name <i>(optional)</i>: ');
	d.write('<input size=42 name="name" value="">');
	d.write('<br>Error Message: ');
	d.write('<input size=42 name="message" value="'+msg+'">');
	d.write('<br>Document: <input size=42 name="url" value="'+url+'">');
	d.write('<br>Line Number: <input size=42 name="line" value="'+line+'">');
	d.write('<br>Browser Version: ');
	d.write('<input size=42 name="version" value="'+navigator.userAgent+'">');
	d.write('<div></font></form>');
	d.close();
	return true;
}
