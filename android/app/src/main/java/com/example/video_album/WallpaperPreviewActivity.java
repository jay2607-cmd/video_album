package com.example.video_album;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;

import com.example.video_album.database.VideosModel;
import com.example.video_album.database.VideosViewModel;
import com.example.video_album.databinding.ActivityWallpaperPreviewBinding;
import com.google.android.exoplayer2.ExoPlayer;
import com.google.android.exoplayer2.MediaItem;
import com.google.android.exoplayer2.Player;
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class WallpaperPreviewActivity extends AppCompatActivity {
    ActivityWallpaperPreviewBinding binding;
    String path, albumName;
    String strFrom;
    MySharedPreference mySharedPreference;
    ExoPlayer exoPlayer;
    List<VideosModel> arrayList = new ArrayList<>();
    VideosViewModel viewModel;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityWallpaperPreviewBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        mySharedPreference = MySharedPreference.getPreferences(WallpaperPreviewActivity.this);
        viewModel = new ViewModelProvider(this).get(VideosViewModel.class);

        albumName = getIntent().getStringExtra("album_name");
//        if (strFrom.equals("singleWp")) {
//            path = getIntent().getStringExtra("videoPath");
//        } else {
//            albumName = getIntent().getStringExtra("album_name");
//        }

        preview();
        toolBar();
    }

    private void toolBar() {
        binding.back.setOnClickListener(view -> finish());
    }

    private void preview() {
        exoPlayer = new ExoPlayer.Builder(getApplicationContext())
                .setVideoScalingMode(2)
                .build();
////
        if (mySharedPreference.getVideoSound()) {
            exoPlayer.setVolume(1.0f);
        } else {
            exoPlayer.setVolume(0.0f);
        }
        exoPlayer.clearMediaItems();
//        if (strFrom.equals("singleWp")) {
//            MediaItem mediaItem = MediaItem.fromUri(path);
//            exoPlayer.setMediaItem(mediaItem);
//        } else {
            arrayList = new ArrayList<>();
            arrayList = viewModel.getAllVideos(albumName);
            if (mySharedPreference.getRandomVideo()) {
                playRandomVideoWallPaper(arrayList);
            } else {
                playAutoVideoWallPaper(arrayList);
            }

//        }

        binding.videoView.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_ZOOM);
        exoPlayer.setRepeatMode(Player.REPEAT_MODE_ALL);
        binding.videoView.setPlayer(exoPlayer);
        exoPlayer.prepare();
        exoPlayer.play();

//        binding.videoView.setOnPreparedListener(mp -> {
//            mp.setLooping(true);
//            if (mySharedPreference.getVideoSound()) {
//                mp.setVolume(1.0f, 1.0f);
//            } else {
//                mp.setVolume(0.0f, 0.0f);
//            }
//            binding.videoView.start();
//        });

        binding.btnWallpaper.setOnClickListener(view -> {
                MyWallpaperService.alreadySetWallPaper(WallpaperPreviewActivity.this, albumName, mySharedPreference.getRandomVideo(), mySharedPreference.getAllAlbumVideo());

            Toast.makeText(this, "Set Wallpaper Successfully", Toast.LENGTH_SHORT).show();
        });
    }

    private void playRandomVideoWallPaper(List<VideosModel> videosModelList) {
        int valSizeOfArray = 0;
        Random rand = new Random();
        String path = "";
        int upperbound = videosModelList.size();
        for (int i = 0; i < (videosModelList.size() * 2); i++) {

            int int_random = rand.nextInt(upperbound);
            path = videosModelList.get(int_random).getVideo_path();

            Log.e("videoPath:WallpaperService", "Random Video Path--> " + path);

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

    private void playAutoVideoWallPaper(List<VideosModel> videosModelList) {
//            valSizeOfArray = 0;
        for (int i = 0; i < videosModelList.size(); i++) {
            String path = videosModelList.get(i).getVideo_path();
            Log.e("videoPath:", "Auto Video Path--> " + path);
            MediaItem mediaItem = MediaItem.fromUri(path);
            if (i == 0) {
                exoPlayer.setMediaItem(mediaItem);
            } else {
                exoPlayer.addMediaItem(mediaItem);
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (exoPlayer.isPlaying()) {
            exoPlayer.stop();
        }

        if (exoPlayer != null) {
            exoPlayer.release();
        }
        this.exoPlayer = null;
    }
}