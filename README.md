# SRWeb Runner

A simple Nginx based runner for [srweb][srweb], the [Student Robotics][sr] website.

## Rationale

In the past users who wished to work on the [Student Robotics][sr] website had to either run a virtual machine clone of the server, or configure Apache on their local machine. While these two options work fine, they can be a little tricky to set up or sometimes simple unreasonable to use (e.g. incompatible operating systems, virtual machine resource requirements). Therefore this project exists to provide an alternative, using Nginx and a simple bootstrap script. Although it should be made clear that this is not a perfect replication of the official web server, it is provided to make it as easy as possible to get started working on the website.

## Instructions

1. Clone `srweb` how you like to a `srweb` directory.
2. Run `run.sh` script from the runner directory.

[sr]: https://www.studentrobotics.org
[srweb]: https://www.studentrobotics.org/cgit/srweb.git/tree/README
