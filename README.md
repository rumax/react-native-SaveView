
# react-native-save-view

[![npm](https://img.shields.io/npm/l/express.svg)](https://github.com/rumax/react-native-SaveView)
[![npm version](https://badge.fury.io/js/react-native-save-view.svg)](https://badge.fury.io/js/react-native-save-view)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Library for saving React Native View/ScrollView elements

## Example

```js
export default class App extends Component {
  componentDidMount() {
    this._saveView();
  }

  render() {
    return (
      <View ref={ref => this._viewRef = ref} collapsable={false}>
        <Text>Some content</Text>
      </View>
    );
  }

  async _saveView() {
    await this._makeSnapshotPNG();
    await this._makeSnapshotPNGBase64();
  }

  async _makeSnapshotPNG() {
    await SaveView.saveToPNG(ref, '/sdcard/Download/view.png');
    // Check /sdcard/Download/view.png using Device File Explorer
  }

  async _makeSnapshotPNGBase64() {
    const base64 = await SaveView.saveToPNGBase64(ref);
    console.log('base64:', base64);
  }
}
```

## Methods
Name | Android | iOS | Description
---- | ------- | --- | -----------
saveToPNG | ✓ | ✗ | Save View to PNG file. Before the function is called, check that android has [write to file permissions](https://developer.android.com/training/data-storage/files)
saveToPNGBase64 | ✓ | ✗ | Save View to PNG base64

## License

[MIT](https://opensource.org/licenses/MIT)

## Author

- [rumax](https://github.com/rumax)

### Other information

- Generated with [react-native-create-library](https://github.com/frostney/react-native-create-library)
- Zero JavaScript dependency. Which means that you do not bring other dependencies to your project
- If you think that something is missing or would like to propose new feature, please, discuss it with author
- Please, feel free to ⭐️ the project. This gives the confidence that you like it and a great job was done by publishing and supporting it 🤩
