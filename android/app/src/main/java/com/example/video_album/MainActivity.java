package com.example.video_album;

import static com.example.video_album.MyWallpaperService.NewVideoWP;
import static com.example.video_album.MyWallpaperService.setToWallPaper;

import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStoreOwner;

import com.example.video_album.database.Album;
import com.example.video_album.database.AlbumListRepository;
import com.example.video_album.database.AlbumListViewModel;
import com.example.video_album.database.VideosModel;
import com.example.video_album.database.VideosViewModel;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_NAME = "nativeDemo";
    List<String> stringList = new ArrayList<>();
    boolean isRandom;

    MySharedPreference mySharedPreference;
    AlbumListRepository viewModel;
    VideosViewModel videosViewModel;

    String category;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Log.e("check", "configureFlutterEngine");
        viewModel = new AlbumListRepository(getApplication());
        videosViewModel = new VideosViewModel(getApplication());
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);

        mySharedPreference = MySharedPreference.getPreferences(getApplicationContext());

        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            String x;

            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("showToast")) {
                    stringList = call.argument("stringList");
                    isRandom = call.argument("booleanValue");

                    if (stringList != null) {
                        StringBuilder message = new StringBuilder("Selected Videos:\n");
                        for (String path : stringList) {
                            message.append(path).append("\n");
                        }

                        Toast.makeText(MainActivity.this, message.toString(), Toast.LENGTH_LONG).show();

                        Log.d("InitialOnSurfaceCreated:", "Enter" + stringList.get(0));


                        Set<String> stringSet = new HashSet<>(stringList);
                        String delimitedString = TextUtils.join(",", stringSet);


                        mySharedPreference.setRandomVideo(isRandom);

                        mySharedPreference.setVideoPath(delimitedString);

                        x = delimitedString;

                        // Set the wallpaper

                        setToWallPaper(getApplicationContext());


                    } else {
                        Toast.makeText(MainActivity.this, "No videos selected.", Toast.LENGTH_SHORT).show();
                    }
                }

                if (call.method.equals("addNew")) {
                    stringList = call.argument("stringList");
                    StringBuilder message = new StringBuilder("Selected Videos:\n");

                    for (String path : stringList) {
                        message.append(path).append("\n");
                    }
                    Log.d("addNew:", "Enter" + stringList.get(0));

                    NewVideoWP(getApplicationContext(), stringList.get(0));
                }

                if (call.method.equals("albumName")) {

                    Log.d("categorya:", "Enter" + category);

                    createMainDirectory(category);

                    setToWallPaper(getApplicationContext());
                }

                if (call.method.equals("addPath")) {

                    List<String> stringList2 = call.argument("stringListArgument");
                    category = call.argument("albumName");


                    Log.d("stringList2:", "Enter" + stringList2.get(0));

                    if (stringList2 != null) {
                        addData(category, stringList2);
                    }

                }
            }

        });
    }

    private void addData(String dir, List<String> pathListFromFlutter) {
        VideosModel videosModel = new VideosModel();
        for (int i = 0; i < pathListFromFlutter.size(); i++) {
            videosModel.setAlbum_name(dir);
            videosModel.setVideo_path(pathListFromFlutter.get(i));
            videosViewModel.insert(videosModel);
        }
//        setToWallPaper(getApplicationContext());
    }

    private void createMainDirectory(String dir) {
        if (VideoAlbumDatabase.getInstance(this).albumListDao().isDataExist(dir) == 0) {
            Album notify = new Album();
            notify.setAlbum_name(dir);
            viewModel.insert(notify);
            Toast.makeText(this, "inserted", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "This name is already in the list please " +
                    "give another name of Album", Toast.LENGTH_SHORT).show();


        }

    }

}
