package com.example.video_album.database;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Update;

import java.util.List;

import io.flutter.Log;

public class VideosViewModel extends AndroidViewModel {

    private VideosRepository repository;
    private LiveData<List<VideosModel>> allData;
    private List<VideosModel> getData;

    public VideosViewModel(@NonNull Application application) {
        super(application);

        repository = new VideosRepository(application);
        allData = repository.getAllData();
        getData = repository.getData();
    }

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    public void insert(VideosModel videosModel) {
        repository.insert(videosModel);
    }

    @Update
    public void update(VideosModel videosModel) {
        repository.update(videosModel);
    }

    public void deleteAllData() {
        repository.deleteAllData();
    }

    public void deleteData(String path, String albumName) {
        repository.deleteData(path, albumName);
    }

    public List<VideosModel> getAllVideos(String dirName) {
        return repository.getVideosData(dirName);
    }

    public void deleteVideo(int id) {
        repository.deleteVideo(id);
    }

    public VideosModel fetchData(int id) {
        return repository.fetchData(id);
    }


    public LiveData<List<VideosModel>> fetchAllData() {
        return allData;
    }

    public LiveData<List<VideosModel>> fetchAllData(String dirName) {
        return repository.getAllData(dirName);
    }

    public List<VideosModel> getAllData() {
        return getData;
    }


    public void updateData(String path, int id) {
        repository.updateData(path, id);
    }
}
