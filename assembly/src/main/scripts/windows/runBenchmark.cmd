@echo off
SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

SET CURR_DIR=%~dp0

cd /D "%CURR_DIR%.."

set APP_HOME=%cd%

echo %APP_HOME%

set APPCP=%APP_HOME%/conf

set JVM_FLAGS=

REM set JMSTESTER_OPTS_MEMORY=

for %%i in (%APP_HOME%\lib\*.jar) do (set APPCP=!APPCP!;%%~i)

if "x%JMST_DEBUG%" NEQ "x" (
   JVM_FLAGS="%JVM_FLAGS% -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
)

REM Set jvm memory configuration
 IF DEFINED JMSTESTER_OPTS_MEMORY (	
    echo "Using already defined JMSTESTER_OPTS_MEMORY=%JMSTESTER_OPTS_MEMORY%\n"
 ) else (
	set JMSTESTER_OPTS_MEMORY= -Xms256M -Xmx256M
 )

ECHO "Executing runBenchmark "

SET PATH=%PATH%;%APP_HOME%/../lib

echo "java %JMSTESTER_OPTS_MEMORY% %JVM_FLAGS% -cp %APPCP% com.fusesource.forge.jmstest.frontend.Benchmark %*"
java %JMSTESTER_OPTS_MEMORY% %JVM_FLAGS% -cp %APPCP% com.fusesource.forge.jmstest.frontend.Benchmark %*
REM java -cp %CLASSPATH%;C:\Temp\jmstester-1.1-SNAPSHOT\lib\activation-1.1.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\activeio-core-3.1.2.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\activemq-all-5.5.1-fuse-07-11.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\activemq-core-5.5.1-fuse-07-11-tests.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\activemq-protobuf-1.1.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\aopalliance-1.0.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\commons-io-1.4.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\commons-logging-1.1.1.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\commons-net-2.0.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\geronimo-j2ee-management_1.1_spec-1.0.1.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\geronimo-jms_1.1_spec-1.1.1.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jasypt-1.7.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jaxb-api-2.0.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jaxb-impl-2.0.3.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jmstester-1.1-SNAPSHOT.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jmstester-core-1.1-SNAPSHOT.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jmstester-rrd-1.1-SNAPSHOT.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jmstester-sigar-1.1-SNAPSHOT.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\jsr173_api-1.0.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\kahadb-5.5.1-fuse-07-11.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\log4j-1.2.14.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\log4j.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\org.osgi.core-4.1.0.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\rrd4j-2.0.7.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\sigar-1.6.4.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\sigar.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\slf4j-api-1.5.11.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-aop-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-asm-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-beans-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-context-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-core-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-expression-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\spring-test-3.0.3.RELEASE.jar;C:\Temp\jmstester-1.1-SNAPSHOT\lib\xbean-spring-3.4.jar;C:\Temp\jmstester-1.1-SNAPSHOT\bin/../conf; com.fusesource.forge.jmstest.frontend.Benchmark %*

ENDLOCAL