/*
*@Name: ServiceCloudUtility
*@Author: Varghese George
*@Description: Contains common methods used for ServiceCloud and BtBb pages. 
**/

public with sharing class ServiceCloudUtility {

    public class ValidateEmailResults{
      public string errormessage;
      public boolean isSuccess;
      public ValidateEmailResults(boolean status,string message)
      {
        this.isSuccess=status;
        this.errormessage=message;
      }

    }
	  Public static ValidateEmailResults validateccemails(string  Recipients)
    {
      ValidateEmailResults results= new ValidateEmailResults(true,'');
      results.isSuccess=true;
       if(Recipients != null && Recipients!='')
          {
              list<string> ccemaillist=Recipients.split(';');
              if(ccemaillist.size()>5)
              {
                  results.isSuccess = false;
                  results.errormessage = 'Error: Maximum 5 emails allowed.';
                  return results;
              }
              else
              {
                  integer x=1;
                  for(string s: ccemaillist)
                  { 
                    if(s!= null && s!= '' && s!= 'null')
                    {
                      if(!Pattern.matches('^\\s*[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-\']+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$',s))
                      {
                         results.isSuccess = false;
                         results.errormessage  = 'Error: '+s+' is not valid email address';
                         system.debug('log2---'+ s);
                         return results;
                      }
                      if(ServiceCloudUtility.exceptionEmailList.contains(s.toLowerCase()))
                      {
                        results.isSuccess = false;
                        results.errormessage  = 'Error: '+s+' is not valid email address';
                        system.debug('log3---'+ s);
                        return results;
                      }
                    } 
                      x++;

                  }
                   return results;
              }
          }
          else
          {
            return results;
          }
    }

    static set<string> exceptionEmailList=new set<String>{
            'supportmanagers@blackboard.com',
            'mhem@blackboard.com',
            'connectsupportmanagers@blackboard.com',
            'bbcollaboratesupportmgmt@blackboard.com',
            'engageclientsuccess@blackboard.com',
            'moodleroomssupportmanagers@moodlerooms.com',
            'supportmanagers@netspot.com.au', 
            'analytics.support@blackboard.com',
            'varghese.test@example.com',
            'support@blackboard.com' };


    public static string getPortalNextAction(string status)
    {
      map <string,string> statusmap= new map<string,string>
      {

      'Closed'=>'The solution for this case is displayed below. If the same problem persists or has recurred, you may reopen this case within the first 30 days following closure; thereafter we request that you submit a new case.',
      'Closed - Pending Release'=>'The status of the Known Issue associated with your issue has been updated to Pending Release to show that we have confirmed this is a bug that is planned to be fixed in a future release, but that release is not yet available. Please refer to the solution in this case and the related known issue article for details. It may take up to 14 business days from the date when the issue was targeted to publish the article.',
      'Closed - Future Reference'=>'Our Product Development organization has verified this issue as a software defect; however, at this time it is not scheduled to be fixed in an upcoming release. Please refer to the solution in this case and the related known issue article in the knowledge base for details. It may take up to 14 business days from the date when the issue was given this status to publish the article.',
      'Pending Upgrade'=>'This issue is fixed in an upcoming software release. Please refer to the solution in this case and the related known issue article in the knowledge base for details.',
      'Enhanced for Review'=>'Our Product Development organization has verified this issue as an enhancement request. It will be considered for future release.',
      'New'=>'Your case has been received by Client Support and a support representative will contact you shortly. If you wish to add additional notes or attachments you may do so via the Add Comment button below.',
      'On Hold'=>'Your case is on hold. Please refer to the note(s) in the Activity Details below for more information.',
      '3rd Party'=>'We are currently working with our partners to ensure service of your hardware. No further information is required of you at this time.',
      'RMA'=>'This case is currently pending the RMA process. Please ensure that we have received your hardware so that it can be returned to you as quickly as possible.',
      'Pending Development'=>'Your case has been evaluated by our Tier 3 team as a product defect or complex issue and they are working to determine next steps. Your case will be updated as more information is available. No further information is required of you at this time.',
      'Pending Change Request'=>'This case requires a change in your Managed Hosting Environment. Our Managed Hosting team will partner with you to ensure appropriate action is taken.',
      'Pending User'=>'We require additional information from you to continue work on this case. Please refer to the note in the Activity Details section below and respond by using the Add Comment button.',
      'Pending Evaluation'=>'Your case has been escalated to our Tier 3 team to determine if this issue is a product defect and to identify any possible workarounds that may be available. Your case will be updated as more information is available. No further information is required of you at this time.',
      'Closed - Pending Target'=>'Our Product Development organization has verified your issue as a software defect. The next step in our process is to determine the root cause, required fix and target release for this bug. Depending on the complexity of this issue, it could take up to 30 days for us to make a determination.',
      'Solution Suggested'=>'A suggested solution for this case appears in the Activity Details below. Please review the solution and click [accept] if you agree that this solves your case; this action will close the case. If the suggested solution does not resolve your case, please click [decline] and we will continue to work with you toward resolution.',
      'Problem Reported: Pending Pyramid Dev'=>'The issue you reported is being investigated by the Pyramid Development team. No further information is required of you at this time.'
    
    }  ;   

    if(statusmap.containskey(status))
    {
      return statusmap.get(status);
    }
    else
    {
      return 'Your case is being worked on by Client Support. No further information is required of you at this time.';
    }
  }
}