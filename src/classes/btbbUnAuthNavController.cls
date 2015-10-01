public with sharing class btbbUnAuthNavController {

public String category {get; set; } 

public Boolean isCollabuser{get {
       isCollabuser = false;
       btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
       authcookie.loadcookie();
        if(authcookie.product != null && authcookie.product!='')
         {
            if (authcookie.product.containsIgnoreCase('collaborate') )
             
             {
               isCollabuser=true;
               
             }
         }
           
         return isCollabuser;}
         set;
    }
 
      
    public btbbUnAuthNavController() {
        
    }
  
  //populate links

     
     
     public static List<BtBb_Link__c>  getbtbbCommunitylinks()
     {
         List<BtBb_Link__c>  btbbCommunitylinks=new List<BtBb_Link__c>();
         string corelicense='Collaborate';
         btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
         authcookie.loadcookie();
         if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         else
         {
            corelicense='ALL';
         }
         
    
          btbbCommunitylinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,target__c,ISUNAUTH__C,ORDER__C from BtBb_Link__c 
                        where WIDGET__C='Community Resources' and CORE_LICENSE__C=:corelicense and isUnAuth__c=true order by ORDER__C asc];
                        
        return btbbCommunitylinks;              
     }
     
     public static List<BtBb_Link__c>  getbtbbServicelinks()
     {
        
         string corelicense='Collaborate';
         List<BtBb_Link__c>  btbbServicelinks=new List<BtBb_Link__c>(); 
         btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
         authcookie.loadcookie();
          if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
         else
         {
            corelicense='ALL';
         }
      btbbServicelinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,target__c,ISUNAUTH__C,ORDER__C from BtBb_Link__c 
                        where WIDGET__C='Self Service' and CORE_LICENSE__C=:corelicense and isUnAuth__c=true order by ORDER__C asc]; 
                        
        return btbbServicelinks;                
     }
     

}