var ProductName = 1;
var UnitPrice = 2;
var Qty =3;
var Discount =4;
var SalesPrice = 5;
var ServiceDate = 6;
var Description = 7;
var TotalC = 8;
    
var total = 0;
var hasDiscount=true;
var hasDate=true;
function InitValues(_hasDiscount,_hasDate)
{
	hasDiscount=_hasDiscount;
	hasDate = _hasDate;
    total = 0;
    if(!hasDiscount)
    {
	    SalesPrice = 4;
		ServiceDate = 5;
		Description = 6;
		TotalC = 7;
	}
	if(!hasDate)
	{
		 Description =6;
		 TotalC =7;
	}
	if(!hasDate && !hasDiscount)
	{
		 Description =5;
		 TotalC =6;
	}
}

function SalesPriceChanged(row)
{
    var nm = 1;
    //debugger;
    if(hasDiscount)
    {
    	var SP =  StripTextToNumber(row.cells[SalesPrice].getElementsByTagName("input")[0].value);
    	var UP =  StripTextToNumber(row.cells[UnitPrice].getElementsByTagName("div")[0].innerHTML.replace('$',''));

    	var disc = (1-SP/UP)*100;
    	row.cells[Discount].getElementsByTagName("input")[0].value= FormatNumber(disc,2);
    }
    calculateGrid(row.parentNode.parentNode);
    
}
function DiscountChanged(row)
{
	
	var _SalesPrice = StripTextToNumber(row.cells[SalesPrice].getElementsByTagName("input")[0].value) *1;
	var _UnitPrice = StripTextToNumber(row.cells[UnitPrice].getElementsByTagName("div")[0].innerHTML.replace('$',''));
	
	if(_UnitPrice == 0)
	{
	  alert("Discount cannot be modified because the Unit Price equals to zero.");
	  calculateGrid(row.parentNode.parentNode);
	  return true;
	}
	
	var _Disc = StripTextToNumber(row.cells[Discount].getElementsByTagName("input")[0].value) *1;
	var _SalesPrice = _UnitPrice - _UnitPrice*_Disc/100; 
	row.cells[SalesPrice].getElementsByTagName("input")[0].value= FormatNumber(_SalesPrice,2);
	calculateGrid(row.parentNode.parentNode);
}

function calculateGrid(tbl)
{
	//debugger;
    var rowCount = tbl.rows.length-1;
    for(var i =1 ; i < rowCount ; i++)
    {
          var row = tbl.rows[i];
          var _Qty = StripTextToNumber(row.cells[Qty].getElementsByTagName("input")[0].value) * 1;
          if(_Qty == 0)
          {
            alert("The quantity must be greater than zero.");
            row.cells[Qty].getElementsByTagName("input")[0].value = FormatNumber(1,2);
            return false;
          }
          var _SalesPrice = StripTextToNumber(row.cells[SalesPrice].getElementsByTagName("input")[0].value) * 1;
          var _UnitPrice = StripTextToNumber(row.cells[UnitPrice].getElementsByTagName("div")[0].innerHTML.replace('$',''));
		  
		  var _Disc = 0 ;
		  if(hasDiscount)
    	  {
    	  	 _Disc = StripTextToNumber(row.cells[Discount].getElementsByTagName("input")[0].value);
		  	if(_UnitPrice != 0)
		  		_Disc = (1-_SalesPrice/_UnitPrice)*100;
		  	else
		  		_Disc = 0;
		  }
          
          var val1 = (_Qty * _UnitPrice);
          val1=roundNumber(val1,2);
          var val2 = (_Qty * _SalesPrice);
          val2=roundNumber(val2,2);
          _Disc=roundNumber(_Disc,2);
          _SalesPrice=roundNumber(_SalesPrice,2);
 		  
 		  if(hasDiscount)
    	  	  row.cells[Discount].getElementsByTagName("input")[0].value = FormatNumber(_Disc,2);
          row.cells[TotalC].innerHTML = FormatCurrency(val2,2);    
          row.cells[SalesPrice].getElementsByTagName("input")[0].value = FormatNumber(_SalesPrice,2);
          row.cells[Qty].getElementsByTagName("input")[0].value = FormatNumber(_Qty,2);
          total += val2;

    }
    total=roundNumber(total,2);
    document.getElementById("sTotal").innerHTML = FormatCurrency(total,2);
}
