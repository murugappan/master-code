public with sharing class btbb_transitionpage {
public string mlist {get;set;}

public btbb_transitionpage(){

mlist = apexpages.currentpage().getparameters().get('web');

}

public Pagereference redirect(){
PageReference pageRef = new PageReference(mlist);
pageref.setredirect(true);
return pageref;

}



}