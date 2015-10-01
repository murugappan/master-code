/*
Class :AttachRedirect
Date:21.05.2013
*/
@isTest(seealldata=true)
private class AttachRedirectTest {

    static testMethod void myUnitTest() {
        
        
        
        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        String userencoded = EncodingUtil.base64Encode(Blob.valueof(Userinfo.getUserID()));
        userencoded = EncodingUtil.urlEncode(userencoded,'UTF-8');
        Apexpages.currentpage().getParameters().put('uval',userencoded);
        
        AttachRedirect ar = new AttachRedirect();
        ar.redirect();
        
        Test.startTest();
        
        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        Apexpages.currentpage().getParameters().put('uval','article');
        
        AttachRedirect ar1 = new AttachRedirect();
        ar1.redirect();
        
        Apexpages.currentpage().getParameters().put('bname','Test');
        Apexpages.currentpage().getParameters().put('fname','Test1.txt');
        Apexpages.currentpage().getParameters().put('sec','abc');
        Apexpages.currentpage().getParameters().put('aws','abc');
        
        Apexpages.currentpage().getParameters().put('uval','abc');
        
        AttachRedirect ar2 = new AttachRedirect();
        ar2.redirect();
       Test.stopTest();
    }
}