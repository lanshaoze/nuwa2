# What's it
 
Nuwa2 is an Android HotFix plugin, it can fix bugs silently without publishing apk, it is updated from nuwa.

# Advantages

* Support gradle 1.x to 2.x ("nuwa1" don't support gradle 2.x)
* High stability and compatibility ("andfix" don't compatibility enough)
* Simpler and easier to use
* Support add shell, worked after MainActivity ("tinker" don't support add shell)
* Support add or alter classes and methods under project's packagename
* Support ProGuard
 
# Usage

1. Copy the plugin folder to your project app/plugin.

2. Add permissions (android 6.0 above need to apply for permission, maybe you can use 'targetSdkVersion 22') 

	```java
	<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
	```
3. Append the content in proguard-rules.pro to your project's proguard-rules.pro (don't need repeat existing lines) 

4. Add these codes to app/build.gradle and sync project.

	```java
	//plugin area
	 buildscript {
		repositories {maven {url uri('./plugin')}}
		dependencies {classpath 'cn.jiajixin.nuwa:buildsrc:2.0'}
	}
	apply plugin: 'cn.jiajixin.nuwa'
	
	//proguard area
	buildTypes {
		release {
			minifyEnabled true
			proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
		}
	}
	
	//dependencies area
	dependencies {
		compile 'cn.jiajixin.nuwa:nuwa:1.0.0'
	}
	```
5. Create your custom application class and override this method below

	```java
	@Override
	protected void attachBaseContext(Context base) {
		super.attachBaseContext(base);
		try{
			Nuwa.init(base);
			//This is a sample path below, apk in diffrent version need diffrent patch file, so you can use BuildConfig.VERSION_CODE
			String path = "/sdcard/patch_"+BuildConfig.VERSION_CODE+".jar";
			Nuwa.loadPatch(base, path);
		}catch (Throwable e){//android 6.0 above need to apply for sdcard permission
			e.printStackTrace();
		}
		//your other code...
	}
	```

# Make Patch

1. Generate signed apk which build type is release. 
It will auto create this folder: app/build/outputs/nuwa, copy it to somewhere such as 'D:/nuwa', and install your generated apk.
You need to backup the nuwa folder and the project source when you generated signed apk, because making patch will use them.

2. Alter some code in bug-source under project's packagename, such as make a toast for testing.
If you haven't used 'productFlavors', startup terminal in the bottom of android-studio, typing in:
	```java
	gradlew nuwaReleasePatch -P NuwaDir=D:/nuwa
	```
If you have used 'productFlavors' in your build.gradle, such as:
	```java
	productFlavors {
        channelTecent{//something else}
        channelHuawei{//something else}
    }
	```
Typing in (Command contains your channel name, and this patch is usually universal):
	```java
	gradlew nuwaChannelTecentReleasePatch -P NuwaDir=D:/nuwa
	```
It will show "BUILD SUCCESSFUL", then wait some seconds, the patch will be made in "app/build/outputs/nuwa/release/patch.jar".
Push this patch into sdcard ("/sdcard/patch_"+BuildConfig.VERSION_CODE+".jar", the path in step 5).
Kill progress (not just finish), restart your app, you can see the changes you did.
Usually, you can download the patch from network.

That's all, enjoy it!

https://github.com/654277633/nuwa2
