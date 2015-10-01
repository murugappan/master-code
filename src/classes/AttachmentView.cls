public class AttachmentView{
    GlobalComponent gc = new GlobalComponent();
    ID attID;
    private String AWSCredentialName = 'Amazon Connection'; 
    public AWSKeys credentials {get;set;}
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public S3.AmazonS3 as3 { get; private set; }
    public String instanceurl {get;set;}
    
    public AttachmentView(ApexPages.StandardController controller) {
        attID = controller.getId();
        instanceurl = URL.getSalesforceBaseUrl().toExternalForm();
        try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
        }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
       } 
    }


    public Pagereference redirect(){
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
        set <id> accountset= new set <id>();
        user currentuser =[select id,contactid from user where id =:userinfo.getUserID() limit 1];
        Case_Attachment__c att = [select ID,Bucket_Name__c,File_Name_URL__c,Related_To__c, Related_To__r.accountid from Case_Attachment__c where ID =: attID];
        for(contact_role__c cr: [select id,role__c,account__c,contact__c from contact_role__c where contact__c != null and account__c!=null
                               and expire_role__c=false and contact__c=:currentuser.contactid and   AccessCode__c!='0'] )
        {
            accountset.add(cr.account__c);
        }
        if(((accountset.size()==0) ||(!accountset.contains(att.Related_To__r.accountid)))&&(!instanceurl.contains('my.salesforce.com')))
        {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Access Denied:  You do not have the appropriate access to view this document.');
            ApexPages.addMessage(errorMsg);
            return null;
        }
        String userencoded = EncodingUtil.base64Encode(Blob.valueof(Userinfo.getUserID()));
        System.debug(userencoded);
        userencoded = EncodingUtil.urlEncode(userencoded,'UTF-8');
        System.debug(userencoded);
        String profileid = Userinfo.getProfileID();
        Profile p = [select Name from Profile where Id =: profileID];
        String url;
        
        if(p.Name.contains('BTBB')){
            url = instanceurl+'/apex/AttachmentRedirect?bname='+att.Bucket_Name__c+'&fname='+att.File_Name_URL__c+'&uval='+userencoded;        
        }else{
            url = instanceurl+'/apex/AttachmentRedirect?bname='+att.Bucket_Name__c+'&fname='+att.File_Name_URL__c+'&uval='+userencoded;
        }
        PageReference newPage = new PageReference(url);
        System.debug('newPage url: ' + newPage.getUrl());
        return newPage;
        return null;

    }    
}