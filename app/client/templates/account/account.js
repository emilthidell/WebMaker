if (Meteor.isClient) {
    Template.account.events({
      'click [data-action=logout]': function () {
        IonPopup.confirm({
          title: 'Are you sure?',
          template: 'Are you <strong>really</strong> sure you want to logout?',
          onOk: function() {
              AccountsTemplates.logout();
          }
        });
      }
    });
}
