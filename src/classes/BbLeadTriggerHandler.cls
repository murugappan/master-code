/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardLeadTriggerHandler
    @abstract       handles all the logic for triggers on Lead
    @since          2011.0915
    @discussion     Class to execute Lead triggers logic
*/
public with sharing class BbLeadTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbLeadTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Lead[] newLeads){
        updateLeadOwnerRelationship(newLeads);
        UpdateRegioncustomfield(newLeads);
        UpdateRatingStatusOnLead(newLeads);
        id pId= UserInfo.getProfileId();
        //Profile ProfileName = [select Name from Profile where id = :userinfo.getProfileId()];
        //String pname = string.valueof(ProfileName.Name);
        for(Lead ld: newLeads){
        
            
            if(ld.Country == null && pId != '00e70000000zlf8AAA' && pId != '00e70000000rsumAAA'){
                ld.Country.addError('Country field is required!');
            }
        
        }
    }
    
    public void OnAfterInsert(Lead[] newLeads, Map<ID, Lead> insertedLeadMap){
        
    }
        
    public void OnBeforeUpdate(Lead[] oldLeads, Lead[] updatedLeads, Map<ID, Lead> oldLeadMap, Map<ID, Lead> updatedLeadMap){
       
       
       
       
       
       
       
       
       
       
        updateLeadOwnerRelationship(updatedLeads);
        UpdateRegioncustomfield(UpdatedLeads);
        StatusOrderValidation(updatedLeads,oldLeadMap);
    
    
    }
    
    public void OnAfterUpdate(Lead[] oldLeads, Lead[] updatedLeads, Map<ID, Lead> oldLeadMap, Map<ID, Lead> updatedLeadMap){

    //Updat Sales Reporting group for lead converted Opps
    UpdateSalesReportingGroupOnOpps(updatedLeads);
    LeadAssignmentFire(updatedLeads,oldLeadMap);
    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------
    
    // To Update Region Field in Lead object TP 5066
    private void UpdateRegioncustomfield(Lead[] leads)
    {
    set<Id> leadOwnerIds = new Set<Id>();
    for(Lead l : leads) leadOwnerIds.add(l.OwnerId);
    Map<Id, User> Users = new Map<Id, User>([select id from User WHERE id In : leadOwnerIds]);
    for(Lead l : leads)
    {
        if (users.containsKey(l.OwnerId) ) l.Owner__c = l.OwnerId;
                else l.Owner__c = null;
                
        if(l.country != Null)
        {        
            if(countries__c.getinstance(l.country.ToLowercase()) != null)
            { 
               l.region__c =  countries__c.getinstance(string.valueof(l.country).ToLowercase()).region__c;
            }  
         }     
    }
        
       
     }
    // copy OwnerId field to Owner__c for Owner__r binding
    private void updateLeadOwnerRelationship(Lead[] leads)
    {
        Set<Id> leadOwnerIds = new Set<Id>();
        for(Lead l : leads) leadOwnerIds.add(l.OwnerId);
    
        Map<Id, User> users = New Map<Id, User>([SELECT Id FROM User WHERE Id IN :leadOwnerIds] );
        for(Lead l : leads)
        {  
            // it ensures that OwnerId is of type User 
            if (users.containsKey(l.OwnerId) ) l.Owner__c = l.OwnerId;
            else l.Owner__c = null;
        }
        
        for(Lead l : leads){
        
               
            /*if((l.Country == 'Australia' || l.Country == 'Finland' || l.Country == 'New Zealand') && (l.Country != 'USA' )){
                    
                    l.Lead_Vertical_1__c = 'Direct';
                    break;
                    
            }
            
            if((l.Country == 'Australia' || l.Country == 'Finland' || l.Country == 'New Zealand') && (l.Country != 'Canada')){
                    
                    l.Lead_Vertical_1__c = 'Direct';
                    
            }
            
            else if((l.Country != 'USA' && l.Country != 'Canada') && (l.Industry == 'Individual Consumer' || l.Industry == 'Internal Bb Account' || l.Industry == ''))
        
            {
                     l.Lead_Vertical_1__c = '';
                     break;
                     
            }*/
                
           
            
            if(l.Country != 'USA' && l.Country != 'Canada'){
                    l.Lead_Vertical_1__c = 'International';
                    
            }
            
            if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Individual Consumer'))
        
                {
                     l.Lead_Vertical_1__c = '';
                     break;
                     
                }
                
            if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Internal Bb Account'))
        
                {
                     l.Lead_Vertical_1__c = '';
                     break;
                     
                }
                
           
        
        
            if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Higher Ed.') 
            // Below OR has been commneted By Nikhil as per reuqest of Eva (TP:4797)
            /*
            && (l.Secondary_Market__c == '2YR College / Community College' || l.Secondary_Market__c == '4YR College / University' 
            || l.Secondary_Market__c == 'HE Consortium' || l.Secondary_Market__c == 'HE School / College / Dept. / Misc.'
            || l.Secondary_Market__c == 'System / Board of Regents' || l.Secondary_Market__c == 'Transact HE Site'
            || (l.Secondary_Market__c == null || l.Secondary_Market__c == ''))*/)
        
                {
                     l.Lead_Vertical_1__c = 'NAHE';
                     break;
                     
                }
          // Commented By Nikhil as per request in TP:4797
          /*      
           if((l.Country == 'Canada' || l.Country == 'USA') && (l.Industry == 'Higher Ed.') 
            && (l.Secondary_Market__c == 'For Profit Ed.' || l.Secondary_Market__c == 'Law School' 
            || l.Secondary_Market__c == 'Ministry Education' || l.Secondary_Market__c == 'Other Vocation Education'
            || l.Secondary_Market__c == 'Vocational Medical/Nursing'))
        
                {
                     l.Lead_Vertical_1__c = 'ProEd';
                     break;
                }
                   
           if((l.Country == 'Canada' || l.Country == 'USA') && (l.Industry == 'Higher Ed.') 
            && (l.Secondary_Market__c == 'For Profit Ed.' || l.Secondary_Market__c == 'Law School' 
            || l.Secondary_Market__c == 'Ministry Education' || l.Secondary_Market__c == 'Other Vocation Education'
            || l.Secondary_Market__c == 'Vocational Medical/Nursing'))
        
                {
                     l.Lead_Vertical_1__c = 'ProEd';
                     break;
                }
            */
                
            if((l.Country == 'Canada' || l.Country == 'USA') && (l.Industry == 'K12') 
            /* &&(l.Secondary_Market__c == 'Elementary / High School' || l.Secondary_Market__c == 'K-12 Consortium' 
            || l.Secondary_Market__c == 'District / Diocese / Multi-Campus Private School' || l.Secondary_Market__c == 'Regional/County Educational Service Unit (BOCES)'
            || l.Secondary_Market__c == 'Department / Office / Misc.' || l.Secondary_Market__c == 'State Board of Education, Virtual School'
            || l.Secondary_Market__c == 'Transact K-12 Site' || (l.Secondary_Market__c == null || l.Secondary_Market__c == '' ))*/)
        
                {
                     l.Lead_Vertical_1__c = 'K12';
                     break;
                     
                }
           
              if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Government'))
        
                {
                     l.Lead_Vertical_1__c = 'ProEd';
                     
                     
                }
                
           
                
            if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Non-Corporate Organization'))
        
                {
                     l.Lead_Vertical_1__c = 'ProEd';
                     break;
                     
                }
                
            if((l.Country == 'USA' || l.Country == 'Canada') && (l.Industry == 'Corporate'))
        
                {
                     l.Lead_Vertical_1__c = 'ProEd';
                     break;
                     
                }

                
       }
          
    } 
    
   Private void UpdateSalesReportingGroupOnOpps(Lead[] Newleads)
    {
           // Set of Opportunityid that has been created through lead conversion.
           set<id> Oppid = New Set<id>();
           
           // Contact id
           
           Set<id> Conid = New Set<id>();
           
           //Map
           Map<id,id> MconidOppid = new Map<id,id>();
           
           // Set Where lead is only converted to Contact
           Set<id> ConvertCon = New Set<id>();
           
           For(Lead lead : Newleads) {
           if (Lead.IsConverted)
           {
           Oppid.Add(lead.ConvertedOpportunityId);
           Conid.Add(lead.ConvertedContactId);
           // Lead is converted to Opportunity and contact as well
           if(lead.ConvertedOpportunityId!=Null && lead.ConvertedContactId!=Null)
           {
            
            MconidOppid.put(lead.ConvertedContactId,lead.ConvertedOpportunityId);
            System.debug('==');
           }
           // Lead is converted only to Contact
           if(lead.ConvertedContactId!=Null && lead.ConvertedOpportunityId==Null)
           ConvertCon.Add(lead.ConvertedContactId);
           }
           
           // Set of Opportunity Owner
           Set<id> Ownerid = New Set<id>();
           List<Opportunity> Lopp =[Select id,Kimble_Record_Type__c,Description,Recordtype.id,Sourced__c,Influenced__c,CampaignId,LeadSource,Ownerid,Sales_Reporting_Group__c,Owner.SalesReportingGroup__c  from Opportunity Where Id IN :Oppid];
           
           // Below two query has been coomneted
           // Kimble query 
          // KimbleOne__BusinessUnit__c TransactBU = [Select ID FROM KimbleOne__BusinessUnit__c WHERE Name = 'Transact'];
          // KimbleOne__BusinessUnit__c ConsultingAndTechnicalServicesBU = [Select ID FROM KimbleOne__BusinessUnit__c WHERE Name = 'DCS (Domestic Consulting Services)'];   
           
           
           
           For(Opportunity Op: Lopp)
           {
                if(Op.Owner.SalesReportingGroup__c != Null)
                {
                   
                   Op.Sales_Reporting_Group__c =Op.Owner.SalesReportingGroup__c;
                   
                   
                   
                } 
              //  TP:3068 and TP:3486(Opps has been created by lead)  
              // As per TP:10679, New picklist value has been added.
                //if(Op.LeadSource == 'Inbound Call' || Op.LeadSource == 'Online Search' ||Op.LeadSource == ' Outbound Marketing Call' ||Op.LeadSource == 'Social Media' ||Op.LeadSource == 'Tradeshow/Live Event' ||Op.LeadSource == 'Webinar'||Op.LeadSource == 'Direct Mail' || Op.LeadSource == 'Marketing' || Op.LeadSource == 'Web' || Op.LeadSource == 'Phone')
              //Modified by Vibha according to Tilanka's Request
              if(Op.LeadSource == 'Direct Mail' || Op.LeadSource == 'Email' ||Op.LeadSource == 'Inbound Call' || Op.LeadSource =='Executive Events' || Op.LeadSource =='Client Success' ||Op.LeadSource == 'Marketing'|| Op.LeadSource == 'Media' ||Op.LeadSource == 'Organic Search'|| Op.LeadSource == 'Organic Social' ||Op.LeadSource == 'Outbound Marketing Call'||Op.LeadSource == 'Paid Search' || Op.LeadSource == 'Paid Social' || Op.LeadSource == 'Purchased List' || Op.LeadSource == 'Social Media' || Op.LeadSource == 'Third Party Inquiry'|| Op.LeadSource == 'Tradeshow/Live Event'|| Op.LeadSource == 'Web'|| Op.LeadSource == 'Webinar')

                {
                 
                      op.Sourced__c = True;
                
                } 
              // If Opps haning any campaign. Checked the campaign checkbox.  
                If(Op.CampaignId != Null)
                {
                   Op.Influenced__c=True;
                
                }  
              // Added for Kimble
              /*
              if(Op.Kimble_Record_Type__c == 'Blackboard Opportunity Transact')                
                {
                      Op.KimbleCRMInt__BusinessUnit__c =TransactBU.id;
                }
                else
                {
                      Op.KimbleCRMInt__BusinessUnit__c =ConsultingAndTechnicalServicesBU .id;                                                 
                } 
                      Op.Description= Op.RecordType.ID;  
                */
           }
           
           // Query contact
           List<contact> LConvetredCon = [Select id,SQL_Date__c,Demand_Funnel_Status__c from contact Where id IN :Conid];
           
           //List to update
           List<contact> toUpdate = New List<contact>();
           
           For(Contact con : LConvetredCon)
           {
              
              If(MconidOppid.ContainsKey(con.id))
              {
                System.debug('===');
                con.SQL_Date__c=DateTime.Now();
                con.Demand_Funnel_Status__c='Suspect/Pipeline';
                toUpdate.Add(con);
              } 
              if(ConvertCon.Contains(con.id))
              {
                con.Demand_Funnel_Status__c='Converted';
                toUpdate.Add(con);
              } 
           
           }
           
           if(toUpdate.Size()>0) 
           {
            runrenewaltrigger.notfirecontacttrigger=True;
            update toUpdate;
           }  
           
           Update Lopp;

}
    
}
    
    
    Private void UpdateRatingStatusOnLead(Lead[] Newleads)
    {
        
        // iterate through all the valus
        For(Lead lead : Newleads)
        { 
            if(lead.Lead_Rating__c!=Null && RatingtoStatus__c.getinstance(lead.Lead_Rating__c)!=Null)
            {
              lead.status=RatingtoStatus__c.getinstance(lead.Lead_Rating__c).Status__c;
            
            }
                if((lead.Status != Null && lead.status=='Prospect') ||(lead.Lead_Rating__c!=Null && lead.Lead_Rating__c=='E') ) 
                lead.MAL_1_Date__c=DateTime.Now();
                
                else if((lead.Status != Null && lead.status=='Inquiry')||(lead.Lead_Rating__c!=Null && lead.Lead_Rating__c=='D'))
                 lead.MAL_2_Date__c=DateTime.Now();
                 
                else if(lead.Status != Null && lead.status=='New')
                 lead.MQL_Date__c=DateTime.Now();
                 
                else if(lead.Status != Null && lead.status=='Working')
                 lead.SAL_Date__c=DateTime.Now();
                 
                else if(lead.Status != Null && lead.status=='Converted')
                 lead.SQL_Date__c=DateTime.Now();
                 
                else if(lead.Status != Null && lead.status=='Transferred to SLX')
                 lead.SQL_Date__c=DateTime.Now();
                
                  
            
            
        }       
        
        
    }
    Private void StatusOrderValidation(Lead[] Newleads,Map<id,Lead> OldLeadMap)
    {
        For(Lead lead: Newleads)
        {
            
            // Lead rating Assignment
            if(lead.Lead_Rating__c!=Null && lead.Lead_Rating__c!=OldLeadMap.get(lead.id).Lead_Rating__c)
            {    
               // System.debug('Test==Test'+ LeadStatusChange__c.getinstance(lead.Lead_Rating__c).Order__c+LeadStatusChange__c.getinstance(OldLeadMap.get(lead.id).Lead_Rating__c).Order__c );
                 if(RatingtoStatus__c.getinstance(lead.Lead_Rating__c)!=Null && LeadStatusChange__c.getinstance(lead.Lead_Rating__c)!=Null && LeadStatusChange__c.getinstance(lead.Lead_Rating__c).Order__c<LeadStatusChange__c.getinstance(OldLeadMap.get(lead.id).Lead_Rating__c).Order__c && lead.Status!='New' && lead.Status!='Working') 
                 lead.status=RatingtoStatus__c.getinstance(lead.Lead_Rating__c).Status__c;
                 if(StatusToOrder__c.getinstance(lead.Status)!=Null && StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status)!=Null && StatusToOrder__c.getinstance(lead.Status).Order__c < StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status).Order__c)
                 lead.status=OldLeadMap.get(lead.id).status;
            }   
            // Toudate Date Value
            if (lead.Status != OldLeadMap.get(lead.Id).Status)
            {
               if(lead.status=='Prospect') 
                     lead.MAL_1_Date__c=DateTime.Now();
               else if(lead.status=='Inquiry')
                     lead.MAL_2_Date__c=DateTime.Now();
               else if(lead.status=='New')
                     lead.MQL_Date__c=DateTime.Now();
               else if(lead.status=='Working')
                     lead.SAL_Date__c=DateTime.Now();
               else if(lead.status=='Converted')
                     lead.SQL_Date__c=DateTime.Now();
               else if(lead.status=='Transferred to SLX')
                     lead.SQL_Date__c=DateTime.Now();
                
           } 
           // Lead status Validation 
            if(lead.Status!=Null && StatusToOrder__c.getinstance(lead.Status)!=Null && StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status)!=Null)
            {  
            
                // System.debug('==+=='+StatusToOrder__c.getinstance(lead.Status).Order__c + StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status).Order__c);
                 if(StatusToOrder__c.getinstance(lead.Status)!=Null && StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status)!=Null && StatusToOrder__c.getinstance(lead.Status).Order__c < StatusToOrder__c.getinstance(OldLeadMap.get(lead.id).Status).Order__c)
                 {
                      lead.Adderror('you cannot reverse the status');
                 }
            }
      }   
    }
    
    
    Private void LeadAssignmentFire(Lead[] Newleads,Map<id,lead> OldMap)
    {
       
       //Set of id 
       Set<id> Leadid = New Set<id>();
       
       For(Lead Led: Newleads)
       {
          if((OldMap.get(Led.id).Status=='Rejected' ||OldMap.get(Led.id).Status=='Nurture'||OldMap.get(Led.id).Status=='Trash'||OldMap.get(Led.id).Status=='Prospect' ||OldMap.get(Led.id).Status=='Inquiry') && Led.Status=='New')
            Leadid.Add(Led.id);
          if(OldMap.get(Led.id).Status=='Rejected' && Led.Status=='New')
          {
            if(OldMap.get(Led.id).Rejection_Reason__c == 'Wrongly assigned - Turn Back to Marketing')
            {
               Leadid.remove(Led.id);
            }
          }
       }
       
       If(Leadid.Size()>0)
       FutureMethodRecordProcessing.ReassignLead(Leadid);
    
    }
}