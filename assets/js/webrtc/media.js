function getUserMediaConstraints() {
  return {
    audio: true,
    video: true,
  }
}

export default class Media {
  constructor(socket) {
    this.socket = socket;
  }

  igniteDevices() {
    return navigator.mediaDevices.getUserMedia(getUserMediaConstraints());
  }
}
