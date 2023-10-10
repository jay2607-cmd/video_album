package com.example.video_album.database;

import android.app.Application;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.lifecycle.LiveData;


import com.example.video_album.VideoAlbumDatabase;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class VideosRepository {
    private AddVideosDao addVideosDao;
    private LiveData<List<VideosModel>> addAlbumData;
    private List<VideosModel> albumModelList;

    public VideosRepository(Application application) {
        VideoAlbumDatabase videoAlbumDatabase = VideoAlbumDatabase.getInstance(application);
        addVideosDao = videoAlbumDatabase.addVideosDao();

        addAlbumData = addVideosDao.fetchAllData();
        albumModelList = addVideosDao.fetchData();
    }

    public void insert(VideosModel videosModel) {
        new InsertAsyncTask(addVideosDao).execute(videosModel);
    }

    public void update(VideosModel videosModel) {
        new UpdateAsyncTask(addVideosDao).execute(videosModel);
    }

    public void deleteAllData() {
        new DeleteAllAsyncTask(addVideosDao).execute();
    }

    public LiveData<List<VideosModel>> getAllData() {
        return addAlbumData;
    }

    public LiveData<List<VideosModel>> getAllData(String dirName) {
        return addVideosDao.fetchAllData(dirName);
    }

    public List<VideosModel> getData() {
        return albumModelList;
    }

    public List<VideosModel> getVideosData(String dirName) {
        return addVideosDao.fetchAllVideos(dirName);
    }

    public void updateData(String path, int id) {
        addVideosDao.updateData(path, id);
        Log.d("updatedData:", "" + id);
    }

    public void deleteVideo(int id) {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Handler handler = new Handler(Looper.getMainLooper());

        executor.execute(() -> {
            addVideosDao.deleteVideo(id);
            //Background work here
            handler.post(() -> {
                //UI Thread work here
            });
        });
    }

    public void deleteData(String path) {
        new AsyncTask<Void, Void, Void>() {
            @Override
            protected Void doInBackground(Void... voids) {
                addVideosDao.deleteData(path);
                return null;
            }
        }.execute();
    }

    public VideosModel fetchData(int id) {
        return addVideosDao.fetchData(id);
    }


    //AsyncTask for create new player
    private static class InsertAsyncTask extends AsyncTask<VideosModel, Void, Void> {

        private AddVideosDao addVideosDao;

        public InsertAsyncTask(AddVideosDao addVideosDao) {
            this.addVideosDao = addVideosDao;
        }


        @Override
        protected Void doInBackground(VideosModel... videosModels) {
            addVideosDao.insertPhotoLapse(videosModels[0]);
            return null;
        }
    }

    private static class UpdateAsyncTask extends AsyncTask<VideosModel, Void, Void> {

        private AddVideosDao addVideosDao;

        public UpdateAsyncTask(AddVideosDao addVideosDao) {
            this.addVideosDao = addVideosDao;
        }

        @Override
        protected Void doInBackground(VideosModel... videosModels) {
            addVideosDao.updateData(videosModels[0]);
            return null;
        }
    }


    private static class DeleteAllAsyncTask extends AsyncTask<Void, Void, Void> {

        private AddVideosDao addVideosDao;

        public DeleteAllAsyncTask(AddVideosDao addVideosDao) {
            this.addVideosDao = addVideosDao;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            addVideosDao.deleteAllData();
            return null;
        }
    }


}
