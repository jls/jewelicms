jeweli = {};
jeweli.admin = {};
jeweli.admin.positionChannelList = function(){
	var l = document.getElementById('new-post-link').offsetLeft;
	document.getElementById('new-post-channels-list').style.left = l + "px";
}
jeweli.admin.previewArticle = function(){
	// Get all of the data value fields
	var fields_container = document.getElementById('article-fields');
	var fields = jeweli.admin.getElementsByClass('rich-edit-text', fields_container, 'textarea');
	var preview_area = document.getElementById('preview-container');
	for(var i = 0; i < fields.length; i++){
		preview_area.innerHTML += "<p>" + fields[i].value + "</p>";
	}
	return fields;
}

// Awesome implementation of getElementsByClass by 
// Dustin Diaz: http://www.dustindiaz.com/getelementsbyclass/
jeweli.admin.getElementsByClass = function(searchClass,node,tag) {
	var classElements = new Array();
	if ( node == null )
		node = document;
	if ( tag == null )
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)");
	for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}

var virgin = true; // A sentinel telling us if updateSlug has been called yet

jeweli.admin.updateSlug = function()
{
	// TRICKY: only update the slug if it was empty on page load
	if (virgin == true && document.getElementById("article_slug").value != "") {
		return;
	} else {
		virgin = false;
	}
	
	var defaultTitle = '', Txt = document.getElementById("article_title").value, TxtTemp, separator = '-', multiReg, c, pos;
	
	if (defaultTitle != '')
	{
		if (Txt.substr(0, defaultTitle.length) == defaultTitle)
		{
			Txt = Txt.substr(defaultTitle.length)
		}	
	}
	
	Txt = Txt.toLowerCase();
		
	// Int'l chars filter
	
	TxtTemp = '';
	for(pos=0; pos<Txt.length; pos++)
	{
		c = Txt.charCodeAt(pos);
		
		if (c >= 32 && c < 128)
		{
			TxtTemp += Txt.charAt(pos);
		}
		else
		{
			if (c == '223') {TxtTemp += 'ss'; continue;}
		if (c == '224') {TxtTemp += 'a'; continue;}
		if (c == '225') {TxtTemp += 'a'; continue;}
		if (c == '226') {TxtTemp += 'a'; continue;}
		if (c == '229') {TxtTemp += 'a'; continue;}
		if (c == '227') {TxtTemp += 'ae'; continue;}
		if (c == '230') {TxtTemp += 'ae'; continue;}
		if (c == '228') {TxtTemp += 'ae'; continue;}
		if (c == '231') {TxtTemp += 'c'; continue;}
		if (c == '232') {TxtTemp += 'e'; continue;}
		if (c == '233') {TxtTemp += 'e'; continue;}
		if (c == '234') {TxtTemp += 'e'; continue;}
		if (c == '235') {TxtTemp += 'e'; continue;}
		if (c == '236') {TxtTemp += 'i'; continue;}
		if (c == '237') {TxtTemp += 'i'; continue;}
		if (c == '238') {TxtTemp += 'i'; continue;}
		if (c == '239') {TxtTemp += 'i'; continue;}
		if (c == '241') {TxtTemp += 'n'; continue;}
		if (c == '242') {TxtTemp += 'o'; continue;}
		if (c == '243') {TxtTemp += 'o'; continue;}
		if (c == '244') {TxtTemp += 'o'; continue;}
		if (c == '245') {TxtTemp += 'o'; continue;}
		if (c == '246') {TxtTemp += 'oe'; continue;}
		if (c == '249') {TxtTemp += 'u'; continue;}
		if (c == '250') {TxtTemp += 'u'; continue;}
		if (c == '251') {TxtTemp += 'u'; continue;}
		if (c == '252') {TxtTemp += 'ue'; continue;}
		if (c == '255') {TxtTemp += 'y'; continue;}
		if (c == '257') {TxtTemp += 'aa'; continue;}
		if (c == '269') {TxtTemp += 'ch'; continue;}
		if (c == '275') {TxtTemp += 'ee'; continue;}
		if (c == '291') {TxtTemp += 'gj'; continue;}
		if (c == '299') {TxtTemp += 'ii'; continue;}
		if (c == '311') {TxtTemp += 'kj'; continue;}
		if (c == '316') {TxtTemp += 'lj'; continue;}
		if (c == '326') {TxtTemp += 'nj'; continue;}
		if (c == '353') {TxtTemp += 'sh'; continue;}
		if (c == '363') {TxtTemp += 'uu'; continue;}
		if (c == '382') {TxtTemp += 'zh'; continue;}
		if (c == '256') {TxtTemp += 'aa'; continue;}
		if (c == '268') {TxtTemp += 'ch'; continue;}
		if (c == '274') {TxtTemp += 'ee'; continue;}
		if (c == '290') {TxtTemp += 'gj'; continue;}
		if (c == '298') {TxtTemp += 'ii'; continue;}
		if (c == '310') {TxtTemp += 'kj'; continue;}
		if (c == '315') {TxtTemp += 'lj'; continue;}
		if (c == '325') {TxtTemp += 'nj'; continue;}
		if (c == '352') {TxtTemp += 'sh'; continue;}
		if (c == '362') {TxtTemp += 'uu'; continue;}
		if (c == '381') {TxtTemp += 'zh'; continue;}
		
		}
	}
	
	multiReg = new RegExp(separator + '{2,}', 'g');
	
	Txt = TxtTemp;
	
	Txt = Txt.replace('/<(.*?)>/g', '');
	Txt = Txt.replace(/\s+/g, separator);
	Txt = Txt.replace(/\//g, separator);
	Txt = Txt.replace(/[^a-z0-9\-\._]/g,'');
	Txt = Txt.replace(/\+/g, separator);
	Txt = Txt.replace(multiReg, separator);
	Txt = Txt.replace(/-$/g,'');
	Txt = Txt.replace(/_$/g,'');
	Txt = Txt.replace(/^_/g,'');
	Txt = Txt.replace(/^-/g,'');
	Txt = Txt.replace(/\.+$/g,'');
	
	if (document.getElementById("article_slug"))
	{
		document.getElementById("article_slug").value = "" + Txt;			
	}
	else
	{
		document.forms['new_article'].elements['article_slug'].value = "" + Txt; 
	}		
}
