require_relative '.\loadAPI.rb'

include Win32API::Constants

wndc = Win32API::WndClassEx.malloc
    wndc.cbSize = Win32API::WndClassEx.size
    wndc.style = 0x0000_0002 | 0x0000_0001 # CS_HREDRAW, CS_VREDRAW
    wndc.lpfnWndProc = Win32API.DefWindowProcW(HInstance, 0, 0, 0)
    wndc.cbClsExtra, wndc.cbWndExtra = 0, 0
    wndc.hInstance = HInstance
    wndc.hIcon = Win32API.LoadIcon(nil, 0x0000_7f00) # IDI_APPLICATION
    wndc.hCursor = Win32API.LoadCursor(nil, 0x0000_7f00) # IDC_ARROW
    wndc.hbrBackground = Win32API.GetStockObject(0x0000_0000) # WHITE_BRUSH
    wndc.lpszMenuName = nil
    wndc.lpszClassName = 'BUTTON' # somehow bug occurs in Unicode
    wndc.hIconSm = Win32API.LoadIcon(nil, 0x0000_7f00)



startupInfo = Win32API::StartupInfo.malloc
Win32API.GetStartupInfo(startupInfo.to_ptr)

nCmdShow = startupInfo.wShowWindow

atom = Win32API.RegisterClassExW(wndc.to_ptr)

raise 'failed to register window class' if atom == 0

hwnd = Win32API.CreateWindowExW(0, 'STATIC'.wchar_t, TEXT('Test'),
    0x00c0_0000,
    200, 100, 300, 300, nil, nil,
    HInstance, nil)

if !(hwnd.null?)
    Win32API.ShowWindow(hwnd, nCmdShow)
    Win32API.MessageBoxW(hwnd, TEXT('Hello, World!'), TEXT('Test'), 0)
else
    raise 'failed to create window'
end