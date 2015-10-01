public class btbb_fileupload_controller {
    public integer listsize                                            {get;set;}
    public String instanceurl                                                 {get;set;}
    public Case c                                                             {get;set;}
    public Boolean showDone;
    public Boolean showDelete;
    public Boolean showAttach;
    public Boolean disableFileInput = false;
    public String uploadcount;
    /******* Attachment Section ***********/
    public List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
    public boolean showAttSec = false;
    public String fname                                                        {get;set;} 
    public Case_Attachment__c record                                           {get;set;}
    public S3.AmazonS3 as3                                                     {get; private set;}
    private String AWSCredentialName = 'Amazon Connection'; 
    public string secret                                                       {get{return credentials.secret;}}
    public string key                                                          {get{return credentials.key;}}
    public AWSKeys credentials                                                 {get;set;} 
    public integer uploadcounter;
    public string CounterString                                                {get;set;}
    public boolean showSuccess;
    public String fnamenormal                                                  {get;set;}
     public String fnameid{get;set;}
    public String caseParam {get; set;}
    public String contentdeposition{get;set;}
    public static string getCounterString(){
        if(ApexPages.CurrentPage().getParameters().get('counterstring') == '')
            return '1';
        else if(ApexPages.CurrentPage().getParameters().get('counterstring') != null)
            return ApexPages.CurrentPage().getParameters().get('counterstring');
        else
            return '1';
    }
    
    public boolean getShowSuccess(){
        return showsuccess;
    }                                     
    
    public integer getUploadCounter(){
        if(ApexPages.CurrentPage().getParameters().get('counterstring') == null)
            uploadcount = '1';
        else if(ApexPages.CurrentPage().getParameters().get('counterstring') != null)
            uploadcount= ApexPages.CurrentPage().getParameters().get('counterstring');
        uploadcounter = integer.valueof(uploadcount);
        return uploadcounter +1;
    }   
    
    public String getsuccessfilename(){
    if(ApexPages.CurrentPage().getParameters().get('fname') != null)
    {
       try{
            string filename =ApexPages.CurrentPage().getParameters().get('fname');
         Case_Attachment__c temprec=[select id,File_Name_w_ext__c,File_Name_URL__c,file_name__c from Case_Attachment__c where id=:filename] ;
         return temprec.file_name__c;
        }
        catch(exception e)
        {
        return null;
        }
    }
    else
        return null;
    }

      
    public btbb_fileupload_controller(ApexPages.StandardController controller) {
        if(ApexPages.CurrentPage().getParameters().get('counterstring') == '')
            counterstring = '0';
        else if(ApexPages.CurrentPage().getParameters().get('counterstring') != null)
            counterstring = ApexPages.CurrentPage().getParameters().get('counterstring');
        else
            counterstring = '0';
        
        if(ApexPages.CurrentPage().getParameters().get('success') != null){
            if(ApexPages.CurrentPage().getParameters().get('success') == 'true'){
                showSuccess = true;
                showDone = true;
            }else{
                showSuccess = false;
                showDone = false;
                }
            }
        showDelete = false;
        showAttach = false;
        disableFileInput = false;
        instanceurl = URL.getSalesforceBaseUrl().toExternalForm();
        if(instanceurl != null && (instanceurl.contains('qax-blackboard') || instanceurl.contains('dvx-blackboard')))
        {
            
            instanceurl='https://blackboard.'+(instanceurl.contains('qax')?'qax.':'dvx.')+instanceurl.substringafter('-blackboard.');
        }
        String cid = ApexPages.CurrentPage().getParameters().get('cid');
        caseParam = cid;
        System.Debug(cid);
        c = [select Id from Case where Id =: cid];
        
        try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
        }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
       } 
    }
    
    public String getCaseNote(){
        return ApexPages.CurrentPage().getParameters().get('casenote');
    }

       public boolean getShowDone(){
           return showDone;
       }
       
       public boolean getShowAttach(){
           return showAttach;
       }
       
       public boolean getdisableFileInput(){
           return disableFileInput;
       }
       
       public boolean getShowDelete(){
           return showDelete;
       }
       
       public boolean getshowAttSec(){
            return showAttSec;
       }  
     
       public Pagereference delCaseAttach(){
            if(caslist != null  && caslist.size() > 0){
                delete caslist;
            }
            showSuccess = false;
            showDelete = false;
            showAttach = false;
            showDone = true;
            return null; 
       }
       
       public Pagereference updatefileinfo(){
           showSuccess = false;
           showAttSec = true;
           showAttach = true;
           showDone = false;
           showDelete = true;
           disableFileInput = true;
           System.debug(showAttSec);
           String filname1 = ApexPages.CurrentPage().getParameters().get('flname');
           String filname= filname1.toLowerCase();
           String fname1;
       String ext;
           if(filname!= null){
              
            if(filname1.contains('\\'))
                filname1 = filname1.substring(filname1.lastindexof('\\')+1,filname1.length());
            
            
            if(filname1.contains('.'))
               ext = filname1.substring(filname1.lastindexof('.'),filname1.length());  

            if(filname1.contains('.'))
                fname = filname1.substring(0,filname1.lastindexof('.'));
            else
                fname = filname1;

           System.debug(fname);
           System.debug(fname1);
           fname1 = fname;
           fnamenormal = fname1;
           fname = fname + '-' + String.valueof(System.now().year())+ '-'+String.valueof(System.now().month())+'-'+String.valueof(System.now().day())+'-'+String.valueof(System.now().hour())+'-'+String.valueof(System.now().minute())+'-'+String.valueof(System.now().second());     
           System.debug(fname);
           fname1 = fname1 + '-' + String.valueof(System.now().year())+ '-'+String.valueof(System.now().month())+'-'+String.valueof(System.now().day())+'-'+String.valueof(System.now().hour())+'-'+String.valueof(System.now().minute())+'-'+String.valueof(System.now().second());     
           System.debug(fname1);
           fname1 = EncodingUtil.urlEncode(fname1,'UTF-8');
           if(ext != null)
               fname = fname + ext;
           System.debug(fname);
           if(ext != null) 
               fname1 = fname1 + ext;
           System.debug(fname1);
        }
        Case_Attachment__c rec = new Case_Attachment__c();
        rec.Bucket_Name__c = 'Case-Attachments';
        rec.file_name__c = filname1;
        contentdeposition='"'+filname1+'"';
        try{
            
        string d=content_type__c.getvalues(ext).Content_Type__c;
        rec.Content_Type__c = d;
        }
        catch(exception e)
        {
            system.debug('--error--'+e);
        rec.Content_Type__c = 'application/octet-stream';
        }
        rec.Related_To__c = c.ID;
        rec.Access__c = 'private';
        rec.File_Name_w_ext__c = fname;
        rec.File_Name_URL__c = fname1;
        rec.UserID__c=userinfo.getuserid();
        String recId = [select Id from RecordType where Name = 'Case Attaachment' limit 1].ID;    
        rec.RecordTypeID = recId;
        Upsert rec;
        
        if(caslist.size() > 0)
        listsize = caslist.size();
        system.debug('LIST SIZE >>>>>>>> ON LOADING FILE >>>>>>> '+caslist.size());
        if(caslist.size() != 0){
        caslist.remove(caslist.size() - 1);
        system.assert(caslist.size() < listsize);
        }else{
        system.assert(caslist.size() == 0);
        }
        caslist.add(rec);
        record = rec;
        fnameid=rec.id;
        System.debug(record);
        return null;
        
    }
    
    Datetime expire = system.now().addDays(1);
    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
          
    string policy { get {return 
        '{ "expiration": "'+formattedexpire+
        '","conditions": [ {"bucket": "'+ record.Bucket_Name__c +
        '" } ,{ "acl": "'+  record.Access__c +'" },'+
        '{"content-type":"'+record.Content_Type__c+'"},'+
        '{"content-disposition":"'+'attachment;filename=\\"'+record.file_name__c+'\\""},'+
        '{"success_action_redirect":"'+instanceurl+'/apex/WFAttachments?cid='+c.ID+'&success=true&counterstring='+counterstring+'&fname='+fnameid+'"},' + 
        '["starts-with", "$key", ""]]}';} set; }         
     
    public String getPolicy() {
        System.debug(policy);
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
       
    public string getfnamenormal(){
        return fnamenormal;
    }
   public string getfnameid(){
        return fnameid;
    }
    public String getSignedPolicy() {  
       String s = make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));
       return s;
    }
   
    public String getHexPolicy() {
        String p = getPolicy();
        return EncodingUtil.convertToHex(Blob.valueOf(p));
   }
    
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        System.debug(secret);
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(Secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }    
    private static testmethod void fileuploadtest(){
       
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
        
        ApexPages.CurrentPage().getParameters().Put('cid',c.ID);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);  
        btbb_fileupload_controller sf = new btbb_fileupload_controller(controller);
        sf.getshowAttSec();
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        sf.updatefileinfo();
        sf.delCaseAttach();
        sf.getPolicy();
        sf.getSignedPolicy();
        sf.getHexPolicy();
        btbb_fileupload_controller.getCounterString();
        sf.getShowSuccess();
        sf.getUploadCounter();
        sf.getsuccessfilename();
        sf.getCaseNote();
        sf.getShowDone();
        sf.getShowAttach();
        sf.getdisableFileInput();
        sf.getShowDelete();
        sf.getfnamenormal();
        
        
        
        
    }     
}