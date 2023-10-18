package com.example.video_album;

import static com.example.video_album.MainActivity.isRandom;
import static com.example.video_album.MainActivity.isUnMuted;

import android.app.WallpaperManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.service.wallpaper.WallpaperService;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.SurfaceHolder;

import com.example.video_album.database.VideosModel;
import com.example.video_album.database.VideosRepository;
import com.google.android.exoplayer2.ExoPlayer;
import com.google.android.exoplayer2.MediaItem;
import com.google.android.exoplayer2.Player;

import java.io.File;
import java.io.IOException;
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
    public List<VideosModel> modelList = new ArrayList<>();


    FolderNameRepository folderNameRepository;
    String folderName;
    VideosRepository repository;
    GestureDetector gestureDetector;


    @Override


    public Engine onCreateEngine() {
        Log.d("DoubleTapertg:", "Tapped at");

        gestureDetector = new GestureDetector(MyWallpaperService.this, new GestureListener());
        return new VideoEngine();
    }

    public class VideoEngine extends Engine { // Implement OnSharedPreferenceChangeListener
        ExoPlayer exoPlayer;
        private BroadcastReceiver broadcastReceiver;

        public VideoEngine() {
            super();
            Log.d("folderName:", "VideoEngine");
        }


        @Override
        public void onCreate(SurfaceHolder surfaceHolder) {

            super.onCreate(surfaceHolder);

            Log.d("VideoEngine:", "onCreate");
            folderNameRepository = new FolderNameRepository(getApplication());
            folderName = folderNameRepository.getList().get(0).getFolder_name();


            Log.e("isMutedcheck:", "" + isUnMuted);

            repository = new VideosRepository(getApplication());
            exoPlayer = new ExoPlayer.Builder(getApplicationContext()).setVideoScalingMode(2).build();
            exoPlayer2 = exoPlayer;

            Log.d("folderName:", "name--> " + folderName);

            modelList = repository.getVideosData(folderName);

            Log.e("modelsize:", "" + modelList.size());


            //todo: put condition that isRandom true or not??
//            if (isRandom) {
//                playRandomVideoWallPaper(modelList);
//            }

           /* IntentFilter intentFilter3 = new IntentFilter("CHANGE_WALLPAPER");
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
            registerReceiver(broadcastReceiver3, intentFilter3);*/


            IntentFilter intentFilter = new IntentFilter(VIDEO_PARAMS_CONTROL_ACTION);
            intentFilter.addAction(RANDOM_PARAMS_CONTROL_ACTION);
            broadcastReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {

                    if (intent.getAction().toString().equals(VIDEO_PARAMS_CONTROL_ACTION)) {
//                        exoPlayer.setVolume(0.0f);

                        if (intent.getBooleanExtra(KEY_ACTION, true)) {
                            Log.d("checkreceiver:", "voulme --> Enter if in boradcast");
                            exoPlayer.setVolume(0.0f);
                        } else {
                            Log.d("checkreceiver:", "voulme --> Enter else");
                            exoPlayer.setVolume(1.0f);
                        }
                    }
                    if (intent.getAction().toString().equals(RANDOM_PARAMS_CONTROL_ACTION)) {
                        if (intent.getBooleanExtra(KEY_RANDOM, false)) {
                            Log.d("checkreceiver:", "video --> Enter if in boradcast");
//                        playRandomVideoWallPaper(modelList);
                            playAutoVideoWallPaper(modelList);
                            return;
                        } else {
                            Log.d("checkreceiver:", "video --> Enter else in boradcast");

                            playRandomVideoWallPaper(modelList);
                        }
                    }
                }
            };
            registerReceiver(broadcastReceiver, intentFilter);

        }

        @Override
        public void onSurfaceCreated(SurfaceHolder holder) {
            super.onSurfaceCreated(holder);

            Log.e("CheckData:", "onSurfaceCreated");


            Log.e("VideoExist:", "onSurfaceCreated" + modelList.size());
            for (int i = 0; i < modelList.size(); i++) {
                String path = modelList.get(i).getVideo_path();
                Log.e("videoPath:", "First Time --> " + path);
                MediaItem mediaItem = MediaItem.fromUri(path);
                exoPlayer.addMediaItem(mediaItem);
            }

//            playAutoVideoWallPaper(modelList);

            exoPlayer.setRepeatMode(Player.REPEAT_MODE_ALL);
            exoPlayer.setVideoSurface(holder.getSurface());
            exoPlayer.prepare();
            exoPlayer.play();
        }

        private void playAutoVideoWallPaper(List<VideosModel> modelList) {
//            valSizeOfArray = 0;
            for (int i = 0; i < modelList.size(); i++) {

                String path = modelList.get(i).getVideo_path();
                File file = new File(path);
                if (file.exists()) {
                    Log.e("videoPath:", "Auto Video Path--> " + path);
                    MediaItem mediaItem = MediaItem.fromUri(path);
                    exoPlayer2.addMediaItem(mediaItem);
//                    valSizeOfArray++;
                } else {
                    Log.e("VideoExist:", "is Not Exist");
                }

            }
        }

        int valSizeOfArray;

        public void playRandomVideoWallPaper(List<VideosModel> arrayList) {
            Random rand = new Random();
            String path = "";
            int upperbound = arrayList.size();
            for (int i = 0; i < (arrayList.size() * 2); i++) {
                int int_random = rand.nextInt(upperbound);

                path = arrayList.get(int_random).getVideo_path();
                Log.e("videoPath:", "Random Video Path--> " + path);
                MediaItem mediaItem = MediaItem.fromUri(path);
                if (exoPlayer2.hasPreviousMediaItem()) {
                    if (!exoPlayer2.getMediaItemAt(exoPlayer2.getPreviousMediaItemIndex()).equals(mediaItem)) {
                        exoPlayer2.addMediaItem(mediaItem);
                        valSizeOfArray++;
                    }
                } else {
                    exoPlayer2.addMediaItem(mediaItem);
                    valSizeOfArray++;
                }
            }
        }

        @Override
        public void onVisibilityChanged(boolean visible) {
            if (visible) {
                exoPlayer.play();
                return;
            }
            exoPlayer.pause();
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
            MyWallpaperService.this.unregisterReceiver(broadcastReceiver);

        }

        @Override
        public void onTouchEvent(MotionEvent event) {
            gestureDetector.onTouchEvent(event);
//            switch (event.getAction()) {
//                case MotionEvent.ACTION_DOWN:
//                    touchDownMs = System.currentTimeMillis();
//                    break;
//                case MotionEvent.ACTION_UP:
//                    handler.removeCallbacksAndMessages(null);
//
//                    if ((System.currentTimeMillis() - touchDownMs) > ViewConfiguration.getTapTimeout()) {
//                        //it was not a tap
//
//                        numberOfTaps = 0;
//                        lastTapTimeMs = 0;
//                        break;
//                    }
//
//                    if (numberOfTaps > 0
//                            && (System.currentTimeMillis() - lastTapTimeMs) < ViewConfiguration.getDoubleTapTimeout()) {
//                        numberOfTaps += 1;
//                    } else {
//                        numberOfTaps = 1;
//                    }
//
//                    lastTapTimeMs = System.currentTimeMillis();
//
//                    if (numberOfTaps == 3) {
//                        Toast.makeText(getApplicationContext(), "triple", Toast.LENGTH_SHORT).show();
//                        //handle triple tap
//                    } else if (numberOfTaps == 2) {
//                        handler.postDelayed(new Runnable() {
//                            @Override
//                            public void run() {
//                                //handle double tap
//                                Toast.makeText(getApplicationContext(), "double", Toast.LENGTH_SHORT).show();
//                            }
//                        }, ViewConfiguration.getDoubleTapTimeout());
//                    }
//            }
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

    private class GestureListener extends GestureDetector.SimpleOnGestureListener {

        @Override
        public boolean onDown(MotionEvent e) {
            return true;
        }

        // event when double tap occurs
        @Override
        public boolean onDoubleTap(MotionEvent e) {
            float x = e.getX();
            float y = e.getY();
            Log.d("DoubleTap:", "Tapped at: (" + x + "," + y + ")");
//            if (!Settings.canDrawOverlays(getApplicationContext())) {
//                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                        Uri.parse("package:" + getPackageName()));
//                startActivityForResult(intent, 0);
//            }
            // Start the FloatingViewService
            Intent serviceIntent = new Intent(getApplicationContext(), FloatingViewService.class);
            startService(serviceIntent);

            // Start your app's MainActivity
//            Intent mainActivityIntent = new Intent(getApplicationContext(), MainActivity.class);
//            mainActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            startActivity(mainActivityIntent);

            return true;
        }

    }

    public static void randomVideo(Context context, boolean value) {
        Intent it = new Intent(RANDOM_PARAMS_CONTROL_ACTION);
        it.putExtra(KEY_RANDOM, value);
        context.sendBroadcast(it);
    }


    public static void setToWallPaper(Context context) {

        // Set the live wallpaper
//        Intent it = new Intent("android.service.wallpaper.CHANGE_LIVE_WALLPAPER");
//        it.putExtra("android.service.wallpaper.extra.LIVE_WALLPAPER_COMPONENT", new ComponentName(context, MyWallpaperService.class));
//        it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        context.startActivity(it);
        Intent it = new Intent("android.service.wallpaper.CHANGE_LIVE_WALLPAPER");
        it.putExtra("android.service.wallpaper.extra.LIVE_WALLPAPER_COMPONENT", new ComponentName(context, MyWallpaperService.class));
        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(it);
        try {
            WallpaperManager.getInstance(context).clear();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
