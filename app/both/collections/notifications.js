Notifications = new Mongo.Collection('notifications');

Notifications.attachSchema(new SimpleSchema({
  userid: {
    type: Number
  },
  title: {
    type: String,
    max: 200
  },
  body: {
    type: String
  },
  unread: {
    type: Boolean,
    defaultValue: true
  }
}));
