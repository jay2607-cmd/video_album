package com.example.video_album;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.service.wallpaper.WallpaperService;
import android.util.Log;
import android.view.SurfaceHolder;

import com.example.video_album.database.VideosModel;
import com.example.video_album.database.VideosRepository;
import com.google.android.exoplayer2.ExoPlayer;
import com.google.android.exoplayer2.MediaItem;
import com.google.android.exoplayer2.Player;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MyWallpaperService extends WallpaperService {
    public static ExoPlayer exoPlayer2;
    private static final boolean ACTION_MUSIC_MUTE = true;
    private static final boolean ACTION_MUSIC_UNMUTE = false;
    private static final String KEY_ACTION = "music";
    private static final String KEY_RANDOM = "set_random_videos";
    public static final String VIDEO_PARAMS_CONTROL_ACTION = BuildConfig.APPLICATION_ID;
    public static final String RANDOM_PARAMS_CONTROL_ACTION = "random_video_data";
    public static List<String> arrayList = new ArrayList<>();
    public static List<VideosModel> modelList = new ArrayList<>();
    MySharedPreference mySharedPreference;
    BroadcastReceiver broadcastReceiver3;
    VideosRepository repository;

    @Override
    public Engine onCreateEngine() {
        return new VideoEngine();
    }

    public class VideoEngine extends Engine { // Implement OnSharedPreferenceChangeListener
        ExoPlayer exoPlayer;

        @Override
        public void onCreate(SurfaceHolder surfaceHolder) {
            super.onCreate(surfaceHolder);
            repository = new VideosRepository(getApplication());
            exoPlayer = new ExoPlayer.Builder(getApplicationContext()).setVideoScalingMode(2).build();
            exoPlayer2 = exoPlayer;
            // Register the SharedPreferences listener
//            SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences(BuildConfig.APPLICATION_ID, Context.MODE_PRIVATE);
//            sharedPreferences.registerOnSharedPreferenceChangeListener(this);
            modelList = repository.getVideosData("hh");
            Log.e("modelsize:", "" + modelList.size());
            mySharedPreference = MySharedPreference.getPreferences(getApplicationContext());
            mySharedPreference.setFirstTimeVideo(true);

            IntentFilter intentFilter3 = new IntentFilter("CHANGE_WALLPAPER");
            intentFilter3.addAction("AddVideos");

            broadcastReceiver3 = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    Log.e("videoPath:", "eNTER IN BROADCAST");
//                    if (intent.getAction().equals("CHANGE_WALLPAPER")) {
//                        if (intent.getBooleanExtra("KEY_SCHEDULE_WP", false)) {
////                            playVideo(arrayList);
//                        } else {
//                            if (mySharedPreference.getRandomVideo()) {
//                                playRandomVideoWallPaper(arrayList);
//                            } else {
////                                playAutoVideoWallPaper(arrayList);
//                            }
//                        }
//                    } else if (intent.getAction().equals("AddVideos")) {
                    String[] paths = intent.getStringExtra("KEY_SCHEDULE_WP").split(",");
                    for (int i = 0; i < paths.length; i++) {
                        if (!paths[i].isEmpty()) {
                            MediaItem mediaItem = MediaItem.fromUri(paths[i]);
                            exoPlayer2.addMediaItem(mediaItem);
                            Log.e("videoPath:", "Path--> " + paths.length);
////                                valSizeOfArray++;
                        }
//
                    }
////
//                    }
                }
            };
            registerReceiver(broadcastReceiver3, intentFilter3);


//            String delimitedString = mySharedPreference.getVideoPath();
//            String[] stringArray = delimitedString.split(",");
//            arrayList.addAll(Arrays.asList(stringArray));
//            Log.e("dataa:", "" + arrayList.get(0));

            if (mySharedPreference.getVideoSound()) {
                exoPlayer.setVolume(1.0f);
            } else {
                exoPlayer.setVolume(0.0f);
            }

//            if (mySharedPreference.getRandomVideo()) {
//                playRandomVideoWallPaper(arrayList);
//            }


            for (int i = 0; i < modelList.size(); i++) {
                String path = modelList.get(i).getVideo_path();
                Log.e("videoPatha:::", "First Time --> " + path);
                MediaItem mediaItem = MediaItem.fromUri(path);
                exoPlayer.addMediaItem(mediaItem);
            }

            exoPlayer.setRepeatMode(Player.REPEAT_MODE_ALL);
            exoPlayer.setVideoSurface(surfaceHolder.getSurface());
            exoPlayer.prepare();
            exoPlayer.play();
        }

        private void playAutoVideoWallPaper(String arrayList) {
//            valSizeOfArray = 0;
            for (int i = 0; i < (MyWallpaperService.this.arrayList.size()); i++) {
                String path = MyWallpaperService.this.arrayList.get(i);
                Log.e("dbPath:", "auto --> " + path);
                MediaItem mediaItem = MediaItem.fromUri(arrayList);
                exoPlayer.addMediaItem(mediaItem);
//                valSizeOfArray++;
            }
        }

        public void playRandomVideoWallPaper(List<String> arrayList) {
            int valSizeOfArray = 0;
            Random rand = new Random();
            String path = "";
            int upperbound = arrayList.size();
            for (int i = 0; i < (arrayList.size() * 2); i++) {
                int int_random = rand.nextInt(upperbound);
                path = arrayList.get(int_random);
                MediaItem mediaItem = MediaItem.fromUri(path);
                if (exoPlayer.hasPreviousMediaItem()) {
                    if (!exoPlayer.getMediaItemAt(exoPlayer.getPreviousMediaItemIndex()).equals(mediaItem)) {
                        exoPlayer.addMediaItem(mediaItem);
                        valSizeOfArray++;
                    }
                } else {
                    exoPlayer.addMediaItem(mediaItem);
                    valSizeOfArray++;
                }
            }
        }

        @Override
        public void onVisibilityChanged(boolean visible) {
            if (visible) {
                exoPlayer.play();
            } else {
                exoPlayer.pause();
            }
        }

        @Override
        public void onSurfaceDestroyed(SurfaceHolder holder) {
            super.onSurfaceDestroyed(holder);
            if (exoPlayer.isPlaying()) {
                exoPlayer.stop();
            }
            if (exoPlayer != null) {
                exoPlayer.release();
            }
            exoPlayer = null;
        }

        @Override
        public void onDestroy() {
            super.onDestroy();

            if (exoPlayer != null) {
                exoPlayer.release();
            }
            this.exoPlayer = null;
            MyWallpaperService.this.unregisterReceiver(broadcastReceiver3);
        }
    }

    // Rest of your MyWallpaperService class...
    public static void muteMusic(Context context) {
        Intent it = new Intent(VIDEO_PARAMS_CONTROL_ACTION);
        it.putExtra(KEY_ACTION, ACTION_MUSIC_MUTE);
        context.sendBroadcast(it);
    }

    public static void unmuteMusic(Context context) {
        Intent it = new Intent(VIDEO_PARAMS_CONTROL_ACTION);
        it.putExtra(KEY_ACTION, ACTION_MUSIC_UNMUTE);
        context.sendBroadcast(it);
    }

    public static void NewVideoWP(Context context, String path) {
        Log.e("videoPath:", "NewVideoWP --> " + path);
        Intent it = new Intent("AddVideos");
        it.putExtra("KEY_SCHEDULE_WP", path);

        context.sendBroadcast(it);
//        String[] paths = path.split(",");

    }

//    @Override
//    public boolean stopService(Intent name) {
//        if (exoPlayer != null) {
//            exoPlayer.release();
//            exoPlayer = null;
//        }
//        if (broadcastReceiver != null) {
//            unregisterReceiver(this.broadcastReceiver);
//        }
//        return super.stopService(name);
//    }
//

    public static void setToWallPaper(Context context) {

        // Set the live wallpaper
        Intent it = new Intent("android.service.wallpaper.CHANGE_LIVE_WALLPAPER");
        it.putExtra("android.service.wallpaper.extra.LIVE_WALLPAPER_COMPONENT", new ComponentName(context, MyWallpaperService.class));
        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(it);

    }
}
