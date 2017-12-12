require 'fiddle\import'

module Win32API
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
    typealias('WNDPROC', 'LRESULT')



    # Kernel32.dll
    extern('HMODULE GetModuleHandle(LPWSTR)')
    extern('void GetStartupInfo(LPSTARTUPINFO*)')

    # User32.dll
    extern('int MessageBoxW(HWND, LPWSTR, LPWSTR, UINT)')
    extern('ATOM RegisterClassExW(WNDCLASSEX*)')
    extern('void* CreateWindowExW(DWORD, LPWSTR, LPWSTR, DWORD, int, int, int, int, HWND, HANDLE, HINSTANCE, void*)')
    extern('BOOL ShowWindow(HWND, int)')
    extern('LONG_PTR DefWindowProcW(HWND, UINT, WPARAM, LPARAM)')
    extern('HANDLE LoadIcon(HINSTANCE, LPWSTR)')
    extern('HANDLE LoadCursor(HINSTANCE, LPWSTR)')
    extern('int GetClassName(HWND, char*, int)')

    # Gdi32.dll
    extern('HANDLE GetStockObject(int)')

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
        HInstance = Win32API.GetModuleHandle(nil)
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