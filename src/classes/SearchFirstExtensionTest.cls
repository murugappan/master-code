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

 
@isTest
private class SearchFirstExtensionTest {

    static testMethod void myUnitTest() {
        Test.starttest();
        PageReference testPage = Page.SearchFirstAccount;
        Test.setCurrentPage(testPage);
        
        SearchFirstExtension myExtension = new SearchFirstExtension();

        myExtension.searchFirstname = '';
        myExtension.searchLastname = '';
        myExtension.searchCompany = '';
        myExtension.searchPhone = '';
        myExtension.searchEmail = '';      
        myExtension.noAccountResult = true;
        myExtension.noContactResult = true;     
        myExtension.emptyAccountList = true;
        myExtension.emptyContactList = true;       
        myExtension.numAccounts = 0;
        myExtension.numContacts = 0;
        myExtension.errorShow = true;
        myExtension.errorTitle = '';
        myExtension.errorMessage = '';
        myExtension.errorSeverity = '';
             
        myExtension.getresultListAccounts();
        myExtension.getresultListContacts();  
        System.assertEquals('',myExtension.searchFirstname);
        System.assertEquals('',myExtension.searchLastname);
        System.assertEquals('',myExtension.searchCompany);
        System.assertEquals('',myExtension.searchPhone);
        System.assertEquals('',myExtension.searchEmail);
        System.assert(myExtension.noAccountResult);
        System.assert(myExtension.noContactResult);
        System.assert(myExtension.emptyAccountList);
        System.assert(myExtension.emptyContactList);
        System.assert(myExtension.errorShow);
        System.assertEquals('',myExtension.errorTitle);
        System.assertEquals('',myExtension.errorMessage);
        System.assertEquals('',myExtension.errorSeverity);

        myExtension.search();    
        myExtension.createNewAccount();
        myExtension.createNewContact();  

        myExtension.searchFirstname = 'Test';
        myExtension.searchLastname = '';
        myExtension.searchCompany = 'Test';
        myExtension.searchPhone = '345345';
        myExtension.searchEmail = '435345@test.com';
        myExtension.search();

        myExtension.searchFirstname = '';
        myExtension.searchLastname = 'Test';
        myExtension.searchCompany = 'Test';
        myExtension.searchPhone = '345345';
        myExtension.searchEmail = '435345@test.com';
        myExtension.search();

        myExtension.searchFirstname = 'Test';
        myExtension.searchLastname = 'Test';
        myExtension.searchCompany = 'Test';
        myExtension.searchPhone = '345345';
        myExtension.searchEmail = '435345@test.com';
        myExtension.search();    
        
        myExtension.searchFirstname = '';
        myExtension.searchLastname = '';
        myExtension.searchCompany = 'x';
        myExtension.searchPhone = '';
        myExtension.searchEmail = '';
        myExtension.search();  
                      
        myExtension.createNewAccount();
        myExtension.createNewContact(); 
        myExtension.reset();
        Test.stoptest();
    }
}