/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardContactTriggerHandler
    @abstract       handles all the logic for triggers on Contact
    @since          2011.0915
    @discussion     Class to execute Contact triggers logic
*/
public with sharing class BbContactTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbContactTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    
    
    
    
    
    public void OnBeforeInsert(Contact[] newContacts){
        updateContactLastInteractionField(newContacts);
        UpdateRatingStatusOnContact(newContacts);
    }
    
    public void OnAfterInsert(Contact[] newContacts, Map<ID, Contact> insertedContactMap){
        
    }
        
    public void OnBeforeUpdate(Contact[] oldContacts, Contact[] updatedContacts, Map<ID, Contact> oldContactMap, Map<ID, Contact> updatedContactMap){
        updateContactLastInteractionField(updatedContacts);
        if(runrenewaltrigger.notfirecontacttrigger==False)
        StatusOrderValidation(updatedContacts,oldContactMap);
    }
    
    public void OnAfterUpdate(Contact[] oldContacts, Contact[] updatedContacts, Map<ID, Contact> oldContactMap, Map<ID, Contact> updatedContactMap)
    { 
      
        if(UpdateContactFromPortalUser.hasAfterUpdateRun !=true)
        {
            updatePreferredLoginSiteOnUser(updatedContacts,oldContactMap,updatedContactMap);
        }
       
    }   


    
    

    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------    

    
    //Updates the Last Interaction fields on Contacts
    private void updateContactLastInteractionField(Contact[] contacts) {
    
        // Bb API User Profile
        Id apiProfile = '00e70000000zlf8AAA';       
    
        for(Contact contact : contacts)
        {
            if(contact.last_interaction_flag__c == False && UserInfo.getProfileId() != apiProfile)
            {
                contact.last_interaction_dttm__c = System.now();
                contact.last_interaction_flag__c = True;  
                contact.last_interaction_user__c = UserInfo.getUserId();
            }
        }
    }
    
 
    private void updatePreferredLoginSiteOnUser(Contact[] updatedContacts,Map<ID, Contact> oldContactMap, Map<ID, Contact> updatedContactMap) 
    {
        List<User> userlist=new List<User>();
        List<User> Userupdated=new List<User>();
        List<Contact> Contactlist=new List<Contact>();
        
        for(Contact con:updatedContacts)
        {
            if(con.NOV_Preferred_Site__c != oldContactMap.get(con.Id).NOV_Preferred_Site__c)
            {
                Contactlist.add(con);
            }
        }
        
        userlist=[Select id,NOV_Preferred_Site__c,contactid from User where contactid IN :Contactlist];
        for(User u:userlist)
        {
            //Contact con = updatedContactMap.get(u.contactId);
            //u.NOV_Preferred_Site__c=con.NOV_Preferred_Site__c;
            u.NOV_Preferred_Site__c=updatedContactMap.get(u.contactId).NOV_Preferred_Site__c;
            Userupdated.add(u);
        }
        
        if(Userupdated!=null && Userupdated.size()>=1)
        {
            update Userupdated;
        }
        
    
    }
   
    Private void UpdateRatingStatusOncontact(contact[] Newcontacts)
    {
        
        // iterate through all the valus
        For(contact contact : Newcontacts)
        { 
            if(contact.lead_Rating__c!=Null && RatingtoStatus__c.getinstance(contact.lead_Rating__c)!=Null)
            {
              contact.Demand_Funnel_Status__c=RatingtoStatus__c.getinstance(contact.lead_Rating__c).Status__c;
            
            }
                if((contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='Prospect') ||(contact.lead_Rating__c!=Null && contact.lead_Rating__c=='E') ) 
                contact.MAL_1_Date__c=DateTime.Now();
                
                else if((contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='Inquiry')||(contact.lead_Rating__c!=Null && contact.lead_Rating__c=='D'))
                 contact.MAL_2_Date__c=DateTime.Now();
                 
                else if(contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='New')
                 contact.MQL_Date__c=DateTime.Now();
                 
                else if(contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='Working')
                 contact.SAL_Date__c=DateTime.Now();
                 
                else if(contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='Converted')
                 contact.SQL_Date__c=DateTime.Now();
                 
                else if(contact.Demand_Funnel_Status__c != Null && contact.Demand_Funnel_Status__c=='Transferred to SLX')
                 contact.SQL_Date__c=DateTime.Now();
                
                  
            
            
        }       
        
        
    }
    
    Private void StatusOrderValidation(contact[] Newcontacts,Map<id,contact> OldcontactMap)
    {
        For(contact contact: Newcontacts)
        {
            
            // Lead rating Assignment
            if(contact.Lead_Rating__c!=Null && contact.Lead_Rating__c!=OldcontactMap.get(contact.id).Lead_Rating__c && RatingtoStatus__c.getinstance(contact.Lead_Rating__c)!=Null )
            {
               
                 contact.Demand_Funnel_Status__c=RatingtoStatus__c.getinstance(contact.Lead_Rating__c).Status__c;
                 if(StatusToOrder__c.getinstance(contact.Demand_Funnel_Status__c).Order__c < StatusToOrder__c.getinstance(OldcontactMap.get(contact.id).Demand_Funnel_Status__c).Order__c)
                 contact.Demand_Funnel_Status__c=OldcontactMap.get(contact.id).Demand_Funnel_Status__c;
            }   
            // Toudate Date Value
            if (contact.Demand_Funnel_Status__c != OldcontactMap.get(contact.Id).Demand_Funnel_Status__c)
            {
               if(contact.Demand_Funnel_Status__c=='Prospect') 
                     contact.MAL_1_Date__c=DateTime.Now();
               else if(contact.Demand_Funnel_Status__c=='Inquiry')
                     contact.MAL_2_Date__c=DateTime.Now();
               else if(contact.Demand_Funnel_Status__c=='New')
                     contact.MQL_Date__c=DateTime.Now();
               else if(contact.Demand_Funnel_Status__c=='Working')
                     contact.SAL_Date__c=DateTime.Now();
               else if(contact.Demand_Funnel_Status__c=='Converted')
                     contact.SQL_Date__c=DateTime.Now();
               else if(contact.Demand_Funnel_Status__c=='Transferred to SLX')
                     contact.SQL_Date__c=DateTime.Now();
                
           } 
           // Lead status Validation 
            if(contact.Demand_Funnel_Status__c!=Null && StatusToOrder__c.getinstance(contact.Demand_Funnel_Status__c)!=Null && StatusToOrder__c.getinstance(OldcontactMap.get(contact.id).Demand_Funnel_Status__c)!=Null)
            {  
            
                 System.debug('==+=='+StatusToOrder__c.getinstance(contact.Demand_Funnel_Status__c).Order__c + StatusToOrder__c.getinstance(OldcontactMap.get(contact.id).Demand_Funnel_Status__c).Order__c);
                 if(StatusToOrder__c.getinstance(contact.Demand_Funnel_Status__c).Order__c < StatusToOrder__c.getinstance(OldcontactMap.get(contact.id).Demand_Funnel_Status__c).Order__c)
                 {
                      contact.Adderror('you cannot reverse the status');
                 }
            }
      }   
    }
}