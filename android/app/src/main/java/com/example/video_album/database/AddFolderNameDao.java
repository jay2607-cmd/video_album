package com.example.video_album.database;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import com.example.video_album.FolderName;

import java.util.List;


@Dao
public interface AddFolderNameDao {
    @Insert
    void insertPhotoLapse(FolderName FolderName);

    @Query("SELECT * FROM tbl_folder_name")
    LiveData<List<FolderName>> fetchAllData();


    @Query("SELECT * FROM tbl_folder_name")
    List<FolderName> fetchData();


    @Update
    void updateData(FolderName photoLapse);

    @Query("SELECT * FROM tbl_folder_name")
    int isDataExist();
}
