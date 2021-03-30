# Awesome Docker scripts

## Описание
### run-in-ns.sh
Скрипт **`run-in-ns.sh`** предназначен для запуска команд с хостовой системы в namespace контейнера. Для чего это нужно? Например для того, что-бы узнать какие соединения открыты контейнером (команды `netstat`, `ss`), посмотреть сетевые настройки (команда `ip`). 

Использование:

```
run-in-ns.sh [-c|--container <id или имя контейнера>] <команда>
```

Параметры:

`-h` или `--help` - печать краткой справки по использованию скрипта.

`-c` или `--container` - необязательный параметр, указывает id или имя контейнера в namespace которого запускать команду, если не указан, то команда будет запущена в namespace всех запущенных контейнеров.

`<команда>` - команда, которую выполнять.

Примеры:
```
[semets@dlg-smev4-test ~]$ sudo ./run-in-ns.sh.sh -c amqp-integration-adapter netstat -np
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 172.21.0.9:50316        10.251.201.83:9092      ESTABLISHED 9071/java           
tcp        0      0 172.21.0.9:46256        10.251.201.84:9092      ESTABLISHED 9071/java           
tcp        0      0 172.21.0.9:54696        10.251.201.85:9092      ESTABLISHED 9071/java           
tcp        0      0 172.21.0.9:50390        10.251.201.83:9092      ESTABLISHED 9071/java           
tcp        0      0 172.21.0.9:50368        10.251.201.83:9092      ESTABLISHED 9071/java           
tcp        0      0 172.21.0.9:54694        10.251.201.85:9092      ESTABLISHED 9071/java           
```
```
[semets@dlg-smev4-test ~]$ sudo ./netstat-for-docker-container.sh -c amqp-integration-adapter netstat -lp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.11:45016        0.0.0.0:*               LISTEN      1364/dockerd        
udp        0      0 127.0.0.11:43471        0.0.0.0:*                           1364/dockerd        
```
### show-cont-ifs.sh
Скрипт **`show-cont-ifs.sh`** показывает с каким сетевым интерфейсом на хосте ассоциирован контейнер.

Использование:

```
show-cont-ifs.sh [-c|--container <id или имя контейнера>]

```

Параметры:

`-h` или `--help` - печать краткой справки по использованию скрипта.

`-c` или `--container` - необязательный параметр, указывает id или имя контейнера ассоциированный интерфейс которого показывать, если не указан, то покажет сетевые интерфейсы всех запущенных контейнеров.

Примеры:

```
[semets@dlg-smev4-test ~]$ sudo ./show-cont-ifs.sh -c 41b4098da190
ui-adapter:  veth11eb7f6
```
```
[semets@dlg-smev4-test ~]$ sudo ././show-cont-ifs.sh -c amqp-integration-adapter
amqp-integration-adapter:  veth0c0de28
```