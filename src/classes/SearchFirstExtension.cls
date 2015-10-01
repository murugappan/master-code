//  Copyright (c) 2009, Christoph Foeckeler, Sales Engineering, Salesforce.com Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    1.    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
//    2.    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
//          documentation and/or other materials provided with the distribution.
//    3.    Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this
//          software without specific prior written permission. 
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

public with sharing class SearchFirstExtension {

    public SearchFirstExtension(ApexPages.StandardController controller) {

    }

    protected List<List<sObject>> searchResults  = new List<List<sObject>>{};
    public List<Account> resultListAccounts;
    public List<Contact> resultListContacts;
    public String searchFirstname{ get; set; }
    public String searchLastname{ get; set; }
    public String searchCompany{ get; set; }
    public String searchPhone{ get; set; }
    public String searchEmail{ get; set; }
    public boolean noAccountResult{ get; set; }
    public boolean noContactResult{ get; set; }  
    public boolean emptyAccountList{ get; set; }
    public boolean emptyContactList{ get; set; }
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; }
    public String errorSeverity{ get; set; }
    public Integer numAccounts{ get; set; }
    public Integer numContacts{ get; set; }
    
    public SearchFirstExtension ( ) {
            emptyAccountList = true;
            emptyContactList = true;
            numAccounts = 0;
            numContacts = 0;
            noAccountResult = false;
            noContactResult = false;
            errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
    }
    
    public List<Account> getresultListAccounts() {
        return resultListAccounts;
    }

    public List<Contact> getresultListContacts() {
        return resultListContacts;
    }
    
    
    public PageReference search() {
      errorShow = false;
        string tablesFields = 'account(id, phone, type, name), contact(id, phone, email, firstname, lastname, accountId, contact_status__c)';
        string searchString = getSearchCriteria();
        if (searchString.length() > 1) {
          try {
              searchString = 'find \'' + searchString + '\' in ALL FIELDS RETURNING ' + tablesFields;
              searchResults = search.query(searchString);
              resultListAccounts = ((List<Account>)searchResults[0]); 
              numAccounts = resultListAccounts.size();     
              emptyAccountList = resultListAccounts.isEmpty() ? true : false;
              noAccountResult = emptyAccountList;
              resultListContacts = ((List<Contact>)searchResults[1]);
              numContacts = resultListContacts.size();
              emptyContactList = resultListContacts.isEmpty() ? true : false;
              noContactResult = emptyContactList;
          } catch (Exception e) {
            // System.debug('Error when executing the search: ' + e);
            errorTitle = e.getMessage();
            errorMessage = e.getMessage();
            errorSeverity = 'error';
            errorShow = true;
          }
        } else if (searchString.length() == 1) {
          numAccounts = 0;
          numContacts = 0;
          emptyAccountList = true;
          emptyContactList = true;
          noAccountResult = false;
          noContactResult = false;
          errorTitle = System.Label.sfError;
          errorMessage = System.Label.sfErrorMessage ;
          errorSeverity = 'error';
          errorShow = true;
        }    
        // return to the same page
        return null;
    }
 
    public PageReference reset() {
        numAccounts = 0;
        numContacts = 0;
        emptyAccountList = true;
        emptyContactList = true;
        searchFirstname = '';
    searchLastname = '';
    searchCompany = '';
    searchPhone = '';
    searchEmail = '';
        errorTitle = '';
        errorMessage = '';
        errorSeverity = '';
        errorShow = false;
        noAccountResult = false;
        noContactResult = false;
        return null;
    }

   
    private string getSearchCriteria() {
        String fullSearchString = '';
        String searchName = searchFirstname;
        if (searchName != ''){
            if (searchLastname != '') {
                searchName = searchFirstname + ' ' + searchLastname;
            }
        } else {
            searchName = searchLastname;    
        }
        fullSearchString = appendToSearchString(fullSearchString, searchName);
        fullSearchString = appendToSearchString(fullSearchString, searchCompany);
        fullSearchString = appendToSearchString(fullSearchString, searchPhone);
        fullSearchString = appendToSearchString(fullSearchString, searchEmail);
        return fullSearchString;
    }
    
    public PageReference createNewAccount(){
        PageReference pageRef = new PageReference('/001/e?retURL=%2F001%2Fo&nooverride=1' + (searchCompany != ''?'&acc2='+ searchCompany : '') );
        return pageRef;
    }
    
     public PageReference createNewContact(){
        PageReference pageRef = new PageReference('/003/e?retURL=%2F003%2Fo' + (searchFirstname != ''?'&name_firstcon2='+ searchFirstname : '') + (searchLastname != ''?'&name_lastcon2='+ searchLastname : '') + (searchPhone != ''?'&con10='+ searchPhone : '') + (searchEmail != ''?'&con15='+ searchEmail : ''));
        return pageRef; // + (searchCompany != ''?'&con4='+ searchCompany : '') 
    }
    
    private string appendToSearchString(String searchString, String newValue) {
        if (newValue != '') {
            if (searchString == '') {
                searchString = newValue;
            } else {
                searchString += ' OR ' + newValue;
            }
        }
        return searchString;
    }
}