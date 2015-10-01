var ua = navigator.userAgent.toLowerCase();

/****  Add the onClick event fo FF  ****/
if ( ua.indexOf( "firefox" ) != -1 ) 
{ 
    HTMLElement.prototype.click = function() 
    {
        var evt = this.ownerDocument.createEvent('MouseEvents');
        evt.initMouseEvent('click', true, true, this.ownerDocument.defaultView, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
        this.dispatchEvent(evt);
    } 
}
/****	Click Link  ****/
function clickLink(linkobj) {
     if (linkobj.getAttribute('onclick') == null) {
          if (linkobj.getAttribute('href')) document.location = linkobj.getAttribute('href');
          else linkobj.click();
     }
     else linkobj.onclick();
}
/****  Define what to do on enEnter Event  ****/
function onEnter(ev,obj)
{
    if(window.event)
    {
	    if(event.keyCode == 13)  //enter pressed
	    {
			window.event.cancelBubble = true;
	      	window.event.returnValue = false;      
			obj.click();
	    }
	}
	else
	{
	    if(ev.keyCode == 13)  //enter pressed
	    {
	    	ev.preventDefault(); 
		    obj.click();
		}
	}
}

/****  Change option disabled to optgroup  ****/
function ChangeOptDisabled() 
{
	var element = document.getElementsByTagName("option");
	for ( var i=0 ; i < element.length ; ++i )
	{    
		if (element[i].nodeName=="OPTION" && element[i].disabled) 
		{     
			var option = element[i];    
			var label =  element[i].innerHTML;
			var insertionPoint = element[i].nextSibling; 
			var parent = element[i].parentNode;
			parent.removeChild(option);
			option = document.createElement('optgroup');
			option.setAttribute('label',label);
			option.setAttribute('style','color:graytext;text-align:center;');
			insertionPoint = parent.insertBefore(option,insertionPoint);
		}  
	}	
}


function decimalOnly (ele,which) { //alert(ele.value);
	var a = ele.value; 
	var illegalChars = /^[+-]?\d+([,]\d+)?([.]\d+)?$/ ;  // /\D/; // allow numbers
  	if ( illegalChars.test(a) ) { 
  		return true;
	}
	alert (' The '+which+' field accepts numbers only '); 
	ele.value = ''; 
	return false;
	
}
function currencyOnly (ele,which) { //alert(ele.value);
	var a = ele.value; 
	var illegalChars = /^[+-]?\d+([,]\d+)?([.]\d+)?$/ ;
	//alert(illegalChars +'**'+a+'**');
	//illegalChars  = new RegExp(illegalChars );
  	if ( illegalChars.test(a) ) { 
  		return true;
	}
	alert (' The '+which+' field accepts numbers only '); 
	ele.value = ''; 
	return false;
}

var beforeSymbol;
var afterSymbol;
var currencyRate;
var defaultCurrency;
var mode = "view";
var UserDecimalSep;
var UserGroupingSep;
var negPrefix;
var negSuffix;
function Init(_beforeSymbol,_afterSymbol,_defaultCurrency,_currencyRate,_mode,_UserGroupingSep,_UserDecimalSep,_negPrefix,_negSuffix)
{
	afterSymbol = _afterSymbol.replace('-','').replace('(','').replace(')','');
	beforeSymbol = _beforeSymbol.replace('-','').replace('(','').replace(')','');
	currencyRate = _currencyRate;
	defaultCurrency = _defaultCurrency;
	mode = _mode;
	UserDecimalSep=_UserDecimalSep;
	UserGroupingSep=_UserGroupingSep.replace(/&#39;/g, "'").replace(/&nbsp;/g, " ");
	negPrefix=_negPrefix;
	if(negPrefix==' ')negPrefix='';
	negSuffix=_negSuffix;
	//SimpleDecimalFormat(decimalSeparator, groupingSeparator, posPrefix, negPrefix, posSuffix, negSuffix)
	userNumberFormatter = new SimpleDecimalFormat(UserDecimalSep,UserGroupingSep,'', negPrefix, '', negSuffix);
}

function roundNumber(num, dec) {
	var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	return result;
}

function StripTextToNumber(value)
{
	//debugger;
	//var a = OpportunitySalesTeamEditPage.prototype.formatCurrency(value);
	var index  =  value.indexOf("(");
    if(index>0)
    	value = value.substring(0,index-1);
    var num = trimbl(value.replace(beforeSymbol,'').replace(afterSymbol,''));
    var replaceAll='['+UserGroupingSep+']';
    var reg = new RegExp(replaceAll, "g");
    num = num.replace(reg,'');
    num=num.replace(UserDecimalSep,'.').replace('\n','');
    
    if(negPrefix=='')
    {
    	if(num.indexOf("-")!=-1)
    	{
    		num=num.replace('-','');
    		num=-num;
    	}
    }
    return num*1;
}

function trimbl(s)
{
    var l=0; var r=s.length -1;
    while(l < s.length && s[l] == ' ')
    {     l++; }
    while(r > l && s[r] == ' ')
    {     r-=1;     }
    return s.substring(l, r+1).replace('&nbsp;','').replace(/ /g,'').replace('\n','').replace(/\s+|\s+$/g,""); 
}
function FormatNumber(displayValue, decimalPoints)
{
	displayValue=displayValue.toFixed(2);
	return userNumberFormatter.formatCurrency(displayValue);
}


function FormatCurrency(displayValue, decimalPoints)
{
    var displayValueString = FormatNumber(displayValue, decimalPoints);
    if(displayValueString.indexOf('-')==-1)
    	return   beforeSymbol + displayValueString + afterSymbol ;
    else
    	return   beforeSymbol + negPrefix + displayValueString.replace('-','') + negSuffix + afterSymbol ;
}

function FormatCurrencyWithConversion(displayValue, decimalPoints)
{
    if(mode == "edit")
    	return FormatCurrency(displayValue, decimalPoints);
    else if(mode == "view")
    {
    	var displayValueString = FormatNumber(displayValue, decimalPoints);
    	var strConv = FormatNumber(roundNumber(displayValue/currencyRate,2));
    	var conv = ' (' + defaultCurrency + ' ' + strConv + ')';
    	var res =  beforeSymbol + displayValueString + afterSymbol + conv;
    	return res;
    }
}

function ValidateInt(value, isRequired)
{
    //value = StripTextToNumber(value);
    var number = parseInt(value);
    
    if (isNaN(number) || number.toString() != value)
    {
        return false;
    }
    
    if (("" == value || 0 == number) && isRequired)
    {
        return false;
    }
       
    return true;
}

function ValidateFloat(value, isRequired)
{
    //value = StripTextToNumber(value);
    var number = parseFloat(value);
    
    if (isNaN(number) || number.toString() != value)
    {
        return false;
    }
    
    if (("" == value || 0 == number) && isRequired)
    {
        return false;
    }
    
    return true;
}
function OpenCenterWindow(url,title,w,h)
{
      var left = (screen.width/2)-(w/2);
	  var top = (screen.height/2)-(h/2);
      window.open(url,title,'width=' + w + ', height=' + h + ',scrollbars=1,top =' + top + ',left='+left);    
}
