public with sharing class bb_oqe_extension {

    public bb_oqe_extension () {}   
    ApexPages.StandardSetController recordset{get;set;}
    public Map<String, String> probabilityStageNameMap{get;set;}
    public string opportunityID{get;set;}
    public string recordId{get;set;}
   
    public bb_oqe_extension (ApexPages.StandardSetController controller) 
    {
        controller.setPageSize(50);  
        recordset=controller;
        //recordId =controller.getId();
        probabilityStageNameMap = new Map<String, String>();
        for (OpportunityStage oppStage : [Select MasterLabel, ForecastCategoryName From OpportunityStage]) 
         {
           probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.ForecastCategoryName );
         }
    }


    public PageReference doCancel()  
    {
        PageReference tr = new PageReference('/apex/bb_oqe');
        tr.setRedirect(true);
        return tr;
    }

    public PageReference doHome()  
    {
        PageReference tr = new PageReference('/home/home.jsp');
        tr.setRedirect(true);
        return tr;
    }
    
    
    public PageReference doCreateView ()
    {
        PageReference tr = new PageReference('/ui/list/FilterEditPage?ftype=o&retURL=/apex/bb_oqe&cancelURL=/apex/bb_oqe');
        tr.setRedirect(true);
        return tr;
    }
    
    public PageReference refreshPage()  
    {
        return null;
    }
  
   public pageReference updateOpportunity()
   {
    string oppid= Apexpages.currentPage().getparameters().get('opportunityID');

    for(opportunity opp: (List<Opportunity>)recordset.getrecords())
    {
        if(opp.id==oppid)
        {
            if(probabilityStageNameMap.keyset().contains(opp.StageName))
            opp.ForecastCategoryName=probabilityStageNameMap.get(opp.StageName);
        }
    }
     return null;
   }
}