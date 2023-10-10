package com.example.video_album.database;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;


@Dao
public interface AlbumListDao {
    @Insert
    void insertNotify(Album notify);

    @Query("SELECT * FROM tbl_album")
    LiveData<List<Album>> fetchAllData();

    @Query("SELECT * FROM tbl_album WHERE album_name=:album_name")
    LiveData<List<Album>> fetchAllData(String album_name);

    @Query("SELECT * FROM tbl_album")
    List<Album> fetchData();

    @Query("SELECT * FROM tbl_album WHERE album_id=:id")
    Album fetchData(int id);

    @Update
    void updateData(Album notify);

    @Delete
    void deleteData(List<Album> notifies);

    @Query("DELETE FROM tbl_album WHERE album_name =:path")
    void deleteData(String path);

    @Query("DELETE FROM tbl_album")
    void deleteAllData();

    @Query("SELECT * FROM tbl_album WHERE album_name = :dir_name")
    int isDataExist(String dir_name);
}
