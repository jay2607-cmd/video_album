package com.example.video_album;

import androidx.room.Entity;
import androidx.room.PrimaryKey;


@Entity(tableName = "tbl_folder_name")
public class FolderName {

    @PrimaryKey(autoGenerate = true)
    private int folder_id;
    private String folder_name;


    public int getFolder_id() {
        return folder_id;
    }

    public void setFolder_id(int folder_id) {
        this.folder_id = folder_id;
    }

    public String getFolder_name() {
        return folder_name;
    }

    public void setFolder_name(String folder_name) {
        this.folder_name = folder_name;
    }
}
