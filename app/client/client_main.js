Meteor.startup(function() {
    Template.account.helpers({
        'pic': function(){
            var userProfile;
            userProfile = Meteor.user().profile;

            if(userProfile) { // logic to handle logged out state
              return userProfile.picture;
            }
        }
    });
    Template.index.helpers({
        'thumb': function(){
            var userProfile;
            userProfile = Meteor.user().profile;

            if(userProfile) { // logic to handle logged out state
              return userProfile.thumb;
            }
        }
    });
});
