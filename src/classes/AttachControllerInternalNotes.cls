public class AttachControllerInternalNotes{
    
    public AWSKeys credentials {get;set;}
    private String AWSCredentialName = 'Test Amazon Connection'; 
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public Case c {get;set;}
    public Case_Attachment__c record {get;set;}
    public S3.AmazonS3 as3 { get; private set; }
    public String contenttype {get;set;}
    String fname;
    public String comment{get;set;}
    public String subject{get;set;}
    public boolean showAttSec = false;
    public List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
    public List<Case_Attachment__c> caslist1 = new List<Case_Attachment__c>();
    public string con;
    public string internalonly {get;set;}
    public string URLred {get;set;}
    
    public boolean getshowAttSec(){
        return showAttSec;
    }
    
        
    public Pagereference updatefileinfo(){
       showAttSec = true;
       System.debug(showAttSec);
       String filname1 = ApexPages.CurrentPage().getParameters().get('flname');
       String filname= filname1.toLowerCase();
       String fname1;

       if(filname!= null){
           if(filname.contains('.')){
                String extension = filname1.substring(filname1.lastindexof('.')+1,filname1.length());
                System.debug(extension);
                List<File_Types__c> contype = new List<File_Types__c>([select ID,MIME_Type__c,Name from File_Types__c where Name =: extension limit 1]);                
                if(contype.size() > 0)
                    contenttype = contype[0].MIME_Type__c;
                else
                    contenttype = null;      
           }                   
           if(filname1.contains('\\'))
                filname1 = filname1.substring(filname1.lastindexof('\\')+1,filname1.length());
           
           String ext = filname1.substring(filname1.lastindexof('.'),filname1.length());  
           
           if(filname1.contains('.'))
                fname = filname1.substring(0,filname1.lastindexof('.'));
           else
                fname = filname1;

           System.debug(fname);
           System.debug(fname1);
           fname1 = fname;
           fname = fname + '-' + String.valueof(System.now().year())+ '-'+String.valueof(System.now().month())+'-'+String.valueof(System.now().day())+'-'+String.valueof(System.now().hour())+'-'+String.valueof(System.now().minute())+'-'+String.valueof(System.now().second());     
           System.debug(fname);
           fname1 = fname1 + '-' + String.valueof(System.now().year())+ '-'+String.valueof(System.now().month())+'-'+String.valueof(System.now().day())+'-'+String.valueof(System.now().hour())+'-'+String.valueof(System.now().minute())+'-'+String.valueof(System.now().second());     
           System.debug(fname1);
           fname1 = EncodingUtil.urlEncode(fname1,'UTF-8');
           fname = fname + ext;
           System.debug(fname);
           fname1 = fname1 + ext;
           System.debug(fname1);
        }
        Case_Attachment__c rec = new Case_Attachment__c();
        rec.Bucket_Name__c = 'SFDCTest';
        rec.file_name__c = filname1;
        if(contenttype != null)
            rec.Content_Type__c = contenttype;
        else
            rec.Content_Type__c = 'application/octet-stream';
        rec.Related_To__c = c.ID;
        rec.Access__c = 'private';
        rec.File_Name_w_ext__c = fname;
        rec.File_Name_URL__c = fname1;
        rec.Notes__c = comment;
        rec.Note_Info__c = subject;
        String recId = [select Id from RecordType where Name = 'Case Attaachment' limit 1].ID;    
        rec.RecordTypeID = recId;
        System.debug(internalonly);
           
        Upsert rec;
        if(caslist.size() > 0)
          delete caslist;
        caslist.add(rec);
        record = rec;
        System.debug(record);
        return null;
    }
    
    public Pagereference delCaseAttach(){
        delete caslist;
        Pagereference p = new Pagereference('/'+c.ID);
        p.setredirect(true);
        return p;
    }
  
    public AttachControllerInternalNotes(ApexPages.StandardController stdController) {
       
        if(ApexPages.CurrentPage().getParameters().get('caseID') != null)
            c = [select ID,CaseNumber from Case where ID =: ApexPages.CurrentPage().getParameters().get('caseID')];
        try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
        }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
       } 
       comment = ApexPages.CurrentPage().getParameters().get('usrcom');
       System.debug(comment);
       System.debug(comment.contains('\r\n'));
       String com1;
       if(comment.contains('\r\n')){
           com1 = comment.replace('\r\n','spacce');
           System.debug(com1);
           System.debug(com1);
           comment = com1;
       }   
       subject = ApexPages.CurrentPage().getParameters().get('sub');
       System.debug(subject);
       con = ApexPages.CurrentPage().getParameters().get('console');
       if(con == 'true')
            URLred = 'https://tapp0.salesforce.com/apex/BBW_CaseAddNote?isdtp=vw&ID='+c.ID+'&usrcom='+comment+'&usrsub='+subject;
       else if(con == 'false')  
            URLred = 'https://tapp0.salesforce.com/apex/BBW_CaseAddNote?ID='+c.ID+'&usrcom='+comment+'&usrsub='+subject; 
       System.debug(URLred); 
       System.debug(credentials.secret);
       System.debug(credentials.key);
    }
     
    Datetime expire = system.now().addDays(1);
    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
        expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
          
    string policy { get {return 
        '{ "expiration": "'+formattedexpire+
        '","conditions": [ {"bucket": "'+ record.Bucket_Name__c +
        '" } ,{ "acl": "'+  record.Access__c +'" },'+
        '{"content-type":"'+record.Content_Type__c+'"},'+
        '{"success_action_redirect": "'+URLred+'"},' +
        '["starts-with", "$key", ""] ]}';   } set; }         
   
    
    public String getPolicy() {
        System.debug(policy);
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
       
    public String getSignedPolicy() {    
        return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));        
    }
   
    public String getHexPolicy() {
        String p = getPolicy();
        return EncodingUtil.convertToHex(Blob.valueOf(p));
   }
    
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(Secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    private static testmethod void AttachControllerInternalNotesTest(){
        Account ac = new Account();
        ac.Name = 'BC';
        ac.BillingCity = 'BC';
        ac.BillingCountry = 'USA';
        ac.BillingPostalCode = 'BC';
        ac.BillingState = 'BC';
        ac.BillingStreet = 'BC';

        insert ac;

        Contact ct= new Contact ();
        
        ct.AccountId=ac.id;
        ct.LastName='AB';
        
        insert ct;
        
        Case c  = new Case();
        c.AccountID = ac.ID;
        c.ContactID = ct.ID;
        insert c;
        
        ApexPages.CurrentPage().getParameters().Put('caseID',c.ID);
        ApexPages.CurrentPage().getParameters().Put('usrcom','AB\r\nCD');
        ApexPages.CurrentPage().getParameters().Put('con','ACD');
        ApexPages.CurrentPage().getParameters().Put('console','false'); 
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);   
        AttachControllerInternalNotes act = new AttachControllerInternalNotes(controller);
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        act.updatefileinfo(); 
        act.getpolicy();
        act.getSignedPolicy();
        act.getHexPolicy();
        act.getshowAttSec();
        act.delCaseAttach();
    }
   
}