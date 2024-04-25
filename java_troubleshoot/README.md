# Java Troubleshooting Notes

## Troubleshoot Memory/Heap Issues
### Reference
* [The Troubleshooting Tools | dev.java](https://dev.java/learn/jvm/tool/troubleshooting/)
* [Eclipse Memory Analyzer - Concepts | eclipse.org](https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Fconcepts%2Fheapdump.html&cp%3D51_2_0)
* [Eclipse Memory Analyzer - Introduction | eclipse.org](https://help.eclipse.org/latest/index.jsp?topic=/org.eclipse.mat.ui.help/welcome.html)
* [Eclipse Memory Analyzer - Basic Tutorial | eclipse.org](https://help.eclipse.org/latest/index.jsp?topic=%2Forg.eclipse.mat.ui.help%2Fgettingstarted%2Fbasictutorial.html&cp%3D51_1_0)
* [Eclipse MAT - Acquiring Heap Dumps | eclipse.org](https://help.eclipse.org/latest/topic/org.eclipse.mat.ui.help/tasks/acquiringheapdump.html)
* [Java Heap Dump Capture | baeldung.com](https://www.baeldung.com/java-heap-dump-capture)
* [jps Command | oracle.com](https://docs.oracle.com/en/java/javase/11/tools/jps.html)
* [jmap Command | oracle.com](https://docs.oracle.com/en/java/javase/11/tools/jmap.html)
* [Memory Analyzer Blog](https://memoryanalyzer.blogspot.com/)


### How To Generate and Analyze Heap Dump
#### Using Eclipse MAT tool 
* Open Eclipse MAT tool
* File >> Acquire Heap Dump >> Choose a local process >> Click Finish. This will generate a Heap dump file.
* The generated dump file will be automatically loaded in a new screen. 
* In the Overview screen, you'll find a lot of Actions like Histogram, Dominator Tree, Top Consumers etc. 
* There are also reports for Leak suspects, Top components etc. 
	
#### Using Command Line Options
* Use jps command to identify a specific process from a list of instrumented JVMs on the target system. Note down the PID of the desired process. 
* Use jmap tool to create a heap dump using PID from above step.
* Use Eclipse MAT tool to analyze the dump file.
	
##### Command Line Reference
    Use jps command to identify the process. Use option "-l" to 
        $ jps -l
        16548
        23276 org.jetbrains.jps.cmdline.Launcher
        26652 org.apache.catalina.startup.Bootstrap
        27708 org.jetbrains.idea.maven.server.RemoteMavenServer36
        796 jdk.jcmd/sun.tools.jps.Jps

	Use jmap tool to create a heap dump.
		$ jmap -dump:live,format=b,file=/c/tmp/mydump.hprof <pid>

## Troubleshoot High CPU Usage
### Reference
* [High CPU Usage in Java | baeldung.com](https://www.baeldung.com/java-high-cpu-usage-causes)

## Garbage Collection
### Reference
* [JVM Garbage Collectors | baeldung.com](https://www.baeldung.com/jvm-garbage-collectors)
* [Analyze Java Garbage Collection Logs | dev.to](https://dev.to/sematext/java-garbage-collection-logs-how-to-analyze-them-4hgb)
