Meteor.subscribe("userData");
Meteor.subscribe("notifications");

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
    setTimeout(function () {
        if (Notifications.find({}).count()) {
            var notificationsArray = Notifications.find({}).fetch();
            notificationsArray.forEach(function(entry) {
                sAlert.info('<b>'+entry.title+'</b><br>'+entry.body, {html: true});
            });
        }
    }, 2000);

});
