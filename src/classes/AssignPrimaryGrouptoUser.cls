public with sharing class AssignPrimaryGrouptoUser {

    public ID UserID;
    public String prgrp {get;set;}
 
    public AssignPrimaryGrouptoUser(ApexPages.StandardController controller) {
        UserID = controller.getId();
        User  u = [select ID,Primary_Group__c from User where ID =: UserID];
        prgrp = u.Primary_Group__c;
        
        qlist.add(new SelectOption('-None-','-None-'));
      
        Set<ID> qID = new Set<ID>();  
        for(List<QueueSobject> qs : [select SobjectType,QueueId from QueueSobject where SobjectType = 'Case']){
            for(QueueSobject qs1 : qs){
               qId.add(qs1.QueueId);
            }
        }
        for(List<Group> grp  : [select Name,Type from Group where ID IN: qID Order By Name]){
            for(Group g1 : grp){
                 qlist.add(new SelectOption(g1.Name,g1.Name));
            }
        }
    }
    
    public List<SelectOption> qlist = new List<SelectOption>();
    
    public List<SelectOption> getQueues(){
        return qlist;
    }
    
    public Pagereference assigntoUser(){
        User u = new User(ID = UserID);
        u.Primary_Group__c = prgrp;
        update u;
        
        Pagereference p = new Pagereference('/'+UserID+'?noredirect=1');
        p.setredirect(true);
        return p;
    }
    
    private static testmethod void AssignPrimaryGrouptoUserTest(){
        
        Profile p = [select ID from Profile where Name = 'SRV - BTBB User'];
        
        User u  = [select ID from User where ProfileID =: p.ID limit 1];
        
        ApexPages.CurrentPage().getParameters().Put('id',u.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(u);
        AssignPrimaryGrouptoUser aq = new AssignPrimaryGrouptoUser(controller);
        aq.getQueues();
        aq.assigntoUser();      
    }  
}