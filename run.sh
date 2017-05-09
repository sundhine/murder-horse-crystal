#!/bin/bash
cd /opt/murder
crystal build src/murder-horse.cr --release
./murder-horse
