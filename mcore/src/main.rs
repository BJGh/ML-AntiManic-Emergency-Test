#![no_std]
#![no_main]

use core::panic::PanicInfo;

// 1. Заглушка проверки (должна быть доступна везде)
pub fn check_file_exists(_path: &str) -> bool {
    true 
}

// 2. Инициализация BioMed
pub fn init_biomed_core() {
    let _core_path = "B:\\model.safetensors";
    
    if check_file_exists(_core_path) {
        // Здесь будет вывод в VGA буфер или COM-порт
    } else {
        loop { unsafe { core::arch::asm!("hlt") } }
    }
}

// 3. Точка входа для твоего Athlon / VMware
#[no_mangle]
pub extern "C" fn _start() -> ! {
    init_biomed_core();
    hlt_loop()
}

// 4. Обработчик паники (обязателен в no_std)
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {
        unsafe { core::arch::asm!("hlt") }
    }
}

// 5. Цикл остановки процессора
#[inline(always)]
fn hlt_loop() -> ! {
    loop {
        unsafe { core::arch::asm!("hlt") }
    }
}

// --- Твой Multiboot Header ---
#[link_section = ".multiboot_header"]
pub static MULTIBOOT_HEADER: [u32; 12] = [
    0x1BADB002, 0x00000003, -(0x1BADB002 + 0x00000003) as u32,
    0, 0, 0, 0, 0, 0, 0, 0, 0
];

// --- Твои структуры данных (CrisisPayload, PhoneRegs и т.д.) ---
#[repr(C)]
pub struct CrisisPayload {
    pub version: u32,
    pub cmd: u32,
    pub len: u64,
    pub data: *const u8,
}

#[repr(C)]
struct PhoneRegs {
    status: u32,
    command: u32,
    data_buffer: [u8; 1024],
}

// Остальной твой код (HolyC мосты, MMIO драйвер телефона) оставляем как есть ниже...

/*#![no_std]
#![no_main]

use core::panic::PanicInfo;
// В твоем no_std ядре или сервисе Classifier
pub fn init_biomed_core() {
    // В Windows-среде (через FFI) или через прерывания DOS
    let core_path = "B:\\model.safetensors";
    
    // Проверка через низкоуровневое чтение секторов
    if check_file_exists(core_path) {
        println!("[mcore] BioMed Matrices found on Drive B.");
    } else {
        panic!("[FATAL] Drive B is empty! Run AUTORUN.BAT first.");
    }
}
pub fn check_file_exists(_path: &str) -> bool {
    // Заглушка: всегда возвращаем true, чтобы компилятор не ругался
    true 
}

// Panic handler for bare-metal environment
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    // In a real system, log to serial or VGA text buffer if available
    loop {
           core::arch::asm!("hlt")
    }
}

// Minimal halt loop to prevent CPU spin
#[inline(always)]
fn hlt_loop() -> ! {
    loop {
        unsafe { core::arch::asm!("hlt") }
    }
}

// Entry point for VMware
#[no_mangle]
pub extern "C" fn _start() -> ! {
    // Future: Initialize GDT, IDT, stack, and serial for debugging
    // For now, just halt to confirm boot
    hlt_loop()
}
#[link_section = ".multiboot_header"]
pub static MULTIBOOT_HEADER: [u32; 12] = [
    0x1BADB002,      // Magic (для Multiboot 1)
    0x00000003,      // Flags (ALIGN + MEMINFO)
    -(0x1BADB002 + 0x00000003) as u32, // Checksum
    // Дополнительные поля для AOT/Android Loader могут быть здесь
    0, 0, 0, 0, 0, 0, 0, 0, 0
];

// Crisis data structure for FFI to HolyC or higher layers
#[repr(C)]
pub struct CrisisPayload {
    pub version: u32,       // Payload format version (for future-proofing)
    pub cmd: u32,          // Command: 0=log, 1=verify_logic, 2=seal
    pub len: u64,          // Length of data buffer
    pub data: *const u8,   // Pointer to UTF-8 encoded data (JSON or raw string)
}
#[repr(C)]
struct PhoneRegs {
    status: u32,
    command: u32,
    data_buffer: [u8; 1024],
}

const PHONE_DRV_BASE: *mut PhoneRegs = 0xFE000000 as *mut PhoneRegs; // Пример адреса MMIO

pub fn send_to_phone(cmd: u32, data: &[u8]) {
    unsafe {
        let regs = &mut *PHONE_DRV_BASE;
        // Копируем данные в буфер MMIO драйвера
        core::ptr::copy_nonoverlapping(data.as_ptr(), regs.data_buffer.as_mut_ptr(), data.len());
        regs.command = cmd; // Сигнализируем драйверу о команде
    }
}
// Return codes for `crisis_holyc_call`
const CRISIS_OK: i32 = 0;
const CRISIS_ERR_NULL: i32 = -1;          // null pointer
const CRISIS_ERR_INVALID_VERSION: i32 = -2;
const CRISIS_ERR_NO_HOLYC: i32 = -3;      // no runtime registered
const CRISIS_ERR_BAD_CMD: i32 = -4;

// Optional runtime-registered HolyC handler.  Higher-level loader (HolyC runtime)
// can register its entrypoint using `register_holyc_handler` below.
static mut HOLYC_HANDLER: Option<extern "C" fn(*const CrisisPayload) -> i32> = None;

/// Register a runtime HolyC handler (optional).
/// Call from higher-level bootstrap / HolyC runtime when available.
#[no_mangle]
pub extern "C" fn register_holyc_handler(handler: Option<extern "C" fn(*const CrisisPayload) -> i32>) {
    unsafe { HOLYC_HANDLER = handler; }
}

// FFI function to pass crisis data to HolyC layer
#[no_mangle]
pub extern "C" fn crisis_holyc_call(payload: *const CrisisPayload) -> i32 {
    if payload.is_null() {
        return CRISIS_ERR_NULL;
    }

    let p = unsafe { &*payload };

    // version 1 is the current payload format we accept here
    if p.version != 1 {
        return CRISIS_ERR_INVALID_VERSION;
    }

    // If a HolyC runtime registered a handler, forward the call to it.
    unsafe {
        if let Some(func) = HOLYC_HANDLER {
            return func(payload);
        }
    }

    // Minimal built-in handling (best-effort; kernel-level fallbacks)
    match p.cmd {
        0 => {
            // cmd=0: log — accept UTF-8 message pointer/len (no-op in no_std kernel)
            // Future: route to serial/VGA logger or ring-buffer for userspace retrieval.
            CRISIS_OK
        }
        1 => {
            // cmd=1: verify_logic — placeholder for lightweight sanity checks
            CRISIS_OK
        }
        2 => {
            // cmd=2: seal — cryptographic sealing requires higher-level runtime
            CRISIS_ERR_NO_HOLYC
        }
        _ => CRISIS_ERR_BAD_CMD,
    }
}

// -------------------------
// Built-in HolyC runtime stub
// -------------------------
// A tiny, optional runtime stub that can be registered at boot by a
// higher-level HolyC runtime or called directly during early bringup.
// This keeps the kernel usable before a full HolyC loader is available.

extern "C" fn holyc_handler_stub(payload: *const CrisisPayload) -> i32 {
    if payload.is_null() {
        return CRISIS_ERR_NULL;
    }
    let p = unsafe { &*payload };
    // Simple behavior implemented in the stub:
    // - cmd==0: accept log (no-op)
    // - cmd==1: verify: check len <= 1024 for sanity
    // - other: return bad-cmd
    match p.cmd {
        0 => CRISIS_OK,
        1 => {
            if p.len <= 1024 { CRISIS_OK } else { CRISIS_ERR_BAD_CMD }
        }
        _ => CRISIS_ERR_BAD_CMD,
    }
}

#[no_mangle]
pub extern "C" fn holyc_runtime_init() -> i32 {
    // Register the built-in stub as the HolyC handler so userland can call
    // `crisis_holyc_call` and get predictable behavior even without a full
    // HolyC runtime present.
    register_holyc_handler(Some(holyc_handler_stub));
    CRISIS_OK
}*/
