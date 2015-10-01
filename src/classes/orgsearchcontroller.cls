public  class orgsearchcontroller {
    
    public class JSONstructure{
        public string label{get;set;}
        public string value{get;set;}
        public string id{get;set;}
        public JSONstructure(string a, string b,string c)
        {
            this.label=a;
            this.value=b;
            this.id=c;
        }
    }
  public string text{get;set;}
    public string ss{get;set;}
   public void parseJson()
    {
        list<JSONstructure> jsnlist=new list<JSONstructure>();
        string term=apexpages.currentPage().getParameters().get('term');
        String soql = 'SELECT Name,id FROM Account where name like \'%'+term+'%\' and CustomerofCollaborate__c = true limit 50';
        ss=soql;
        List<Account> acct = Database.Query(soql);
        if(acct != null && acct.size()>0)
        {
            for(account ac :acct)
            {
                jsnlist.add(new JSONstructure(ac.name,ac.name,ac.id) );
            }
        }
        text = JSON.serialize(jsnlist);
    }   
}