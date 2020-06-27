# Performance Comparison Report

|subject|provider|memory|storage|bandwidth|traffic|ping|price|
|-|-|-|-|-|-|-|-|
|Hetzner_CP31|Hetzner Nuremberg|8 gb|80 gb|n/s|20 tb|44 ms|10.77€/mo (IVA incl.)|
|Hetzner_CPX21|Hetzner Nuremberg|4 gb|80 gb|n/s|20 tb|44 ms|8.35€/mo (IVA incl.)|
|OVH_Essential|OVH Strasbourg|4 gb|80 gb|500 Mbps|unlimited|40 ms|12.10€/mo (10€ + IVA 21%)|
|Scaleway_DEV1-M|Scaleway Paris|4 gb|40 gb|300 Mbps|n/s|32 ms|9.67€/mo (7.99€ + IVA 21%)|
## CPU

### Single Core
|subject|run time|events|events/s|
|-|-|-|-|
|Hetzner_CPX21|10.0020s|1493|149.24|
|Scaleway_DEV1-M|10.0037s|1300|129.93|
|Hetzner_CP31|10.0087s|1061|105.96|
|OVH_Essential|10.0080s|762|76.12|

### All Cores
|subject|run time|threads|events|events/s|
|-|-|-|-|-|
|Hetzner_CPX21|10.0089s|3|3737|373.32|
|Scaleway_DEV1-M|10.0067s|3|3627|362.40|
|Hetzner_CP31|10.0087s|2|2060|205.79|
|OVH_Essential|10.0081s|2|1542|153.98|

## Memory

|subject|run time|events|
|-|-|-|
|OVH_Essential|10.0001s|52578668|
|Hetzner_CP31|10.0004s|49302944|
|Hetzner_CPX21|10.0001s|48846241|
|Scaleway_DEV1-M|10.0002s|27399955|

## FileIO

### Sequential Read
|subject|run time|events|reads/s|reads (MiB/s)|
|-|-|-|-|-|
|Hetzner_CPX21|10.0001s|10043267|1004229.42|15691.08|
|Hetzner_CP31|10.0001s|5819262|581825.87|9091.03|
|Scaleway_DEV1-M|10.0002s|5391680|539022.08|8422.22|
|OVH_Essential|10.0001s|5216795|521555.12|8149.30|

### Sequential Write
|subject|run time|events|writes/s|fsyncs/s|writes (MiB/s)|
|-|-|-|-|-|-|
|Hetzner_CPX21|10.0184s|279908|12255.32|15717.55|191.49|
|Hetzner_CP31|10.0110s|251703|11026.03|14137.98|172.28|
|OVH_Essential|10.0150s|236313|10351.99|13263.82|161.75|
|Scaleway_DEV1-M|10.0444s|57124|2498.52|3225.98|39.04|

### Sequential Rewrite
|subject|run time|events|writes/s|fsyncs/s|writes (MiB/s)|
|-|-|-|-|-|-|
|Hetzner_CP31|10.0161s|319640|13989.57|17930.60|218.59|
|Hetzner_CPX21|10.0162s|302042|13225.95|16961.76|206.66|
|OVH_Essential|10.0139s|261447|11451.21|14676.21|178.93|
|Scaleway_DEV1-M|10.0379s|76303|3336.81|4301.70|52.14|

### Random Read/Write
|subject|run time|events|reads/s|writes/s|fsyncs/s|reads (MiB/s)|writes (MiB/s)|
|-|-|-|-|-|-|-|-|
|Hetzner_CPX21|10.0134s|235270|6182.99|4121.99|13226.13|96.61|64.41|
|Hetzner_CP31|10.0121s|226115|5943.78|3962.52|12699.54|92.87|61.91|
|OVH_Essential|10.0169s|204746|5377.67|3585.14|11497.69|84.03|56.02|
|Scaleway_DEV1-M|10.1360s|25476|662.75|442.00|1446.04|10.36|6.91|

