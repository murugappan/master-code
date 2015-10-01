@RestResource(urlMapping='/rqstrspnse/*')

global class MyRestResource {

    @HttpPost
    global static void doPost(string resultset){
    
        
           /*response_code=1&response_msg=Success&cc_err_code=1&cc_return_msg=Approved.
           &auth_code=128874&fraud_status=None&mode=Y&
           order_id=BBDN-0067000000adRfr_1422911694019&tran_id=54cf8c91-2776-3000-008c-0003ba9896f7&
           tran_status=A&merchant_data=Tuition Payment&avs_display=&
           notice=&cvv2_resp=&date_time=1422911728748 */
           
           
            string stringvalue = resultset;
             
            
             
            string[] part;

            part = stringvalue.split('\\&');

            string[] partresponsemsg;

            partresponsemsg = part[1].split('\\=');
            
            string response_msg;
            
            response_msg = partresponsemsg[1];
            
            
            string[] orderidval;
            
            orderidval = part[7].split('\\-');
            
            string[] ordervalsplit;
            
            ordervalsplit =  orderidval[1].split('\\_');
            
            string order_id;
            
            order_id = ordervalsplit[0];
            
           
            string[] responsecodeval;
            
            responsecodeval = part[0].split('\\=');
            
            string response_code;
            
            response_code = responsecodeval[1];
            
            
            string[] authcodeval;
            
            authcodeval = part[4].split('\\=');
            
            string auth_code;
            
            auth_code = authcodeval[1];
            
            
            string[] tranidval;
            
            tranidval = part[8].split('\\=');
            
            string tran_id;
            
            tran_id = tranidval[1];
            
            
          
            
            
            
            datetime lastauthdate;
            
            lastauthdate = system.now();
            
           
               
            Opportunity opp = new Opportunity();
            opp.Id = order_id;
            opp.CCP_Response_Message__c = response_msg;
            opp.CCP_Response_Code__c = response_code;
            opp.CCP_Auth_Code__c = auth_code;
            opp.CCP_Last_Auth_DateTimeStamp__c = lastauthdate;
            if(response_msg == 'Success'){
            opp.CPQ_PO_Number__c = tran_id;
            opp.CPQ_PO_Required__c = 'No';
            opp.BbDN_Renewal_Processed__c = true;
            
            
            //sending email to the internal team and customer if success:
            
            Opportunity opptoquery = [Select id, AccountId, Account.Fax, Account.BillingStreet, End_Date__c, BbDN_Renewal_Processed__c, Account.BillingCity, Account.BillingState, Account.BillingCountry,
                                     Account.BillingPostalCode, Sec_Oli_Dropped_Values__c, Account.Name, latefeevalue__c, Sec_Oli_Values__c,MyRestResource_Email__c, MyRestResource_Name__c, Account.PS_Company_Id__c, MyRestResource_totalv__c, MyRestResource_totaloliv__c, MyRestResource_totataxv__c, Name from Opportunity Where Id =: order_id];
            
              string part2d;
              if(opptoquery.Sec_Oli_Dropped_Values__c != null){
              string[] part2 = opptoquery.Sec_Oli_Dropped_Values__c.split('\\(');
              string part2a;
              part2a = part2[1];
              string[] part2b = part2a.split('\\)');
              string part2c = part2b[0];
              
              part2d = part2c.replace(',', '<br>');
              
              
              
              }
      
           
            List<Attachment> att = [SELECT id, Name, Body, BodyLength FROM Attachment WHERE ParentID =: order_id LIMIT 1];
            system.debug('The size is: '+att.size());
            system.debug('The att name is:'+att);
            
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('BbDN_Aggrement.pdf');
            efa.setBody(att[0].Body);
            fileAttachments.add(efa); 
           
           
           
           
           
           
           
           List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     
       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add('BbPartnerRenewals@Blackboard.com');
            //sendTo.add('murugappan.alagappan@gmail.com');
            mail.setToAddresses(sendTo);
            mail.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail.setCcAddresses(new String[] {'Nicole.Kindle@Blackboard.com', 'Lloyd.Boateng@Blackboard.com','murugappan.alagappan@blackboard.com'});
            mail.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail.setSubject('Internal Copy: Blackboard Building Blocks Partnership Renewal – '+opptoquery.Account.name);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            String body = '';
            body += '<b>Blackboard Building Blocks Partnership Renewal – </b>'+ opptoquery.Account.name+ '<br/>'+ '<br/>'; 
            body += '<b><u>Company Information:</u></b>'+'<br/>'+ '<br/>';
            body += 'Company Name:'+' '+ opptoquery.Account.Name  +'<br/>'+'<br/>';
            body += 'Address:'+' '+ opptoquery.Account.BillingStreet  +'<br/>'+'<br/>';
            body += 'Country:'+' '+ opptoquery.Account.BillingCountry  +'<br/>'+'<br/>';
            body += 'City:'+' '+ opptoquery.Account.BillingCity  +'<br/>'+'<br/>';
            body += 'State/Province:'+' '+ opptoquery.Account.BillingState  +'<br/>'+'<br/>';
            body += 'Postal Code:'+' '+ opptoquery.Account.BillingPostalCode +'<br/>'+'<br/>';
            body += 'E-Mail:'+' '+opptoquery.MyRestResource_Email__c+ '<br/>'+'<br/>';
            body += '<b><u>Subscription Options:</u></b>'+ '<br/>'+ '<br/>';
            
            body += ''+ opptoquery.Sec_Oli_Values__c +'<br/>'+ '<br/>';
            
             
            if(opptoquery.Sec_Oli_Dropped_Values__c != null){
                body += ''+ part2d +'<br/>'+ '<br/>'; 
            }
            
            body += '<b><u>Billing Information:</u></b>'+ '<br/>'+ '<br/>';
            body += '<b><u>Payment Method Selected: </u></b>'+ '<br/>'+ '<br/>';
            body += 'Pay by Credit Card:'+' '+ 'Yes' + '<br/>'+ '<br/>';
            body += 'Pay by Check without a PO:'+' '+ 'No' + '<br/>'+ '<br/>';
            body += 'Pay by Check requires a PO:'+' ' + 'No' + '<br/>'+ '<br/>';
            body += 'Renewal Fees:'+ ''+ opptoquery.MyRestResource_totaloliv__c +'<br/>'+ '<br/>';
            body += 'Taxes:' + ''+opptoquery.MyRestResource_totataxv__c + '<br/>' + '<br/>';
            if(opptoquery.latefeevalue__c != '$0'){
                body += 'Late Fee:' + ''+opptoquery.latefeevalue__c + '<br/>' + '<br/>';
            }
            body += 'Total Amount:' +''+ opptoquery.MyRestResource_totalv__c +'<br/>'+ '<br/>';
            
            
            
            body += 'Payment has been submitted from Behind the Blackboard and a receipt has been sent to '+opptoquery.MyRestResource_Email__c+'.';
                   
            mail.setHtmlBody(body);
            
            mails.add(mail);
      
         
            Messaging.sendEmail(mails);  
            
            
           
            
           /* List<Attachment> att = [SELECT id, Name, Body, BodyLength FROM Attachment WHERE ParentID =: order_id LIMIT 1];
            system.debug('The size is: '+att.size());
            system.debug('The att name is:'+att);
            
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('BbDN_Aggrement.pdf');
            efa.setBody(att[0].Body);
            fileAttachments.add(efa); */
          
           
           
           
            List<Messaging.SingleEmailMessage> mails2 = new List<Messaging.SingleEmailMessage>();
     
       
            Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
            List<String> sendTo2 = new List<String>();
            sendTo2.add(opptoquery.MyRestResource_Email__c);
            //sendTo2.add('murugappan.alagappan@gmail.com');
            mail2.setToAddresses(sendTo2);
            mail2.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail2.setCcAddresses(new String[] {'Nicole.Kindle@Blackboard.com', 'Lloyd.Boateng@Blackboard.com', 'murugappan.alagappan@blackboard.com'});
            
            mail2.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail2.setSubject('Your Blackboard Building Blocks Partnership Renewal');
            mail2.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            String body2 = 'Date' + ' ' + system.today().format() +'<br/>'+'<br/>';
            body2 += 'Dear ' + opptoquery.MyRestResource_Name__c +'<br/>'+'<br/>';
            body2 += 'Thank you for renewing your Blackboard Building Blocks™ partnership and developer license(s). Attached are the terms and conditions that govern your participation in the Blackboard Building Blocks partnership program and your use of the developer license(s). You will receive an email with your license(s) and installation instructions in 3-5 business days. Please find your order summary below.'+ '<br/>'+ '<br/>'; 
            body2 += '<b><u>Ordered Products</u></b>'+'<br/>'+ '<br/>';
            
            body2 += ''+ opptoquery.Sec_Oli_Values__c +'<br/>'+ '<br/>';
            
            if(opptoquery.Sec_Oli_Dropped_Values__c != null){
                body2 += ''+ part2d +'<br/>'+ '<br/>'; 
            }
            
            body2 += '<b> <u>Order Summary</u> </b>'+ '<br/>'+ '<br/>';
            body2 += 'Order Amount:' +''+ opptoquery.MyRestResource_totaloliv__c +'<br/>'+ '<br/>';
            body2 += 'Taxes (if applicable):'+'' + opptoquery.MyRestResource_totataxv__c  + '<br/>'+ '<br/>';
            body2 += 'Total Amount Paid:' +''+ opptoquery.MyRestResource_totalv__c +'<br/>'+ '<br/>';
            if(opptoquery.latefeevalue__c != '$0'){
                body2 += 'Late Fee:' + ''+opptoquery.latefeevalue__c + '<br/>' + '<br/>';
            }
            
            body2 += 'Membership Expiration:'+ ' '+opptoquery.End_Date__c.format() +'<br/>'+ '<br/>';
            body2 += 'Please contact us at BbPartnerRenewals@blackboard.com, with any questions.' +'<br/>'+'<br/>';
            
            body2 += 'Best regards,' + '<br/>';
            body2 += 'Blackboard Partnerships' + '<br/>';
            body2 += 'BbPartnerRenewals@blackboard.com,';
            
            
                   
            mail2.setHtmlBody(body2);
            
            mails2.add(mail2);
      
         
            Messaging.sendEmail(mails2); 
            
            
            
         
            
            Note noteval = new Note();
            noteval.Title = 'Transaction Details';
            noteval.ParentId = order_id;
            
            
            string prodval = opptoquery.Sec_Oli_Values__c.replace('<br>', '\r\n');
            system.debug('%%%'+prodval);
            
            string prodval1;
            if(opptoquery.Sec_Oli_Dropped_Values__c != null){
            string prodvala1 = part2d.replace(',', '<br>');
            prodval1 = part2d.replace('<br>', '\r\n');
            }
            
            

            String body1 = '';
            body1 += 'Blackboard Building Blocks Partnership Renewal – '+ opptoquery.Account.name + '\r\n'; 
            body1 += 'Company Information:' + '\r\n'; 
            body1 += 'Company Name:'+' '+ opptoquery.Account.name + '\r\n';
            body1 += 'Address:'+' '+ opptoquery.Account.BillingStreet + '\r\n';
            body1 += 'Country:'+' '+ opptoquery.Account.BillingCountry + '\r\n';
            body1 += 'City:'+' '+ opptoquery.Account.BillingCity  + '\r\n';
            body1 += 'State/Province:'+' '+ opptoquery.Account.BillingState + '\r\n';
            body1 += 'Postal Code:'+' '+ opptoquery.Account.BillingPostalCode + '\r\n';
            body1 += 'E-Mail:'+' '+opptoquery.MyRestResource_Email__c + '\r\n';
            body1 += 'Subscription Options:' + '\r\n';
            
            body1 += ''+ prodval + '\r\n';
            
              
            if(opptoquery.Sec_Oli_Dropped_Values__c != null){
                body1 += ''+ prodval1 + '\r\n';
            }
            
            body1 += 'Billing Information:' + '\r\n';
            body1 += 'Payment Method Selected:' + '\r\n';
            body1 += 'Pay by Credit Card:'+' '+ 'Yes' + '\r\n' ;
            body1 += 'Pay by Check without a PO:'+' '+ 'No' + '\r\n';
            body1 += 'Pay by Check requires a PO:'+' ' + 'No' + '\r\n';
            body1 += 'Renewal Fees:'+ ''+ opptoquery.MyRestResource_totaloliv__c + '\r\n';
            body1 += 'Taxes:' + ''+opptoquery.MyRestResource_totataxv__c + '\r\n';
            if(opptoquery.latefeevalue__c != '$0'){
                body1 += 'Late Fee:' + ''+opptoquery.latefeevalue__c + '\r\n';
            }
            body1 += 'Total Amount:' +''+ opptoquery.MyRestResource_totalv__c  + '\r\n';
            
            
            
            body1+= 'Payment has been submitted from Behind the Blackboard and a receipt has been sent to '+opptoquery.MyRestResource_Email__c+'.';
            noteval.Body = body1;
            insert noteval;          
          
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            }
            update opp;
               
               
               
           
    
           
           
           
           
   
           /*system.debug('VALUE OF RESULTSET IS:'+ resultset);
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {'murugappan.alagappan@blackboard.com'}; 
           
           mail.setToAddresses(toAddresses);
           mail.setSubject('RESULT');
           mail.setBccSender(false);
           mail.setUseSignature(false);
           mail.setPlainTextBody('The following is the result obtained: '+ resultset+ ' Value of response_msg is: '+response_msg+'Value of auth_code: '+auth_code+'Value of response_code'+response_code);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */
           
           
           
           
               

     }

}