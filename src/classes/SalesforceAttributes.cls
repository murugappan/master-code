// Created By: Dominic Baker
//
// This class will hold static methods that will return attributes about the current Salesforce Instance.

public with sharing class SalesforceAttributes 
{
    // This method will return the server name for the instacne the current User is logged into
    public static String getServerName()
    {
        String instanceURL = URL.getSalesforceBaseUrl().toExternalForm(); // This is the full Base URL of the org as a String
        String serverName;
        Integer startIndex = -1;
        Integer dotPos, hashPos;
        
        // Check if it is production
        if (instanceURL.indexOf('na') != -1)
        {
            startIndex = instanceURL.indexOf('na');
        }
        // Check if it is a sandbox
        else if (instanceURL.indexOf('cs') != -1)
        {
            startIndex = instanceURL.indexOf('cs');
        }
        
        // Check to see if it has a valid Salesforce server name
        if (startIndex != -1)
        {
            dotPos = instanceURL.indexOf('.', startIndex); // The position of the first '.' after the server name
            hashPos = instanceURL.indexOf('-', startIndex); // The position of the first '-' after the server name
            
            // Check if there is a . after the server name
            if (dotPos != -1)
            {
                serverName = instanceURL.substring(startIndex, dotPos);
                
                // Check if there is a - after the  server name and before the '.'
                if (hashPos != -1 && hashPos < dotPos)
                {
                    serverName = instanceURL.substring(startIndex, hashPos);
                }
            }
        }
        
        // Return the server name or null if not found
        return serverName;
    }
    
    // This method will return the Site URL for the instance the current User is logged into
    public static String getSiteDomain()
    {
        String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();
        //String serverName = SalesforceAttributes.getServerName(); // Gets the name of the current server being used 
        String siteURL;

        if(instanceURL.contains('na5') || instanceURL.contains('http://blackboard.force.com') || instanceURL.contains('https://blackboard.secure.force.com')||instanceURL.containsignorecase('blackboard.my.salesforce'))
        {
            siteURL = 'https://blackboard.secure.force.com';
        }
        else if(instanceURL.contains('cs3') || instanceURL.contains('blackboard.qax'))
        {
            siteURL = 'http://blackboard.qax.cs3.force.com';
        }
        else if(instanceURL.contains('cs12') || instanceURL.contains('blackboard.dvx'))
        {
            siteURL = 'http://blackboard.dvx.cs12.force.com';
        }
        else
        {
            siteURL = 'http://blackboard.force.com';
        }
        
        return siteURL;
    }
}