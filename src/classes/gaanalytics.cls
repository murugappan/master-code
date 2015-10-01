@RestResource(urlMapping='/GARestCall/*')



/*
MAPPING OF VARIABLES:

dimension1 ==>  UserName      
dimension2 ==>  ProfileName
dimension3 ==>  OpportunityName
dimension4 ==>  AccountName
dimension5 ==>  CaseNumber

*/

global class gaanalytics {

    @HttpGet
    global static string doReply(){
    
    
    String userName = UserInfo.getUserName();
    Id profileId=userinfo.getProfileId();
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    string returnValue;
    list<Opportunity> oppList = new list<Opportunity>();
    list<Account> accList = new list<Account>();
    list<Case> caseList = new list<Case>();
    
    string stringvalue = RestContext.Request.params.get('source_url');
    
    system.debug('Stringvalue--'+stringvalue);
    string prefix;
    string[] part;
    part = stringvalue.split('\\/');
    system.debug('part --'+part );
    prefix = part[1];
    
    if(prefix.length() > 3 && prefix.length() == 15){
    
        
        if(prefix.startsWith('006')){
            oppList = [Select id, AccountId, Account.Name, Name from Opportunity Where Id =: prefix LIMIT 1];
        }
        
        else if(prefix.startsWith('001')){
            accList = [Select id, Name from Account Where Id =: prefix LIMIT 1];
        }
        
        else if(prefix.startsWith('500')){
            caseList = [Select id, CaseNumber from Case Where Id =: prefix LIMIT 1];
        }
        
        
                 Map<String, String> stringMap = new Map<String, String>();
                 stringMap.put('dimension1',UserName);
                 stringMap.put('dimension2',profileName);
                 
                 if(oppList.size() > 0){
                     stringMap.put('dimension3',oppList[0].Name);
                 }
                 
                 if(accList.size() > 0){
                     stringMap.put('dimension4',accList[0].Name);
                 }
                 
                 if(caseList.size() > 0){
                     stringMap.put('dimension5',caseList[0].CaseNumber);
                 }
                 

       
                 string m ='';
                 string mupdate;
                        
                        for(String s:StringMap.keySet()){
                           if(m!=''){
                           m = + m + ', '+ '"' + s + '"'+ ' : '+ '"' + StringMap.get(s) + '"' ;
                           }
                           else{
                           if(m==''){
                            m = '"'+ s + '"' +' : '+ '"'+ StringMap.get(s) + '"';
                            
                           }
                          } 
                        }
                
                 mupdate = '{' + m + '}';
                               
                 
                 returnValue = mupdate;
    
    
    
    
    }
    
    else {
    
                 Map<String, String> stringMap = new Map<String, String>();
                 stringMap.put('dimension1',UserName);
                 stringMap.put('dimension2',profileName);
                 
                 string m ='';
                 string mupdate;
                        
                        for(String s:StringMap.keySet()){
                           if(m!=''){
                           m = + m + ', '+ '"' + s + '"'+ ' : '+ '"' + StringMap.get(s) + '"' ;
                           }
                           else{
                           if(m==''){
                            m = '"'+ s + '"' +' : '+ '"'+ StringMap.get(s) + '"';
                            
                           }
                          } 
                        }
                
                 mupdate = '{' + m + '}';
                               
                 
                 returnValue = mupdate;
    
    
    }
   
    return returnValue ;
  }
  
}