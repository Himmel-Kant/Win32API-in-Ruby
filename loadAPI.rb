require 'fiddle\import'

module WinAPI
    extend Fiddle::Importer
    dlload 'C:\Windows\System32\user32.dll', 'C:\Windows\System32\kernel32.dll',
        'C:\Windows\System32\gdi32.dll'

    typealias('HANDLE', 'void*')
    typealias('HINSTANCE', 'HANDLE')
    typealias('HMODULE', 'HINSTANCE')
    typealias('HWND', 'HANDLE')

    typealias('LPWSTR', 'unsigned short*')      # 16 bit expected

    typealias('BOOL', 'int')                    # dependent on environment
    typealias('BYTE', 'unsigned char')          #  8 bit expected
    typealias('WORD', 'unsigned short')         # 16 bit expected
    typealias('DWORD', 'unsigned long')         # 32 bit expected
    typealias('UINT', 'unsigned int')           # dependent on environment

    typealias('INT_PTR', Fiddle::SIZEOF_VOIDP == 8 ? 'long long' : 'long')
    typealias('UINT_PTR', 'unsigned ' + (Fiddle::SIZEOF_VOIDP == 8 ? 'long long' : 'long'))
    typealias('LONG_PTR', 'INT_PTR')

    typealias('WPARAM', 'UINT_PTR')
    typealias('LPARAM', 'LONG_PTR')
    typealias('LRESULT', 'LONG_PTR')

    typealias('LPSTARTUPINFO', 'void*')
    typealias('ATOM', 'WORD')
    typealias('WNDCLASSEX*', 'void*')
    typealias('WNDPROC', 'LRESULT*')

    # Kernel32.dll
    extern('HMODULE GetModuleHandle(LPWSTR)')
    extern('void GetStartupInfo(LPSTARTUPINFO*)')

    # User32.dll
    extern('int MessageBoxW(HWND, LPWSTR, LPWSTR, UINT)')
    extern('ATOM RegisterClassExW(WNDCLASSEX*)')
    extern('void* CreateWindowExW(DWORD, LPWSTR, LPWSTR, DWORD, int, int, int, int, HWND, HANDLE, HINSTANCE, void*)')
    extern('BOOL ShowWindow(HWND, int)')
    extern('HANDLE LoadIconW(HINSTANCE, LPWSTR)')
    extern('HANDLE LoadCursorW(HINSTANCE, LPWSTR)')
    extern('BOOL GetClassInfoW(HINSTANCE, LPWSTR, WNDCLASSEX*)')
    extern('HANDLE LoadImageW(HINSTANCE, LPWSTR, UINT, int, int, UINT)') # will replace LoadIcon and LoadCursor

    # Gdi32.dll
    extern('HANDLE GetStockObject(int)')

    def self.DefWindowProcW(*args)
        func = Fiddle::Function.new(import_symbol('DefWindowProcW'),
            [Fiddle::TYPE_VOIDP, -Fiddle::TYPE_INT, Fiddle::TYPE_UINTPTR_T, Fiddle::TYPE_INTPTR_T], Fiddle::TYPE_INTPTR_T)
        if args.length == 0 then func.ptr
        else func.call(*args) end
    end



    StartupInfo = struct([
        'DWORD  cb',
        'LPWSTR lpReserved',
        'LPWSTR lpDesktop',
        'LPWSTR lpTitle',
        'DWORD  dwX',
        'DWORD  dwY',
        'DWORD  dwXSize',
        'DWORD  dwYSize',
        'DWORD  dwXCountChars',
        'DWORD  dwYCountChars',
        'DWORD  dwFillAttribute',
        'DWORD  dwFlags',
        'WORD   wShowWindow',
        'WORD   cbReserved2',
        'BYTE*  lpReserved2',
        'HANDLE hStdInput',
        'HANDLE hStdOutput',
        'HANDLE hStdError'
    ])
    WndClassEx = struct([
        'UINT       cbSize',
        'UINT       style',
        'WNDPROC    lpfnWndProc',
        'int        cbClsExtra',
        'int        cbWndExtra',
        'HINSTANCE  hInstance',
        'HANDLE     hIcon',
        'HANDLE     hCursor',
        'HANDLE     hbrBackground',
        'LPWSTR     lpszMenuName',
        'LPWSTR     lpszClassName',
        'HANDLE     hIconSm'
    ])



    module Constants
        def self.MAKEINTRESOURCE(int)
            Fiddle::Pointer.to_ptr(int)
        end

        HInstance       = WinAPI.GetModuleHandle(nil)

        WS_OVERLAPPED   = 0x0000_0000
        WS_CAPTION      = 0x00C0_0000
        WS_SYSMENU      = 0x0008_0000
        WS_THICKFRAME   = 0x0004_0000
        WS_MINIMIZEBOX  = 0x0002_0000
        WS_MAXIMIZEBOX  = 0x0001_0000

        WS_OVERLAPPEDWINDOW   = WS_OVERLAPPED |
                                WS_CAPTION |
                                WS_SYSMENU |
                                WS_THICKFRAME |
                                WS_MINIMIZEBOX |
                                WS_MAXIMIZEBOX

        CW_USEDEFAULT   = -0x8000_0000
        
        CS_VREDRAW      = 0x0001
        CS_HREDRAW      = 0x0002

        IDI_APPLICATION = MAKEINTRESOURCE(0x7f00)
        IDC_ARROW       = MAKEINTRESOURCE(0x7f00)

        WHITE_BRUSH     = 0
    end
end

class Fiddle::CStruct
    def self.malloc(&proc)
        proc ||= Proc.new{}
        proc.call(super)
    end
end

class String
    def wchar_t()
        self.encode(Encoding::UTF_16LE)
    end
end

def TEXT(str)
    if str.kind_of?(String)
        str.encode(Encoding::UTF_16LE)
    else
        raise TypeError
    end
end