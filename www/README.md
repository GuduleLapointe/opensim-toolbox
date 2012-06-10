Authors:	Olivier van Helden, Gudule Lapointe (Speculoos.net)
http://www.speculoos.net/opensim-toolbox
Reditribution, modification and use are authorized, provided that 
this disclaimer, the authors name and Speculoos web address stay in the redistributed code

gridinfo.php
============

This module can be integrated to your website to display grid info statistics

Common features
---------------
Displays
	Online users
	Local active users
	Total active users (*)
	Total users
	Total regions

(*) About total active users 
----------------------------
This module displays both local and total active users
	Active users are users which connected during the last 30 days
	In an hypergrid-enabled grid, displaying only local users (like most modules do) would give a fake idea of the real activity of the grid.
	Grid activity is better reflected by total active users (including those coming from other grids)
	But local user is the only number comparable with other grids.
	So we decided to display both.
	
Requirements
------------

The count of hypegrid active visitors requires the presence of the table "cacheusers", and running a batch script to update this table on a regular basis.
Both should be included in this package and can be found on the project web page mentioned above.


Installation
------------

Put the grindinfo.php on the top of your website
Copy config.php.example as config.php, in the same directory as gridinfo.php and adjust values.
config.php uses the same variable name as a couple of other third party modules, so gridinfo can be fully integrated with them.

