import DomManager from './webrtc/dom_manager';
import Media from './webrtc/media';
import Socket from './webrtc/socket';
import Orchestrator from './webrtc/orcherstrator';

window.connect = (roomCode, rootNodeId) => {
  const rootNode = document.getElementById(rootNodeId);
  if (!rootNode) {
    throw "Could not build WebRTC room. Root node is missing from DOM";
  }
  console.log(`Join room ${roomCode}`);

  const domManager = new DomManager(roomCode, rootNode);
  const media = new Media();
  media.igniteDevices().then((stream) => {
    const orchestrator = new Orchestrator(stream, domManager);
    const socket = new Socket(roomCode, orchestrator);
    domManager.setupLocal(stream);
    socket.open(roomCode);
  }).catch((err) => console.error('Failed to setup User context', err));
}

window.mute = (kind) => {
  const videoEl = document.getElementsByClassName('local-video')[0]
  // now get the steam 
  const stream = videoEl.srcObject;
  // now get all tracks
  const tracks = stream.getTracks();
  // now close each track by having forEach loop
  tracks.forEach(function(track) {
    console.log(track)
    console.log(track.kind)
    console.log(kind)
    if (track.kind == kind){
      console.log("filpped")
      track.enabled = !track.enabled;
    }
    // toggle audio button
    const audioButton = document.querySelector(".local-video").parentElement.querySelector(".mute-audio")
    if (track.kind == "audio"){
      if (track.enabled){
        audioButton.classList.add("enabled")
        audioButton.classList.remove("disabled")
      } else {
        audioButton.classList.remove("enabled")
        audioButton.classList.add("disabled")
      }
    }
    // toggle audio button
    const videoButton = document.querySelector(".local-video").parentElement.querySelector(".mute-video")
    if (track.kind == "video"){
      if (track.enabled){
        videoButton.classList.add("enabled")
        videoButton.classList.remove("disabled")
      } else {
        videoButton.classList.remove("enabled")
        videoButton.classList.add("disabled")
      }
    }
  });

}