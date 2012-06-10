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
	
Installation
------------

Put the grindinfo.php on the top of your website
Copy config.php.example as config.php, in the same directory as gridinfo.php and adjust values.
config.php uses the same variable name as a couple of other third party modules, so gridinfo can be fully integrated with them.

