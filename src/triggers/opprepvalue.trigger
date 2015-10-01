trigger opprepvalue on Opportunity_Value__c (before update) {

set<id> Idset = new set<Id>();
set<id> OppIdset = new set<Id>();


for(Opportunity_Value__c oppval: trigger.new){
    if(oppval.Opportunity_c__c != null){
        Idset.add(oppval.Id);
        OppIdset.add(oppval.Opportunity_c__c);
    }
}

list<Opportunity_Value__c> oppList = [Select id, Opportunity_c__c,Quota_New_Sales__c, Quota_Renewal_Sales__c,New_Sales__c, Amount__c ,Expiring_Contract_value__c,Renewal_sales_value__c, Opportunity_c__r.CPQ_Expected_Renewal_Amount__c, Opportunity_c__r.Prior_Year_Value__c, 
                                      Opportunity_c__r.Quota_Value__c, Opportunity_c__r.Quota_Renewal_Sales_Value__c from Opportunity_Value__c Where Opportunity_c__c IN: OppIdset  ];

system.debug('SIZE:'+oppList.size());
system.debug('LIST IS:'+oppList);

  //if(Trigger.isUpdate){
        for(Opportunity_Value__c oppval: trigger.new){
            
            system.debug('NSALES'+oppval.Quota_New_Sales__c);
            system.debug('NSALESADJUST'+oppval.Quota_New_Sales_Adjustment__c);
            system.debug('RSALES'+oppval.Quota_Renewal_Sales__c);
            system.debug('RSALESADJUST'+oppval.Quota_Renewal_Sales_Adjustment__c);
            
            
            if((oppval.Quota_New_Sales_Adjustment__c != null) || (oppval.Quota_New_Sales_Adjustment__c != null)){
                
                 Decimal masternewsalesval = oppval.New_Sales__c;
                 Decimal masternewewalsalesval = oppval.Renewal_sales_value__c;
                 
                 system.debug('masternewsalesval'+masternewsalesval);
                 system.debug('masternewewalsalesval'+masternewewalsalesval);
                 
                 Decimal oldNewSalesvalue = Trigger.oldMap.get(oppval.Id).Quota_New_Sales_Adjustment__c;
                 Decimal NewSalesvalue = oppval.Quota_New_Sales_Adjustment__c;
                 
                 system.debug('oldNewSalesvalue'+oldNewSalesvalue);
                 system.debug('NewSalesvalue'+NewSalesvalue);
                 
                 Decimal oldRenewalSalesvalue = Trigger.oldMap.get(oppval.Id).Quota_Renewal_Sales_Adjustment__c;
                 Decimal renewalSalesvalue = oppval.Quota_Renewal_Sales_Adjustment__c;
                 
                 system.debug('oldRenewalSalesvalue'+oldRenewalSalesvalue);
                 system.debug('renewalSalesvalue'+renewalSalesvalue);
                    
                 
                 if(NewSalesvalue != oldNewSalesvalue){
                     oppval.Quota_New_Sales__c = masternewsalesval + oppval.Quota_New_Sales_Adjustment__c;
                     system.debug('quota new sales val is:'+oppval.Quota_New_Sales__c);
                    
                 }
                 if(renewalSalesvalue != oldRenewalSalesvalue){
                     oppval.Quota_Renewal_Sales__c = masternewewalsalesval + oppval.Quota_Renewal_Sales_Adjustment__c;
                     system.debug('quota nenewal sales val is:'+oppval.Quota_Renewal_Sales__c);
                 }
                 
                 
            }
            
            
        }

     //}
     
       list<opportunity> opptoUpdate = new list<opportunity>();
       list<opportunity> opptoList = [Select id from Opportunity Where Id IN:OppIdset];
       system.debug('SSS'+opptoList.size());
       system.debug('RRR'+opptoList);
       for(Opportunity opp: opptoList){
           if(opptoList.size() > 0){
               opptoUpdate.add(opp);    
       }
       update opptoUpdate;
       
       
       
       }
     
       Decimal totalval = 0.00;
        
     
       for(Opportunity_Value__c oppvalue: oppList){
       
           
           // add quota new sales credit and quota renewal sales credit from opp
                 Decimal Opptotalval = oppvalue.Opportunity_c__r.Quota_Value__c + oppvalue.Opportunity_c__r.Quota_Renewal_Sales_Value__c;
                 system.debug('OPP TOTAL VAL IS:'+Opptotalval);
                 
           if(oppvalue.Id != null){
                 
                 // add quota new sales and quota renewal sales
                 totalval = totalval + oppvalue.Quota_New_Sales__c + oppvalue.Quota_Renewal_Sales__c;
                 system.debug('TOTAL VAL IS:'+totalval);
                 
                 if(Opptotalval != totalval){
                      //oppvalue.Opportunity_c__c.addError('Issues with the Adjustment values! Please check!');
                 }
                 
                 
           }
            
       
       }


}