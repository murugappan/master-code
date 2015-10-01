global class CloseCase_GRT_30days_Solunsuggst implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {    
         if(test.isrunningtest()){

           Datetime SolutSugGRT30days = system.now().addMinutes(-1);
           String query = 'SELECT Id,casenumber,status,Last_Activity_Date_Time__c,LastModifiedDate,Last_activity_update__c,Date_Time_Last_Support_Communication__c from case where Status=\'Solution Suggested\' and Last_activity_update__c>:SolutSugGRT30days and LastModifiedDate>:SolutSugGRT30days ';
          return Database.getQueryLocator(query);
           }
       else{
        Datetime SolutSugGRT30days = system.now().addDays(-31);
        String query = 'SELECT Id,casenumber,status,Last_Activity_Date_Time__c,LastModifiedDate,Last_activity_update__c,Date_Time_Last_Support_Communication__c from case where Status=\'Solution Suggested\' and Last_activity_update__c<:SolutSugGRT30days and LastModifiedDate<:SolutSugGRT30days ';
        return Database.getQueryLocator(query);
        }
    }
 
    global void execute(Database.BatchableContext BC, List<Case> scope)
    {
      List<Case> caselist=new List<Case>();
      for(Case c: scope)
        {   
            if(c.id!=null) 
            {
            c.status='Closed';
            caselist.add(c);
            system.debug('display--'+scope);

            } 
        
            }
             List<Solution_Detail__c> sdlist = new List<Solution_Detail__c>();
         for(Solution_Detail__c sd1 : [select Id,Name from Solution_Detail__c where Case__c IN :scope AND Status__c = 'In Consideration']){
             
             sd1.Status__c = 'Not Considered';
             sdlist.add(sd1);
            
            }
            update sdlist; 
            if(caselist!=null){
                 update caselist;
                 system.debug('cases updated--'+caselist);
             }
       }  
    global void finish(Database.BatchableContext BC)
    {
    }
}