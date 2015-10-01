public class SendToCustomer {
public List<Contact> contactList{get;set;}
public string pageLink {get;set;}
public string pageLinkvalue {get;set;}
public string itemId {get;set;}
public list<Contact_Role_Selector__c> crslist {get;set;}
public Id AccountID {get;set;}
public list<Contact_Role__c> crlist {get;set;}

public String theId;

    public SendToCustomer(ApexPages.StandardController controller) {
    theId = ApexPages.currentPage().getParameters().get('id');
    //pageLink = 'www.google.com';
    
    loadContacts(); 
    }
    
public void loadContacts(){
  
  
    opportunity opp = [Select id, AccountId from Opportunity Where id =: theId];
    
    AccountID = opp.AccountId;
    
    contactList = [Select id, Name from Contact Where AccountId =: AccountID];
  
    crlist = [Select id, Name, Role__c, Contact__c, Contact__r.AccountId, Contact__r.Name, Contact__r.Contact_Status__c,  Contact__r.Email from Contact_Role__c Where Role__c ='LEARN - Academic Developer' AND Contact__r.AccountId =: AccountID  ];
    
    system.debug('The crlist is: '+crlist);
    system.debug('The crlist is: '+crlist.size());
  
  
    crsList = [Select id, Contact_Role__c, Contact_Role__r.Contact__c,Contact_Role__r.role__c,Contact_Role__r.Contact__r.Name,Contact_Role__r.Contact__r.FirstName,Contact_Role__r.Contact__r.Contact_Status__c,Contact_Role__r.Contact__r.Email, Opportunity__c, Contact_Name__c, Account_Name__c, Contact_Email__c, Role__c from Contact_Role_Selector__c Where Opportunity__c =:theId and Contact_Role__r.role__c in ('Learn - Primary Sales Contact','Learn - Primary Sales Technical Contact')];
    system.debug('***'+crsList);

}


/*public pagereference sendEmail(){

    if(crsList.size()>0){
     for(Contact_Role_Selector__c  crs : crsList){
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     
        if (crs.Contact_Role__r.Contact__r.Email!= null ) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            //pageLink = 'https://blackboard--qax.cs30.my.salesforce.com/apex/RenewalOppDetail?Id='+theId;
            pageLink = 'http://qax-blackboard.cs30.force.com/apex/RenewalOppDetail?Id='+theId;
            sendTo.add(crs.Contact_Role__r.Contact__r.Email);
            mail.setToAddresses(sendTo);
            mail.setReplyTo('murugappan.alagappan@gmail.com');
            mail.setSenderDisplayName('BbDN Support');
            mail.setSubject('BbDN Renewal Alert Notification');
            String body = 'Dear ' + crs.Contact_Role__r.Contact__r.FirstName + ', ' + '<br/>'+ '<br/>';
            body += 'Your Blackboard Building Blocks Partnership and development licenses will expire on <b>April 14, 2015</b>.'+ '<br/>'+ '<br/>'; 
            body += ' <a href="' + pageLink + '";>'+'Click here to begin the renewal process'+'</a>'+ '<br/>'+ '<br/>';
            body += 'You will need to use your Behind the Blackboard credentials to log into the site. Please email us at BbPartnerRenewals@blackboard.com if you have any trouble accessing the site.'+ '<br/>'+ '<br/>';
            body += 'Renew by April 1st and be entered to win a featured banner on the '+'<a href=" '+ 'http://www.blackboard.com/Partnerships/Extensions.aspx'+ '";>'+'Blackboard Extensions'+'</a>'+' website or a spotlight feature in our'+'<a href=" '+ 'http://bbbb.blackboard.com/PartnerNewsletter_January2013'+ '";>' + ' Blackboard Partnerships Newsletter'+'</a>'+' to Blackboard’s higher-education clients in North America.'+'<br/>'+'<br/>';
            body += 'Thank you for your continued partnership with Blackboard. Please email me with questions.'+ '<br/>'+ '<br/>';
            body += 'Best Regards,'+ '<br/>';
            body += 'SSI Renewal Analyst'+'<br/>';
            body += 'Email Address';
            mail.setHtmlBody(body);
            
            mails.add(mail);
         }
         
          Messaging.sendEmail(mails);

       }
     } 
          
        note n = new note();
        n.parentId= theId; //Id of the opportunity for which you want to add this note
        n.body='Renewal Notofication sent to'; // body of the note. this should be populated from the notes field that you have shown in the screenshot
        n.title='Renewal Notofication sent to'; // the title of the note
        n.isPrivate=false;  // if private it will be visible only for the owner and any user with modify all permission
        insert n; //insert the record
          
          
          PageReference pageRef = new PageReference('/'+theId);
          return pageRef;
 }*/
 
 
 
 
 
public pagereference sendEmail(){

    if(crlist.size()>0){
     for(Contact_Role__c  crs : crlist){
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     
        if (crs.Contact__r.Email!= null ) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            //pageLink = 'https://blackboard--qax.cs30.my.salesforce.com/apex/RenewalOppDetail?Id='+theId;
            BBDN_Values__c values = BBDN_Values__c.getInstance('HPP_End_Point');
            
            pageLinkvalue = values.pageLink__c;
            pageLink = pageLinkvalue+theId;
            
            //pageLink = 'http://qax-blackboard.cs30.force.com/apex/RenewalOppDetail?Id='+theId;
            sendTo.add(crs.Contact__r.Email);
            mail.setToAddresses(sendTo);
            mail.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail.setSubject('BbDN Renewal Alert Notification');
            String body = 'Dear ' + crs.Contact__r.Name + ', ' + '<br/>'+ '<br/>';
            //body += 'Your Blackboard Building Blocks Partnership and development licenses will expire on <b>April 14, 2015</b>.'+ '<br/>'+ '<br/>'; 
            //body += ' <a href="' + pageLink + '";>'+'Click here to begin the renewal process'+'</a>'+ '<br/>'+ '<br/>';
            //body += 'You will need to use your Behind the Blackboard credentials to log into the site. Please email us at BbPartnerRenewals@blackboard.com if you have any trouble accessing the site.'+ '<br/>'+ '<br/>';
            //body += 'Renew by April 1st and be entered to win a featured banner on the '+'<a href=" '+ 'http://www.blackboard.com/Partnerships/Extensions.aspx'+ '";>'+'Blackboard Extensions'+'</a>'+' website or a spotlight feature in our'+'<a href=" '+ 'http://bbbb.blackboard.com/PartnerNewsletter_January2013'+ '";>' + ' Blackboard Partnerships Newsletter'+'</a>'+' to Blackboard’s higher-education clients in North America.'+'<br/>'+'<br/>';
            //body += 'Thank you for your continued partnership with Blackboard. Please email me with questions.'+ '<br/>'+ '<br/>';
            //body += 'Best Regards,'+ '<br/>';
            //body += 'Blackboard Partnerships'+'<br/>';
            //body += 'BbPartnerRenewals@blackboard.com';
            body += 'Your Blackboard Building Blocks Partnership and development license(s) <b> expire on April 14, 2015</b>.'; 
            body += ' Please click '+ ' <a href="' + pageLink + '";>'+'here'+'</a>'+ ' to renew online.'+ '<br/>'+ '<br/>';
            body += 'If you have forgotten your login credentials, simply reply to this email and we will reset your password for you. As a reminder, all renewals submitted after the 4/14/2015 deadline are subject to a <b>$250 late fee</b>.';
            body += ' If you have questions or do not wish to renew your partnership, please email us at BbPartnerRenewals@blackboard.com.'+'<br/>'+'<br/>';
            body += 'Thank you for your continued support and partnership.'+ '<br/>'+ '<br/>';
            body += 'Best Regards,'+ '<br/>';
            body += 'Blackboard Partnerships'+'<br/>';
            body += 'BbPartnerRenewals@blackboard.com'+'<br/>';
            
            mail.setHtmlBody(body);
            
            mails.add(mail);
         }
          
          system.debug('***'+mails);
          Messaging.sendEmail(mails);
          system.debug('***'+mails);

       }
     } 
          
        note n = new note();
        n.parentId= theId; //Id of the opportunity for which you want to add this note
        n.body='Renewal Notification sent to All Contacts'; // body of the note. this should be populated from the notes field that you have shown in the screenshot
        n.title='Renewal Notification sent to All Contacts'; // the title of the note
        n.isPrivate=false;  // if private it will be visible only for the owner and any user with modify all permission
        insert n; //insert the record
          
          
          PageReference pageRef = new PageReference('/'+theId);
          return pageRef;
 }
 
 
 
 

public pagereference sendEmailToContact(){

     system.debug('$$$$$$$$$$$$$'+ crlist.size());
     
     list<Contact> conList = [select id,name,email,FirstName from contact where id =:itemId];
     
     system.debug('$$$$$$$$$$$$$'+ conList.size());
     
     if(conList.size()>0){
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if (crlist[0].Contact__r.Email != null) { 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            BBDN_Values__c values = BBDN_Values__c.getInstance('HPP_End_Point');
            
            pageLinkvalue = values.pageLink__c;
            pageLink = pageLinkvalue+theId;
            sendTo.add(conList[0].Email);
            system.debug('$$$$$$$$$$'+conList[0].Email);
            mail.setToAddresses(sendTo);
            mail.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail.setSubject('Renew Your Blackboard Building Blocks Partnership Now');
            String body = 'Dear ' + conList[0].Name + ', ' + '<br/>'+ '<br/>';
            body += 'Your Blackboard Building Blocks Partnership and development license(s) <b> expire on April 14, 2015</b>.'; 
            body += ' Please click '+ ' <a href="' + pageLink + '";>'+'here'+'</a>'+ ' to renew online.'+ '<br/>'+ '<br/>';
            body += 'If you have forgotten your login credentials, simply reply to this email and we will reset your password for you. As a reminder, all renewals submitted after the 4/14/2015 deadline are subject to a <b>$250 late fee</b>.';
            body += ' If you have questions or do not wish to renew your partnership, please email us at BbPartnerRenewals@blackboard.com.'+'<br/>'+'<br/>';
            body += 'Thank you for your continued support and partnership.'+ '<br/>'+ '<br/>';
            body += 'Best Regards,'+ '<br/>';
            body += 'Blackboard Partnerships'+'<br/>';
            body += 'BbPartnerRenewals@blackboard.com'+'<br/>';
            mail.setHtmlBody(body);
            mails.add(mail);
         }
         
          List<Messaging.SendEmailResult> results  = Messaging.sendEmail(mails);
          system.debug('$$$$$$$$$$'+results);
       if (!results.get(0).isSuccess()) {
          System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
          String errorMessage = results.get(0).getErrors()[0].getMessage();
        }

       }
       
        note n = new note();
        n.parentId= theId; //Id of the opportunity for which you want to add this note
        n.body='Renewal Notification sent to '+conList[0].Name; // body of the note. this should be populated from the notes field that you have shown in the screenshot
        n.title='Renewal Notification sent to '+conList[0].Name; // the title of the note
        n.isPrivate=false;  // if private it will be visible only for the owner and any user with modify all permission
        insert n; //insert the record
               
       
       
       
       PageReference pageRef = new PageReference('/'+theId);
       return pageRef;
      
   }
   
   
   
    


}