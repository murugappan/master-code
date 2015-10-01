public with sharing class btbb_upconfirmation {
public  Account a {get; set;}
public string errorText {get; private set;}

public btbb_upconfirmation(){
try{
 a = [Select id, PS_Company_Id__c from Account where id =: apexpages.currentpage().getparameters().get('id')];
}

catch(exception e){
errorText = 'Invalid Account';}
}


}