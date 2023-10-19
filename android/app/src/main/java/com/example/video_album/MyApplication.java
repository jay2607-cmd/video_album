package com.example.video_album;

import android.app.Application;

public class MyApplication extends Application {

    MySharedPreference mySharedPreference;

    @Override
    public void onCreate() {
        super.onCreate();

        mySharedPreference = MySharedPreference.getPreferences(getApplicationContext());

    }
}
