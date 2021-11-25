#!/usr/bin/env python
#
# clean_geotrace_export.py

"""clean_geotrace_export.py  last modified 2021-11-25

./clean_geotrace_export.py IDP2021_GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_WUEpD6wK.txt > GEOTRACES_IDP2021_Seawater_Discrete_Sample_v1_WUEpD6wK.clean.txt

"""


import sys
import time

DEBUG = False

if len(sys.argv) < 2:
	sys.exit(__doc__)
else:

	linecounter = 0
	removecounter = 0

	# track number of real values for each column
	found_header = False
	col_to_header = {} # key is col number, value is name of header 
	count_by_column = {} # key is col number, value is count of number of non-NA cells

	geotrace_file = sys.argv[1]

	# begin normal operation
	sys.stderr.write("# Reading file {}  {}\n".format( geotrace_file, time.asctime() ) )
	for line in open(geotrace_file,'r'):
		linecounter += 1
		# if // is at beginning of line, count, then skip the line
		# cannot use grep -v, since most lines contain hyperlink with https://something
		if line.find("//")==0:
			removecounter += 1
			continue
		if found_header is False:
			if line.find("Cruise")==0: # this is the header line
				found_header = True
				lsplits = line.strip().split("\t")
				for i, item in enumerate(lsplits): # get column headers
					col_to_header[i] = item
		else:
			lsplits = line.strip().split("\t")
			for i, item in enumerate(lsplits):
				if item and item!="9": # 9 is flag for no data for QV:SEADATANET columns
					count_by_column[i] = count_by_column.get(i,0) + 1

		# change:
		# Operator's Cruise Name   to   Operators
		# TMR#4  to  TMR_4
		#  [umol/kg]  to  _umol_kg
		#
		outline = line.replace("'","").replace("#","_").replace(" [","_").replace("]","")
		sys.stdout.write(outline)

	sys.stderr.write("# Counted {} lines with {} columns, removed {} lines  {}\n".format( linecounter, len(col_to_header), removecounter, time.asctime() ) )

	if DEBUG==True:
		for i, n in sorted(count_by_column.items(), key=lambda x: x[1], reverse=True):
			cline = "#VAR:{}\t{}\t{}\n".format( col_to_header.get(i,"NONE"), i, n )
			sys.stderr.write(cline)


### LOGS ONLY ###

Sample_Data_v1_WUEpD6wK_log = """
./clean_geotrace_export.py IDP2021_GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_WUEpD6wK.txt > GEOTRACES_IDP2021_Seawater_Discrete_Sample_v1_WUEpD6wK.clean.txt
# Reading file IDP2021_GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_WUEpD6wK.txt  Thu Nov 25 17:00:36 2021
# Counted 102877 lines with 417 columns, removed 6692 lines  Thu Nov 25 17:00:41 2021
"""


