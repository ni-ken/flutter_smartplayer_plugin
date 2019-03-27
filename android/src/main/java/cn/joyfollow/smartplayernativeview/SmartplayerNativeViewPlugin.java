package cn.joyfollow.smartplayernativeview;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SmartplayerNativeViewPlugin
 */
public class SmartplayerNativeViewPlugin {

    static {
        System.loadLibrary("SmartPlayer");
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "smartPlayerView", new SmartPlayerViewFactory(registrar));
    }


}
