> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari Relationships With Implicit Attributes Example

> **Demonstrates implicit attributes for automatic foreign key management in contained objects**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains an example showing how to use Gilhari's **implicit attributes** feature, where attributes of a contained (referenced) object are automatically initialized by the ORM using foreign key values derived from the containing (referencing) object, simplifying JSON object creation.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_relationships_implicit_attribs_example) that can run as a RESTful microservice (server) to persist app specific JSON objects with relational mappings.

This example can be used **standalone as a RESTful microservice** or optionally with the ORMCP Server.

**Related:**
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples) - Comprehensive list of examples

**Note:** This example is also included in the Gilhari SDK distribution. If you have the SDK installed, you can use it directly from the `examples/gilhari_relationships_implicit_attribs_example` directory without cloning.

## Example Overview

The example showcases a JSON object model with two types of objects: **A** and **B**

**Object Model Overview:**
- **A**: Parent object that contains a B object
- **B**: Child object contained by A with an implicit `aId` attribute
- **Attributes**: 
  - A: aId (int), aString (string), aBoolean (boolean), aFloat (double), aDate (long/milliseconds), aB (B object)
  - B: bId (int), bInt (int), bString (string), aId (int - **IMPLICIT**, auto-populated)
- **Database Tables**: A, B (stored in separate tables)

### What Makes This Example Different?

This example demonstrates the **implicit attributes** feature:

**Implicit Attributes Feature:**
- The `aId` attribute in the B object is marked as **IMPLICIT_ATTRIB** in the ORM specification
- When creating an A object with a contained B object, you **do not need to specify** the `aId` value in the B object
- The ORM automatically populates the B object's `aId` with the value from the parent A object's `aId`
- This simplifies JSON object creation and reduces redundancy in client code

**Key Benefits:**
- **Cleaner JSON**: No need to repeat foreign key values in child objects
- **Automatic management**: ORM handles the foreign key relationships
- **Reduced errors**: Eliminates potential mismatches between parent and child IDs
- **BYVALUE semantics**: Contained B objects are deleted when their parent A object is deleted

**Configuration:**
See `config/gilhari_relationships_implicit_attribs_example.jdx` for how to configure implicit attributes using IMPLICIT_ATTRIB directive.

### A Object Structure (with contained B object - without explicit aId in B)
```json
{
  "aId": 1,
  "aString": "aString_1",
  "aBoolean": true,
  "aFloat": 1.1,
  "aDate": 347184000001,
  "aB": {
    "bId": 100,
    "bInt": 100,
    "bString": "bString_1"
  }
}
```

**Note:** The `aId` is **not specified** in the B object. The ORM will automatically populate it from the parent A object's `aId` value.

### A Object After Retrieval (B object now includes aId)
```json
{
  "aId": 1,
  "aString": "aString_1",
  "aBoolean": true,
  "aFloat": 1.1,
  "aDate": 347184000001,
  "aB": {
    "bId": 100,
    "aId": 1,
    "bInt": 100,
    "bString": "bString_1"
  }
}
```

**Note:** When retrieved, the B object includes the `aId` value that was automatically populated by the ORM.

## Project Structure

```
gilhari_relationships_implicit_attribs_example/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...      # A.java, B.java
├── config/                        # Configuration files
│   ├── gilhari_relationships_implicit_attribs_example.jdx  # ORM specification with IMPLICIT_ATTRIB
│   └── classnames_map_example.js
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommands.cmd / .sh         # API testing scripts
└── curlCommandsPopulate.cmd / .sh # Sample data population scripts
```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., A, B) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **A and B classes**: Simple shell (container) classes (.java files) corresponding to the domain-specific JSON object model classes of related entities (Container domain model classes)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_relationships_implicit_attribs_example.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables, **including the IMPLICIT_ATTRIB configuration**.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model classes (like A, B) corresponding to the conceptual domain-specific JSON object model classes are defined as subclasses of the JDX_JSONObject class
- Appropriate mappings for the domain-specific JSON object model classes are defined in the ORM specification file using the corresponding container domain model classes
- **IMPLICIT_ATTRIB configuration** enables automatic foreign key population from parent objects

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### Implicit Attribute Configuration

The key to this example is in the ORM specification file (`config/gilhari_relationships_implicit_attribs_example.jdx`), where the `aId` attribute in the B class is marked as implicit.

**Parent Class (A) with BYVALUE Relationship:**
```
CLASS .A TABLE A
    VIRTUAL_ATTRIB aId ATTRIB_TYPE int
    VIRTUAL_ATTRIB aString ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB aBoolean ATTRIB_TYPE boolean
    VIRTUAL_ATTRIB aFloat ATTRIB_TYPE double
    VIRTUAL_ATTRIB aDate ATTRIB_TYPE long
    
    PRIMARY_KEY aId 
    SQLMAP FOR aDate SQLTYPE DATE
    RELATIONSHIP aB REFERENCES .B BYVALUE REFERENCED_KEY AKEY WITH aId
;
```

**Child Class (B) with IMPLICIT_ATTRIB:**
```
CLASS .B TABLE B
    VIRTUAL_ATTRIB bId ATTRIB_TYPE int
    VIRTUAL_ATTRIB bInt ATTRIB_TYPE int
    VIRTUAL_ATTRIB bString ATTRIB_TYPE java.lang.String
    IMPLICIT_ATTRIB aId ATTRIB_TYPE int  // <-- Implicit attribute
    
    PRIMARY_KEY bId 
    REFERENCE_KEY AKEY aId
;
```

**How it works:**
1. When creating an A object, you include a B object in the `aB` attribute
2. You **omit** the `aId` field in the B object JSON
3. The ORM automatically populates B's `aId` with the value from A's `aId`
4. The REFERENCE_KEY directive links the implicit attribute to the parent relationship
5. When queried, the B object includes the `aId` value

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_relationships_implicit_attribs_example",
  "jdx_orm_spec_file": "./config/gilhari_relationships_implicit_attribs_example.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 5,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.js",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_relationships_implicit_attribs_example) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)
If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker**
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/A
http://localhost:80/gilhari/v1/B
```

### Supported HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/A` |
| POST | Create objects | `POST /gilhari/v1/A` |
| PUT | Update objects | `PUT /gilhari/v1/A` |
| PATCH | Partial update | `PATCH /gilhari/v1/A` |
| DELETE | Delete objects | `DELETE /gilhari/v1/A` |

### Example Operations

**Create A object with contained B object (without aId in B):**
```bash
curl -X POST http://localhost:80/gilhari/v1/A \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "aId": 1,
      "aString": "aString_1",
      "aBoolean": true,
      "aFloat": 1.1,
      "aDate": 347184000001,
      "aB": {
        "bId": 100,
        "bInt": 100,
        "bString": "bString_1"
      }
    }
  }'
```

**Note:** The `aId` is **not specified** in the B object. It will be automatically populated from the parent A's `aId`.

**Query all A objects (deep - includes B with aId populated):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A" \
  -H "Content-Type: application/json"
```

**Shallow query (exclude B objects):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A?deep=false" \
  -H "Content-Type: application/json"
```

**Query with path expression:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A?filter=jdxObject.aB.bInt>100" \
  -H "Content-Type: application/json"
```

**Query all B objects (will show auto-populated aId):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/B" \
  -H "Content-Type: application/json"
```

**Delete A object (cascades to B):**
```bash
curl -X DELETE "http://localhost:80/gilhari/v1/A?filter=aId=1"
```

### Testing the API

**Comprehensive test scripts:**

1. **curlCommands.cmd / .sh** - Demonstrates implicit attribute behavior

   Demonstrates:
   - Creating A objects without specifying aId in B objects
   - Verifying aId is auto-populated in retrieved B objects
   - Deep and shallow queries
   - Path expressions for filtering
   - Cascading deletes

2. **curlCommandsPopulate.cmd / .sh** - Population with data

   Demonstrates:
   - Sample data population
   - Multiple object creation scenarios
   - A objects with and without B objects
   - Querying to verify implicit attribute population

Run the scripts to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommands.cmd
curlCommandsPopulate.cmd

# Linux/Mac
chmod +x curlCommands.sh curlCommandsPopulate.sh
./curlCommands.sh
./curlCommandsPopulate.sh

# Custom port
curlCommands.cmd 8899
curlCommandsPopulate.sh 8899
```

The scripts demonstrate the implicit attributes feature where the B object's `aId` is automatically populated from the parent A object, simplifying JSON object creation.

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server** (optional): Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server (Optional)

This Gilhari microservice can be used with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use ORMCP tools** to query and manipulate A and B objects through natural language

The ORMCP Server will automatically handle the implicit attribute behavior when creating objects.

For more information on ORMCP Server:
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **ORMCP/Gilhari Examples**: [https://github.com/softwaretree/ormcp-docs#examples](https://github.com/softwaretree/ormcp-docs#examples)
- **Product Website**: [https://www.softwaretree.com/products/ormcp/](https://www.softwaretree.com/products/ormcp/)

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Documentation**: [https://github.com/softwaretree/ormcp-docs](https://github.com/softwaretree/ormcp-docs)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`
- **operationDetails Documentation**: See `operationDetails_doc.md` for GraphQL-like query capabilities

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_relationships_implicit_attribs_example.jdx` for correct database URL and JDBC driver path

**Problem**: The implicit aId is not being populated in B objects
- **Solution**: Verify the ORM specification has `IMPLICIT_ATTRIB aId` in the B class and `REFERENCED_KEY AKEY` in the A class's RELATIONSHIP declaration

**Problem**: Error when including aId in B object during creation
- **Solution**: When aId is IMPLICIT_ATTRIB, you should omit it in the JSON. If you include it, the value may be ignored or cause errors

## Support

For issues or questions:
- **ORMCP Documentation & Issues**: [https://github.com/softwaretree/ormcp-docs/issues](https://github.com/softwaretree/ormcp-docs/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_relationships_implicit_attribs_example/issues](https://github.com/SoftwareTree/gilhari_relationships_implicit_attribs_example/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!