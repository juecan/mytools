#!/bin/bash

# Check port status
lsdahdi | awk '{if ($NF == "RED") print "pstn line ", $1, "is red"}'

