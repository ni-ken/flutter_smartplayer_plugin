package cn.joyfollow.smartplayernativeview;

import android.content.Context;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;
import static io.flutter.plugin.common.PluginRegistry.Registrar;

public class SmartPlayerViewFactory extends PlatformViewFactory {
    private final Registrar mPluginRegistrar;

    public SmartPlayerViewFactory(Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mPluginRegistrar = registrar;
    }


    @Override
    public PlatformView create(Context context, int i, Object o) {
        return new SmartPlayerViewController(context, mPluginRegistrar, i);
    }
}
