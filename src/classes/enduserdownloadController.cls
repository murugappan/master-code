public class enduserdownloadController {
    
    //GlobalComponent gc = new GlobalComponent();
    transient List<casewrapper> caselist = new List<casewrapper>();
    List<User> u;
    private User CurrentUser;
    public String DateSort          {get; set;}
    public List<String> clientID {get;set;}
    public boolean resetCookie{get;set;}
       public List<List<casewrapper>> getRecentCases() {
            List<List<casewrapper>> templist= new List<List<casewrapper>>();
            List<casewrapper> clist = new List<casewrapper>();
             if(null != caselist) {
                if(caselist.size() > 2000){ 
                   
                   for(Integer i=0; i<2000; i++){
                       if(clist !=null && clist.size()<1000)
                       {
                       clist.add(caselist[i]);
                       }
                       else
                       {
                        templist.add(clist);
                        clist = new List<casewrapper>();
                       }
                       
                   
                                              }
                        templist.add(clist);                      
                                       }
                else
                
                {
                   
                   for(Integer i=0; i<caselist.size(); i++)
                   
                   {
                      if(clist !=null && clist.size()<1000)
                       {
                       clist.add(caselist[i]);
                       }
                       else
                       {
                        templist.add(clist);
                        clist = new List<casewrapper>();
                       }
                   }
                    templist.add(clist);
                }
            }
               
             return templist;   
                                           }
        
       public enduserdownloadcontroller() {
          Cookie session = ApexPages.currentPage().getCookies().get('sessionlog');
          if (session == null) {
            resetCookie=true;
            session = new Cookie('sessionlog',Userinfo.getsessionid(),null,-1,false);
            } 
            else { 
                if(Userinfo.getsessionid() == session.getvalue())
                {
                  resetCookie=false;
                }  
                else
                { 
                 resetCookie=true;  
                 session = new Cookie('sessionlog', Userinfo.getsessionid(),null,-1,false);
                }
        }
            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{session});
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
           CurrentUser = [Select Id, Name, FirstName, LastName From User Where Id =: Userinfo.getUserID()];     
           u = new List<User>([select ID,ContactID from USer where ID =: Userinfo.getUserID()]);
           Map<ID,Set<String>> accountmap = new Map<ID,Set<String>>();
           Set<ID> AccountID = new Set<ID>();
       
       for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false AND Contact__c!= NULL]){
              
           for(Contact_Role__c cr1 : cr){                  

               if(null != accountmap && (accountmap.size() == 0 || !accountmap.containsKey(cr1.Account__c))){
                   
                   Set<String> role = new Set<String>();
                   if(null != cr1.Code__c) {
                        role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
                   AccountID.add(cr1.Account__c);
               }else if(null != accountmap){
                   
                   Set<String> role = new Set<String>();
                   role = accountmap.get(cr1.Account__c);
                   if(null != cr1.Code__c) {
                       role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
                   AccountID.add(cr1.Account__c);
               }               
            }
         }   
         list<case> casequerylist=[SELECT Id, Invoke_Premium_Support__c,AccountId,Account.Name, Case_Record__c, Account_Name__c , Status, ContactId, Contact.Name, Core_License__r.Name, CaseNumber, Subject, Description, Customer_Portal_Status__c,Asset.External_Asset_Name__c, Case_Severity__c, LastModifiedDate, CreatedDate, Psft_Case_Id__c, isClosed, ClosedDate,Last_activity_update__c,End_User_Product__c,End_user__r.email__c,End_User__r.name FROM Case where  AccountID IN: accountmap.Keyset() AND End_User__c != NULL AND contactID=NULL ORDER BY Last_activity_update__c DESC LIMIT 2000];
         System.debug('+++' + casequerylist);
         for(Case c : casequerylist){
           //  DateSort = c.LastModifiedDate.format('MM/dd/yyyy');
             Set<String> roles = new Set<String>();
             roles = accountmap.get(c.AccountID);    
             if(roles.contains('COLLABORATE')){
                 if((c.Core_License__r.Name  != null && c.Core_License__r.Name.containsignorecase('Collaborate')) || (c.Case_Record__c != null && c.Case_Record__c.containsignorecase('Collaborate')))
                    caselist.add(new casewrapper(c));                  
            
             }             
          } 
           
          clientID = new List<String>();  
          Set<String> cId = new Set<String>();
          for(List<Account> acc : [select ID,PS_Company_Id__c,Name from Account where ID IN: AccountID ORDER BY NAME DESC]){
              for(Account a : acc){
                      cId.add(a.Name + ' : ' + a.PS_Company_Id__c); 
              }        
          }
          system.debug('Case list>>>'+caselist);
          system.debug('Query list>>'+casequerylist);
          clientID.addAll(cId);                                      
       }
       
       public String getMyName(){
           return CurrentUser.Name;
       }
       
       public String getMyFirstName(){
           return CurrentUser.FirstName;
       }
       
       public String getMyLastName(){
           return CurrentUser.LastName;
       }
       
       public pagereference resetfilter()
       {
        Cookie session = ApexPages.currentPage().getCookies().get('sessionlog');
        pagereference pge=new pagereference(ApexPages.currentPage().geturl());
        if (session != null) {
            session = new Cookie('sessionlog','sessionreset',null,-1,false);
             ApexPages.currentPage().setCookies(new Cookie[]{session});
            } 
        pge.setredirect(true);  
        return pge; 
       }
       //Added By Shirish On 23-August-11 for MLA Admin contact roles  
        public boolean isMLAAdmin {
                    
            get {                   
                    
                if(u != null && u.size() > 0) {
                    Integer flag = 0;                
                    for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId]) {
                        if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin'))) {
                        
                        isMLAAdmin = true;                      
                        } else {
                            isMLAAdmin = false;  
                            break; 
                        }
                    }
                }                         
                return isMLAAdmin;
            }
            set { 
                if(value != null) isMLAAdmin = value;                
            }
        }   
        
    public PageReference Redirect() {
    GlobalComponent gc = new GlobalComponent();
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
            return null;
        }
    }
     class  casewrapper{
      public case c{get;set;}
      public string createddate{get;set;}
      public string lastupdatedate{get;set;}
      public string closeddate{get;set;}
      public casewrapper(case cs)
      {
        c=cs;
        createddate=cs.createddate.format('d MMM yyyy HH:mm:ss z');
        lastupdatedate=cs.Last_activity_update__c.format('d MMM yyyy HH:mm:ss z');
        if(cs.closeddate!=null)
        closeddate=cs.closeddate.format('d MMM yyyy HH:mm:ss z');

      }
  }
       
     
 //   static testmethod void caseSearchControllertest(){
 //   caseSearchController csc = new caseSearchController();
 //   csc.Redirect();
 //   csc.getRecentCases();
 //   csc.getMyName();
 //   csc.getMyFirstName();
  //  csc.getMyLastName();
  //  Boolean b = csc.isMLAAdmin;
  //  }   

}