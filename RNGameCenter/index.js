import { NativeModules, NativeEventEmitter } from 'react-native';
const { RNGameCenter } = NativeModules;

const emitter = new NativeEventEmitter(RNGameCenter);

module.exports = {
    initialize:(options: object) => RNGameCenter.initialize(options),
    getPlayer: () => RNGameCenter.getPlayer(),
    openLeaderboardModal:(options: object) => RNGameCenter.openLeaderboardModal(options),
    submitLeaderboardScore:(score: int, options: object) => RNGameCenter.submitLeaderboardScore(score, options),
    addEventListener: (eventType: string, listener: Function) => emitter.addListener(eventType, listener),
    removeListener: (eventType: string) => emitter.removeAllListeners(eventType)
};

export default RNGameCenter
