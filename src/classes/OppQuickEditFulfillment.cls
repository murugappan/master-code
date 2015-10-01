public with sharing class OppQuickEditFulfillment {
    
    public OppQuickEditFulfillment() 
    {
            
    }
    public OppQuickEditFulfillment(ApexPages.StandardSetController controller) 
    {
        controller.setPageSize(50);     
    }

    public PageReference doCancel()  
    {
        PageReference tr = new PageReference('/apex/OQEFulfillment');
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
        PageReference tr = new PageReference('/ui/list/FilterEditPage?ftype=o&retURL=/apex/OQEFulfillment&cancelURL=/apex/OQEFulfillment');
        tr.setRedirect(true);
        return tr;
    }
    
    public PageReference refreshPage()  
    {
        return null;
    }
    
}