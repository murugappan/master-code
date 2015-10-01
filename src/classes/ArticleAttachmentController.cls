public class ArticleAttachmentController {

    public S3.ListAllMyBucketsEntry[] allBucketList {get;set;}    
    public String bucketToUploadObject {get;set;}
    public AWSKeys credentials {get;set;}
    public String bucketNameToCreate {get;set;}
    private String AWSCredentialName = 'Amazon Connection'; 
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public KnowledgeArticleWrapper kavWrapper {get;set;}
    public Case_Attachment__c record {get;set;}
    public S3.AmazonS3 as3 { get; private set; }
    public String contenttype {get;set;}
    String fname;
    public String note {get;set;}
    public boolean showAttSec = false;
    public List<Case_Attachment__c> caslist = new List<Case_Attachment__c>();
    public List<Case_Attachment__c> caslist1 = new List<Case_Attachment__c>();
    public string console;
    public string URLred {get;set;}
    public String OwnerId {get;set;}
    public String signed{get;set;}
    public Long Lexpires{get;set;}
    public string internalonly {get;set;}
    public string relatetoSI {get;set;}
    public Boolean showDone;
    public Boolean showDelete;
    public Boolean showAttach;
    public Boolean disableFileInput = false;
    public String uploadcount;
    public integer uploadcounter;
    public string CounterString {get;set;}
    public boolean showSuccess;
    public String contentdeposition{get;set;}
    public boolean getshowAttSec(){
        return showAttSec;
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
       
       public static string getCounterString(){
        if(ApexPages.CurrentPage().getParameters().get('counterstring') == '')
            return '0';
        else if(ApexPages.CurrentPage().getParameters().get('counterstring') != null)
            return ApexPages.CurrentPage().getParameters().get('counterstring');
        else
            return '0';
    }
    
    public boolean getShowSuccess(){
        return showsuccess;
    }                                     
    
    public integer getUploadCounter(){
        if(ApexPages.CurrentPage().getParameters().get('counterstring') == null)
            uploadcount = '0';
        else if(ApexPages.CurrentPage().getParameters().get('counterstring') != null)
            uploadcount= ApexPages.CurrentPage().getParameters().get('counterstring');
        uploadcounter = integer.valueof(uploadcount);
        return uploadcounter++;
    }   
       
     
    
    public boolean getadmininfo(){
        Set<ID> profid = new Set<ID>();
        
        for(List<Profile> p : [select Id,Name from Profile where Name = 'SRV - System Administrator' OR Name = 'SRV - KM Administrators' OR Name ='System Administrator']){
            for(Profile p1 : p){
                profid.add(p1.ID);
            }
        }
        
        if(profid.contains(Userinfo.getProfileID()))
            return true;
        else
            return false;    
    }
    public String[] allBuckets { get {
        try{
           Datetime now = Datetime.now();
           S3.ListAllMyBucketsResult allBuckets = as3.ListAllMyBuckets(as3.key,now,as3.signature('ListAllMyBuckets',now));
           OwnerId = allBuckets.Owner.Id;
           S3.ListAllMyBucketsList bucketList = allBuckets.Buckets;
           S3.ListAllMyBucketsEntry[] buckets = bucketList.Bucket;
           allBucketList = buckets;
           String[] bucketNames = new String[]{};

            for(S3.ListAllMyBucketsEntry bucket: buckets){
                System.debug('Found bucket with name: ' + bucket.Name);
                bucketNames.add(bucket.name);
            }
            return bucketNames;
        }catch (System.NullPointerException e) {
            return null;
        }catch(Exception ex){
            System.debug(ex);
            return null; 
        }
      }  
      set;
   }
   
   public List<SelectOption> getBucketNames() {
        List<SelectOption> options = new List<SelectOption>();
        String[] bckts = allBuckets;
        if(bckts!=null){
            for(String bucket : allBuckets){
                options.add(new SelectOption(bucket,bucket)); 
            }
            return options;
        }else
            return null;
    }
  
    public PageReference createBucket(){
    
        System.debug(bucketNameToCreate);
        try{ 
            Datetime now = Datetime.now(); 
            S3.CreateBucketResult createBucketReslt = as3.CreateBucket(bucketNameToCreate,null,as3.key,now,as3.signature('CreateBucket',now));
            bucketNameToCreate = '';
            return null;
        }catch(System.CalloutException callout){
            System.debug(callout.getMessage());
            return null; 
        }catch(Exception ex){
            System.debug(ex);
            return null; 
        }
    }
    
    public Pagereference updatechange(){
         note = ApexPages.CurrentPage().getParameters().get('note1');
         String s  = ApexPages.CurrentPage().getParameters().get('selv');
         String s1 = ApexPages.CurrentPage().getParameters().get('relsi');
         internalonly = s;  
         relatetoSI = s1;
         if(caslist.size() > 0){
            caslist[0].Notes__c=note;
           /* if(internalonly == 'Yes')
                caslist[0].Internal_only_Attachment__c = true;
            else
                caslist[0].Internal_only_Attachment__c = false;  
            if(relatetoSI == 'Yes')
               if(lrjira.size() > 0 )
                    caslist[0].Support_Incident__c = lrjira[0].ID;*/
            Update caslist[0];
         }
         System.debug(note);
         return null;
    }
    
    public Pagereference updatechange1(){
         note = ApexPages.CurrentPage().getParameters().get('note1');
         String s  = ApexPages.CurrentPage().getParameters().get('selv');
         String s1 = ApexPages.CurrentPage().getParameters().get('relsi');
         bucketToUploadObject = ApexPages.CurrentPage().getParameters().get('buck');
         internalonly = s;  
         relatetoSI = s1;
         if(caslist.size() > 0){
            caslist[0].Notes__c=note;
         /*   if(internalonly == 'Yes')
                caslist[0].Internal_only_Attachment__c = true;
            else
                caslist[0].Internal_only_Attachment__c = false;  
            if(relatetoSI == 'Yes')
               if(lrjira.size() > 0 )
                    caslist[0].Support_Incident__c = lrjira[0].ID;*/
             caslist[0].Bucket_Name__c = bucketToUploadObject;       
             Update caslist[0];
         }
         System.debug(note);
         System.debug(internalonly);
         return null;
    }


    public Pagereference updatefileinfo(){
    	
       showAttSec = true;
       showAttach = true;
       showDone = false;
       showDelete = true;
       disableFileInput = true;
       System.debug(showAttSec);
       String filname1 = ApexPages.CurrentPage().getParameters().get('flname');
       String filname= filname1.toLowerCase();
       System.debug(note);
       String fname1;
       string ext;
       if(filname!= null){
           if(filname1.contains('\\'))
                filname1 = filname1.substring(filname1.lastindexof('\\')+1,filname1.length());
           fname = filname1;

            if(filname1.contains('.'))
           ext = filname1.substring(filname1.lastindexof('.'),filname1.length());  
           try{
               contenttype=content_type__c.getvalues(ext).Content_Type__c;
              }
           catch(exception e)
             {
               contenttype = 'application/octet-stream';
              }     

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
        rec.Bucket_Name__c = bucketToUploadObject;
        rec.file_name__c = filname1;
        contentdeposition='"'+filname1+'"';
        if(contenttype != null)
            rec.Content_Type__c = contenttype;
        else
            rec.Content_Type__c = 'application/octet-stream';
        rec.Article_Id__c = kavWrapper.KnowledgeArticleId;
        rec.Article_Title__c = kavWrapper.name;
        rec.Article_Version_Id__c = kavWrapper.articleId;
        rec.Access__c = 'private';
        rec.File_Name_w_ext__c = fname;
        rec.File_Name_URL__c = fname1;
        if(note == 'Enter Notes')
            rec.Notes__c = '';
        else
            rec.Notes__c = note;
        String recId = [select Id from RecordType where Name = 'Article Attachment' limit 1].ID;    
        rec.RecordTypeID = recId;
        System.debug(internalonly);
      /*  if(internalonly == 'Yes')
            rec.Internal_only_Attachment__c = true;
        else
            rec.Internal_only_Attachment__c = false;    

        if(relatetoSI == 'Yes')
           if(lrjira.size() > 0 )
               rec.Support_Incident__c = lrjira[0].ID;*/
       
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
        showDelete = false;
        showAttach = false;
        showDone = true;
         return null; 
        Pagereference p = new Pagereference('/apex/KnowledgeArticleManagement?articleVersionId='+kavWrapper.articleId);
        p.setredirect(true);
        return p;
    }
  
    public ArticleAttachmentController(ApexPages.StandardController stdController) {
        
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
        
        bucketToUploadObject = 'Kb-Attachments';
        if(ApexPages.CurrentPage().getParameters().get('articleVersionId') != null)
        {
        	try
        	{
	        	KnowledgeArticleVersion kav = [Select Id, Title, Summary, KnowledgeArticleId 
	        								   From KnowledgeArticleVersion 
	        								   Where Id =: ApexPages.CurrentPage().getParameters().get('articleVersionId')];
	        	kavWrapper = new KnowledgeArticleWrapper(kav.Id, kav.Title, '1', kav.KnowledgeArticleId);
        	}
        	catch (Queryexception e)
        	{
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your article Id is invalid.'));
        	}
        }        
        console = ApexPages.CurrentPage().getParameters().get('console');
        System.debug('console >>>>' + console);
        if(console == 'true')
            URLred = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/KnowledgeArticleManagement?articleVersionId='+kavWrapper.articleId+'&isdtp=vw';
        else if(console == 'false')  
            URLred = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/KnowledgeArticleManagement?articleVersionId='+kavWrapper.articleId;
        System.debug('URLred >>>>' + URLred);
        try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
        }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
       } 
       note = 'Enter Notes';
       internalonly = 'No';
       relatetoSI = 'No';
      
    }
     
    Datetime expire = system.now().addDays(1);
    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+
        expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
          
    string policy { get {return 
        '{ "expiration": "'+formattedexpire+
        '","conditions": [ {"bucket": "'+ bucketToUploadObject +
        '" } ,{ "acl": "'+  record.Access__c +'" },'+
     /*   '["starts-with", "$aws:Referer", "http://btbb.sit.cs3.force.com/"],'+*/
        '{"content-type":"'+record.Content_Type__c+'"},'+
        '{"content-disposition":"'+'attachment;filename=\\"'+record.file_name__c+'\\""},'+
        '{"success_action_redirect": "'+URLred+'"},' +
        '["starts-with", "$key", ""] ]}';   } set; }         
   
    
    public String getPolicy() {
        System.debug(policy);
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
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
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    private static testmethod void ArticleAttachmentControllerTest(){
        
        /*Solution s  = new Solution();
        s.SolutionName = 'Test';
        Insert s;
        
        ApexPages.CurrentPage().getParameters().Put('articleID',s.ID);
        ApexPages.CurrentPage().getParameters().Put('console','false'); 
        ApexPages.CurrentPage().getParameters().Put('success','true'); 
        ApexPages.StandardController controller = new ApexPages.StandardController(s);  
        ArticleAttachmentController sf = new ArticleAttachmentController(controller);
        sf.getshowAttSec();
        sf.getadmininfo();
        sf.getBucketNames();
        sf.bucketNameToCreate = 'Hello';
        sf.createBucket();
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        sf.updatefileinfo();
        sf.updatechange();
        sf.updatechange1();
        sf.delCaseAttach();
        sf.getPolicy();
        sf.getSignedPolicy();
        sf.getHexPolicy();
        sf.getShowDone();
        sf.getShowAttach();
        sf.getdisableFileInput();
        sf.getShowDelete();
        ArticleAttachmentController.getCounterString();
        sf.getShowSuccess();
        sf.getUploadCounter();*/ // Need to update to test Knowledge
        
    }
   
}