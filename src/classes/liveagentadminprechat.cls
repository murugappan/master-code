public without sharing class liveagentadminprechat {


    public string contactid{get;set;} 
    public string conatctemail{get;set;}
    public string name {get;set;}
    public string Account{get;set;}
    public string userid{get;set;}
    public Set<Id> accId{get;set;}
    public liveagentadminprechat(){
    string privatekey='b3h!ndBlackB0ard';
    cookie authcookie=ApexPages.currentPage().getCookies().get('btbbauth');
    system.debug('cookie---'+authcookie);
    if(authcookie != null)
            {   
                blob decodedblob=EncodingUtil.base64decode(authcookie.getvalue());
                blob decryptedMessage=crypto.decryptWithManagedIV('AES128',Blob.valueof(privateKey),decodedblob);
                string strUrlUTF8 = decryptedMessage.tostring();
                system.debug('test--'+strUrlUTF8 );
                    if(authcookie != null)
                    {
                        btbbCookieClass.AauthCookie temp=(btbbCookieClass.AauthCookie)JSON.deserialize(EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'),btbbCookieClass.AauthCookie.class);
                        userid=temp.userid;
                     }
           }
     system.debug('Userid---'+userid);      
    if(userid!=null)
    {                    
    
    User u = [Select id, name, contactId, contact.Phone, contact.Name, contact.Email, contact.Account.Name from User where id =: userid ];
    contactid=u.contactid;
    conatctemail=u.contact.email;
    name=u.name;
    }
}


          public List<selectOption> accounts {
           get {
                List<selectOption> options = new List<selectOption>();
                List<User> u = new List<User>([select ID,ContactID from USer where ID =: userid]);
                 accId = new Set<ID>();
                System.debug(u[0].ContactID);
                for(Contact_Role__c cr : [Select c.Role__c, c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID and role__c like 'Collaborate%' and role__c like '%Admin%' AND Contact__c!= NULL]){
                        accId.add(cr.Account__c);    
                        System.debug(accId);
                } 
                System.debug(accId.size());
                System.debug(accId);
                User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
                accId.add(loginUser.AccountId);
 
                for (account at : [SELECT id,name FROM Account WHERE ID IN: accId ORDER BY name])
                {if((at.id!=null)||(at.name!=null))
                    {
                         options.add(new SelectOption(at.id,at.name));
                            
                    }

                }
 
            return options;           
        }
        set;
    } 
public void refresh()
{
 system.debug('Account id--'+account);
}
    public List<selectOption> assets {
        get {
            List<selectOption> options = new List<selectOption>();
           
            if (account != null) {
            
                    options.add(new SelectOption( '' ,'-- Select an Environment --'));

                    }
                                    
            System.debug('account>>>>>>' + account);
            List<User> u = new List<User>([select ID,ContactID from USer where ID =: userid]);
            System.debug(u);
            System.debug(account);
            Map<ID,Set<String>> accountmap = new Map<ID,Set<String>>();

       for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false AND Contact__c!= NULL]){
              
           for(Contact_Role__c cr1 : cr){                  
               if(null != accountmap && (accountmap.size() == 0 || !accountmap.containsKey(cr1.Account__c))){
                   
                   Set<String> role = new Set<String>();
                   if(null != cr1.Code__c) {
                        role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
               }else if(null != accountmap){
                   
                   Set<String> role = new Set<String>();
                   role = accountmap.get(cr1.Account__c);
                   if(null != cr1.Code__c) {
                       role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
               }               
            }
         }   
         System.debug('accountmap >>>> '+ accountmap);
         Set<ID> casID = new Set<ID>();
 
         for (Asset a : [SELECT id, AccountID,  Core_License__r.Name, Product2Id, Product2.Name, isBtbbEligible__c,External_Asset_Name__c,Software_URL__c FROM Asset a WHERE (a.accountid in :accId AND a.core_license__r.name like 'Collaborate' AND a.isBtbbEligible__c = true) OR (a.accountid in :accId AND a.Force_Btbb_Visibility__c = true AND a.core_license__r.name like 'Collaborate') Order By Name]){
             // teting bit bucket
             Set<String> roles = new Set<String>();
             roles = accountmap.get(a.AccountID);  
             System.debug(a.Core_License__r.Name);
             if(a.Core_License__r.Name != null)
             System.debug(a.Core_License__r.Name.contains('ANGEL'));
             System.debug(a.External_Asset_Name__c);
             System.debug(a.id); 
             System.debug(roles); 
            if(roles != null && roles.contains('COLLABORATE')){
                   if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Collaborate')){
                     if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id+'_'+a.accountid,a.Product2.Name+' '));
                     }
                  }   
              }
         }     
         accountmap.clear(); 
         return options;           
        }
        set;
    }
    
   public pagereference redirect()
   {
       cookie authcookie=ApexPages.currentPage().getCookies().get('btbbauth');
    
    if(authcookie == null)
    {
    if(URL.getSalesforceBaseUrl().toExternalForm().contains('qax-blackboard'))
     {
        pagereference pageref= new pagereference('https://blackboard.qax.cs1.force.com/apex/liveagentadminprechat');
        for(string str: apexpages.currentpage().getparameters().keyset())
        {
            pageref.getparameters().put(str,apexpages.currentpage().getparameters().get(str));
        }
        pageref.setredirect(true);
        return pageref;
    }
    return null;
   }
   return null;
}
}