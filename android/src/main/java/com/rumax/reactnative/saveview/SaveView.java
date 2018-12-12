package com.rumax.reactnative.saveview;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.support.annotation.NonNull;
import android.util.Base64;
import android.view.View;
import android.widget.ScrollView;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class SaveView {
  private ReactApplicationContext context;

  public SaveView(@NonNull final ReactApplicationContext context) {
    this.context = context;
  }

  public void saveToPNG(final int reactTag, final File file, @NonNull final OnComplete callback) {
    context.getNativeModule(UIManagerModule.class).addUIBlock(new UIBlock() {
      @Override
      public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
        try {
          View view = nativeViewHierarchyManager.resolveView(reactTag);
          Bitmap bitmap = getBitmap(view);
          saveBitmap(bitmap, file);
          callback.onSuccess();
        } catch (Exception e) {
          callback.onFail(e);
        }
      }
    });
  }

  public void saveToPNGBase64(final int reactTag, @NonNull final OnCompleteBase64 callback) {
    context.getNativeModule(UIManagerModule.class).addUIBlock(new UIBlock() {
      @Override
      public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
        try {
          View view = nativeViewHierarchyManager.resolveView(reactTag);
          Bitmap bitmap = getBitmap(view);
          String base64 = bitmapToBase64(bitmap);
          callback.onSuccess(base64);
        } catch (Exception e) {
          callback.onFail(e);
        }
      }
    });
  }

  private Bitmap getBitmap(View view) {
    View viewToSave = view;

    if (view instanceof ScrollView) {
      ScrollView scrollView = (ScrollView) view;
      viewToSave = scrollView.getChildAt(0);
    }

    return getBitmapFromView(viewToSave, viewToSave.getHeight(), viewToSave.getWidth());
  }

  private Bitmap getBitmapFromView(View view, int height, int width) {
    Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
    Canvas canvas = new Canvas(bitmap);
    Drawable bgDrawable = view.getBackground();

    if (bgDrawable != null) {
      bgDrawable.draw(canvas);
    } else {
      canvas.drawColor(Color.WHITE);
    }

    view.draw(canvas);

    return bitmap;
  }

  private void saveBitmap(Bitmap bitmap, File file) throws IOException {
    if (file.exists()) {
      throw new IOException("File [" + file.getAbsolutePath() + "] already exits");
    }

    try (FileOutputStream output = new FileOutputStream(file)) {
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
    }
  }

  private String bitmapToBase64(Bitmap bitmap) {
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
    byte[] byteArray = byteArrayOutputStream .toByteArray();
    return Base64.encodeToString(byteArray, Base64.DEFAULT);
  }

  public interface OnComplete {
    void onSuccess();
    void onFail(Exception exception);
  }

  public interface OnCompleteBase64 {
    void onSuccess(String base64);
    void onFail(Exception exception);
  }
}
