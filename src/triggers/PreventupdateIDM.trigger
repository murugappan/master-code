trigger PreventupdateIDM on User (before update) {

RecordType Rec = [select Id from RecordType where Name = 'Blackboard Standard Contact' and SobjectType ='contact'];
user uu =[Select id,username, Alias from User where id =: UserInfo.getUserId()];

//map<id,user> proid = new map<id,user>([select  profileId from user]);
map<id,profile> ul = new map<id,profile>([select UserLicenseId from profile]);
map<id,UserLicense> uli = new  map<id,UserLicense>([select id,Name from UserLicense]);
if(uu.Alias =='idm')
 { 
 for(user u : Trigger.new)
  {   
    if(u.ContactId!=Rec.id && uli.get(ul.get(u.profileId).UserLicenseId).Name!='Overage High Volume Customer Portal' )
     {
     u.addError(' cannot update users');
     }
   }     
  }
}