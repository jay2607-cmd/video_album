package com.example.video_album.database;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Update;

import java.util.List;

public class AlbumListViewModel extends AndroidViewModel {

    private AlbumListRepository repository;
    private LiveData<List<Album>> allData;

    public AlbumListViewModel(@NonNull Application application) {
        super(application);

        repository = new AlbumListRepository(application);
        allData = repository.getAllData();
    }

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    public void insert(Album notify) {
        repository.insert(notify);
    }

    @Update
    public void update(Album notify) {
        repository.update(notify);
    }

    public void deleteAllData() {
        repository.deleteAllData();
    }

    public void deleteData(String path) {
        repository.deleteData(path);
    }

    public Album fetchData(int id) {
        return repository.fetchData(id);
    }


    public LiveData<List<Album>> fetchAllData() {
        return allData;
    }

    public LiveData<List<Album>> fetchAllData(String dirName) {
        return repository.getAllData(dirName);
    }

}
