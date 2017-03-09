# nuwa2
android hotfix plugin, update the nuwa plugin, support gradle 1.2.3 to 2.x.

说明：
热修复是什么？热修复就是app出现bug之后无需用户更新app就能静默修复bug，注意不是web页面而是可以静默修复原生bug哦。

外面的热修复框架都是公说公有理，婆说婆有理，既然如此，我就都体验一番。

以前使用阿里的andfix集成到我们的项目，听云错误监听工具发现，兼容性80%-90%，报错率达到0.1以上，不可使用。

腾讯微信的tikner也体验过，操作复杂，文档复杂，且不支持加固，国内360助手安卓市场，必须用360加固软件加固后才能发包，故暂不用tinker。

美团的Robust据说比较靠谱，但是不开源，想用用不了。

大众点评某工程师开发的一套nuwa，用的是DexClassLoader，系统自带api，兼容性好，稳定性高，针对加固的APP，如360加固仅支持修复MainActivity加载之后的MainActivity之外的代码。

但是作者的nuwa，仅支持gradle 1.2.3（即项目根目录build.gradle中的classpath 'com.android.tools.build:gradle:1.2.3'）。

现在都2.3的时代了，instant-run等都需要新版gradle才能支持，所以很多人都不愿意用。作者没维护，因为他自己创业去了？好像后面就没碰这些代码了吧。

由于nuwa原理可靠，操作简单，不要浪费前人的血汗，最主要的是我没得其他框架用啊，外面也没人弄套“可用”的插件，于是我把他的gradle插件更新了一番，支持1.x到现在的2.x版本，另外完善了之前的部分细节。

支持新增包、新增类、新增方法、新增变量、修改类、不能修改资源文件、不能修改Application子类，限制只能修改App包名下的java文件，第三方库不能修改。

下面说明操作步骤(Teamlib SDK内部基础library项目默认已集成，具体参见HotfixManager.java类注释。下面介绍单独集成方式)：

1.复制plugin目录到app/plugin

-------------------------------------------------------------------------------------------------------------------------------

2.需要下面两个权限

< uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

< uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>


-------------------------------------------------------------------------------------------------------------------------------

3.追加proguard-rules.pro中的混淆配置并且开启混淆（如果你的项目中有配置的某一行，则那一行不用重复复制过去）

buildTypes {

	release {
		minifyEnabled true
		proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
	}
}

-------------------------------------------------------------------------------------------------------------------------------

4.app/build.gradle添加插件和依赖

buildscript {

    repositories {maven {url uri('./plugin')}}
    dependencies {classpath 'cn.jiajixin.nuwa:buildsrc:2.0'}
}

apply plugin: 'cn.jiajixin.nuwa'


compile 'cn.jiajixin.nuwa:nuwa:1.0.0'

-------------------------------------------------------------------------------------------------------------------------------

5.自定义Application重写下面这个方

@Override
protected void attachBaseContext(Context base) {

	super.attachBaseContext(base);
	Nuwa.init(this);
	// /sdcard/patch_1.jar，可以用VERSION_CODE区分版本以免新版APP也加载这些老补丁，
	//具体应用可以让后台做一个检测和下载补丁的接口，下载完成重启Application，而不是简单重启Activity，这个我就不多说了
	Nuwa.loadPatch(this, Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + "patch_" + BuildConfig.VERSION_CODE + ".jar");
	//其他你的代码方法上面两句后面
}

-------------------------------------------------------------------------------------------------------------------------------

6.rebuild，同步后，打包release版本apk。会在app/build/outputs中生成nuwa文件夹，备份好，
例如放到d:/nuwa。

每个release正式发包时一定要备份当前打包的apk对应的源码，和对应的nuwa文件夹。安装这个打包好的apk。

-------------------------------------------------------------------------------------------------------------------------------

7.先测试单个渠道情况，在上一次出现bug的apk对应的源码基础上，修改任意一个方法，或者新增一个java类，或者删除某个方法。

打开android studio底部Terminal命令行输入：gradlew nuwaReleasePatch -P NuwaDir=D:/nuwa，首次编译可能要下载一些东西，后面就非常快，
其中D:/nuwa就是第6步骤中保存的文件。

命令执行完成会出现“BUILD SUCCESSFUL”，然后等待几秒，补丁将生成到app/build/outputs/nuwa文件夹中的patch.jar。

重命名拷贝放到第5步指定的位置，/sdcard/patch_你的版本号.jar。杀掉APP进程重启即可看到你改动后的功能（简单finish不行，需要killProgress）。

-------------------------------------------------------------------------------------------------------------------------------

8.这一点没有就忽略不用看。国内多渠道打包问题。例如你配置了两个渠道

	productFlavors {
	
        qihoo360//360助手
                {
                    manifestPlaceholders = [channelID_td_analytics: "360市场"]
                    buildConfigField "String", "channelId_talkingdata", "\"xxxxxxx\""
                    buildConfigField "String", "channel", "\"qihoo360\""
                }
        tecent//应用宝
                {
                    manifestPlaceholders = [channelID_td_analytics: "应用宝"]
                    buildConfigField "String", "channelId_talkingdata", "\"xxxxx\""
                    buildConfigField "String", "channel", "\"tecent\""
                }
		
    }
    
生成补丁命令差异，中间多了Qihoo360即可：

gradlew nuwaQihoo360ReleasePatch -P NuwaDir=D:/nuwa

