public class FollowtheSun{

    public Case c {get;set;}
    public String expec {get;set;}
    public String emailorphone {get;set;}
    public String timecons {get;set;}
    public String descrip {get;set;}
    public String accessinfo {get;set;}
    Map<String,String> queuemap = new Map<String,String>();
    Account a;
    List<GroupMember> grpmem = new List<GroupMember>();
    Set<ID> usrID = new Set<ID>();
    List<String> emails = new List<String>();

    public FollowtheSun(ApexPages.StandardController controller) {

        ID cID = controller.getId();
        c = [select CreatedById,ID,Contact_Name__c,Account_Complex_Hosting__c,Asset_Database__c,AccountId,ContactID,Account_Name__c,CaseNumber,Case_Severity__c,Escalated_Tier_2__c,OwnerID,Primary_Group_Name__c  from Case where ID =: cID];
        Id aid = c.AccountId;
        a = [select ID,Learn_Queue__c,Angel_Queue__c,Xythos_Queue__c,Transact_Queue__c from Account where ID =: aID];
        for(List<Group> g : [select ID,Name from Group where Type = 'Queue']){
            for(Group g1 : g){
                queuemap.put(g1.Name,g1.ID); 
            }
        }

    }

    public void getEmails(){

        if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
            grpmem = [select ID,UserOrGroupId,GroupId from GroupMember where GroupID =: c.OwnerID];
        }else if(String.valueof(c.OwnerID).substring(0,3) == '005'){
            usrID.add(c.OwnerID); 
        }     

        if(String.valueof(c.OwnerID).substring(0,3) == '00G'){
            for(GroupMember gm : grpmem){
                usrID.add(gm.UserOrGroupId);
            }
        }


        if(usrID.size() > 0){
            for(List<User> u : [select Id,Email from User where ID IN: usrID]){
                for(User usr : u){
                    emails.add(usr.Email);
                }
            }    
        }
    }

    public Pagereference changecaseowner(){
        System.debug(c.Primary_Group_Name__c);
        if(c.Primary_Group_Name__c != null && c.Account_Complex_Hosting__c !='TRUE'){
            if((c.Primary_Group_Name__c.contains('L1')||c.Primary_Group_Name__c.contains('L2'))&&c.Primary_Group_Name__c.contains('Managed Hosting')&&!c.Primary_Group_Name__c.contains('EMEA')&&!c.Primary_Group_Name__c.contains('Slash'))
            {
                c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - Slash'); 
                c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - Slash';   
                c.Follow_the_Sun__c = true;   
            }
            else if(c.Primary_Group_Name__c =='Learn - L2 - Managed Hosting - Slash')
            {
                c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - EMEA'); 
                c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - EMEA';   
                c.Follow_the_Sun__c = true;  
            }
            else if(c.Primary_Group_Name__c =='Learn - L2 - Managed Hosting - EMEA')
            {
                c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting'); 
                c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting';   
                c.Follow_the_Sun__c = true; 
            }  
            else if(c.Primary_Group_Name__c =='Learn - L1 - Managed Hosting - EMEA')
            {
                c.OwnerID = queuemap.get('Learn - L1 - Managed Hosting'); 
                c.Primary_Group_Name__c = 'Learn - L1 - Managed Hosting';   
                c.Follow_the_Sun__c = true; 
            }
            else if((c.Primary_Group_Name__c.contains('L1') && ((!c.Primary_Group_Name__c.contains('ANZSEA') && !c.Primary_Group_Name__c.contains('EMEA'))) ) && (c.Primary_Group_Name__c.contains('Resellers') && c.Primary_Group_Name__c.contains('CognosOnline'))){
                c.OwnerID = queuemap.get('Learn - L2 - ANZSEA'); 
                c.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';   
                c.Follow_the_Sun__c = true;
            }else if((c.Primary_Group_Name__c.contains('L1') && c.Primary_Group_Name__c.contains('ANZSEA')) || (c.Primary_Group_Name__c  == 'Learn – L1 – Resellers – BEENET' || c.Primary_Group_Name__c == 'Learn – L1 – Resellers – AssistMicro')){
                c.OwnerID = queuemap.get('Learn - L1 - EMEA'); 
                c.Primary_Group_Name__c = 'Learn - L1 - EMEA'; 
                c.Follow_the_Sun__c = true;            
            }else if((c.Primary_Group_Name__c.contains('L1') && c.Primary_Group_Name__c.contains('EMEA')) || (c.Primary_Group_Name__c == 'Learn – L1 – Resellers – Eiffel' || c.Primary_Group_Name__c =='Learn – L1 – Resellers – BMEHolding') ){
                c.OwnerID = queuemap.get('Learn - L1'); 
                c.Primary_Group_Name__c = 'Learn - L1'; 
                c.Follow_the_Sun__c = true;

                /*  if(c.Asset_Database__c == null || c.Asset_Database__c.contains('WINDOWS') || c.Asset_Database__c.contains('Win')){
                    c.OwnerID = queuemap.get('Learn - L1 - Windows'); 
                    c.Primary_Group_Name__c = 'Learn - L1 - Windows'; 
                    c.Follow_the_Sun__c = true;
                }else{
                    c.OwnerID = queuemap.get('Learn - L1 - Unix'); 
                    c.Primary_Group_Name__c = 'Learn - L1 - Unix';
                    c.Follow_the_Sun__c = true;  
                } */   
            }else if(c.Primary_Group_Name__c.contains('L1') && (c.Primary_Group_Name__c.equals('Learn - L1')||c.Primary_Group_Name__c.contains('Windows') || c.Primary_Group_Name__c.contains('Unix') || c.Primary_Group_Name__c.contains('LAC') || c.Primary_Group_Name__c.contains('Mobile') && (!c.Primary_Group_Name__c.contains('ANZSEA') &&  !c.Primary_Group_Name__c.contains('EMEA')))){
                system.debug('--Queue--'+queuemap.get('Learn - L2 - ANZSEA'));
                c.OwnerID = queuemap.get('Learn - L2 - ANZSEA'); 
                c.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';  //Changed from L1 to L2 TP3964
                c.Follow_the_Sun__c = true;
            }
            else if(c.Primary_Group_Name__c.contains('L2') && (c.Primary_Group_Name__c.equals('Learn - L2')||c.Primary_Group_Name__c.contains('Windows') || c.Primary_Group_Name__c.contains('Unix') || c.Primary_Group_Name__c.contains('LAC') || c.Primary_Group_Name__c.contains('Mobile') && (!c.Primary_Group_Name__c.contains('ANZSEA') &&  !c.Primary_Group_Name__c.contains('EMEA')))||c.Primary_Group_Name__c.contains('Grupo A')){
                system.debug('--Queue--'+queuemap.get('Learn - L2 - ANZSEA'));
                c.OwnerID = queuemap.get('Learn - L2 - ANZSEA'); 
                c.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';
                c.Follow_the_Sun__c = true;
            }else if(c.Primary_Group_Name__c.contains('L2') && c.Primary_Group_Name__c.contains('ANZSEA')){
                c.OwnerID = queuemap.get('Learn - L2 - EMEA'); 
                c.Primary_Group_Name__c = 'Learn - L2 - EMEA';
                c.Follow_the_Sun__c = true;
            }else if(c.Primary_Group_Name__c.contains('L2') && c.Primary_Group_Name__c.contains('EMEA')){
                c.OwnerID = queuemap.get('Learn - L2'); 
                c.Primary_Group_Name__c = 'Learn - L2'; 
                c.Follow_the_Sun__c = true;

                /*  if(c.Asset_Database__c == null || c.Asset_Database__c.contains('WINDOWS') || c.Asset_Database__c.contains('Win')){
                    c.OwnerID = queuemap.get('Learn - L2 - Windows'); 
                    c.Primary_Group_Name__c = 'Learn - L2 - Windows'; 
                    c.Follow_the_Sun__c = true;
                }else{
                    c.OwnerID = queuemap.get('Learn - L2 - Unix'); 
                    c.Primary_Group_Name__c = 'Learn - L2 - Unix';
                    c.Follow_the_Sun__c = true;
                }*/ 
            /* Moodlerooms FTS Logic */    
            }
            else if(c.Primary_Group_Name__c == 'Moodlerooms: Territory 1 Engagement Team' || c.Primary_Group_Name__c == 'Moodlerooms: Territory 2 Engagement Team' || c.Primary_Group_Name__c == 'Moodlerooms: Territory 3 Engagement Team' || c.Primary_Group_Name__c == 'Moodlerooms: Territory LAC')  
            {
              c.OwnerID = queuemap.get('Moodlerooms: APAC'); 
              c.Primary_Group_Name__c = 'Moodlerooms: APAC';   
              c.Follow_the_Sun__c = true;
            }
            else if(c.Primary_Group_Name__c == 'Moodlerooms: APAC')
            {
              c.OwnerID = queuemap.get('Moodlerooms: EMEA'); 
              c.Primary_Group_Name__c = 'Moodlerooms: EMEA';   
              c.Follow_the_Sun__c = true;
            }else if(c.Primary_Group_Name__c == 'Moodlerooms: EMEA')
            {
              c.OwnerID = queuemap.get('Moodlerooms: Territory 2 Engagement Team'); 
              c.Primary_Group_Name__c = 'Moodlerooms: Territory 2 Engagement Team';   
              c.Follow_the_Sun__c = true;
            }    
            Update c;
            sendEmail();

            Pagereference p = new Pagereference('/'+c.ID);
            p.setredirect(true);
            return p;
        }  
        return null;
    }
    
    public pagereference navigatecase()
    {
        Pagereference p = new Pagereference('/'+c.ID);
            p.setredirect(true);
            return p;
    }
    public void sendEmail(){
        getEmails();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setSubject('Case '+ c.CaseNumber + ' has been assigned.');
        mail.setSubject('FTS HAND OFF : '+ c.CaseNumber + ' - ' + c.Account_Name__c); // Added for TP 1318
        //mail.setHtmlBody('<br/>Alert  : A' + c.Case_Severity__c + 'Case' + c.CaseNumber + 'has assigned to you' +
        mail.setHtmlBody('<br/><br/>Case ID: ' + c.CaseNumber +  
                '<br/><br/>Institution Name: ' + c.Account_Name__c +
                '<br/><br/>Client Contact Name: ' + c.Contact_Name__c+
                '<br/><br/>Have any expectations been set with the client: ' + (expec != null?expec.replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('\n','<br/>'):'') +
                '<br/><br/>Email and/or Phone number: ' + emailorphone +
                '<br/><br/>Time constraints in terms of availability of the Contact: ' + timecons +
                '<br/><br/>Issue Description: ' + (descrip != null?descrip.replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('\n','<br/>'):'') +
                '<br/><br/>Confirmed Access Information: ' + (accessinfo != null?accessinfo.replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('\n','<br/>'):''));
        mail.setToAddresses(emails);
        Boolean check = true;    
        if(emails != null){      
            for(Integer i=0; i<emails.size(); i++){   
                if(emails[i] == null)
                    check = false;
            }
        }     
        if(emails != null && check == true && emails.size() != 0)  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });



        Case_Note__c note = new Case_Note__c();
        note.Case__c = c.ID;
        note.Public__c = false;
        note.From_Type__c = 'Employee';
        note.Details__c = 'Case ID : ' + c.ID + '\n Institution Name : ' + c.Account_Name__c + '\n Client Contact Name : ' + c.Contact_Name__c+ '\n Have any expectations been set with the client : ' + expec + '\n Email and/or Phone number : ' + emailorphone + '\n Time constraints in terms of availability of the Contact : ' + timecons + '\n Issue Description : ' + descrip + '\n Confirmed Acces Information : ' + accessinfo;
        note.Type__c = 'Follow the Sun';

        insert note;
    }

    static testmethod void FollowtheSunTest(){

        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country'; 
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        a.Learn_Queue__c = 'Learn - L2 - EMEA';
        Insert a;

        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.BillingStreet = 'Test Street';
        a1.BillingCity = 'Test City';
        a1.BillingState = 'Test State';
        a1.BillingCountry = 'Test Country'; 
        a1.BillingPostalCode = 'Test Code';
        a1.Type = 'Partner';
        a1.Learn_Queue__c = 'Learn - L2 - ANZSEA';
        Insert a1;

        Account a2 = new Account();
        a2.Name = 'Test Account';
        a2.BillingStreet = 'Test Street';
        a2.BillingCity = 'Test City';
        a2.BillingState = 'Test State';
        a2.BillingCountry = 'Test Country'; 
        a2.BillingPostalCode = 'Test Code';
        a2.Type = 'Partner';
        a2.Learn_Queue__c = 'Learn - L1 - EMEA';
        Insert a2;

        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        c.AccountID = a.ID;
        insert c;

        Core_License__c cr1 = new  Core_License__c();
        cr1.Name = 'Learn';
        Insert cr1;

        Asset aset = new Asset();
        aset.Name = 'Test Asset 111';
        aset.Core_License__c = cr1.ID;
        aset.AccountID = a.ID;
        insert aset;

        Case c1= new Case();
        c1.AccountId = a.ID;
        c1.ContactID = c.ID;
        c1.AssetID = aset.ID;
        c1.Case_Severity__c='3';
        c1.Primary_Group_Name__c =  'Learn - L2 - EMEA';
        insert c1;

        Case c2= new Case();
        c2.AccountId = a1.ID;
        c2.ContactID = c.ID;
        c2.AssetID = aset.ID;
        c2.Case_Severity__c='3';
        c2.Primary_Group_Name__c =  'Learn - L2 - ANZSEA';
        insert c2;

        Case c3= new Case();
        c3.AccountId = a2.ID;
        c3.ContactID = c.ID;
        c3.AssetID = aset.ID;
        c3.Case_Severity__c='3';
        c3.Primary_Group_Name__c =  'Learn - L1 - EMEA';
        insert c3;


        Test.startTest();

        ApexPages.currentPage().getparameters().put('id',c1.ID); 
        ApexPages.StandardController controller1 = new ApexPages.StandardController(c1);
        FollowtheSun ca1 = new FollowtheSun(controller1); 
        ca1.changecaseowner();


        ApexPages.currentPage().getparameters().put('id',c2.ID); 
        ApexPages.StandardController controller2 = new ApexPages.StandardController(c2);
        FollowtheSun ca2 = new FollowtheSun(controller2); 
        ca2.changecaseowner();

        ApexPages.currentPage().getparameters().put('id',c3.ID); 
        ApexPages.StandardController controller3 = new ApexPages.StandardController(c3);
        FollowtheSun ca3 = new FollowtheSun(controller3); 
        ca3.changecaseowner();

        Test.stopTest();

    }



}