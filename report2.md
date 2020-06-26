# Performance Comparison Report

## CPU

### Single Core
|subject|run time|events|events/s|
|-|-|-|-|
|Run_2|10.0030s|1520|151.94|
|Run_1|10.0041s|1482|148.12|

### All Cores
|subject|run time|threads|events|events/s|
|-|-|-|-|-|
|Run_2|10.0062s|8|9953|994.55|
|Run_1|10.0073s|8|9910|990.16|

## Memory

|subject|run time|events|
|-|-|-|
|Run_2|5.5398s|104857600|
|Run_1|5.5820s|104857600|

## FileIO

### Sequential Read
|subject|run time|events|reads/s|reads (MiB/s)|
|-|-|-|-|-|
|Run_1|10.0001s|15458074|1545611.68|24150.18|
|Run_2|10.0001s|15357565|1535562.05|23993.16|

### Sequential Write
|subject|run time|events|writes/s|fsyncs/s|writes (MiB/s)|
|-|-|-|-|-|-|
|Run_2|10.0199s|286171|12526.73|16132.44|195.73|
|Run_1|10.0346s|201160|8791.05|11346.37|137.36|

### Sequential Rewrite
|subject|run time|events|writes/s|fsyncs/s|writes (MiB/s)|
|-|-|-|-|-|-|
|Run_2|10.0299s|283966|12421.22|15989.09|194.08|
|Run_1|10.0217s|224580|9823.31|12675.96|153.49|

### Random Read/Write
|subject|run time|events|reads/s|writes/s|fsyncs/s|reads (MiB/s)|writes (MiB/s)|
|-|-|-|-|-|-|-|-|
|Run_2|10.0164s|141571|3719.36|2479.74|8035.38|58.12|38.75|
|Run_1|10.0482s|120961|3168.78|2112.52|6851.27|49.51|33.01|

