public class AttachRedirect{
  GlobalComponent gc = new GlobalComponent();
  private String AWSCredentialName = 'Amazon Connection'; 
        public AWSKeys credentials {get;set;}
        public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public S3.AmazonS3 as3 { get; private set; }

    public PageReference redirect() {
      try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
        }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
       } 
       String bucketname = Apexpages.currentpage().getParameters().get('bname');
       String fname = Apexpages.currentpage().getParameters().get('fname');
       String seckey = secret;
       String AWSKey = key;
       String user = ApexPages.CurrentPage().getParameters().get('uval');
       if(user != 'article')
           user = EncodingUtil.urlDecode(user,'UTF-8');
       System.debug(user);
       System.debug(Blob.valueof(Userinfo.getUserID()));
       if(user != 'article' && user != EncodingUtil.base64Encode(Blob.valueof(Userinfo.getUserID()))){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'ACCESS DENIED');
           ApexPages.addMessage(msg);
           return null;
       }else{ 
           if(user == 'article'){
               Datetime now = DateTime.now();
               Datetime expireson = now.addYears(10);
               Long Lexpires = expireson.getTime()/1000;
               System.debug(fname);
               fname = EncodingUtil.urlEncode(fname,'UTF-8'); 
               String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucketname+'/'+fname; 
               String macUrl ;
               Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(seckey)); 
               macUrl = EncodingUtil.base64Encode(mac);
               macUrl = EncodingUtil.urlEncode(macUrl,'UTF-8'); 
               String url = 'https://s3.amazonaws.com/'+bucketname+'/'+fname+'?AWSAccessKeyId='+AWSKey+'&Expires='+Lexpires+'&Signature='+macUrl;
               System.debug('url: ' + url);
               PageReference newPage = new PageReference(url);
               System.debug('newPage url: ' + newPage.getUrl());
               return newPage;
           }else{
                if(gc.userRedirect == true){
                  PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
                  pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
                  pageRedirect.setRedirect(true);
                  return pageRedirect;
               }
               Datetime now = DateTime.now();
               Datetime expireson = now.AddSeconds(4);
               Long Lexpires = expireson.getTime()/1000;
               System.debug(fname);
               fname = EncodingUtil.urlEncode(fname,'UTF-8'); 
               String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucketname+'/'+fname; 
               String macUrl ;
               Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(seckey)); 
               macUrl = EncodingUtil.base64Encode(mac);
               macUrl = EncodingUtil.urlEncode(macUrl,'UTF-8'); 
               String url = 'https://s3.amazonaws.com/'+bucketname+'/'+fname+'?AWSAccessKeyId='+AWSKey+'&Expires='+Lexpires+'&Signature='+macUrl;
               System.debug('url: ' + url);
               PageReference newPage = new PageReference(url);
               System.debug('newPage url: ' + newPage.getUrl());
               return newPage;
          }
       }    
    }
    
    private static testmethod void AttachRedirectTest(){

        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        String userencoded = EncodingUtil.base64Encode(Blob.valueof(Userinfo.getUserID()));
        userencoded = EncodingUtil.urlEncode(userencoded,'UTF-8');
        Apexpages.currentpage().getParameters().put('uval',userencoded);
        
        AttachRedirect ar = new AttachRedirect();
        ar.redirect();
        
        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        Apexpages.currentpage().getParameters().put('uval','article');
        
        AttachRedirect ar1 = new AttachRedirect();
        ar1.redirect();
        
        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        Apexpages.currentpage().getParameters().put('uval','abc');
        
        AttachRedirect ar2 = new AttachRedirect();
        ar2.redirect();
    }
}