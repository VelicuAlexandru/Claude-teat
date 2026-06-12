package com.monkeyart.app;

import android.app.Activity;
import android.os.Bundle;
import android.view.WindowManager;
import android.view.View;
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
        Button waveButton = (Button) findViewById(R.id.waveButton);
        waveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                monkeyView.wave();
            }
        });
    }
}
