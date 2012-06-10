-- This table must be created in the same database used by the authentication server
-- Statistics use JOIN requests between griduser, presence, regions and cacheuser

CREATE TABLE IF NOT EXISTS cacheusers (
	userid char(36),
	avatar varchar(128),
	grid varchar(255),
	login int(11),
	PRIMARY KEY (userid), KEY(login)
);
