package com.yang.my_shopping_goods_manage;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import com.yang.my_shopping_goods_manage.utils.FileChooseUtil;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    //channel的名称，由于app中可能会有多个channel，这个名称需要在app内是唯一的。
    private static final String CHANNEL_OPENFILEMANAGER = "samples.flutter.io/openFileManager";
//    private static final String CHANNEL_IMPORTDATA = "samples.flutter.io/importData";
    private static final String CHANNEL_TEXTLIST = "samples.flutter.io/textList";
    private EventChannel.EventSink sink;

    // 选择文件后的回调函数
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode,data);
        if (resultCode == Activity.RESULT_OK) {
            Uri uri = data.getData();
            if(uri != null){
                String chooseFileResultPath = FileChooseUtil.getInstance(this).getChooseFileResultPath(uri);
                FileInputStream fileInputStream = null;
                InputStreamReader inputStreamReader = null;
                BufferedReader bufferedReader = null;
                try {
                    fileInputStream = new FileInputStream(chooseFileResultPath);
                    inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
                    bufferedReader = new BufferedReader(inputStreamReader);
                    String line =bufferedReader.readLine();
                    String text = "";
                    while (line!=null){
                        text += line + ",";
                        line = bufferedReader.readLine();
                    }
                    if(text.endsWith(",")){
                        text = text.substring(0, text.length() - 1);
                    }
                    sink.success(text);

                }catch (Exception e){
                    e.printStackTrace();
                } finally {
                    try {
                        bufferedReader.close();
                    }catch (IOException e){
                        e.printStackTrace();
                    }
                    try {
                        inputStreamReader.close();
                    }catch (IOException e){
                        e.printStackTrace();
                    }
                    try {
                        fileInputStream.close();
                    }catch (IOException e){
                        e.printStackTrace();
                    }
                }
            }

        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        //
        new EventChannel(getFlutterView(), CHANNEL_TEXTLIST).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                sink = eventSink;
            }

            @Override
            public void onCancel(Object o) {

            }
        });

        new MethodChannel(getFlutterView(), CHANNEL_OPENFILEMANAGER).setMethodCallHandler(
                (MethodCall methodCall, MethodChannel.Result result)->{
                    if (methodCall.method.equals("openFileManager")) {
                        openFileSelector();
//                        openAssignFolder("/storage/emulated/0/Tencent/QQfile_recv/");
                    } else if(methodCall.method.equals("importData")) {
                        String args1 = methodCall.argument("args1");
                        writeData(args1);
                        result.success(0);
                    }
                }
        );
    }


    private void openFileSelector() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("file/*.txt");//设置类型，我这里是任意类型，任意后缀的可以这样写。
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        startActivityForResult(intent, 0);
    }



    private void writeData(String data) {
        String filePath = "/sdcard/xicunshudianApp/";
        String fileName = "shudianData.txt";
        writeTxtToFile(data, filePath, fileName);
    }

    // 将字符串写入到文本文件中
    private void writeTxtToFile(String strcontent, String filePath, String fileName) {
        //生成文件夹之后，再生成文件，不然会出错
        makeFilePath(filePath, fileName);

        String strFilePath = filePath + fileName;
        // 每次写入时，都换行写
        String strContent = strcontent + "\r\n";
        try {
            File file = new File(strFilePath);
            if(file.exists()){
                file.delete();
            }
            if (!file.exists()) {
                Log.d("TestFile", "Create the file:" + strFilePath);
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            RandomAccessFile raf = new RandomAccessFile(file, "rwd");
            raf.seek(file.length());
            raf.write(strContent.getBytes());
            raf.close();
        } catch (Exception e) {
            Log.e("TestFile", "Error on write File:" + e);
        }
    }

//生成文件

    private File makeFilePath(String filePath, String fileName) {
        File file = null;
        makeRootDirectory(filePath);
        try {
            file = new File(filePath + fileName);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return file;
    }

//生成文件夹

    private static void makeRootDirectory(String filePath) {
        File file = null;
        try {
            file = new File(filePath);
            if (!file.exists()) {
                file.mkdir();
            }
        } catch (Exception e) {
            Log.i("error:", e + "");
        }
    }
}
