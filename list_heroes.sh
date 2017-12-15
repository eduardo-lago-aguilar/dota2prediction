#!/bin/bash
#
# list_heroes.sh
#
# This script retrieves the list of heroes from trainingdata.txt for 
# https://www.hackerrank.com/challenges/dota2prediction/problem
#
# USAGE
#   $ ./list_heroes.sh
#
# AUTHOR
#   Written by Eduardo Lago Aguilar <eduardo.lago.aguilar@gmail.com> 
#
# list_heroes.sh is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 2 of the License, or (at your 
# option) any later version.
#
# <Script/Application name> is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for 
# more details.
#
# 
# See GNU General Public License <http://www.gnu.org/licenses/>.

awk -v FS="," -v OFS="\n" '{NF=NF-1; print}' < trainingdata.txt | sort -u | awk -v ORS=", " 'BEGIN {print "("} {print "\""$0"\""}' 
