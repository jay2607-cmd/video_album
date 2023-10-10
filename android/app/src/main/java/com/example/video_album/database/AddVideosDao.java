package com.example.video_album.database;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;


import java.util.List;


@Dao
public interface AddVideosDao {
    @Insert
    void insertPhotoLapse(VideosModel videosModel);

    @Query("SELECT * FROM tbl_videos")
    LiveData<List<VideosModel>> fetchAllData();

    @Query("SELECT * FROM tbl_videos WHERE album_name=:dir_name")
    LiveData<List<VideosModel>> fetchAllData(String dir_name);

    @Query("SELECT * FROM tbl_videos WHERE album_name=:dir_name")
    List<VideosModel> fetchAllVideos(String dir_name);

    @Query("SELECT * FROM tbl_videos")
    List<VideosModel> fetchData();

    @Query("SELECT * FROM tbl_videos WHERE video_id=:id")
    VideosModel fetchData(int id);

    @Update
    void updateData(VideosModel photoLapse);

    @Query("UPDATE tbl_videos SET album_name = :name WHERE video_id = :id")
    void updateData(String name, int id);

    @Delete
    void deleteData(List<VideosModel> favourite);

    @Query("DELETE FROM tbl_videos WHERE video_path =:path")
    void deleteData(String path);

    @Query("DELETE FROM tbl_videos")
    void deleteAllData();

    @Query("DELETE FROM tbl_videos WHERE video_id= :id")
    void deleteVideo(int id);
}
