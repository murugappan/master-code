public class Utility{
 
    public static boolean isFutureUpdate;      
    
    @future
    public static void updateSIWithCase(Set<Id> SISet, Boolean isInsert) {
        Map<id, Id> mapOfCaseIdWithSIId = new Map<id, Id>();
        Map<Id, Case> mapOfCaseWithId = new Map<Id, Case>(); 
        Map<Id, learnJIRA__c> mapOfSIWithId = new Map<Id, learnJIRA__c>();
        Set<Id> learnJiraIds = new Set<Id>();
       
        List<Case> caseList = new List<Case>();
        List<learnJIRA__c> SIList = [Select Id, Name, OriginCaseID__c From learnJIRA__c Where id IN :SISet];
        for(learnJIRA__c si : SIList ) { 
            learnJiraIds.add(si.Id);        //Will store the all Support Incident ID
            if(si.OriginCaseID__c != null)  //Will store the Support Incident Id on the basis of case Id
                mapOfCaseIdWithSIId.put(si.OriginCaseID__c, si.Id);
            System.debug('OriginCaseID__c >>>>>>>>>>>>>>>>>>> ' + si.OriginCaseID__c);
        }
        
        if(mapOfCaseIdWithSIId.size() > 0) {
            
            for(Case caseObj : [Select Description, Subject, A2__c, Asset.Version_Build__c, Asset.Front_Back_Access__c, Module__c, Module__r.Name,Functional_Area__r.Name, Category__r.Name, Core_License__r.Name From Case Where id IN : mapOfCaseIdWithSIId.keyset()]){
                
                mapOfCaseWithId.put(mapOfCaseIdWithSIId.get(caseObj.Id), caseObj);
            }
        }
        if(!isInsert) {
            System.debug('<<<<<<<<<<<In Is Insert False>>>>>>>>>>>');
            learnJIRA__c si1;
            String SIName;
            for(Solution sol : [select id, SolutionNumber, Support_Incident__c from Solution where Support_Incident__c IN : SISet]) {
            
                for(learnJIRA__c si: SIList ) {  
                    SIName = si.Name;                   
                    if(si.Id == sol.Support_Incident__c) {                      
                        if(!SIName.contains(sol.SolutionNumber) || !SIName.Contains('SI')) {
                            si1 = new learnJIRA__c(ID = si.ID);
                            si1.Name = 'SI-' + sol.SolutionNumber;  
                            mapOfSIWithId.put(si1.Id, si1);
                        }
                    }
                }
            }
        }
        if(isInsert) {
            Case caseObj;
            set<Id> uniqueCaseIds = new set<Id>();
            //Update SI Name with Solution Number
            for(Solution sol : [select id, SolutionNumber, Support_Incident__c from Solution where Support_Incident__c IN : SISet]) {
            
                for(learnJIRA__c si: SIList ) {                      
                    if(si.Id == sol.Support_Incident__c) { 
                        learnJIRA__c si1 = new learnJIRA__c(ID = si.ID);
                        si1.Name = 'SI-' + sol.SolutionNumber;  
                        mapOfSIWithId.put(si1.Id, si1);
                        caseObj = mapOfCaseWithId.get(si.ID);
                        if(caseObj != null && !uniqueCaseIds.contains(caseObj.Id)) {
                            caseObj.Article_Number__c = sol.SolutionNumber;
                            caseObj.Article_Id__c = sol.Id;
                            caseList.add(caseObj);
                            uniqueCaseIds.add(caseObj.Id);
                        }
                        //learnJiraList.add(si1); 
                    }
                }       
            }
            
            if(caseList.size() > 0)
                update caseList;
               
        } 
       
        
        if(mapOfCaseIdWithSIId.size() > 0) {
            
           // for(Case caseObj : [Select Description, Subject, A2__c, Asset.Version_Build__c, Asset.Front_Back_Access__c, Module__c, Module__r.Name,Functional_Area__r.Name, Category__r.Name, Core_License__r.Name From Case Where id IN : mapOfCaseIdWithSIId.keyset()]){
                
               // mapOfCaseWithId.put(mapOfCaseIdWithSIId.get(caseObj.Id), caseObj);
           // }
            if(mapOfCaseWithId.size() > 0) {
                 Case caseObj;
                 learnJIRA__c si1;
                 for(learnJIRA__c si : SIList) {
                    if(mapOfSIWithId.containsKey(si.Id)) 
                        si1 = mapOfSIWithId.get(si.Id);
                    else
                        si1 = new learnJIRA__c(ID = si.ID);
                    
                    caseObj = mapOfCaseWithId.get(si1.Id);
                    if(null != caseObj) {
                        System.debug('caseObj.Module__c>>>>>>>>' +caseObj.Module__c);
                        System.debug('caseObj.Functional_Area__c>>>>>>>>' +caseObj.Functional_Area__c);
                        System.debug('caseObj.Category__c>>>>>>>>' +caseObj.Category__c);
                        System.debug('caseObj.Category__c>>>>>>>>' +caseObj.Core_License__r.Name);
                        si1.Module__c = caseObj.Module__r.Name;
                       //si1.Module__c = caseObj.Module__r.Name;
                        si1.Functional_Area__c = caseObj.Functional_Area__r.Name;
                        si1.Category__c = caseObj.Category__r.Name;
                        si1.System_Information__c = caseObj.Asset.Front_Back_Access__c;
                        //si1.Private_Description__c = caseObj.Description;
                        si1.Steps_to_Replicate__c = caseObj.A2__c;
                        si1.Reported_In_Version__c = caseObj.Asset.Version_Build__c;                    
                        si1.Product_ID__c = caseObj.Core_License__r.Name;
                        mapOfSIWithId.put(si1.Id, si1);
                    }
                    //learnJiraList.add(si1);                   
                    
                }
            }           
        }
        Utility.isFutureUpdate = true;
        if(mapOfSIWithId.size() > 0) {
            try {
                update mapOfSIWithId.values();
            } 
            catch (Exception Ex) {
                system.debug(Ex);
            } 
        }      
        
    }
    
  /*  public static void caseStatusUpdateEmail(List<Case> caseList, String EmailTemplateName) {
        
        Map<String, Id> mapOfEmailTemplateWithName = new Map<String, Id>();
        for (EmailTemplate e : [select Id,Name,Subject,body from EmailTemplate where name = : EmailTemplateName]){
            //emailtemplatelist.add(e);
            mapOfEmailTemplateWithName.put(e.Name, e.Id);
        }  
        List<String> emailList = new List<String>();
        for(Case caseObj : CaseList) {
            
            if(null != caseObj.Contact_Email__c) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //mail.setTargetObjectId(caseObj.Id);
                System.debug('Contact Email Id  >>>>>>' + caseObj.Contact_Email__c);
                System.debug('EmailTemplateName  >>>>>>' + EmailTemplateName);
                System.debug('EmailTemplateName Id  >>>>>>' + mapOfEmailTemplateWithName.get(EmailTemplateName));
                mail.setToAddresses(emailList);             
                emailList.add(caseObj.Contact_Email__c);
                if(EmailTemplateName.equals('JIRA Link Existing SI - Release Future Ref Email')) {
                    mail.setSubject('Case ' + CaseObj.CaseNumber +' linked to Known Issue');
                    mail.setPlainTextBody('Dear ' + caseObj.Contact_Name__c +', \n\nThis issue is being tracked as <KB number> and can be viewed in our known issues list here <link to KB article>.   It is currently targeted to be fixed in TR which is scheduled to be available TF \n\nDue to a variety of reasons, the bugs targeted to be fixed in a release can change.  If that should happen, you will receive an automatic notification of the target release and an expected timeframe for its availability.  The KB article for this issue will also be updated with the new target release and an expected timeframe for its availability. \n\nIf you would like to have a voice in our bug prioritization for an upcoming service pack, you can join our Bug Squad.Here is the link to sign up: https://behind.blackboard.com/System-Administrator/Learn/Client-Programs/Bug-Squad-Request.aspx.\n\n I am updating the status of this ticket to Closed – Pending Upgrade to reflect that you are aware of the current target version and awaiting the availability of the release.\n\n Sincerely, \n\n Blackboard Inc.');
                } else if(EmailTemplateName.equals('JIRA Link Existing SI - Release Future Ref Email')) {   
                    mail.setSubject('Case ' + CaseObj.CaseNumber +' linked to Known Issue');
                    mail.setPlainTextBody('Dear ' + caseObj.Contact_Name__c +', \n\nThis issue is being tracked as <KB number> and can be viewed in our known issues list here <link to KB article>.   It is currently targeted to be fixed in TR which is scheduled to be available TF \n\nDue to a variety of reasons, the bugs targeted to be fixed in a release can change.  If that should happen, you will receive an automatic notification of the target release and an expected timeframe for its availability.  The KB article for this issue will also be updated with the new target release and an expected timeframe for its availability. \n\nIf you would like to have a voice in our bug prioritization for an upcoming service pack, you can join our Bug Squad.Here is the link to sign up: https://behind.blackboard.com/System-Administrator/Learn/Client-Programs/Bug-Squad-Request.aspx.\n\n I am updating the status of this ticket to Closed – Pending Upgrade to reflect that you are aware of the current target version and awaiting the availability of the release.\n\n Sincerely, \n\n Blackboard Inc.');
                } else if(EmailTemplateName.equals('')) {
                    
                    mail.setSubject('Case ' + CaseObj.CaseNumber +' linked to Known Issue');
                    mail.setPlainTextBody('Dear ' + caseObj.Contact_Name__c +', \n\nThis issue is being tracked as <KB number> and can be viewed in our known issues list here <link to KB article>.   It is currently targeted to be fixed in TR which is scheduled to be available TF \n\nDue to a variety of reasons, the bugs targeted to be fixed in a release can change.  If that should happen, you will receive an automatic notification of the target release and an expected timeframe for its availability.  The KB article for this issue will also be updated with the new target release and an expected timeframe for its availability. \n\nIf you would like to have a voice in our bug prioritization for an upcoming service pack, you can join our Bug Squad.Here is the link to sign up: https://behind.blackboard.com/System-Administrator/Learn/Client-Programs/Bug-Squad-Request.aspx.\n\n I am updating the status of this ticket to Closed – Pending Upgrade to reflect that you are aware of the current target version and awaiting the availability of the release.\n\n Sincerely, \n\n Blackboard Inc.');
                }                                                                               

                //mail.setTemplateId(mapOfEmailTemplateWithName.get(EmailTemplateName));
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } else {
                System.debug('No Contact Email Id Defined');
            }
        }
    }
    */
    
    
      static testMethod void testSave() { 
      
          set<Id> setOfSI = new set<Id>();
          List<learnJIRA__c> ljr = new List<learnJIRA__c>();
          
          Account ac =TestMethodUtility.createAccount();
          insert ac;
          
          contact c =TestMethodUtility.createContact(ac);
          insert c;
          
          Core_License__c cl =TestMethodUtility.createCoreLicense();
          insert cl;
          
          Module__c m =TestMethodUtility.createModule(cl);
          insert m;
          
          case cc = TestMethodUtility.createCase(c,cl,ac,m);
          insert cc;
         
          
          learnJIRA__c si1= TestMethodUtility.createSupportIncident(cc);
          si1.Summary__c='test1';
          ljr.add(si1);
          
          learnJIRA__c si2= TestMethodUtility.createSupportIncident(cc);
          si2.Summary__c='test2';
          ljr.add(si2);
          
          learnJIRA__c si3= TestMethodUtility.createSupportIncident(cc);
          si3.Summary__c='test3';
          ljr.add(si3);
          
          insert ljr;
          
          Solution  s2 = TestMethodUtility.Createsolution(); 
          s2.CurrencyIsoCode='GBP';
          s2.SolutionName='test2 solution';
          s2.iscopy__c = true;
          s2.status='In review';
          s2.Change_Status_12_months__c=False;
          s2.Support_Incident__c=si1.id;
          
          Insert s2;
          
          For(learnJIRA__c si :ljr)
          setOfSI.add(si.Id); 
          
          Utility.updateSIWithCase(setOfSI,false);
          Utility.isFutureUpdate = true;
          
          Utility.updateSIWithCase(setOfSI,True);
          Utility.isFutureUpdate = true;
      }
}