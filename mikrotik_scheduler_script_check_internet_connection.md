# mikrotik scheduler script check internet connection

## script
```
/system script
add dont-require-permissions=no name=check_ping_and_disable_route_xyz owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="\
    \n:local ipToCheck \"abc.edf.ghi.jkl\";\
    \n    \r\
    \n:local routeToDisable 1;\
    \n    \r\
    \n:local countFail 0;\
    \n    \
    \n    \r\
    \n\r\
    \n:for i from=1 to=5 do={\
    \n        \r\
    \n  :if ([/ping \$ipToCheck count=1] = 0) do={\
    \n            \r\
    \n    :set countFail (\$countFail + 1);\
    \n        \r\
    \n  }\
    \n    \r\
    \n}\
    \n    \
    \n    \r\
    \n\r\
    \n:if (\$countFail = 5) do={\
    \n        \r\
    \n  /ip route set \$routeToDisable disabled=yes;\
    \n    \r\
    \n}\
    \n"
add dont-require-permissions=no name=check_ping_and_enable_route_xyz owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="\
    \n:local ipToCheck \"abc.edf.ghi.jkl\";\
    \n    \r\
    \n:local routeToEnable 1;\
    \n    \
    \n    \r\
    \n\r\
    \n:if ([/ping \$ipToCheck count=5] > 0) do={\
    \n        \r\
    \n  /ip route set \$routeToEnable disabled=no;\
    \n    \r\
    \n}\
    \n"
```

## scheduler
```
/system scheduler
add interval=1m name=schedule_check_and_disable_route_via_xyz on-event=check_ping_and_disable_route_xyz policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=\
    jul/24/2024 start-time=07:21:40
add interval=1m name=schedule_check_and_enable_route_via_xyz on-event=check_ping_and_enable_route_xyz policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=\
    jul/24/2024 start-time=07:21:45

```