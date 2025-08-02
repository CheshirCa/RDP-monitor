# Настройки
$LogName = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational"
$CheckInterval = 10  # Интервал проверки в секундах
$LastProcessedId = $null

# Функция отображения алертов
function Show-RdpAlert {
    param(
        [string]$Message
    )

    try {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup($Message, 0, "RDP Alert", 0x0 + 0x30) | Out-Null
    } catch {
        # В случае ошибки просто игнорируем, так как логгирование удалено
    }
}

# Функция обработки событий
function Process-RdpEvent {
    param(
        [System.Diagnostics.Eventing.Reader.EventRecord]$Event
    )

    $EventData = @{
        Id = $Event.Id
        RecordId = $Event.RecordId
        TimeCreated = $Event.TimeCreated
        Properties = $Event.Properties | ForEach-Object { $_.Value }
    }

    switch ($Event.Id) {
        20503 {  # Запущен теневой просмотр сеанса
            $User = $EventData.Properties[1]
            $Computer = $EventData.Properties[0]
            $SessionId = $EventData.Properties[2]
            $AlertMsg = "ALERT: Запущен теневой просмотр сеанса`nПользователь: $User`nКомпьютер: $Computer`nСессия: $SessionId"
            Show-RdpAlert -Message $AlertMsg
        }
        
        20506 {  # Запущено теневое управление сеансом
            $User = $EventData.Properties[1]
            $SessionId = $EventData.Properties[0]
            $AlertMsg = "ALERT: Запущено теневое управление сеансом`nПользователь: $User`nСессия: $SessionId"
            Show-RdpAlert -Message $AlertMsg
        }
        
        20504 {  # Остановлен теневой просмотр сеанса
            $User = $EventData.Properties[1]
            $SessionId = $EventData.Properties[2]
            $AlertMsg = "ALERT: Теневой просмотр сеанса остановлен`nПользователь: $User`nСессия: $SessionId"
            Show-RdpAlert -Message $AlertMsg
        }
        
        20507 {  # Остановлено теневое управление сеансом
            $User = $EventData.Properties[1]
            $SessionId = $EventData.Properties[0]
            $AlertMsg = "ALERT: Теневое управление сеансом остановлено`nПользователь: $User`nСессия: $SessionId"
            Show-RdpAlert -Message $AlertMsg
        }
    }

    # Обновляем последний обработанный ID
    $script:LastProcessedId = $Event.RecordId
}

# Основной цикл мониторинга
try {
    # Получаем последний ID события при старте
    $LastEvent = Get-WinEvent -LogName $LogName -MaxEvents 1 -ErrorAction SilentlyContinue
    if ($LastEvent) {
        $script:LastProcessedId = $LastEvent.RecordId
    } else {
        $script:LastProcessedId = 0
    }

    while ($true) {
        try {
            # Получаем только новые события
            $Events = Get-WinEvent -LogName $LogName -ErrorAction SilentlyContinue |
                     Where-Object { 
                         $_.RecordId -gt $script:LastProcessedId -and 
                         ($_.Id -eq 20503 -or $_.Id -eq 20506 -or $_.Id -eq 20504 -or $_.Id -eq 20507) 
                     } |
                     Sort-Object TimeCreated
            
            if ($Events) {
                foreach ($Event in $Events) {
                    Process-RdpEvent -Event $Event
                }
            }
        } catch {
            # В случае ошибки просто игнорируем, так как логгирование удалено
        }
        
        Start-Sleep -Seconds $CheckInterval
    }
}
catch {
    # В случае ошибки просто игнорируем, так как логгирование удалено
}
