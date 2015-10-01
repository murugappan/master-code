public with sharing class testingbatch {



public void execute(){
    
     integer cnt;
     list<learnJIRA__c> ljs;
     list<learnJIRA__c> updatelist = new list<learnJIRA__c>();
     Known_Issue__kav kavtest;
     map<id,known_issue__kav>KImap=new map<id,known_issue__kav>();
     
     for(known_issue__kav ki : [SELECT id, KnowledgeArticleId, FirstPublishedDate,Summary, IsLatestVersion,VersionNumber, Title, PublishStatus, Support_Incident__c FROM Known_Issue__kav WHERE PublishStatus='Archived' AND Language = 'en_US' AND LastModifiedDate > :system.today().addDays(-60) AND isLatestVersion=true  ]){
          KImap.put(ki.KnowledgeArticleId,ki);
        
     
     }
  
     
     for(known_issue__kav ki : [SELECT id, KnowledgeArticleId,FirstPublishedDate,Summary, IsLatestVersion,VersionNumber, Title, PublishStatus, Support_Incident__c FROM Known_Issue__kav WHERE PublishStatus='Online' AND Language = 'en_US' AND LastModifiedDate > :system.today().addDays(-60) AND isLatestVersion=true  ]){
         KImap.put(ki.KnowledgeArticleId,ki);
     
     }
     
     //for(known_issue__kav ki : [SELECT id, KnowledgeArticleId,FirstPublishedDate,Summary,VersionNumber, IsLatestVersion, Title, PublishStatus, Support_Incident__c FROM Known_Issue__kav WHERE PublishStatus='Draft' AND Language = 'en_US' AND LastModifiedDate > :system.today().addDays(-60) AND isLatestVersion=true   ]){
       // KImap.put(ki.KnowledgeArticleId,ki);
        
     //system.debug('********' + ki.FirstPublishedDate);
     //}
      
      
     ljs =[Select id, Article_Version_Id__c, Article_First_Published_Date__c, Version_Number__c, Article_Id__c,Client_Facing_Description_HTML__c,Article_Id_18__c,Article_Title__c,Article_Published_Status__c from learnJIRA__c where Article_Id_18__c IN:KImap.keyset()];
     
     /*boolean flag;
     string ljstatus;
     for(learnJIRA__c lj : ljs){
         flag = false;
         ljstatus = lj.Article_Published_Status__c;
         if(ljstatus  == 'Published'){
             ljstatus  = 'Online';
         }
         system.debug('Murugappan' + lj.Version_Number__c);
         if(KImap.containskey(lj.Article_Id__c)){
            kavtest = KImap.get(lj.Article_Id__c);
            
            if((lj.Client_Facing_Description_HTML__c==null) || (lj.Article_Title__c==null) || (!lj.Client_Facing_Description_HTML__c.equals(kavtest.Summary))||(!lj.Article_Title__c.equals(kavtest.Title)))
            {
            lj.Client_Facing_Description_HTML__c = kavtest.Summary;
            lj.Article_Title__c= kavtest.Title;
            flag = true;
            }
            if(kavtest.PublishStatus != ljstatus ){
                if(kavtest.PublishStatus == 'Online'){
                    lj.Article_Published_Status__c = 'Published';
                }
                else{
                    lj.Article_Published_Status__c = kavtest.PublishStatus;
                }
                lj.Article_First_Published_Date__c = kavtest.FirstPublishedDate;
                if(kavtest.PublishStatus == 'Online'){
                    lj.Version_Number__c = string.valueOf(kavtest.VersionNumber);
                }
                flag = true;
            }
            if(lj.Article_Version_Id__c != kavtest.id){
                lj.Article_Version_Id__c = kavtest.id;
                system.debug(lj.Article_Version_Id__c);
                system.debug(lj.Version_Number__c);
                if(lj.Version_Number__c == null){
                    lj.Version_Number__c = 0 + '';
                }
                if(kavtest.VersionNumber!=null)
                {
                    lj.Version_Number__c = string.valueOf(kavtest.VersionNumber);
                }

                system.debug(lj.Article_First_Published_Date__c); 
                flag = true;
            }
            if(flag == true){
            updatelist.add(lj);
            cnt = updatelist.size();
            }
        }   
     
     }*/
     /*try{
     update updatelist;
     }
     catch (Exception e){
     
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {'murugappan.alagappan@blackboard.com','heather.maniscalco@blackboard.com'}; 
   //String[] ccAddresses = new String[] {'testcc1@mail.com','testcc1@mail.com'};
   mail.setToAddresses(toAddresses);
   //mail.setCcAddresses(ccAddresses);
   //mail.setSenderDisplayName('My Name');
   mail.setSubject('Batch Process Failed');
   mail.setBccSender(false);
   mail.setUseSignature(false);
   mail.setPlainTextBody('The following exception has occurred: '+ e.getMessage());
   
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     
     }*/
     
     
     /////
     
     
     for(learnJIRA__c lj : ljs){
     
     
             if(KImap.containskey(lj.Article_Id_18__c)){
                    kavtest = KImap.get(lj.Article_Id_18__c);
                    
                    
                    if((lj.Client_Facing_Description_HTML__c==null) || (lj.Article_Title__c==null) || (!lj.Client_Facing_Description_HTML__c.equals(kavtest.Summary))||(!lj.Article_Title__c.equals(kavtest.Title)) || (lj.Article_First_Published_Date__c == null)|| (!lj.Article_Published_Status__c.equals(kavtest.PublishStatus)))
                    {
                            lj.Client_Facing_Description_HTML__c = kavtest.Summary;
                            lj.Article_Title__c= kavtest.Title;
                            
                            if(lj.Article_First_Published_Date__c != null){
                                    lj.Article_First_Published_Date__c = kavtest.FirstPublishedDate;
                            }
                            
                            
                            
                            
                            lj.Article_Published_Status__c = kavtest.PublishStatus;
                            lj.Version_Number__c = string.valueOf(kavtest.VersionNumber);
                            lj.Client_Facing_Description_HTML__c = kavtest.Summary;
                            lj.Article_Title__c = kavtest.Title;
                            lj.Article_First_Published_Date__c = kavtest.FirstPublishedDate;
                            lj.Article_Version_Id__c = kavtest.Id;
                            lj.Article_ID__c = kavtest.KnowledgeArticleId;                            
                                                        

                            
                    }
                    
                    
                        updatelist.add(lj);    
                    
             }
                         
     
     
     
     
     }
     
     try{
                              update updatelist;
        }
    
    catch (Exception e){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'murugappan.alagappan@blackboard.com','heather.maniscalco@blackboard.com'}; 
        mail.setToAddresses(toAddresses); 
        mail.setSubject('Batch Process Failed');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('The following exception has occurred: '+ e.getMessage());
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
    }
     
     
    
     
     } 
}