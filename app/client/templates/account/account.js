if (Meteor.isClient) {
    Template.account.events({
      'click [data-action=logout]': function () {
        AccountsTemplates.logout();
      }
    });
}
