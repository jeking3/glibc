# glibc CI #

The `install.sh` script is used to load or rebuild docker images inside Travis CI.
The `run.sh` script is used to run a build in a container.

Each directory is a "container":

* `build` - for a regular build
* `coverity` - for a Coverity Scan build

Each container has a build script and a `Dockerfile`.
