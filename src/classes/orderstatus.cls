public class orderstatus {
public string Oppid {get;set;}
public string[] idVal {get;set;}
public Id opportunityId {get;set;}
public boolean doShowSuccess {get;set;}
public string oppaccname {get;set;}
public string oppaccountbillingstreet {get;set;}
public string oppaccountbillingcountry {get;set;}
public string oppaccountbillingcity {get;set;}
public string oppaccountbiillingstate {get;set;}
public string oppaccountbillingpostalcode {get;set;}
public list<User> u {get;set;}
public date enddate {get;set;}
public list<attachment> att {get;set;}
public string totalval {get;set;}
public string totaltaxval {get;set;}
public string totalolival {get;set;}
public string secolivalues {get;set;}
public string partf {set;get;}

public orderstatus(){

    
    u = new List<User>([select ID, NAme, ContactID, Contact.Email from USer where ID =: Userinfo.getUserID()]);
    system.debug('THE USER IS'+u[0].Name + 'and the email is' +u[0].Contact.Email);
    
    OppId = ApexPages.currentPage().getParameters().get('id');
    system.debug('OPPID IS'+OppId);
    
    idVal = OppId.split('\\/');
    opportunityId = idVal[0];
    system.debug('opportunityId IS'+opportunityId);
    totalval = idVal[1];
    string[] totalvala = totalval.split('\\=');
    totalval = totalvala[1];
    system.debug('TotalVal is:'+totalval);
    
    
    
      
    
    totalolival = idVal[2];
    string[] totalolivala = totalolival.split('\\=');
    totalolival = totalolivala[1];
    system.debug('TotaloliVal is:'+totalolival);
    
    
    totaltaxval = idVal[3];
    string[] totaltaxvala = totaltaxval.split('\\=');
    totaltaxval = totaltaxvala[1];
    system.debug('TotaltaxVal is:'+totaltaxval);
    
      
      secolivalues =  idVal[4];
      system.debug('The secolivalues are:'+secolivalues);
      string[] part;
      part = secolivalues.split('\\$');
      string parta;
      parta = part[1];
      string[] partb = parta.split('\\(');
      string partc = partb[1];
      string[] partd = partc.split('\\)');
      string parte = partd[0];
      system.debug('Value of PART E IS:'+parte);
      partf = parte.replace(',', '<br>');
      system.debug('Value of PART F IS:'+partf); 
    
    
    opportunity opp = [Select id, AccountId, CCP_Response_Message__c,End_Date__c, Account.BillingStreet, BbDN_Renewal_Processed__c, Account.BillingCity, Account.BillingState, Account.BillingCountry,
                       Account.BillingPostalCode, Account.Name, Account.PS_Company_Id__c, Name from Opportunity Where Id =: opportunityId];
    
    oppaccname = opp.Account.name; 
    oppaccountbillingstreet = opp.Account.BillingStreet;
    oppaccountbillingcity = opp.Account.BillingCity;
    oppaccountbiillingstate = opp.Account.BillingState;
    oppaccountbillingpostalcode = opp.Account.BillingPostalCode;
    oppaccountbillingcountry = opp.Account.BillingCountry;
    enddate = opp.End_Date__c;
        
    
    if(opp.CCP_Response_Message__c == 'Success'){
        doShowSuccess = true;
    }
    
    else{
        doShowSuccess = false;
    
    }
    

}






/*public PageReference sendEmail() {
   
    
     string totalv = ApexPages.currentPage().getParameters().get('totalv');
     string totaloliv = ApexPages.currentPage().getParameters().get('totaloliv');
     string totaltaxv = ApexPages.currentPage().getParameters().get('totaltaxv');
     String urlVal = Apexpages.currentPage().getUrl();
     
     system.debug('VAL IS'+totalv);
     system.debug('VAL IS'+totaloliv);
     system.debug('VAL IS'+urlVal);
     
     string[] part = urlVal.split('\\/');
     system.debug('VAL IS'+part);
     
     
     
     string ccvalue= 'Yes';
     string wpovalue= 'No';
     string wopovalue='No';
     
     
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add('murugappan.alagappan@blackboard.com');
            mail.setToAddresses(sendTo);
            mail.setReplyTo('murugappan.alagappan@blackboard.com');
            mail.setSenderDisplayName('BbDN Support');
            mail.setSubject('Internal Copy: Blackboard Building Blocks Partnership Renewal – '+oppaccname);
            String body = '';
            body += '<b>Blackboard Building Blocks Partnership Renewal – </b>'+ oppaccname+ '<br/>'+ '<br/>'; 
            body += '<b><u>Company Information:</u></b>'+'<br/>'+ '<br/>';
            body += 'Company Name:'+' '+ oppaccname  +'<br/>'+'<br/>';
            body += 'Address:'+' '+ oppaccountbillingstreet  +'<br/>'+'<br/>';
            body += 'Country:'+' '+ oppaccountbillingcountry  +'<br/>'+'<br/>';
            body += 'City:'+' '+ oppaccountbillingcity  +'<br/>'+'<br/>';
            body += 'State/Province:'+' '+ oppaccountbiillingstate  +'<br/>'+'<br/>';
            body += 'Postal Code:'+' '+ oppaccountbillingpostalcode +'<br/>'+'<br/>';
            //body += 'E-Mail:'+' '+u[0].Contact.Email+ '<br/>'+'<br/>';
            body += '<b><u>Subscription Options:</u></b>'+ '<br/>'+ '<br/>';
            body += ''+ partf +'<br/>'+ '<br/>';
            
            body += '<b><u>Billing Information:</u></b>'+ '<br/>'+ '<br/>';
            body += '<b><u>Payment Method Selected: </u></b>'+ '<br/>'+ '<br/>';
            body += 'Pay by Credit Card:'+' '+ ccvalue + '<br/>'+ '<br/>';
            body += 'Pay by Check without a PO:'+' '+ wpovalue + '<br/>'+ '<br/>';
            body += 'Pay by Check requires a PO:'+' ' + wopovalue + '<br/>'+ '<br/>';
            body += 'Renewal Fees:'+ ''+ totalolival +'<br/>'+ '<br/>';
            body += 'Taxes:' + ''+totaltaxval + '<br/>' + '<br/>';
            body += 'Total Amount:' +''+ totalval +'<br/>'+ '<br/>';
            
            
            
            body += 'Payment has been submitted from Behind the Blackboard and a receipt has been sent to '+u[0].Contact.Email+'.';
                   
            mail.setHtmlBody(body);
            
            mails.add(mail);
       
         
            Messaging.sendEmail(mails); 
          
            system.debug('The OPP ID is:'+opportunityId);
            att = [SELECT id, Name, Body, BodyLength FROM Attachment WHERE ParentID =: opportunityId LIMIT 1];
            system.debug('The size is: '+att.size());
            system.debug('The att name is:'+att);
            
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('BbDN_Aggrement.pdf');
            efa.setBody(att[0].Body);
            fileAttachments.add(efa);
            
            
            List<Messaging.SingleEmailMessage> mails2 = new List<Messaging.SingleEmailMessage>();
     
            Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
            List<String> sendTo2 = new List<String>();
            sendTo2.add('murugappan.alagappan@blackboard.com');
            mail2.setToAddresses(sendTo2);
            mail2.setReplyTo('murugappan.alagappan@blackboard.com');
            mail2.setSenderDisplayName('BbDN Support');
            mail2.setSubject('Your Blackboard Building Blocks Partnership Renewal');
            mail2.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            String body2 = 'Date' + ' ' + system.today().format() +'<br/>'+'<br/>';
            body2 += 'Dear ' + u[0].Name +'<br/>'+'<br/>';
            body2 += 'Thank you for renewing your Blackboard Building Blocks™ partnership and developer license(s). Attached are the terms and conditions that govern your participation in the Blackboard Building Blocks partnership program and your use of the developer license(s). You will receive an email with your license(s) and installation instructions in 3-5 business days. Please find your order summary below.'+ '<br/>'+ '<br/>'; 
            body2 += '<b><u>Ordered Products</u></b>'+'<br/>'+ '<br/>';
            body2 += ''+ partf +'<br/>'+ '<br/>';
            
            
            body2 += '<b> <u>Order Summary</u> </b>'+ '<br/>'+ '<br/>';
            body2 += 'Order Amount:' +''+ totalolival +'<br/>'+ '<br/>';
            body2 += 'Taxes (if applicable):'+'' + totaltaxval  + '<br/>'+ '<br/>';
            body2 += 'Total Amount Paid:' +''+ totalval +'<br/>'+ '<br/>';
            body2 += 'Membership Expiration:'+ ' '+enddate.format() +'<br/>'+ '<br/>';
            
            body2 += 'Please contact us at BbPartnerRenewals@blackboard.com, with any questions.' +'<br/>'+'<br/>';
            
            body2 += 'Best regards,' + '<br/>'+ '<br/>';
            
            
                   
            mail2.setHtmlBody(body2);
            
            mails2.add(mail2);
       
         
          Messaging.sendEmail(mails2);
          
          

   return null;
    
 } */







}