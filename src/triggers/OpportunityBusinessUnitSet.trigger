trigger OpportunityBusinessUnitSet on Opportunity (before insert) {
    
    
    KimbleOne__BusinessUnit__c TransactBU = [Select ID FROM KimbleOne__BusinessUnit__c
                                                WHERE Name = 'Transact'];
                                                
    KimbleOne__BusinessUnit__c ConsultingAndTechnicalServicesBU = [Select ID FROM KimbleOne__BusinessUnit__c
                                                WHERE Name = 'DCS (Domestic Consulting Services)'];                                                
    
    
        for (Opportunity opportunity : Trigger.new) 
        {
                KimbleOne__BusinessUnit__c TheDefault;
                
                if(Opportunity.Kimble_Record_Type__c == 'Blackboard Opportunity Transact')                
                {
                TheDefault = TransactBU;                                                               
                }
                else
                {
                TheDefault = ConsultingAndTechnicalServicesBU;                                                  
                }                                               
                
                Opportunity.KimbleCRMInt__BusinessUnit__c = TheDefault.Id;
                Opportunity.Description = Opportunity.RecordType.ID;
        }

}