
import { NativeModules, findNodeHandle } from 'react-native';

const { RNSaveView } = NativeModules;

const getReactTag = (view: ?React$ElementRef<*>) => {
  if (!view) {
    throw new Error('View has to be defined');
  }

  const reactTag = findNodeHandle(view);

  if (!reactTag) {
    throw new Error('Invalid view provided, cannot get reactTag');
  }

  return reactTag;
}

export default {
  saveToPNG: async (view: ?React$ElementRef<*>, path: string) => {
    await RNSaveView.saveToPNG(getReactTag(view), path);
  },
  saveToPNGBase64: async (view: ?React$ElementRef<*>) => {
    const base64 = await RNSaveView.saveToPNGBase64(getReactTag(view));
    return base64;
  },
};
