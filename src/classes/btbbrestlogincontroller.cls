public  class btbbrestlogincontroller {
    public LoginResponse response{get;set;}

    public btbbrestlogincontroller() {
        string email= ApexPages.currentPage().getheaders().get('username');
        string password=ApexPages.currentPage().getheaders().get('password');
        List<user> userlist=[Select id,username,Psft_Operator_ID__c from User where email=:email and email != null and isactive=true and contactid!=null];
            if(userlist!=null && userlist.size()>0)
            {
                system.debug('username--'+userlist[0].username+' pasword--'+password);
                pagereference result=site.login(userlist[0].username,password,'/btbb_home');
                system.debug('result--'+result);
                if(result != null)
                {
                    response = new LoginResponse(userlist[0].Psft_Operator_ID__c,'SUCCESS',true);
                }
                else
                {
                    response = new LoginResponse(null,'LOGIN_ERROR',false);
                }
            }
            else
            {
                 response = new LoginResponse(null,'NO_USER_FOUND',false);
            }
        
    }
    public class LoginResponse {
            public string BBPSoftUID{get;set;}
            public  string Status{get;set;}
            public boolean Success{get;set;}
            public LoginResponse(string psftid,string statuscode,boolean issuccess)
            {
                BBPSoftUID=psftid;
                Status=statuscode;
                Success=issuccess;
            }
        }
}