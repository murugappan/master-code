public with sharing class btbb_confirmdisplay {
public boolean isVld {get;set;}
public Univs__c un {get; set;}
private List<Univs__c> blist;
public Univs__c univsnamess {get;set;}

public btbb_confirmdisplay(){

blist = [Select id, LastModifieddate, View_Count__c, Client_Id__c, Active__c, Website__c, Page_Text__c, HTML_Text__c From Univs__c where Account__c =:apexpages.currentpage().getparameters().get('id') AND Active__c = True];

 if(blist == null || blist.size()== 0){
            
           univsnamess = new Univs__c();
            
        } 
        else if(blist.size()== 1){
            
            univsnamess = blist[0];
            
        } 
        else if(blist.size()>1){
            
            for(Univs__c b: blist){
                if(univsnamess == null){
                    univsnamess = b;
                }
                else if(univsnamess.LastModifieddate < b.LastModifieddate){
            
                    univsnamess = b;
            
                }   
            }            
            
        }
        
 if(univsnamess.Website__c != null)
 {
 isVld = true;
 }
 
 
 
        
        
 }
}