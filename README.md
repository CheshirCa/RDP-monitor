# RDP-monitor
A lightweight PowerShell-based tool compiled into an EXE that monitors Windows RDP shadow sessions in real-time. It detects and alerts on four critical events (IDs 20503, 20504, 20506, 20507) related to unauthorized remote control attempts, displaying instant pop-up notifications without logging or console output.


### **Instructions for Compiling the Script into EXE and Using It**  

#### **1. Compiling the Script into EXE Using `PS2EXE`**  
To convert `.ps1` to `.exe`, we’ll use the **PS2EXE** module.  

##### **1.1. Installing PS2EXE (if not installed)**  
Open PowerShell **as Administrator** and run:  
```powershell
Install-Module -Name PS2EXE -Force
```  

##### **1.2. Compiling the Script into EXE**  
Save your script (e.g., `RDP_Shadow_Monitor.ps1`), then run:  
```powershell
Invoke-PS2EXE -InputFile "RDP_Shadow_Monitor.ps1" -OutputFile "RDP_Shadow_Monitor.exe" -IconFile "C:\path\to\icon.ico" -Title "RDP Shadow Monitor" -NoConsole
```  
**Parameters:**  
- `-InputFile` – Path to the `.ps1` file.  
- `-OutputFile` – Where to save the `.exe`.  
- `-IconFile` *(optional)* – Custom icon for the EXE.  
- `-Title` *(optional)* – Window title (if GUI is used).  
- `-NoConsole` – Hide the console (if only popup alerts are needed).  

---  

#### **2. Using the EXE File**  
##### **2.1. Running the Monitor**  
- Simply launch `RDP_Shadow_Monitor.exe`.  
- The program will run in the background and show **pop-up alerts** for the following events:  
  - **20503** – Shadow RDP session started.  
  - **20506** – Shadow RDP control started.  
  - **20504** – Shadow RDP session stopped.  
  - **20507** – Shadow RDP control stopped.  

##### **2.2. Autostart (if needed)**  
To run the monitor at system startup:  
1. Press `Win + R`, type `shell:startup`.  
2. Copy `RDP_Shadow_Monitor.exe` into this folder.  

##### **2.3. Stopping the Monitor**  
- Open **Task Manager** (`Ctrl + Shift + Esc`).  
- Find the `RDP_Shadow_Monitor.exe` process and end it.  

---  

#### **3. Additional Customization (if needed)**  
- **Change the check interval** (default: 5 sec):  
  In the script, find `$CheckInterval = 5` and modify the value.  
- **Add more events**:  
  Inside the `switch ($Event.Id)` block, add new `case` entries with the desired Event IDs.  

---  

### **Final Notes**  
- The **EXE file** runs in the background and **shows alerts** when someone attempts **hidden RDP access**.  
- No installation required; can be added to startup.


### **Инструкция по компиляции PowerShell скрипта в EXE и его использованию**

#### **1. Компиляция скрипта в EXE с помощью `ps2exe`**
Для преобразования `.ps1` в `.exe` используется модуль **PS2EXE**.  

##### **1.1. Установка PS2EXE (если не установлен)**
Откройте PowerShell **от имени администратора** и выполните:
```powershell
Install-Module -Name PS2EXE -Force
```

##### **1.2. Компиляция скрипта в EXE**
Сохраните ваш скрипт (например, `RDP_Shadow_Monitor.ps1`), затем выполните:
```powershell
Invoke-PS2EXE -InputFile "RDP_Shadow_Monitor.ps1" -OutputFile "RDP_Shadow_Monitor.exe" -IconFile "C:\path\to\icon.ico" -Title "RDP Shadow Monitor" -NoConsole
```
**Параметры:**
- `-InputFile` – путь к `.ps1` файлу.
- `-OutputFile` – куда сохранить `.exe`.
- `-IconFile` *(опционально)* – иконка для EXE (если нужна).
- `-Title` *(опционально)* – заголовок окна (если используется GUI).
- `-NoConsole` – скрыть консоль (если нужен только всплывающий алерт).

---

#### **2. Использование EXE**
##### **2.1. Запуск монитора**
- Просто запустите `RDP_Shadow_Monitor.exe`.  
- Программа будет работать в фоне и показывать **всплывающие уведомления** при событиях:
  - **20503** – начат теневой просмотр RDP.
  - **20506** – начато теневое управление RDP.
  - **20504** – остановлен теневой просмотр.
  - **20507** – остановлено теневое управление.

##### **2.2. Автозапуск (если нужно)**
Чтобы монитор запускался при старте системы:
1. Нажмите `Win + R`, введите `shell:startup`.
2. Скопируйте `RDP_Shadow_Monitor.exe` в эту папку.

##### **2.3. Остановка монитора**
- Откройте **Диспетчер задач** (`Ctrl + Shift + Esc`).
- Найдите процесс `RDP_Shadow_Monitor.exe` и завершите его.

---

#### **3. Дополнительные настройки (если нужно)**
- **Изменить интервал проверки** (по умолчанию 5 сек):  
  В скрипте найдите `$CheckInterval = 5` и поменяйте значение.
- **Добавить больше событий**:  
  В блоке `switch ($Event.Id)` добавьте новые `case` с нужными ID.

---

### **Итог**
- **EXE-файл** работает в фоне и **показывает алерты** при попытках **подключиться к вашему RDP** в скрытом режиме.
- Не требует установки, можно добавить в автозагрузку.
- Если нужны логи, можно вернуть запись в файл (но в текущей версии она удалена).  

🚀 **Готово!** Теперь ваш монитор RDP-сессий работает в виде EXE.
- If logging is needed, modify the script to re-enable file logging (removed in this version).  

🚀 **Done!** Your RDP shadow session monitor now works as a standalone EXE.
