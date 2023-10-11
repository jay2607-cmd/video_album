package com.example.video_album;

import android.app.Application;
import android.os.AsyncTask;

import androidx.lifecycle.LiveData;

import com.example.video_album.database.AddFolderNameDao;

import java.util.List;

import io.flutter.Log;

public class FolderNameRepository {

    private AddFolderNameDao addFolderNameDao;
    private LiveData<List<FolderName>> notificationList;
    private List<FolderName> list;

    public FolderNameRepository(Application application) {
        VideoAlbumDatabase photoLapseDatabase = VideoAlbumDatabase.getInstance(application);
        addFolderNameDao = photoLapseDatabase.addFolderNameDao();

        notificationList = addFolderNameDao.fetchAllData();
        list=addFolderNameDao.fetchData();
        Log.d("folderName:", "name--> " + list);
    }

    public void insert(FolderName notify) {
        new InsertAsyncTask(addFolderNameDao).execute(notify);
    }

    public void update(FolderName notify) {
        new UpdateAsyncTask(addFolderNameDao).execute(notify);
    }

    public void insertData() {
        addFolderNameDao.isDataExist();
    }
    

    public LiveData<List<FolderName>> getAllData() {
        return notificationList;
    }

    public List<FolderName> getList() {
        return list;
    }



    //AsyncTask for create new player
    private static class InsertAsyncTask extends AsyncTask<FolderName, Void, Void> {

        private AddFolderNameDao addFolderNameDao;

        public InsertAsyncTask(AddFolderNameDao addFolderNameDao) {
            this.addFolderNameDao = addFolderNameDao;
        }


        @Override
        protected Void doInBackground(FolderName... notifies) {
            addFolderNameDao.insertPhotoLapse(notifies[0]);
            return null;
        }
    }

    private static class UpdateAsyncTask extends AsyncTask<FolderName, Void, Void> {

        private AddFolderNameDao addFolderNameDao;

        public UpdateAsyncTask(AddFolderNameDao addFolderNameDao) {
            this.addFolderNameDao = addFolderNameDao;
        }

        @Override
        protected Void doInBackground(FolderName... notifies) {
            addFolderNameDao.updateData(notifies[0]);
            return null;
        }
    }


}
