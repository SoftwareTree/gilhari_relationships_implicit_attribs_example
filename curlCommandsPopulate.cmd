REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_relationships_implicit_attribs_example:1.0.
REM
REM  This scripts populates some data but does not delete them.
REM
REM  The responses are recorded in a log file (curl.log).
REM
REM  Note that these curl commands use a default mapped port number of 80
REM  even though the port number exposed by the app-specific
REM  microservice may be different (e.g., 8081) inside the container shell.
REM
REM  You may optionally specify a non-default port number as the first 
REM  command line argument to this script. For example, to specify a 
REM  port number of 8899, use the following command:
REM     curlCommands 8899
REM
REM  Note: aId is an IMPLICIT attribute in the B object referenced by the aB attrubute of A

IF %1.==. GOTO DefaultPort
SET port=%1
GOTO Proceed

:DefaultPort
SET port=80
GOTO Proceed

:Proceed

echo ** BEGIN OUTPUT ** > curl.log
echo. >> curl.log
echo. >> curl.log

echo Using PORT number %port% >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all A objects (and their referenced B objects)  to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/A" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object with one referenced B object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":1,""aString"":""aString_1"",""aBoolean"":true,""aFloat"":1.1,""aDate"":347184000001,""aB"":{""bId"":100,""aId"":1,""bInt"":100,""bString"":""bString_1""}}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all A objects (and their referenced B objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query all A objects (without their referenced B objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object with one referenced B object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":2,""aString"":""aString_2"",""aBoolean"":false,""aFloat"":2.2,""aDate"":347184000002,""aB"":{""bId"":200,""aId"":2,""bInt"":200,""bString"":""bString_2""}}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one A object without any referenced B objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json"  -d "{""entity"":{""aId"":3,""aString"":""aString_3"",""aBoolean"":false,""aFloat"":3.3,""aDate"":347184000003}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all A objects (and their referenced B objects) objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query all A objects (without their referenced B objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all A objects (and their referenced B objects) objects where aId>1" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?filter=aId>1"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all A objects (and their referenced B objects) objects where the related B object's bInt > 100 (using a path-expression)" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A?filter=jdxObject.aB.bInt>100"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of A objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all B objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/B"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of all A objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** END OUTPUT ** >> curl.log
echo. >> curl.log

type curl.log

