trigger CreateTask on Opportunity (After Update) {

System.debug('Test==test' + runrenewaltrigger.TaskTrigger+runrenewaltrigger.TaskPrevTrigger);

  if(runrenewaltrigger.TaskTrigger==False && runrenewaltrigger.TaskPrevTrigger==False)
  {        
       
           
              
                   
            //Set of Won opportunity id
            Set<id> Oppid = New Set<id>();
            
            //To update delivery dates on Products
            Set<id> UpdateDelDate = New Set<id>();
        
            For(Opportunity opp: Trigger.New)
            {
                if(Opp.Iswon==True && Opp.isclosed==True && Opp.StageName!=Trigger.OldMap.get(Opp.id).StageName)
                 Oppid.Add(opp.id);
                
               // Below requirement has bee revoked. 
                // To Update delivery dates on Products 
              /*  
                If(opp.Master_Delivery_Date__c!=Null && opp.Master_Delivery_Date__c!=Trigger.OldMap.Get(opp.id).Master_Delivery_Date__c)
                {
                 UpdateDelDate.Add(opp.id); 
                } 
              */   
            }
        
            //Map of  unique combination and Opportunity
            Map<string,Opportunitylineitem> Moppl = New Map<string,Opportunitylineitem>();
        
            // List of custom Tasks
            List<Custom_Task__c> LcusTask = New List<Custom_Task__c>();
            
            // Map of Queue
            Map<string,QueueSobject> MStrQue = New Map<String,QueueSobject>();
        
            For(QueueSobject que : [Select Queue.Name,Queueid,SobjectType from QueueSobject where SobjectType='Custom_Task__c'])
            {
                    MStrQue.put(que.Queue.Name,que);
            }
        
        
            if(Oppid.Size()>0)
            {
               // Run Once
              runrenewaltrigger.TaskTrigger=True;
        
                For(Opportunitylineitem oppl : [Select id,CPQ_Product_Status__c,CPQ_Platform__c,product2.Product_Group__c,Product2.Transact_Product_Category__c,Opportunityid,Opportunity.Ownerid,Opportunity.Owner.Name from opportunitylineitem where Opportunityid IN :Oppid])
                {
                    Moppl.put(oppl.CPQ_Product_Status__c+','+oppl.CPQ_Platform__c+','+oppl.product2.Transact_Product_Category__c+oppl.Opportunityid,oppl);
                    System.debug('===+==='+oppl.CPQ_Product_Status__c+','+oppl.CPQ_Platform__c+','+oppl.product2.Product_Group__c+oppl.Opportunityid);
                }
        
                // Create custom Tasks 
                System.debug('==++++==='+ Moppl.Size());
                For(OpportunityLineitem Oppl1 : Moppl.values())
                {
                    String str11=oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c;
                    System.debug('===+00+==='+str11.length());
                   // System.debug('===+0+==='+!oppl1.product2.Transact_Product_Category__c.contains('TECH'));
                    if(oppl1.product2.Transact_Product_Category__c!=NUll && !oppl1.product2.Transact_Product_Category__c.contains('TECH') && TransactProductCategory__c.getInstance(oppl1.product2.Transact_Product_Category__c)!=Null && str11.length()<=34 && FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c)!=Null )
                    {
                        System.debug('===+1+==='+oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c);
                        Custom_Task__c temp = New Custom_Task__c();
                        temp.Name=FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c).Task_Name__c;
                        temp.Opportunity__c=Oppl1.Opportunityid;
                        System.debug('==VV=' +FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c).Queue__c);
                        if(FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c).Queue__c=='None')                     
                        {
                        temp.Ownerid=Oppl1.Opportunity.Ownerid;
                        temp.Queue__c=Oppl1.Opportunity.Owner.Name;
                        }
                        else
                        {
                        temp.Ownerid=MStrQue.get(FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c).Queue__c).Queueid;
                        temp.Queue__c=MStrQue.get(FulfillmentSettings__c.getInstance(oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c).Queue__c).Queue.Name;
                        }
                        
                        temp.Store_combination__c=oppl1.CPQ_Product_Status__c+','+oppl1.CPQ_Platform__c+','+oppl1.product2.Transact_Product_Category__c;
                        LcusTask.Add(temp); 
                    }
                }
        
                If(LcusTask.Size()>0)
                insert LcusTask;
        
            }   
          
          // This Requirement has been revoked.
          /*  
            if(UpdateDelDate.Size()>0)
            {
                 // List of opportunitylineitem to update
                 List<OpportunityLineItem> Opplitem = New List<OpportunityLineItem>();
                 
                 For(OpportunityLineItem Oppl : [Select id,Opportunity.Master_Delivery_Date__c,CPQ_Delivery_Date__c  from OpportunitylineItem Where Opportunityid IN :UpdateDelDate])
                 { 
                    //Override the delivery date from Master Delivery Date
                    // If(Oppl.CPQ_Delivery_Date__c==Null)
                     {
                      Oppl.CPQ_Delivery_Date__c=Oppl.Opportunity.Master_Delivery_Date__c;
                      Opplitem.Add(Oppl);
                     }
                 }
                 
                 If(Opplitem.Size()>0)
                 Update Opplitem;
                 
            
            
            }
          */  
         
   }         

}