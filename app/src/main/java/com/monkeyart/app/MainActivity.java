package com.monkeyart.app;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        );
        setContentView(R.layout.activity_main);

        final MonkeyView monkeyView = (MonkeyView) findViewById(R.id.monkeyView);

        Button waveLeftButton = (Button) findViewById(R.id.waveLeftButton);
        waveLeftButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                monkeyView.waveLeft();
            }
        });

        Button waveRightButton = (Button) findViewById(R.id.waveRightButton);
        waveRightButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                monkeyView.waveRight();
            }
        });
    }
}
