@istest
Private class LiveChatTranscriptTest{

static testmethod void unittest(){

LiveChatVisitor Livechat = new LiveChatVisitor();
insert Livechat;
LiveChatTranscript  Test = New LiveChatTranscript();
Test.LiveChatVisitorid=Livechat.id;
Insert test;
 }
}