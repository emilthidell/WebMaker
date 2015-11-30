var getFbPicture = function(accessToken, size) { // make async call to grab the picture from facebook
    var result;
    result = Meteor.http.get("https://graph.facebook.com/me", {
      params: {
        access_token: accessToken,
        fields: 'picture.width('+size+').height('+size+')'
      }
    });
    if(result.error) {
      throw result.error;
    }
    return result.data.picture.data.url; // return the picture's url
  };

// during new account creation get user picture from Facebook and save it on user object
Accounts.onCreateUser(function(options, user) {
  if(options.profile) {
    options.profile.picture = getFbPicture(user.services.facebook.accessToken, 300);
    options.profile.thumb   = getFbPicture(user.services.facebook.accessToken,  25);
    user.profile = options.profile; // We still want the default 'profile' behavior.
  }

  return user;
});

Meteor.publish("userData", function () {
    return Meteor.users.find({_id: this.userId},
        {fields: {'services': 1 }
    });
});

Meteor.publish("notifications", function () {
    // this.userId
    return Notifications.find({ userid: 1 , unread: true});
});
