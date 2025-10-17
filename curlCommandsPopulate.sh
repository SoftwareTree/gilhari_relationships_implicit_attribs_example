#!/bin/sh
# A shell script to invoke some sample curl commands on a Linux/Mac machine 
# against a running container image of the app-specific Gilhari microservice 
# gilhari_relationships_implicit_attribs_example:1.0.
#
# This scripts populates some data but does not delete them.
#
# The responses are recorded in a log file (curl.log).
#
# Note that these curl commands use a default mapped port number of 80
# even though the port number exposed by the app-specific
# microservice may be different (e.g., 8081) inside the container shell.
#
# You may optionally specify a non-default port number as the first 
# command line argument to this script. For example, to specify a 
# port number of 8899, use the following command:
# curlCommands 8899
#
# Note: aId is an IMPLICIT attribute in the B object referenced by the aB attrubute of A

# Check if a port is provided as an argument, if not, use default port 80
if [ -z "$1" ]; then
    port=80
else
    port=$1
fi

# Log file where output will be saved
log_file="curl.log"

# Start logging
echo "** BEGIN OUTPUT **" > "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# Log port information
echo "Using PORT number $port" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all A objects (and their referenced B objects) to start fresh
echo "** Delete all A objects (and their referenced B objects) to start fresh" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/A" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one A object with one referenced B object
echo "** Insert one A object with one referenced B object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/A" -H "Content-Type: application/json" -d '{"entity":{"aId":1,"aString":"aString_1","aBoolean":true,"aFloat":1.1,"aDate":347184000001,"aB":{"bId":100,"aId":1,"bInt":100,"bString":"bString_1"}}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all A objects (and their referenced B objects)
echo "** Query all A objects (and their referenced B objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Shallow Query all A objects (without their referenced B objects)
echo "** Shallow Query all A objects (without their referenced B objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A?deep=false" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one A object with one referenced B object
echo "** Insert one A object with one referenced B object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/A" -H "Content-Type: application/json" -d '{"entity":{"aId":2,"aString":"aString_2","aBoolean":false,"aFloat":2.2,"aDate":347184000002,"aB":{"bId":200,"aId":2,"bInt":200,"bString":"bString_2"}}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one A object without any referenced B objects
echo "** Insert one A object without any referenced B objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/A" -H "Content-Type: application/json" -d '{"entity":{"aId":3,"aString":"aString_3","aBoolean":false,"aFloat":3.3,"aDate":347184000003}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all A objects (and their referenced B objects)
echo "** Query all A objects (and their referenced B objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Shallow Query all A objects (without their referenced B objects)
echo "** Shallow Query all A objects (without their referenced B objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A?deep=false" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all A objects (and their referenced B objects) where aId > 1
echo "** Query all A objects (and their referenced B objects) objects where aId>1" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A?filter=aId>1" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all A objects (and their referenced B objects) where the related B object's bInt > 100
echo "** Query all A objects (and their referenced B objects) objects where the related B object's bInt > 100 (using a path-expression)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A?filter=jdxObject.aB.bInt>100" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of A objects
echo "** Query the count of A objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all B objects
echo "** Query all B objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/B" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of all A objects
echo "** Query the count of all A objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/A/getAggregate?attribute=aId&aggregateType=COUNT" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# End logging
echo "** END OUTPUT **" >> "$log_file"
echo "" >> "$log_file"

# Display the log content
cat "$log_file"
