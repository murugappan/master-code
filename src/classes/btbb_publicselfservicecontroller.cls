public class btbb_publicselfservicecontroller {

    
public String searchText{ set; get; }
  
  public PageReference SearchArticle() {
    
     PageReference pageRedirect = new PageReference('/btbb_publicKbSearch');
     pageRedirect.getParameters().put('searchText', searchText);
         pageRedirect.setRedirect(true);
         return pageRedirect;       
  }  
  public btbb_publicselfservicecontroller() {
    searchText = 'Search Knowledge Base';
  }
  
  static testMethod void publicSelfServiceTest() { 
    
        btbb_publicselfservicecontroller selfService = new btbb_publicselfservicecontroller();
        selfService.SearchText = 'Test';
        selfService.SearchArticle();        
    }
  

  public  List<BtBb_Link__c>  getbtbbServicelinks()
   {
    
     string corelicense='Collaborate';
     List<BtBb_Link__c>  btbbServicelinks=new List<BtBb_Link__c>(); 
     btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
     authcookie.loadcookie();
     if(authcookie.product != null && authcookie.product!='')
     {
      corelicense=authcookie.product;
     }
  
    btbbServicelinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,ISUNAUTH__C, target__c, ORDER__C,DESCRIPTION__C,ELEMENTID__C from BtBb_Link__c 
            where WIDGET__C='Self Service' and CORE_LICENSE__C=:corelicense AND isUnAuth__c=true order by ORDER__C asc]; 
            
    return btbbServicelinks;        
   } 
}