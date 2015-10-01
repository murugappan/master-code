public with sharing class btbb_udh {
    public string store {get;set;}
    public Univs__c univsnames {get;set;}
    public string errorText {get; private set;}
    public boolean isAccountValid {get; private set;}
    public boolean checkForValidURL {get;set;}
    private List<Univs__c> alist;
    public string errorTxt {get;set;}
    public  Account a {get;set;}
    public string check {get;set;}
    public boolean checkvalid {get;set;}
    public string dText {get;set;}
    
    public btbb_udh(){  
        
        
        /*check = ApexPages.currentPage().getParameters().get('bcheck');
        if(check == 'true'){
        
        checkvalid = true;
        
        }
        else {
        checkvalid = false;
        } */
        
        
        
        store = 'Provide link';
        //store = 'Provide help text';
        
        
        
        
        isAccountValid = true;
        try{
             a = [Select id, PS_Company_Id__c from Account where id =: apexpages.currentpage().getparameters().get('id')];
        }
        catch(exception e){
            errorText = 'The Account is not Valid';
            isAccountValid = false;
        }
        
        if (a != null){ 
        
            alist = [Select id, LastModifieddate, View_Count__c, Website__c, Client_Id__c, Active__c, Page_Text__c, HTML_Text__c From Univs__c where Account__c =:apexpages.currentpage().getparameters().get('id') AND Active__c = True];
                     
        }
            
        if(alist == null || alist.size()== 0){
            
           univsnames = new Univs__c();
            
        } 
        else if(alist.size()== 1){
            
            univsnames = alist[0];
            
        } 
        else if(alist.size()>1){
            
            for(Univs__c b: alist){
                if(univsnames == null){
                    univsnames = b;
                }
                else if(univsnames.LastModifieddate < b.LastModifieddate){
            
                    univsnames = b;
            
                }   
            }            
            
        }
            
    } 
            
            
            
  
        public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        //options.add(new SelectOption('Select Option','Select Option')); 
        options.add(new SelectOption('Provide link','Provide link'));
        options.add(new SelectOption('Provide help text','Provide help text')); 
         
        return options; 
    }                                          
    public pagereference savemeth(){
          Univs__c Uname = new Univs__c();
          Uname.Account__c = a.id;
          //univsnames.Active__c = true;
          if(store == 'Provide link'){
              Uname.Website__c = univsnames.Website__c;
              checkForValidURL = true;
          if(Uname.Website__c != Null){
              String regexFormat ='(^((http|https)://)+?(www.)??([a-zA-Z0-9]|-)+?([.][a-zA-Z0-9(-|/|=|?)??]+?)+?$)';  
              Pattern urlFormat = Pattern.Compile(regexFormat);  
              Matcher format_of_url = urlFormat.Matcher(Uname.Website__c);
                  if (format_of_url.Matches()){
                      //if((Uname.Website__c).startsWith('http|https://')){
                      insert Uname;
                      //}
                      //else
                      //{
                      //dText = 'Append http://';
                      //}          
                      for(Univs__c b: alist){
                      univsnames.Active__c = false;
                      }
                      update alist;
                      pagereference pageref;
                      pageref = page.btbb_updateconfirmation;
                      pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
                      pageref.setRedirect(true);
                      return pageref;
                     
            } 
          else{
          errorTxt = 'Enter proper format for website';
          Univsnames.Website__c = null;
          }
          }}
                    
          if(store == 'Provide help text'){
              Uname.HTML_Text__c = univsnames.HTML_Text__c;
                      insert Uname;          
                      for(Univs__c b: alist){
                      univsnames.Active__c = false;
                      }
                      update alist;
                      pagereference pageref;
                      pageref = page.btbb_updateconfirmation;
                      pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
                      pageref.setRedirect(true);
                      return pageref;
                      
          }
          
       return null;}
    
            
             

    public pagereference deactiprof(){
        for(Univs__c b: alist){
        univsnames.Active__c = false;
        b.Website__c = null;
        b.HTML_Text__c = null;
        }
        update alist;
        pagereference pageref;
        pageref = page.btbb_deactivedisplay;
        pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
        pageref.setRedirect(true);
        return pageref;
          
    }       
}