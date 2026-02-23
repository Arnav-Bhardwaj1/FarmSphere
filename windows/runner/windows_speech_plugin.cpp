#include "windows_speech_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace windows_speech_plugin {

// Plugin implementation
class WindowsSpeechPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WindowsSpeechPlugin(flutter::PluginRegistrarWindows *registrar);

  virtual ~WindowsSpeechPlugin();

  // Disallow copy and assign.
  WindowsSpeechPlugin(const WindowsSpeechPlugin&) = delete;
  WindowsSpeechPlugin& operator=(const WindowsSpeechPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  flutter::PluginRegistrarWindows *registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
};

// Static method to register the plugin
void WindowsSpeechPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto plugin = std::make_unique<WindowsSpeechPlugin>(registrar);

  registrar->AddPlugin(std::move(plugin));
}

WindowsSpeechPlugin::WindowsSpeechPlugin(flutter::PluginRegistrarWindows *registrar)
    : registrar_(registrar) {
  channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "farmsphere/windows_speech",
      &flutter::StandardMethodCodec::GetInstance());

  channel_->SetMethodCallHandler(
      [this](const auto &call, auto result) {
        this->HandleMethodCall(call, std::move(result));
      });
}

WindowsSpeechPlugin::~WindowsSpeechPlugin() {}

void WindowsSpeechPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name() == "initialize") {
    // For now, return false as Windows Speech API requires more complex setup
    // This is a placeholder for future Windows Speech Recognition implementation
    result->Success(flutter::EncodableValue(false));
  } else if (method_call.method_name() == "startListening") {
    result->Success(flutter::EncodableValue(false));
  } else if (method_call.method_name() == "stopListening") {
    result->Success(flutter::EncodableValue(true));
  } else {
    result->NotImplemented();
  }
}

}  // namespace windows_speech_plugin

void WindowsSpeechPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  windows_speech_plugin::WindowsSpeechPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
