public class btbb_htmldisp {

public Univs__c htmldisplay { get; set; }


public btbb_htmldisp(){
        htmldisplay = [Select id, Name, Account__r.Name, Account__c, HTML_Text__c From Univs__c where Account__c =:apexpages.currentpage().getparameters().get('sid') AND Active__c = True];    
    }




}