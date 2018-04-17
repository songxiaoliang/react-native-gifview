<img src="http://oleeed73x.bkt.clouddn.com/1523954189_634686.png" />

[![JavaScript Style Guide](https://cdn.rawgit.com/standard/standard/master/badge.svg)](https://github.com/standard/standard)

#### 功能支持：加载、播放、暂停等。

<img width=400 height=500 src="http://oleeed73x.bkt.clouddn.com/1523955151452.jpg" />
<img width=400 height=500 src="http://oleeed73x.bkt.clouddn.com/1523955135615.jpg" />

#### 一、配置

##### 【 Android 平台配置 】
##### 1. 将android_gifview文件夹拖入android工程包名目录下，例如 com.xxx。
##### 2. 打开android_gifview下文件，将最顶部package com.xxx中xxx替换成自己对应包名。
##### 3. 在MainApplication中的getPackages方法中注册Package:
```java
    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new GifViewPackage()
      );
    }
```

##### 【 iOS 平台配置 】
#####  将ios_gifview文件夹拖入工程目录下即可，如下图
<img src="http://oleeed73x.bkt.clouddn.com/1523953350315.jpg"/>
#### 二、使用

##### 1.将RCTGIFView.js导入RN工程
##### 2.将RCTGIFView作为Component导入,并在render中渲染:
```xml
import RCTGIFView from './RCTGIFView';
render() {
    return (
      <View style={ styles.container }>
        <RCTGIFView 
          style={ styles.gifImage } 
          imageName={ this.state.gifImage }
          playStatus={ this.state.isPlaying }
        />
      </View>
    );
  }
```
##### 3.属性介绍
###### （1）playStatus: 控制gif图的播放桩体，true为播放，false为暂停
###### （2）imageName: gif图URL，em: https://cimili-cdn-gif-of-track.cimili.com/v2_gif_266_6967.gif

