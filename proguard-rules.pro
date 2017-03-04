-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-dontpreverify
-dontwarn **.**
-dontnote
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*-dontskipnonpubliclibraryclassmembers

-keepattributes SourceFile,LineNumberTable,Exceptions,Signature,InnerClasses,EnclosingMethod,*Annotation*,*JavascriptInterface*

-keep enum org.greenrobot.eventbus.ThreadMode { *; }

-keep class **.R$* {*;}
-keep class sun.misc.Unsafe { *; }
-keep class * implements android.os.Parcelable {public static final android.os.Parcelable$Creator *;}
-keep class * extends java.lang.annotation.Annotation

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService

-keepclassmembers enum * {public static **[] values();public static ** valueOf(java.lang.String);}
-keepclassmembers class * extends android.app.Application{*;}
-keepclassmembers class * extends android.app.Activity {public void *(android.view.View);}
-keepclassmembers class ** {@org.greenrobot.eventbus.Subscribe <methods>;}
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent { <init>(java.lang.Throwable); }
-keepclassmembers class * extends android.webkit.WebChromeClient { public void openFileChooser(...); public void onShowFileChooser(...); }
-keepclassmembers class * implements java.io.Serializable { static final long serialVersionUID; private static final java.io.ObjectStreamField[] serialPersistentFields; private void writeObject(java.io.ObjectOutputStream); private void readObject(java.io.ObjectInputStream); java.lang.Object writeReplace(); java.lang.Object readResolve(); }

-keepclasseswithmembers class * {public <init>(android.content.Context, android.util.AttributeSet);}
-keepclasseswithmembernames class * {native <methods>;public <init>(android.content.Context, android.util.AttributeSet, int);}

-keep class org.** {*;}
-keep class android.** {*;}
-keep class com.android.** {*;}
-keep class com.google.** {*;}
-keep class cn.jiajixin.nuwa.** { *; }