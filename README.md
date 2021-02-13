# cover2cover

A script for converting JaCoCo XML coverage reports into Cobertura XML coverage
reports.

## Motivation

I created this script because I wanted code coverage reports in Jenkins[[1]].
Since Cobertura[[2]] doesn't support Java 1.7 or higher (the project seems
abandoned), we had to use JaCoCo[[3]], which is great coverage tool and very easy
to use.

However, the Jenkins JaCoCo plugin[[4]] leaves a lot to be desired, while Cobertura's
Jenkins plugin[[5]] is a lot better. To be precise, it supports:

  * Trend graphs for packages, classes, etc. instead of just lines
  * Trend graphs in percentages instead of absolute numbers
  * High and low "water marks" that cause the build to become unstable in Jenkins

Until the JaCoCo plugin is up to speed, this script can be used to convert
JaCoCo XML reports into Cobertura XML reports, so we can continue to use the
Cobertura Jenkins plugin to track coverage.

Not every feature is supported, but close enough.

# Dockerized steps

* Just run the command against your source-code in a container

* `JACOCO_XML`: the `jacoco.xml` file
* `SRC_MAIN_JAVA_DIR`: the app sources
* `COBERTURA_XML_FILE`: the desired covertura.xml file to be created

```console
$ docker run -ti -v $(pwd):/app \
             -e JACOCO_XML=/app/build/reports/jacoco/test/jacocoTestReport.xml \
             -e SRC_MAIN_JAVA_DIR=/app/src/main/java \
             -e COBERTURA_XML_FILE=/app/build/reports/cobertura.xml \
             marcellodesales/cover2cover
```

## Docker-Compose

* After you generate the tests, adjust the paths to the vars

```yaml
version: "3.8"

services:

  fromJacoco2Cobertura:
    image: marcellodesales/cover2cover
    volumes:
      - ./:/app
    environment:
      - SRC_MAIN_JAVA_DIR=/app/src/main/java
      - JACOCO_XML=/app/build/reports/jacoco/test/jacocoTestReport.xml
      - COBERTURA_XML_FILE=/app/build/reports/cobertura.xml
```

* Generate the coverage just executing docker-compose

```console
$ docker-compose -f docker-compose-example.yaml up
WARNING: Found orphan containers (distance-matrix-service_distance-matrix-service-tests_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Starting distance-matrix-service_fromJacoco2Cobertura_1 ... done
Attaching to distance-matrix-service_fromJacoco2Cobertura_1
distance-matrix-service_fromJacoco2Cobertura_1 exited with code 0
```

* Make sure the file exists outside the container

```console
$ ls -la build/reports/cobertura.xml
-rw-r--r--  1 marcellodesales  staff  29722 Feb 13 08:59 build/reports/cobertura.xml
```

## Usage

Add the following "post step" to your Jenkins build:

    mkdir -p target/site/cobertura && cover2cover.py target/site/jacoco/jacoco.xml src/main/java > target/site/cobertura/coverage.xml

And add the Cobertura plugin with the following path:

    **/target/site/cobertura/coverage.xml

> (Note: The above assumes a Maven project)

[1]: http://jenkins-ci.org/ "Jenkins"
[2]: http://cobertura.sourceforge.net/ "Cobertura"
[3]: http://www.eclemma.org/jacoco/ "JaCoCo"
[4]: https://wiki.jenkins-ci.org/display/JENKINS/JaCoCo+Plugin "Jenkins JaCoCo plugin"
[5]: https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin "Jenkins Cobertura plugin"
