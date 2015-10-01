trigger Updatedeliverydates on Custom_Task__c (After Update) {

    //Map of opp id and combination
    Set<String> NewCol = New Set<String>();
    
    //set of opportunity ids
    set<id> Opplid = New Set<id>();
    
    //Store combinations and opportunity ids
    For(Custom_Task__c custask : Trigger.New)
    {
        if(custask.Status__c=='Completed')
        {
            NewCol.Add(custask.Store_combination__c+custask.Opportunity__c);
            Opplid.Add(custask.Opportunity__c);
        }    
        
    }
  if(Opplid.Size()>0)
  {
      //  List of lineitems
      List<OpportunityLineItem> Oppll =  [Select id,CPQ_Product_Status__c,CPQ_Platform__c,product2.Product_Group__c,Product2.Transact_Product_Category__c,Opportunityid,Renewal_Unique_Line_ID__c from opportunitylineitem where Opportunityid IN :Opplid];
      
      // List of lineitems for updates
      List<OpportunityLineitem> LopplForUpdate = New List<OpportunityLineItem>();
      
      
      //Below Part will Update Asset status(start)
      
      //List of Assets
      List<Asset> Lass= [Select id,Status,product2id,CPQ_LineIdentifier__c,Opportunity__c from Asset Where Opportunity__c IN :Opplid];
      
      //List to update the status record
      List<Asset> LasstForUpdate = New List<Asset>();
      
      //Map of Asset
      Map<String,Asset> Masst= New Map<String,Asset>();
      
      
      // Map of Asset to identify
      For(Asset Asst: Lass)
      {
         
         Masst.put(Asst.product2id+Asst.CPQ_LineIdentifier__c+Asst.Opportunity__c,Asst);
         System.debug('===()==='+Asst.product2id+Asst.CPQ_LineIdentifier__c+Asst.Opportunity__c);    
      }
     
      //set the date values
      For(OpportunityLineItem Oppl: Oppll)
      {
          if(NewCol.contains(oppl.CPQ_Product_Status__c+','+oppl.CPQ_Platform__c+','+oppl.product2.Transact_Product_Category__c+oppl.Opportunityid))
          {
              
              // to Update delivery date 
              Oppl.CPQ_Delivery_Date__c=System.today();
              // Modified by Vibha 
              // Update asset delivery status to Installed if Product status is new/Renewal
              if(oppl.CPQ_Product_Status__c=='New'|| oppl.CPQ_Product_Status__c=='Renewal')
                  Oppl.CPQ_Delivery_Status__c='Installed';
                  
              else
                  Oppl.CPQ_Delivery_Status__c='Obsolete';  
                             
              LopplForUpdate.Add(Oppl);
              
              // To Update assets status
              System.debug('===(1)==='+Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid);
              if(Masst.containskey(Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid))
              {
              System.debug('===(2)==='+Masst.get(Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid).Status);
              if(oppl.CPQ_Product_Status__c=='New'|| oppl.CPQ_Product_Status__c=='Renewal')
                  Masst.get(Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid).Status='Installed';
              else
                  Masst.get(Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid).Status='Obsolete';
              
              LasstForUpdate.Add(Masst.get(Oppl.Product2id+Oppl.Renewal_Unique_Line_ID__c+Oppl.Opportunityid));
              }
          }    
           
       }
      
      // to update product lines
      If(LopplForUpdate.Size()>0)
      Update LopplForUpdate ;
      
      // to update assets
      If(LasstForUpdate.Size()>0)
      Update LasstForUpdate;
      
      
      
      // Below Part of the code will Update Master delivery Date on Opportunity
      
      //Map of Opportunity and the List of Tasks
      Map<Id,List<Custom_Task__c>> MapCusTask = New Map<Id,List<Custom_Task__c>>();
      
      For(Custom_Task__c Custm : [Select id,Opportunity__c,Status__c from Custom_Task__c  Where Opportunity__c IN : Opplid])
      {
      
        if(MapCusTask.ContainsKey(Custm.Opportunity__c))
        {
            List<Custom_Task__c> temp=MapCusTask.get(Custm.Opportunity__c);
            temp.Add(custm);
            MapCusTask.put(Custm.Opportunity__c,temp);
        }
        else
        {
         
         List<Custom_Task__c> temp= New List<Custom_Task__c>();
         temp.Add(Custm);
         MapCusTask.put(Custm.Opportunity__c,temp);
        
        }
      }
      
      //List of Opportunity to Update
      List<Opportunity> Lopp = New List<Opportunity>();
      
      Map<id,Opportunity> Mopp= New Map<id,Opportunity>([Select id,Master_Delivery_Date__c from Opportunity Where ID IN :Opplid]);
        
        For(Custom_Task__c custask : Trigger.New)
        {
            
            if(custask.Status__c=='Completed')
            {
                Boolean str= False;
                
                For(Custom_Task__c Cutm : MapCusTask.get(custask.Opportunity__c))
                {
                   
                    If(Cutm.Status__c!='Completed')
                    {
                     
                      str=True;
                    
                    }
                }
                 if(str==False)
                 {
                    if(Mopp.get(custask.Opportunity__c).Master_Delivery_Date__c==Null)
                    {
                       Mopp.get(custask.Opportunity__c).Master_Delivery_Date__c =System.today();
                       Lopp.Add(Mopp.get(custask.Opportunity__c));
                       System.debug('+++===+++');
                    }   
                }
            
            }
            
        }    
        if(Lopp.Size()>0)
        {
           runrenewaltrigger.TaskPrevTrigger=True;
           Update Lopp;
        } 
      
      
      
      
      
  }  

}