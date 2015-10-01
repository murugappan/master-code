public  class viewProd
{
    public Id TasksId {get;set;}
    Public String storeid {get;set;}
    Public Id opId {get;set;}
    Public List<OpportunityLineitem> oppty{get;set;}
    Public List<Contact_Role_Selector__c>fullContactRoleList {get;set;}
   
    Public ViewProd()
         {    
       
          }            
    
    Public List<OpportunityLineitem> getoppline()
    {
       //TasksId= ApexPages.currentPage().getParameters().get('id');
       //storeId =[Select Store_combination__c,Opportunity__c from Custom_Task__c where id=:TasksId].Store_combination__c ;
        opId =[Select Store_combination__c, Opportunity__c from Custom_Task__c where id=:TasksId].Opportunity__c ; 
        oppty = [Select Id,Product2Id, Product2.Name,CPQ_Product_Status__c,PS_Product_ID__c,TotalPrice,Store_combination__c
                        From Opportunitylineitem where Store_combination__c=: storeId and opportunityId =: opId ]; 
                
        return oppty;
    }
    Public List<Contact_Role_Selector__c> getconroleselector()
    {
        opId =[Select Store_combination__c, Opportunity__c from Custom_Task__c where id=:TasksId].Opportunity__c ; 
         fullContactRoleList = [Select c.Contact_Role__r.Role__c,c.Contact_Role__r.Contact__r.Name, c.Contact_Role__r.Contact__r.id,
                                c.Role__c,c.Contact_Role__r.Contact__r.Email From Contact_Role_Selector__c c Where Opportunity__c =: opId];
         return fullContactRoleList ;
    }
}