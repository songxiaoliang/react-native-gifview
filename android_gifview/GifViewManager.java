package com.xxx.gifview;

import android.widget.ImageView;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import pl.droidsonroids.gif.GifDrawable;

/**
 * GifView
 * Created by songlcy on 2018/4/16.
 */

public class GifViewManager extends SimpleViewManager<ImageView> implements LifecycleEventListener{

    private GifDrawable gifDrawable;
    private ThemedReactContext mContext;
    private Map<String, byte[]> imageCache = new HashMap<>();
    private OkHttpClient mOkHttpClient = new OkHttpClient();
    private static final String GIFVIEW_MANAGER_NAME = "GIFImageView";

    @Override
    public String getName() {
        return GIFVIEW_MANAGER_NAME;
    }

    /**
     * 此处创建View实例，并返回
     * @param reactContext
     * @return
     */
    @Override
    protected ImageView createViewInstance(ThemedReactContext reactContext) {
        this.mContext = reactContext;
        this.mContext.addLifecycleEventListener(this);
        ImageView imageView = new ImageView(reactContext);
        return imageView;
    }

    @ReactProp(name = "imageName")
    public void setImageSrc(final ImageView image, String url) {
//        if(gifDrawable != null && gifDrawable.isPlaying()) {
//            gifDrawable.stop();
//        }
        if(imageCache.containsKey(url)) {
            showGifImage(image,imageCache.get(url));
        } else {
            loadImage(image, url);
        }
    }

    /**
     * 切换播放状态
     * @param image
     * @param status true: 播放 false： 暂停
     */
    @ReactProp(name = "playStatus")
    public void setPlayingStatus(ImageView image, Boolean status) {
        if(gifDrawable != null) {
            if(status) {
                if(!gifDrawable.isPlaying()) {
                    gifDrawable.start();
                }
            } else {
                if(gifDrawable.isPlaying()) {
                    gifDrawable.stop();
                }
            }
        }
    }

    /**
     * 下载Gif,获取图片字节流
     * @param image 组件实例
     * @param url Gif图片URL
     */
    private void loadImage(final ImageView image, final String url) {
        Request request = new Request.Builder().url(url).build();
        Call call = mOkHttpClient.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onResponse(Call call, final Response response) throws IOException {
                mContext.runOnUiQueueThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            showGifImage(image, response.body().bytes());
                            imageCache.put(url, response.body().bytes());
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
            @Override
            public void onFailure(Call call, IOException e) {
            }
        });
    }

    /**
     * 渲染Gif图
     */
    private void showGifImage(final ImageView image, final byte[] imageBytes) {
        try {
            gifDrawable = new GifDrawable(imageBytes);
        } catch (IOException e) {
            e.printStackTrace();
        }
        image.setBackground(gifDrawable);
    }

    @Override
    public void onHostResume() {

    }

    @Override
    public void onHostPause() {

    }

    @Override
    public void onHostDestroy() {
        imageCache.clear();
        gifDrawable.recycle();
    }

}
