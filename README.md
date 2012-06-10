# Authors:	Olivier van Helden, Gudule Lapointe (Speculoos.net)
# http://www.speculoos.net/opensim-toolbox
# Reditribution, modification and use are authorized, provided that 
# this disclaimer, the authors name and Speculoos web address stay in the redistributed code

Linux OpenSim-Toolbox
=====================

Linux OpenSim Toolbox, a set of useful tools to manage OpenSim servers on Linux, FreeBSD and MacOS.

Should work as is on most *nix based systems, including
	- Linux (tested on Debian Squeeze, Ubuntu 10.04 and 11.10)
	- FreeBSD (tested on 8.2)
	- MacOS (tested on 10.7)

INSTALLATION
------------

Tools must be installed on the system hosting the authentication server.
They need access to the mysql database and some need access to log files or config files
They can be put anywhere in your filesystem tree, we suggest keeping the directory structure and put it in /opt/opensim

After installing, you must copy etc/opensim-toolbox.example to one of these locations:
	/etc/opensim-toolbox
	~/etc/opensim-toolbox
	[opensim-toolbox bin parent directory]/etc/opensim-toolbox

Preference files will be loaded in this order

INCLUDED FILES
--------------

etc/opensim-cacheusers.example
	copy this file to etc/opensim-cacheusers and adjust according to your installation

bin/opensim-cacheusers
	Parse log file to fetch new hypergrid user connection data and update mysql cacheusers table.
	These data are needed to calculate visit statistics (particularly, hg active "last month" users)

bin/helpfunctions
	A set of functions and variable initialisation used in other tools. Useless to run it directly, it is called from other scripts
	
