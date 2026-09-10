package app.nexu.messenger;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowManager;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Desactivar el efecto de rebote/overscroll nativo de Android
        if (this.bridge != null && this.bridge.getWebView() != null) {
            this.bridge.getWebView().setOverScrollMode(View.OVER_SCROLL_NEVER);
        }

        // Desactivar Pantalla Completa Inmersiva desde el lanzamiento para reservar el espacio de la barra de estado desde el segundo cero
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            getWindow().setStatusBarColor(0xFF08090B);
            getWindow().setNavigationBarColor(0xFF08090B);
        }

        // Forzar aplicación inmediata del padding del notch al abrir la app sin requerir interacción del usuario
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            final View contentView = findViewById(android.R.id.content);
            if (contentView != null) {
                contentView.post(new Runnable() {
                    @Override
                    public void run() {
                        contentView.requestApplyInsets();
                    }
                });

                contentView.setOnApplyWindowInsetsListener(new View.OnApplyWindowInsetsListener() {
                    @Override
                    public WindowInsets onApplyWindowInsets(View v, WindowInsets insets) {
                        int topInset = insets.getSystemWindowInsetTop();
                        if (topInset > 0) {
                            contentView.setPadding(0, topInset, 0, 0);
                        } else {
                            // Fallback de dimensión nativa para asegurar el margen al inicio
                            int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
                            if (resourceId > 0) {
                                int statusBarHeight = getResources().getDimensionPixelSize(resourceId);
                                contentView.setPadding(0, statusBarHeight, 0, 0);
                            }
                        }
                        return insets;
                    }
                });
            }
        }
    }
}
