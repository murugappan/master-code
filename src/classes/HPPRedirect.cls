public class HPPRedirect {
public string mlist {get;set;}

public HPPRedirect(){

mlist = apexpages.currentpage().getparameters().get('weblink');

}

public Pagereference redirect(){
PageReference pageRef = new PageReference(mlist);
pageref.setredirect(true);
return pageref;

}

}