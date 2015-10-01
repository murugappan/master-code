public  class searchcasecontroller {

public string inputstring {get;set;}
public string errText {get;set;}
public string errTextvalue {get;set;}
public list<EndUser__c> c {get;set;}
public Blob bb {get;set;}
public string cc {get;set;}
public string urll {get;set;}
public string novalidemailtext {get;set;}
public string aftersubmitText{get;set;}
public boolean brender {get;set;}
public string nocases {get;set;}

public searchcasecontroller(){
brender = false;
}

public void submit(){
    
    if(String.isNotBlank(inputstring)){
    errText = '';
    c = [Select id, Email__c from EndUser__c where Email__c =: inputstring LIMIT 1];
    
    if(c.size()>0){
        novalidemailtext = '';
        Id theID = c[0].id;
        String timestamp = system.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ');
        list<string>  slist= new list<string>();
        Slist.add(theID);
        Slist.add(timestamp);
        string strSSO = String.Format('{0};{1}',Slist);
        blob key=blob.valueof('b3H1nDTehB1@ckB0ard');
        blob md5key=Crypto.generateDigest('md5',key);
        string message=strSSO;
        blob encrypt= Crypto.encryptWithManagedIV('AES128', md5key, Blob.valueof(message));
       
    


 

        list<Case> caselist = [Select id, End_User__c from Case where End_User__c =:theID];
            if(caselist.size()>0){
                urll= URL.getSalesforceBaseUrl().toExternalForm() + '/btbb_edusrcasehistory?euid='+EncodingUtil.urlencode(EncodingUtil.base64Encode(encrypt),'UTF-8');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {inputstring}; 
                mail.setToAddresses(toAddresses);
                //mail.setSenderDisplayName('Salesforce Support');
                mail.setSubject('"Blackboard Support: Your Cases"');
                mail.setOrgWideEmailAddressId('0D270000000Gmrt');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody('Please click here to see the list of cases created by you: ' + urll);
                mail.setHtmlBody('Please click here to see the list of cases created by you: <b> ' + '<a href ="'+urll+'">View Cases</a>' + '<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>'+'<br/>');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                brender = true;
                aftersubmitText = 'An email has been sent to your inbox with a link to view the cases created by you'; 
            }
            
            else{
                //brender = true;
                nocases = 'There are no cases associated with this email.';
                errText='';
                novalidemailtext='';
            }
    
        }
        
        else if(c.size() == 0){
        novalidemailtext = 'The email provided is not a valid one. Please provide a valid email address to get a list of cases created by you in the past.';
        errText='';
        nocases='';
        
        }
    
    }
    
    else{
    errText = 'Input field cannot be blank, Please enter a valid e-mail address!';
    novalidemailtext= '';
    nocases='';
    }
       
}

}