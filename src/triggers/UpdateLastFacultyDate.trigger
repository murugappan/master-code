trigger UpdateLastFacultyDate on Event (After Insert,After update) {

     //set of ids
     Set<id> AccId = New Set<id>();
     Set<Id> TskId = New Set<Id>();
     Set<Id> OppId = New Set<Id>();
     Opportunity opp;
     Map<Id,Event> mapofTsk = new Map<Id,Event>();
     For(Event evnt : Trigger.New)
     {
      if(evnt.type=='Faculty Engagement' && evnt.Event_Status__c=='Completed' && (String.Valueof(evnt.Whatid).contains('001') || String.Valueof(evnt.Whatid).contains('006')))
        {
           if(String.Valueof(evnt.Whatid).contains('001'))
           {
              AccId.Add(evnt.Whatid);
              mapoftsk.put(evnt.Whatid,evnt);
           }
           else
           {
              // OppId = evnt.Whatid;
              opp = [Select id, AccountId from Opportunity where Id =: evnt.Whatid];
              mapoftsk.put(Opp.AccountId,evnt);
              AccId.add(opp.AccountId);
              
           }
           TskId.Add(evnt.id);
          // mapoftsk.put(evnt.Whatid,evnt);
           System.Debug('2nd'+evnt.ActivityDate);
           System.Debug('Map'+mapoftsk);
        }
     }
     //Map<Id,Task> mapofTsk = new Map<Id,Task>([Select id,WhatId,ActivityDate,type,Event_Status__c from Event where id IN: TskId]);
    
     if(AccId.size()>0)
     {
         // List of account to update
         List<Account> LAcc= New List<Account>();
                
         //Query for Account
         For(Account acc:[select id,Last_Faculty_Engagement__c from Account Where id IN :AccId])
         { 
           acc.Last_Faculty_Engagement__c = mapoftsk.get(acc.id).ActivityDate;
           LAcc.Add(acc);
           System.Debug('3rd'+acc.Last_Faculty_Engagement__c);
         
         }
         
         If(LAcc.Size()>0)
         update LAcc;
     }    
}