import env from "./env";

function getHandleDescription(socket, rtcConnections, peer_id, event) {
  return (description) => {
      rtcConnections[peer_id].setLocalDescription(description);
      const message = {to: [peer_id], event: event, data: description};
      socket.send(JSON.stringify(message));
  }
}

function getOnIceCandidate(socket, peer_id) {
  return (event) => {
      if (event.candidate != null) {
          const message = {to: [peer_id], event: "candidate", data: event.candidate};
          socket.send(JSON.stringify(message));
      }
  }
}

function getHandleTrack(domManager, peerId, from_metadata) {
  return (event) => {
    domManager.setupPeer(peerId, from_metadata, event.streams[0]);
  };
}

function startRTCConnection(socket, domManager, peer_id, from_metadata, localStream, rtcConnections, config) {
  let connection = new RTCPeerConnection(config);
  connection.addStream(localStream);
  connection.onicecandidate = getOnIceCandidate(socket, peer_id);
  connection.ontrack = getHandleTrack(domManager, peer_id, from_metadata);
  rtcConnections[peer_id] = connection;
}

export default class Orchestrator {
  constructor(stream, domManager) {
    this.domManager = domManager;
    this.stream = stream;
    this.rtcConfig = env.rtcConfig;
    this.offerOptions = {
      offerToReceiveAudio: 1,
      offerToReceiveVideo: 1,
    };
    this.rtcConnections = {};
  }

  onAuthenticated(socket, data, from) {
    this.logMessage('authenticated', data, from);
  }

  onAnswer(socket, data, from) {
    this.rtcConnections[from].setRemoteDescription(data);
  }

  onJoined(socket, data, from, from_metadata) {
    this.logMessage('joined', data, from);
    let peer_id = data.peer_id;
    startRTCConnection(socket, this.domManager, peer_id, from_metadata, this.stream, this.rtcConnections, this.rtcConfig);
    this.rtcConnections[peer_id].createOffer(
        getHandleDescription(socket, this.rtcConnections, peer_id, "offer"),
        console.dir,
        this.offerOptions
    );
  }

  onLeft(socket, data, from) {
    this.logMessage('left', data, from);
    delete this.rtcConnections[data.peer_id];
    this.domManager.removePeer(data.peer_id);
  }

  onOffer(socket, data, from, from_metadata) {
    startRTCConnection(socket, this.domManager, from, from_metadata, this.stream, this.rtcConnections, this.rtcConfig);
    let connection = this.rtcConnections[from];
    connection.setRemoteDescription(data)
    connection.createAnswer(
        getHandleDescription(socket, this.rtcConnections, from, "answer"),
        console.dir,
    );
  }

  onCandidate(socket, data, from) {
    try {
      var candidate = new RTCIceCandidate(data);
      this.rtcConnections[from].addIceCandidate(candidate);
    } catch (e) {
      console.dir(e);
    }
  }

  onError(socket, data, from) {
    this.logMessage('error', data, from);
    console.warn('Server error > ', data);
  }

  logMessage(name, data, from) {
    console.log(`== New message == [${name}]`);
    console.log(`DATA >`, data);
    console.log('FROM >', from);
    console.log('==');
  }

}