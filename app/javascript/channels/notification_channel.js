import consumer from "channels/consumer"

const intersects = (a, b) => {
  const s = new Set(b);
  return [...new Set(a)].some(x => s.has(x));
};

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    this.sendAutoReloadNotification();
    let topics = this.getCurrentUserTopics();

    if(!intersects(topics, data.topics)) return;

    this.perform('create_notification', data)
    this.displayNotification();
  },

  getCurrentUserTopics() {
    let el = document.getElementById('current_user_topics');
    let data = el.attributes['data'].value;
    return data.split(', ');
  },

  displayNotification() {
    var bell = document.getElementsByClassName('notification-bell')[0]
    bell.classList += ' notified'
  },

  sendAutoReloadNotification() {
    let url = window.location.href.split('/')[3].split('?')[0];
    
    if(!(url == '' || url == 'questions')) return;

    let elem = document.getElementsByClassName('autoreload-notification')[0]
    console.log(elem)
    elem.style.visibility="visible"
  }
});
