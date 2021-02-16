function getHostname() {
  if (document.location.protocol.indexOf('https') >= 0) {
    return 'wss://babystream.kalvad.com:443'
  } else {
    return `ws://${window.location.host.replace('4000', '8042')}`;
  }

}

function buildUrl(code) {
  return `${getHostname()}/webrtc/${code}`;
}

export default class Socket {

  constructor(code, orchestrator) {
    this.url = buildUrl(code);
    this.orchestrator = orchestrator;
  }

  open() {
    if (this.interval) {
      window.clearInterval(this.interval);
    }
    this.interval = window.setInterval(() => {
      this.socket.send('ping');
    }, 30000);

    document.cookie = "credentials=" + JSON.stringify({
      username: "BROWSER",
      password: "PASSWORD"
    });
    this.socket = new WebSocket(this.url);

    const messageEventListeners = {
      answer: (data, from, from_metadata) => this.orchestrator.onAnswer(this.socket, data, from),
      authenticated: (data, from, from_metadata) => this.orchestrator.onAuthenticated(this.socket, data, from),
      candidate: (data, from, from_metadata) => this.orchestrator.onCandidate(this.socket, data, from),
      joined: (data, from, from_metadata) => this.orchestrator.onJoined(this.socket, data, from, from_metadata),
      left: (data, from, from_metadata) => this.orchestrator.onLeft(this.socket, data, from),
      offer: (data, from, from_metadata) => this.orchestrator.onOffer(this.socket, data, from, from_metadata),
      error: (data, from, from_metadata) => this.orchestrator.onError(this.socket, data, from),
    };

    this.socket.onmessage = (raw) => {
      if (raw === 'pong') {
        return;
      }
      const message = JSON.parse(raw.data);
      messageEventListeners[message.event](message.data, message.from, message.from_metadata);
    };
  }
}
