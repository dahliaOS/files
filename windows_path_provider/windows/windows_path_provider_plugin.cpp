#include "include/windows_path_provider/windows_path_provider_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>
#include <locale>
#include <KnownFolders.h>
#include <ShlObj.h>

namespace {

class WindowsPathProviderPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WindowsPathProviderPlugin();

  virtual ~WindowsPathProviderPlugin();

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void WindowsPathProviderPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "windows_path_provider",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<WindowsPathProviderPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

WindowsPathProviderPlugin::WindowsPathProviderPlugin() {}

WindowsPathProviderPlugin::~WindowsPathProviderPlugin() {}

int GetPathIndexArgument(const flutter::MethodCall<>& method_call) {
  int index = -1;
  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (arguments) {
    auto index_it = arguments->find(flutter::EncodableValue("path_index"));
    index = std::get<int>(index_it->second);
  }
  return index;
}

GUID folders[]
{
    FOLDERID_Profile,
    FOLDERID_Desktop,
    FOLDERID_Documents,
    FOLDERID_Pictures,
    FOLDERID_Downloads,
    FOLDERID_Music,
    FOLDERID_Videos,
    FOLDERID_Public,
    FOLDERID_Templates,
};

std::string ws2s(const std::wstring& wstr)
{
    if (wstr.empty()) return std::string();
    const int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), nullptr, 0, nullptr, nullptr);
    std::string strTo(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &strTo[0], size_needed, nullptr, nullptr);
    return strTo;
}

void WindowsPathProviderPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPath") == 0) {
    int index = GetPathIndexArgument(method_call);
    int arraySize = sizeof(folders) / sizeof(*folders);

    if(index >= 0 && index < arraySize) {
      PWSTR path = nullptr;
      const HRESULT pathResult = SHGetKnownFolderPath(folders[index], 0, nullptr, &path);
      const std::wstring string(path);
      if (SUCCEEDED(pathResult)) {
        result->Success(flutter::EncodableValue(ws2s(string)));
      }
		
      CoTaskMemFree(path);
    } else {
      result->Error("argument_error", "No path index was provided");
    }
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void WindowsPathProviderPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  WindowsPathProviderPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
