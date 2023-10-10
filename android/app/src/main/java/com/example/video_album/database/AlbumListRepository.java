package com.example.video_album.database;

import android.app.Application;
import android.os.AsyncTask;

import androidx.lifecycle.LiveData;


import com.example.video_album.VideoAlbumDatabase;

import java.util.List;

public class AlbumListRepository {

    private AlbumListDao notificationDao;
    private LiveData<List<Album>> notificationList;

    public AlbumListRepository(Application application) {
        VideoAlbumDatabase photoLapseDatabase = VideoAlbumDatabase.getInstance(application);
        notificationDao = photoLapseDatabase.albumListDao();

        notificationList = notificationDao.fetchAllData();
    }

    public void insert(Album notify) {
        new InsertAsyncTask(notificationDao).execute(notify);
    }

    public void update(Album notify) {
        new UpdateAsyncTask(notificationDao).execute(notify);
    }

    public void deleteAllData() {
        new DeleteAllAsyncTask(notificationDao).execute();
    }

    public LiveData<List<Album>> getAllData() {
        return notificationList;
    }

    public LiveData<List<Album>> getAllData(String dirName) {
        return notificationDao.fetchAllData(dirName);
    }

    public void insertData(String name) {
        notificationDao.isDataExist(name);
    }


    public void deleteData(String path) {
        new AsyncTask<Void, Void, Void>() {
            @Override
            protected Void doInBackground(Void... voids) {
                notificationDao.deleteData(path);
                return null;
            }
        }.execute();
    }

    public Album fetchData(int id) {
        return notificationDao.fetchData(id);
    }


    //AsyncTask for create new player
    private static class InsertAsyncTask extends AsyncTask<Album, Void, Void> {

        private AlbumListDao notificationDao;

        public InsertAsyncTask(AlbumListDao notificationDao) {
            this.notificationDao = notificationDao;
        }


        @Override
        protected Void doInBackground(Album... notifies) {
            notificationDao.insertNotify(notifies[0]);
            return null;
        }
    }

    private static class UpdateAsyncTask extends AsyncTask<Album, Void, Void> {

        private AlbumListDao notificationDao;

        public UpdateAsyncTask(AlbumListDao notificationDao) {
            this.notificationDao = notificationDao;
        }

        @Override
        protected Void doInBackground(Album... notifies) {
            notificationDao.updateData(notifies[0]);
            return null;
        }
    }


    private static class DeleteAllAsyncTask extends AsyncTask<Void, Void, Void> {

        private AlbumListDao notificationDao;

        public DeleteAllAsyncTask(AlbumListDao notificationDao) {
            this.notificationDao = notificationDao;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            notificationDao.deleteAllData();
            return null;
        }
    }


}
