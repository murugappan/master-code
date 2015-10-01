public with sharing class ServiceNowFulfillment {

    public final Asset currentAsset{get;set;}
    public list<Asset> assetlist{get;set;}
    public list<Asset> astlist{get;set;}
    
    public map<id,asset>assetmap= new map<id,asset>();
    public list<Asset> assetupdatelist=  new list<Asset>();
    public list<selectoption> toplevelassets= new  list<selectoption>();
    public boolean isedited{get;set;} 
    public boolean editmode{get;set;}
     public string instanceurl {get;set;}
    
     //public list<id> prior{get;set;}
    public boolean fulfillreq{get;set;}
    public Boolean disableInput {get; set;}
    public Boolean disableError {get; set;}
  
  //sorting
  
   private String sortDirection = 'ASC';
   private String sortExp = 'name';
    public id currentAsstID;


    public ServiceNowFulfillment(ApexPages.StandardController stdController) {
    	 instanceurl =URL.getSalesforceBaseUrl().toExternalForm();
         ViewData();
        isedited=false;
        assetlist= new list<asset>();
   
       
        this.currentAsset = [select id,Asset_ID_18__c,name,Status,CPQ_Current_Opportunity_ID__c,accountid,Fulfillment_Requested__c,SN_Fulfillment_Complete__c from Asset where id=:stdController.getid()];
         
       currentAsstID= currentAsset.AccountId;
        
      assetlist=[select id,name,Status,External_Asset_Name__c,CPQ_Current_Opportunity_ID__c,Top_Level_Asset__c,Prior_Top_Level_Asset__c,Fulfillment_Action__c,Fulfillment_Action_Date__c,Fulfillment_Action_Counter__c,FulFillment_Prior_Action__c, Fulfillment_Request_Notes__c,Fulfillment_Last_Requested_Date__c,Fulfillment_Requested__c,Fulfillment_Request_Counter__c,
       First_Fulfillment_Requested_Date__c,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,SN_Fulfillment_Complete__c,accountid from Asset  where accountid=:currentAsset.accountid and Opportunity__r.StageName = '(W) Won' order by name ASC];
        
       
          if(assetlist!= null && assetlist.size()>0)
        {

            for(asset a: assetlist)
            {
                toplevelassets.add(new selectoption(a.id,a.name));
                if(a.Top_Level_Asset__c == null)
                {
                    a.Top_Level_Asset__c=a.id;
                }
               
            }
                
             assetmap= new map<id,asset>(assetlist.deepclone(true,true,true));
            
        }
        editmode=true;
        }


public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
 
 public List<Asset> getAssets() {
       return assetlist;
   }
 
 public PageReference ViewData() {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       system.debug('SortExp'+sortExpression);
      system.debug('SortFullExp'+sortFullExp);
       //query the database based on the sort expression
      assetlist = Database.query('select id,name,Status,External_Asset_Name__c,CPQ_Current_Opportunity_ID__c,Top_Level_Asset__c,Prior_Top_Level_Asset__c,Fulfillment_Action__c,Fulfillment_Action_Date__c,Fulfillment_Action_Counter__c,FulFillment_Prior_Action__c, Fulfillment_Request_Notes__c,Fulfillment_Last_Requested_Date__c,Fulfillment_Requested__c,Fulfillment_Request_Counter__c,First_Fulfillment_Requested_Date__c,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,SN_Fulfillment_Complete__c,accountid from Asset where accountid=:currentAsstID and Opportunity__r.StageName = \'(W) Won\' order by ' + sortFullExp);
       if(assetlist!= null && assetlist.size()>0)
        {

            for(asset a: assetlist)
            {
                
                if(a.Top_Level_Asset__c == null)
                {
                    a.Top_Level_Asset__c=a.id;
                }
               
            }
                
             
            
        } 
       return null;
   }

   /* public list<asset> getAssetlist()
    {
        return assetlist;
    }
*/
    public list<selectoption> getTopLevelAssets()
    {
        return toplevelassets;
    }

     public void submit()
    {
       
        boolean iserror=false;
        astlist=[select id,name,External_Asset_Name__c,CPQ_Current_Opportunity_ID__c,Top_Level_Asset__c,Prior_Top_Level_Asset__c,Fulfillment_Action__c,Fulfillment_Action_Date__c,Fulfillment_Action_Counter__c,FulFillment_Prior_Action__c, Fulfillment_Request_Notes__c,Fulfillment_Last_Requested_Date__c,Fulfillment_Requested__c,Fulfillment_Request_Counter__c,
        First_Fulfillment_Requested_Date__c,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,SN_Fulfillment_Complete__c,accountid from Asset  where accountid=:currentAsset.accountid and Opportunity__r.StageName = '(W) Won' order by CPQ_Current_Opportunity_ID__c desc];
        
        if(astlist!= null && astlist.size()>0){
            
            for(asset ast1:astlist){
                if(ast1.Fulfillment_Requested__c==true){
                    
                    disableInput = true;
                    iserror=true;
                    Apexpages.message msg= new ApexPages.Message(ApexPages.Severity.Error,'ServiceNow Request Pending,click cancel');
                    ApexPages.addMessage(msg);
                    }
                else{
                    isedited=false;
                     assetupdatelist= new list<asset>(); 
                     
                   for(asset ast:assetlist )
                   {
                    system.debug('ast.id-->'+ast.id+'ast--->'+ast.Top_Level_Asset__c+'astmap--->'+assetmap.get(ast.id).Top_Level_Asset__c);
                    if((ast.Top_Level_Asset__c != assetmap.get(ast.id).Top_Level_Asset__c && ast.Top_Level_Asset__c != ast.Prior_Top_Level_Asset__c)
                     ||( ast.Fulfillment_Action__c!=assetmap.get(ast.id).Fulfillment_Action__c&& ast.Fulfillment_Action__c!= ast.FulFillment_Prior_Action__c))
                    {
                        isedited=true;
                        assetupdatelist.add(ast);
                    }
                   
                }
                if(isedited==false)
                {
                    Apexpages.message msg= new ApexPages.Message(ApexPages.Severity.Error,'Please edit Fulfillment Relationship to Submit');
                    ApexPages.addMessage(msg);
                }
                if(isedited==true && iserror==false)
                {
                  editmode=false;  
                }
                     
               }
            }
        
        }
       
        
       }
    

    public void cancelsubmit()
    {
         editmode=true;
    }

    public pagereference cancel()
    {
        pagereference pageref= new pagereference('/'+currentasset.id);
        return pageref;
    }

    public list<asset> getupdatelist()
    {
        return assetupdatelist;
    }

    public pagereference save()
    {
       if(assetupdatelist!=null && assetupdatelist.size()>0)
       {
        for(asset ast: assetupdatelist)
        {
            if( ast.Top_Level_Asset__c == ast.id)
            {
                ast.Top_Level_Asset__c=null;
            }
            ast.SN_Fulfillment_Complete__c=true;
            ast.Prior_Top_Level_Asset__c=assetmap.get(ast.id).Top_Level_Asset__c; 
            if( ast.Prior_Top_Level_Asset__c == ast.id)
            {
                ast.Prior_Top_Level_Asset__c=null;
            }
        }
        update assetupdatelist;
        currentAsset.SN_Fulfillment_Complete__c=true;
        currentAsset.Top_Level_Asset__c=null;
        update currentAsset;
        pagereference pageref= new pagereference('/'+currentasset.id);
        return pageref;
       }

       return null;
    }

    public pagereference confirm()
    {
        assetupdatelist= new list<asset>();
        for(asset a: assetlist)
        {
            if(a.CPQ_Current_Opportunity_ID__c==currentasset.CPQ_Current_Opportunity_ID__c)
            {
                 if( a.Top_Level_Asset__c == a.id)
                {
                    a.Top_Level_Asset__c=null;
                }
                a.Fulfillment_Last_Requested_Date__c=system.today();
                if( a.Fulfillment_Action_Counter__c==null)
                {
                    a.Fulfillment_Action_Counter__c=1;
                }
                a.Fulfillment_Action_Counter__c=a.Fulfillment_Action_Counter__c+1;
                if(a.First_Fulfillment_Requested_Date__c==null)
                {
                    a.First_Fulfillment_Requested_Date__c=system.today();
                }
                a.Last_Fulfillment_Origin_Asset_SF_API_ID__c=currentasset.Asset_ID_18__c;
                assetupdatelist.add(a);
            }
            
        }
        currentasset.Fulfillment_Requested__c=true;
        
        update assetupdatelist;
        update currentasset;
        pagereference pageref= new pagereference('/'+currentasset.id);
        return pageref;
    }
}