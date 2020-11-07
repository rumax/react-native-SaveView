import { NativeModules, findNodeHandle } from 'react-native';

const { RNSaveView } = NativeModules;

// Duplicates definition from findNodeHandle (no export)
type ViewType = null | number | React.Component<any, any> | React.ComponentClass<any>;

const getReactTag = (view: ViewType) => {
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
  saveToPNG: async (view: ViewType, path: string) => {
    await RNSaveView.saveToPNG(getReactTag(view), path);
  },

  saveToPNGBase64: async (view: ViewType) => {
    const base64 = await RNSaveView.saveToPNGBase64(getReactTag(view));
    return base64;
  },
};
