package com.example.video_album;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;


import com.example.video_album.database.AddFolderNameDao;
import com.example.video_album.database.AddVideosDao;
import com.example.video_album.database.Album;
import com.example.video_album.database.AlbumListDao;
import com.example.video_album.database.VideosModel;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


@Database(entities = {Album.class, VideosModel.class, FolderName.class}, version = 1,
        exportSchema = false)
public abstract class VideoAlbumDatabase extends RoomDatabase {

    private static VideoAlbumDatabase instance;

//    public abstract AddVideosDao addAlbumDao();

    public abstract AlbumListDao albumListDao();
    public abstract AddVideosDao addVideosDao();

    public abstract AddFolderNameDao addFolderNameDao();
//
//    public abstract SchedulerDao schedulerDao();


    private static final int NUMBER_OF_THREADS = 3445;
    public static final ExecutorService databaseWriteExecutor = Executors.newFixedThreadPool(NUMBER_OF_THREADS);

    public static synchronized VideoAlbumDatabase getInstance(Context context) {
        if (instance == null) {
            //If instance is null that's mean database is not created and create a new database instance
            instance = Room.databaseBuilder(context.getApplicationContext(),
                            VideoAlbumDatabase.class, "video_album_database")
                    .fallbackToDestructiveMigration()
                    .allowMainThreadQueries()
                    .addCallback(roomCallBack)
                    .build();
        }

        return instance;
    }

    private static Callback roomCallBack = new Callback() {

        @Override
        public void onCreate(@NonNull SupportSQLiteDatabase db) {
            super.onCreate(db);
//            new PopulateDbAsyncTask(instance).execute();
        }
    };

}
