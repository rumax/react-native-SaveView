package com.rumax.reactnative.saveview;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;

public class SaveViewModule extends ReactContextBaseJavaModule {
    private static final String NAME = "RNSaveView";
    private ReactApplicationContext context;

    SaveViewModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    @Override
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void saveToPNG(final int reactTag, final String filePath, final Promise promise) {
        SaveView saveView = new SaveView(context);

        File file = new File(filePath);
        if (file.exists()) {
            file.delete();
            file = new File(filePath);
        }

        saveView.saveToPNG(reactTag, file, new SaveView.OnComplete() {
            @Override
            public void onSuccess() {
                promise.resolve(true);
            }

            @Override
            public void onFail(Exception exception) {
                promise.reject(exception);
            }
        });
    }

    @ReactMethod
    public void saveToPNGBase64(final int reactTag, final Promise promise) {
        SaveView saveView = new SaveView(context);

        saveView.saveToPNGBase64(reactTag, new SaveView.OnCompleteBase64() {
            @Override
            public void onSuccess(String base64) {
                promise.resolve(base64);
            }

            @Override
            public void onFail(Exception exception) {
                promise.reject(exception);
            }
        });
    }
}
