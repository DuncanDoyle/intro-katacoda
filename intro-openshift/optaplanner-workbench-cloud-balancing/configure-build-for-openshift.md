We will deploy our Planner project to the Red Hat JBoss BRMS Decision Server in OpenShift Container Platform. This Decision Server uses the so-called S2I, or Source-to-Image, concept to build its OpenShift (Docker) container images. In essence, you provide S2I the source code of your planner project, and the build system will use Maven to build the KJAR (Knowledge JAR) containing the data model, configuratino and constraint rules, deploy this KJAR onto the Decision Server and create the container image.

Because S2I uses Maven, we first need to make sure that our project is buildable by Maven. To verify this, we clone the project onto our local filesystem. Business Central uses a Git repository for storage under the covers, so we can simply use our favorite Git tool to clone the BRMS repository:

`git clone ssh://brmsAdmin@localhost:8001/cloud-balancing`{{code}}

When asked for the password, use `jbossbrms1!`{{code}}

---
**NOTE**

The Git implementation of Business Central uses an older public key algorithm (DAS). Our Katacoda instance supports this algorithm by default, but on other machines, it might be required to add the following settings to your SSH configuration file (on Linux and macOS this file is located at “~/.ssh/config”).

```
 Host localhost
 HostKeyAlgorithms +ssh-dss
 ```

---

After the project has been successfully cloned, go to the “cloud-balancing/cloud-balancing” directory and run “mvn clean install” to start the Maven build. If all his correct, this will produce a build failure:

```
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 7.346 s
[INFO] Finished at: 2017-09-06T19:38:39+07:00
[INFO] Final Memory: 34M/399M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:2.5.1-jboss-2:compile (default-compile) on project cloud-balancing: Compilation failure: Compilation failure:
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[3,49] package org.optaplanner.core.impl.domain.solution does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[4,55] package org.optaplanner.core.api.score.buildin.hardsoft does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[11,45] cannot find symbol
[ERROR] symbol: class AbstractSolution
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[11,62] cannot find symbol
[ERROR] symbol: class HardSoftScore
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[10,42] package org.optaplanner.core.api.domain.solution does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Process.java:[7,40] package org.optaplanner.core.api.domain.entity does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[16,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[17,45] package org.optaplanner.core.api.domain.solution does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[19,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/CloudBalancingSolution.java:[20,47] package org.optaplanner.core.api.domain.valuerange does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Process.java:[13,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Process.java:[15,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Process.java:[16,45] package org.optaplanner.core.api.domain.variable does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Process.java:[19,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Computer.java:[12,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Computer.java:[14,32] package org.kie.api.definition.type does not exist
[ERROR] /Users/ddoyle/Development/git/cloud-balancing/cloud-balancing/src/main/java/optaplanner/cloud_balancing/Computer.java:[16,32] package org.kie.api.definition.type does not exist
```

This is because our project contains Java annotations and types from the “kie-api” and "optaplanner-core" libraries, however, those dependencies are not defined in the “pom.xml” project descriptor of our project. These dependencies are not required for builds done in Business Central, as Business Central provides these JARs on the build path implicitly. However, we need to explicitly define this dependency in our “pom.xml” file for our local and Decision Server S2I Maven builds to succeed.

Add the following dependency to the “pom.xml” file of the project:

```
<dependencies>
   <dependency>
     <groupId>org.optaplanner</groupId>
     <artifactId>optaplanner-core</artifactId>
     <version>6.5.0.Final-redhat-2</version>
     <scope>provided</scope>
   </dependency>
</dependencies>
```

Note the “provided” scope, as we only require this dependency at compile time. At runtime, this dependency is provided by the Decision Server platform.

Run the build again: “mvn clean install”. The build should now succeed. We can commit these changes and push them back to our Git repository in Business Central with the following commands:

`git add pom.xml`{{copy}}

`git commit -m "Added kie-api dependency to POM."`{{code}}

`git push`{{code}}
