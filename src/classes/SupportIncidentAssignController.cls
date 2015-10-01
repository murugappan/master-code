public with sharing class SupportIncidentAssignController
{
    public learnJIRA__c supportIncident {get; set;}
    public Boolean hasErrors {get; set;}
    public Boolean noPrimaryGroup {get; set;}
    public String selectedPrimaryGroup {get; set;}
    public String selectedUser {get; set;}
    public String userComments {get; set;}
    public Boolean closeWin {get {if (closeWin == null) return false; return closeWin;} set;}
    private String theId;
    private String oldOwner;
        
    public SupportIncidentAssignController(ApexPages.StandardController stdController)
    {
        hasErrors = false;
        noPrimaryGroup = true;
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
        if (selectedPrimaryGroup != null && selectedPrimaryGroup != '' && selectedPrimaryGroup != '--Select Primary Group--')
        {
            noPrimaryGroup = false;
        }
        system.debug(selectedPrimaryGroup);
    }
    
    public void loadSupportIncident()
    {
        try
        {
            supportIncident = [Select Id, Name, OwnerId, Owner.Name, Primary_Group__c, Assign_To_Comment__c, Assign_To_Count__c From learnJIRA__c Where Id =: theId];
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
        if (selectedPrimaryGroup != null && selectedPrimaryGroup != '' && selectedPrimaryGroup != '--Select Primary Group--')
        {
            noPrimaryGroup = false;
        }
        if (noPrimaryGroup == true)
        {
            closeWin = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Choose a primary Group then User Name to save.'));
            hasErrors = true;
            return null; 
        }    
            
        try
        {
            learnJIRA__c tempSI = [Select Id, Status__c From learnJIRA__c Where Id =: theId];
            
            supportIncident.Status__c = 'Assigned';                  
            supportIncident.OwnerId = selectedUser;
            supportIncident.Assign_To_Comment__c = userComments;
            
            if (supportIncident.Assign_To_Count__c == null)
            {
                supportIncident.Assign_To_Count__c = 0;
            }
            else
            {
                supportIncident.Assign_To_Count__c = supportIncident.Assign_To_Count__c + 1;
            }
                        
            if (selectedUser == null || selectedUser == '-No User-' || selectedUser == '')
            {
                closeWin = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Choose a valid User.'));
                hasErrors = true;
                return null;
            }
                        
            User u = [select Primary_group__c from User where Id =: selectedUser];       
            supportIncident.Primary_Group__c = u.Primary_group__c;
    
            learnJIRANote__c siNote = new learnJIRANote__c();
            siNote.Support_Incident__c = supportIncident.Id;
            siNote.Details_HTML__c = 'Support Case Assigned to <b>' + supportIncident.Primary_Group__c + '</b><br/>' + supportIncident.Assign_To_Comment__c;
            siNote.Details__c = siNote.Details_HTML__c;
            siNote.Title__c = 'Support Incident Assign To';

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

    public void loadUsers()
    {
        noPrimaryGroup = false;
        if (selectedPrimaryGroup == null && selectedPrimaryGroup == '' && selectedPrimaryGroup == '--Select Primary Group--')
        {
            noPrimaryGroup = true;
            selectedPrimaryGroup = '--Select Primary Group--';
            selectedUser = '--First select a Primary Group--';
        }
    }
    
    public list<SelectOption> getQueueList() 
    {
        list<SelectOption> optionList = new List<SelectOption>();
        list<Group> groupList; 
        String qryString;
                
        optionList.Add(new SelectOption('-Select Primary Group-','--Select Primary Group--'));
        optionList.Add(new SelectOption('ALL','ALL'));
                
        for(Group g : [Select Name, Type, (Select SobjectType From QueueSobjects where SobjectType = 'learnJIRA__c') 
                       From Group 
                       Where Type = 'Queue' 
                       order by Name])
        {
            if(g.QueueSObjects != null && !g.QueueSobjects.isEmpty())
            {                          
                if(g.Name.contains('Moodlerooms'))
                {
                    optionList.add(new SelectOption(g.Name, g.Name));
                }
            }
        }   
        return optionList;
    }
    
       
        
        
    public list<SelectOption> getQueueList1() 
    {
        list<SelectOption> optionList1 = new List<SelectOption>();
        list<Group> groupList1; 
        String qryString1;
                
        optionList1.Add(new SelectOption('Moodlerooms','Moodlerooms'));
        //optionList1.Add(new SelectOption('-Select Business Unit-','--Select Business Unit--'));
        
        
        
                
       
        return optionList1;
     }
    
    
    
    
    
        
    public list<SelectOption> getUserList() 
    {
        list<SelectOption> optionList = new list<SelectOption>();
        optionList.add(new SelectOption('','---Please Select---'));

        if (selectedPrimaryGroup != 'ALL')
        {
            for(User u1 : [Select u.Name, u.Id,u.Primary_Group__c 
                           From User u 
                           Where IsActive = true 
                           And u.Primary_Group__c != null 
                           And u.Primary_Group__c =: selectedPrimaryGroup 
                           order by u.Name])
            {
                optionList.add(new SelectOption(u1.Id, u1.Name));           
            }
        }
        else
        {
            for(User u1 : [Select u.Name, u.Id,u.Primary_Group__c 
                           From User u 
                           Where IsActive = true 
                           And u.Primary_Group__c != null 
                           order by u.Name])
            {
                optionList.add(new SelectOption(u1.Id, u1.Name));           
            }
        }
        
        if (optionList.size() < 2)
        {
            optionList = new List<SelectOption>();
            optionList.add(new SelectOption('-No User-','-No User-'));
            selectedUser = '-No User-';
        }
        return optionList;
    }
}