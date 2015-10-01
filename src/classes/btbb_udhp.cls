public with sharing class btbb_udhp {
public boolean isValid {get;set;}

public Univs__c blist {get;set;}
public string errorText {get;set;}

public btbb_udhp(){ 
try{
blist = [Select id, LastModifieddate, LastModifiedBy.Profile.Name, LastModifiedBy.Name, Account__r.Name, View_Count__c, Website__c, Active__c, Page_Text__c, HTML_Text__c From Univs__c where Account__c =:apexpages.currentpage().getparameters().get('id') AND Active__c = true];
system.debug(blist);
if(blist.Website__c == null && blist.HTML_Text__c == null && blist.Active__c == true || blist.Website__c == '' && blist.HTML_Text__c == '' && blist.Active__c == true)
{
isValid = true;
}

}

catch(exception e)
{
//errorText = 'Associate with an Account';
isValid = true;

}





}





public PageReference redirect(){
pagereference pageref = page.btbb_updatedirecthelp;
pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
//pageref.getParameters().put('bcheck', ''+ isValid);


//pagereference pageref = new pagereference('https://cs12.salesforce.com/apex/auto3?id=' + ApexPages.currentPage().getParameters().get('id'));
pageref.setRedirect(true);
return pageref;


   }
}