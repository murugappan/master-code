Trigger CPQQuoteStatusTrigger on Opportunity (after update) {

       If(!UpdationOpportunity.updateFlag)
        {
            UpdationOpportunity.updateFlag=True; 
    
            //CPQ Record Type
            String newId='CPQ New Sales Opportunity Record Type';
            String renewId ='CPQ Renewal Opportunity Record Type';
            
            // Opportunity Id
            Set<Id> allOppsTrig = new Set<Id>();
            
            //retrieve active quote ids for each triggered opp
              List<ID> synchQuotes = new List<ID>();
            
            
            //List of Cameleon Quote for Update
            List<CameleonCPQ__Quote__c> quotesToUpdate = new List<CameleonCPQ__Quote__c>();
            
            For(Opportunity opp : Trigger.New)
            {
                  
                  if(opp.CPQ_Quote_Status__c !=  Trigger.oldmap.get(opp.id).CPQ_Quote_Status__c && (opp.PFIN_Intgr_Record_Type__c.contains(renewId) || opp.PFIN_Intgr_Record_Type__c.contains(newId)) && opp.CPQActiveRelease__c != Null)
                   {
                      allOppsTrig.Add(opp.id);
                      synchQuotes.Add(opp.CPQActiveRelease__c);
                   }
            }         
             
             
            if(allOppsTrig.size()>0)
            {            
               
               //get status and associate opp id for each synched quote
                 List<CameleonCPQ__Quote__c> allQuotes = [SELECT OpportunityId__c, CameleonCPQ__Status__c from CameleonCPQ__Quote__c where Id IN :synchQuotes];
                 
                 Map<Id,CameleonCPQ__Quote__c> quoStatus = new Map<Id, CameleonCPQ__Quote__c>();
                 
                 // Since CPQActiveRelease__c  field having Filter. so Only we can Select CPQActiveRelease__c(Lookup to Opps) that is already in related list.
                 
                 for(CameleonCPQ__Quote__c q : allQuotes){
                    quoStatus.put(q.OpportunityId__c, q);
                 }
               
               
               
               List<Opportunity> LisOpp =[Select id,CPQActiveRelease__c,CPQ_Quote_Status__c,PFIN_Intgr_Record_Type__c from Opportunity Where id IN :  allOppsTrig];
               
                For(Opportunity Opp : LisOpp)
                {
                     if (opp.CPQ_Quote_Status__c=='Approved Price Quote') 
                      {
                          quoStatus.get(Opp.id).CameleonCPQ__Status__c='Approved';
                          quotesToUpdate.Add(quoStatus.get(Opp.id));
                      }
                      else if(opp.CPQ_Quote_Status__c=='Quote Rejected') 
                      {
                         quoStatus.get(Opp.id).CameleonCPQ__Status__c='Rejected';
                         quotesToUpdate.Add(quoStatus.get(Opp.id));
                      }
                      else if(opp.CPQ_Quote_Status__c ==null || opp.CPQ_Quote_Status__c=='') 
                      {
                        quoStatus.get(Opp.id).CameleonCPQ__Status__c='Draft';
                        quotesToUpdate.Add(quoStatus.get(Opp.id));
                      } 
                         
                         
                }  
             Update quotesToUpdate;
             
             }   
        }          
             
 }