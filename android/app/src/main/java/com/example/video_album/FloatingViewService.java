package com.example.video_album;

import android.app.Service;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.os.IBinder;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;

public class FloatingViewService extends Service {
    private WindowManager windowManager;
    private View floatingView;

    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize the window manager
        windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        Log.d("DoubleTapFloat:", "String");


        // Inflate your floating view layout
        floatingView = LayoutInflater.from(this).inflate(R.layout.dialog_exit, null);

        // Define layout parameters for the floating view
        WindowManager.LayoutParams params = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
        );

        // Set the initial position of the floating view
        params.gravity = Gravity.CENTER;
//        params.x = 100;
//        params.y =100;
        windowManager.addView(floatingView, params);

        if (floatingView != null) {
            floatingView.setVisibility(View.VISIBLE);
        }


        RelativeLayout dialog_exit_rel_no = (RelativeLayout) floatingView.findViewById(R.id.dialog_exit_rel_no);
        RelativeLayout dialog_exit_rel_yes = (RelativeLayout) floatingView.findViewById(R.id.dialog_exit_rel_yes);

        dialog_exit_rel_no.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                //windowManager.removeView(floatingView);

                if (floatingView != null) {
                    floatingView.setVisibility(View.GONE);
                }
                stopService(new Intent(getApplicationContext(), FloatingViewService.class));

            }
        });

        dialog_exit_rel_yes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent mainActivityIntent = new Intent(getApplicationContext(), MainActivity.class);
                mainActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(mainActivityIntent);

                // windowManager.removeView(floatingView);
                stopService(new Intent(getApplicationContext(), FloatingViewService.class));

                if (floatingView != null) {
                    floatingView.setVisibility(View.GONE);

                }
            }
        });

        // Add the floating view to the window manager


//        // Handle double tap to show the floating view
//        GestureDetector gestureDetector = new GestureDetector(this, new GestureListener());
//        floatingView.setOnTouchListener((v, event) -> gestureDetector.onTouchEvent(event));
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // Remove the floating view when the service is destroyed
        if (floatingView != null) {
            windowManager.removeView(floatingView);

        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    // Handle double tap to show the floating view
    private class GestureListener extends GestureDetector.SimpleOnGestureListener {
        @Override
        public boolean onDoubleTap(MotionEvent e) {
            // Show the floating view
            // You can set the visibility of your floating view to VISIBLE here
            return true;
        }
    }
}
