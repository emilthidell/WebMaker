Meteor.startup(function () {

    if (Posts.find({}).count() === 0) {
        Posts.insert({
          title: Fake.sentence(),
          body: Fake.paragraph(),
          published: Fake.fromArray([true, false])
        });
    }

    if (Notifications.find({}).count() === 0) {
        Notifications.insert({
          title: Fake.sentence(),
          body: Fake.paragraph(),
          userid: 1
        });
    }

});
