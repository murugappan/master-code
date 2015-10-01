public class btbb_publiccommunity{
  
     
     public  List<BtBb_Link__c>  getbtbbCommunitylinks()
     {
         List<BtBb_Link__c>  btbbCommunitylinks=new List<BtBb_Link__c>();
         string corelicense='Collaborate';
         btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
         authcookie.loadcookie();
         if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         
         
    
          btbbCommunitylinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,ISUNAUTH__C,ORDER__C, target__c, DESCRIPTION__C,ELEMENTID__C from BtBb_Link__c 
                        where WIDGET__C='Community Resources' and isUnAuth__c=true and CORE_LICENSE__C=:corelicense order by ORDER__C asc];
                        
        return btbbCommunitylinks;              
     }
     
 

}