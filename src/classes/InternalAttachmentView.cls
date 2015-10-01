public class InternalAttachmentView{

    ID attID;
    private String AWSCredentialName = 'Amazon Connection'; 
    public AWSKeys credentials {get;set;}
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public S3.AmazonS3 as3 { get; private set; }
    
    public InternalAttachmentView(ApexPages.StandardController controller) {
        attID = controller.getId();
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
        Case_Attachment__c att = [select ID,Bucket_Name__c,File_Name_URL__c from Case_Attachment__c where ID =: attID];
        String userencoded = EncodingUtil.base64Encode(Blob.valueof(Userinfo.getUserID()));
        System.debug(userencoded);
        userencoded = EncodingUtil.urlEncode(userencoded,'UTF-8');
        System.debug(userencoded);
        String profileid = Userinfo.getProfileID();
        Profile p = [select Name from Profile where Id =: profileID];
        String url1;
        if(p.Name.contains('BTBB')){
            url1 = 'https://blackboard.secure.force.com/AttachmentRedirect?bname='+att.Bucket_Name__c+'&fname='+att.File_Name_URL__c+'&uval='+userencoded;        
        }else{
            url1 = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/AttachmentRedirect?bname='+att.Bucket_Name__c+'&fname='+att.File_Name_URL__c+'&uval='+userencoded;
        }
        PageReference newPage = new PageReference(url1);
        System.debug('newPage url: ' + newPage.getUrl());
        return newPage;
        return null;
    }
    
    private static testmethod void InternalAttachmentViewTest(){
        Case_Attachment__c ca = new Case_Attachment__c();
        ca.Bucket_Name__c = 'Test';
        insert ca;
        
        ApexPages.CurrentPage().getParameters().put('id',ca.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(ca);
        InternalAttachmentView ia = new InternalAttachmentView(controller);
        ia.redirect();
        
    }
    
}