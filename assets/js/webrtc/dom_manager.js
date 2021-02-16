
function getLocalVideoId(roomCode) {
  return `local-video-${roomCode}`;
}

function getPeerVideoId(id) {
  return `peer-video-${id}`;
}

  /** Prepare our DOM to use WebRTC */
function setup(id, templateId, roomCode, stream, mute = false, isBaby = false) {

  const roomElement = document.getElementById(`room-${roomCode}`)
  const rootNode = isBaby ? document.getElementById(`room-${roomCode}-main`) : document.getElementById(`room-${roomCode}-peers`)
  if (!document.getElementById(id)) {
      const template = document.getElementById(templateId);
      const child = document.importNode(template.content, true);
      child.querySelector('video').id = id;
      rootNode.appendChild(child);
    }
    const el = document.getElementById(id);
    el.srcObject = stream;
    el.muted = mute;
    return el;
  }

export default class DomManager {

  constructor(code, rootNode) {
    this.roomCode = code;
    this.templateId = 'webrtc-video-template';
    this.rootNode = rootNode;
  }

  setupLocal(stream) {
    const el = setup(getLocalVideoId(this.roomCode), this.templateId, this.roomCode, stream, true);
    el.classList.add('local-video');
    window.mute("audio")
    window.mute("video")
  }

  setupPeer(peerId, from_metadata, stream) {
    console.log(`setupPeer ${from_metadata}`)
    console.log(`setupPeer specifed ${from_metadata.is_device}`)
    setup(getPeerVideoId(peerId), this.templateId, this.roomCode, stream, false, from_metadata?.is_device);
  }

  removePeer(peerId) {
    const element = document.getElementById(getPeerVideoId(peerId));
    element.parentNode.removeChild(element);
  }

  local() {
    return document.getElementById(getLocalVideoId());
  }

}
