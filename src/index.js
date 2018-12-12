
import { NativeModules, findNodeHandle } from 'react-native';

const { SaveView } = NativeModules;

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
    await SaveView.saveToPNG(getReactTag(view), path);
  },
  saveToPNGBase64: async (view: ?React$ElementRef<*>) => {
    const base64 = await SaveView.saveToPNGBase64(getReactTag(view));
    return base64;
  },
};
