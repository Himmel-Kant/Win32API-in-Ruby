require_relative '.\loadAPI.rb'

include WinAPI::Constants

wndc = WinAPI::WndClassEx.malloc
    wndc.cbSize         = WinAPI::WndClassEx.size
    wndc.style          = CS_HREDRAW | CS_VREDRAW
    wndc.lpfnWndProc    = WinAPI.DefWindowProcW
    wndc.cbClsExtra, wndc.cbWndExtra = 0, 0
    wndc.hInstance      = HInstance
    wndc.hIcon          = WinAPI.LoadIconW(nil, IDI_APPLICATION)
    wndc.hCursor        = WinAPI.LoadCursorW(nil, IDC_ARROW)
    wndc.hbrBackground  = WinAPI.GetStockObject(WHITE_BRUSH)
    wndc.lpszMenuName   = nil
    wndc.lpszClassName  = TEXT('TESTCLASS')
    wndc.hIconSm        = WinAPI.LoadIconW(nil, IDI_APPLICATION)



startupInfo = WinAPI::StartupInfo.malloc
WinAPI.GetStartupInfo(startupInfo.to_ptr)

nCmdShow = startupInfo.wShowWindow

atom = WinAPI.RegisterClassExW(wndc.to_ptr)

raise 'failed to register window class' if atom == 0

hwnd = WinAPI.CreateWindowExW(0, TEXT('TESTCLASS'), TEXT('Test'),
    WS_OVERLAPPEDWINDOW,
    200, 100, CW_USEDEFAULT, 0, nil, nil,
    HInstance, nil)

if !(hwnd.null?)
    WinAPI.ShowWindow(hwnd, nCmdShow)
    WinAPI.MessageBoxW(hwnd, TEXT('Hello, World!'), TEXT('Test'), 0)
else
    raise 'failed to create window'
end