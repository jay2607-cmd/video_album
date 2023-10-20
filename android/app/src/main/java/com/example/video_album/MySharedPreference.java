package com.example.video_album;

import static com.example.video_album.Constants.ENABLE_ALL_ALBUM_VIDEO;

import android.content.Context;
import android.content.SharedPreferences;

public class MySharedPreference {
    private static MySharedPreference myPreferences;
    private static SharedPreferences sharedPreferences;
    private static SharedPreferences.Editor editor;

    private MySharedPreference(Context context) {
        sharedPreferences = context.getSharedPreferences(BuildConfig.APPLICATION_ID, Context.MODE_MULTI_PROCESS);
        editor = sharedPreferences.edit();
        editor.apply();
    }

    public void setVideoSound(boolean videoSound) {
        editor.putBoolean(Constants.ENABLE_SOUND, videoSound);
        editor.apply();
    }

    public boolean getVideoSound() {
        return sharedPreferences.getBoolean(Constants.ENABLE_SOUND, false);
    }

    public void setFirstTimeVideo(boolean videoSound) {
        editor.putBoolean(Constants.FIRST_TIME, videoSound);
        editor.apply();
    }

    public boolean getFirstTime() {
        return sharedPreferences.getBoolean(Constants.FIRST_TIME, false);
    }

    public boolean getAllAlbumVideo() {
        return sharedPreferences.getBoolean(ENABLE_ALL_ALBUM_VIDEO, false);
    }

    public void setRandomVideo(boolean randomVideo) {
        editor.putBoolean(Constants.ENABLE_RANDOM_VIDEO, randomVideo);
        editor.apply();
    }

    public boolean getIsRandom() {
        return sharedPreferences.getBoolean(Constants.IS_RANDOM, false);
    }

    public void setIsRandom(boolean setRandom) {
        editor.putBoolean(Constants.IS_RANDOM, setRandom);
        editor.apply();
    }

    public boolean getRandomVideo() {
        return sharedPreferences.getBoolean(Constants.ENABLE_RANDOM_VIDEO, false);
    }

    public static MySharedPreference getPreferences(Context context) {
        if (myPreferences == null) myPreferences = new MySharedPreference(context);
        return myPreferences;
    }

    public void setVideoPath(String videoPath) {
        editor.putString("VIDEO_PATH", videoPath);
        editor.apply();
    }

    public String getVideoPath() {
        return sharedPreferences.getString("VIDEO_PATH", "");
    }

    public void clear() {
        editor.clear();
        editor.apply();
    }

    public void commit() {
        editor.commit();
    }

}
