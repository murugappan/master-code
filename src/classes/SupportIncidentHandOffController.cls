public with sharing class SupportIncidentHandOffController
{
    public learnJIRA__c supportIncident {get; set;}
    public Boolean hasErrors {get; set;}
    public String selectedPrimaryGroup {get; set;}
    public String userComments {get; set;}
    public Boolean closeWin {get {if (closeWin == null) return false; return closeWin;} set;}
    private String theId;
    private String oldOwner;
    public String RecordTypes;
    public string businessunit{get;set;}    
    public SupportIncidentHandOffController(ApexPages.StandardController stdController)
    {
    	businessunit='';
        hasErrors = false;
        theId = ApexPages.currentPage().getParameters().get('id');
        if (theId == null)
        {
            theId = stdController.getId();
        }
        
        loadSupportIncident();
        if (supportIncident.Id != null)
        {
            oldOwner = supportIncident.OwnerId;
        }

        if (supportIncident.Primary_Group__c != null)
        {
            selectedPrimaryGroup = supportIncident.Primary_Group__c;              
        }
        
        system.debug(selectedPrimaryGroup);    
        if(supportIncident.RecordType.Name=='Moodlerooms')
        {
        	businessunit='Moodlerooms';
        }  
        else
        {
        	businessunit='Collaborate';
        }              
    system.debug('My business'+businessunit);
    }
    
    private void loadSupportIncident()
    {
        try
        {
            supportIncident = [Select Id, Name, OwnerId, Owner.Name, Primary_Group__c, Assign_To_Comment__c, Assign_To_Count__c,RecordType.Name From learnJIRA__c Where Id =: theId];
        }
        catch (Queryexception qe)
        {
            supportIncident = new learnJIRA__c();
            hasErrors = true;
            ApexPages.addMessages(qe);
        }
    }
  
    public Pagereference SaveOwner() 
    {
        try
        {
            learnJIRA__c tempSI = [Select Id, Status__c From learnJIRA__c Where Id =: theId];
            
            //supportIncident.Status__c = 'Needs Attention';                  
            supportIncident.OwnerId = selectedPrimaryGroup; 
            supportIncident.Assign_To_Comment__c = userComments;
            
            if (supportIncident.Assign_To_Count__c == null)
            {
                supportIncident.Assign_To_Count__c = 0;
            }
            else
            {
                supportIncident.Assign_To_Count__c = supportIncident.Assign_To_Count__c + 1;
            }
                        
            supportIncident.Primary_Group__c = [select Name from Group where Id =: selectedPrimaryGroup].Name;
    
            learnJIRANote__c siNote = new learnJIRANote__c();
            siNote.Support_Incident__c = supportIncident.Id;
            siNote.Details_HTML__c = 'Support Case Assigned to <b>' + supportIncident.Primary_Group__c + '</b><br/>' + supportIncident.Assign_To_Comment__c;
            siNote.Details__c = siNote.Details_HTML__c;
            siNote.Title__c = 'Support Incident Hand Off';

            insert siNote;
            update supportIncident;  
            closeWin = true;       
            return null;
        }       
        catch (Exception e)
        {
            closeWin = false;
            ApexPages.addMessages(e);
            hasErrors = true;
            return null; 
        }
    } 
    
    public list<SelectOption> getQueueList() 
    {
        list<SelectOption> optionList = new List<SelectOption>();
        list<Group> groupList; 
        String qryString;
                
        optionList.Add(new SelectOption('-Select Primary Group-','--Select Primary Group--'));
                
        for(Group g : [Select Name, Type, (Select SobjectType From QueueSobjects where SobjectType = 'learnJIRA__c') 
                       From Group 
                       Where Type = 'Queue' 
                       order by Name])
        {
            if(g.QueueSObjects != null && !g.QueueSobjects.isEmpty())
            {                          
                if((g.Name.contains('Collaborate')&&businessunit.contains('Collaborate')) || (g.Name.contains('Moodlerooms')&&businessunit.contains('Moodlerooms')))
                {
                	system.debug('name-----'+g.Name);
                    optionList.add(new SelectOption(g.Id, g.Name));
                }
               
                }
        }
          
        
        system.debug(selectedPrimaryGroup);
        return optionList;
    }
    
    
    public list<SelectOption> getQueueList1() 
    {
        list<SelectOption> optionList1 = new List<SelectOption>();
        list<Group> groupList1; 
        String qryString1;
                
       
//optionList1.Add(new SelectOption('-Select Business Unit-','--Select Business Unit--'));
 optionList1.Add(new SelectOption('Collaborate','Collaborate'));
       
        optionList1.Add(new SelectOption('Moodlerooms','Moodlerooms'));
                
       
        return optionList1;
     }
    
}