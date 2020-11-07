CREATE TABLE `auth` (
  `id` int(11) NOT NULL auto_increment,
  `session` char(32) NOT NULL,
  `success` tinyint(1) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ;

CREATE TABLE `clients` (
  `id` int(4) NOT NULL auto_increment,
  `version` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ;

CREATE TABLE `input` (
  `id` int(11) NOT NULL auto_increment,
  `session` char(32) NOT NULL,
  `timestamp` datetime NOT NULL,
  `realm` varchar(50) default NULL,
  `success` tinyint(1) default NULL,
  `input` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `session` (`session`,`timestamp`,`realm`)
) ;

CREATE TABLE `sensors` (
  `id` int(11) NOT NULL auto_increment,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY  (`id`)
) ;

CREATE TABLE `sessions` (
  `id` char(32) NOT NULL,
  `starttime` datetime NOT NULL,
  `endtime` datetime default NULL,
  `sensor` int(4) NOT NULL,
  `ip` varchar(15) NOT NULL default '',
  `termsize` varchar(7) default NULL,
  `client` int(4) default NULL,
  PRIMARY KEY  (`id`),
  KEY `starttime` (`starttime`,`sensor`)
) ;

CREATE TABLE `ttylog` (
  `id` int(11) NOT NULL auto_increment,
  `session` char(32) NOT NULL,
  `ttylog` mediumblob NOT NULL,
  PRIMARY KEY  (`id`)
) ;

CREATE TABLE `downloads` (
  `id` int(11) NOT NULL auto_increment,
  `session` CHAR( 32 ) NOT NULL,
  `timestamp` datetime NOT NULL,
  `url` text NOT NULL,
  `outfile` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `session` (`session`,`timestamp`)
) ;

create table `commands` (
    `id`	 int(11) NOT NULL auto_increment,
    `command` char(32) NOT NULL,
    `impl_type` int(4) NOT NULL,
    `prof_type` char(32) NOT NULL,
    	PRIMARY KEY (`id`)
);

create table fake_commands(
    `id`	 int(11) NOT NULL auto_increment,
    `command` char(32) NOT NULL,
    `fake_output` char(32) NOT NULL,
    	PRIMARY KEY (`id`)
);

create table cases(
    `id`	 int(11) NOT NULL auto_increment,
    `initial_cmd` char(32) NOT NULL,
    `cmd_profile` char(32) NOT NULL,
    `action` int(4) NOT NULL,
    `action_param` char(32) NOT NULL,
    `rl_params` char(32) NOT NULL,
    `next_cmd` char(32) NOT NULL,
    	PRIMARY KEY (`id`)
);

--
-- WARNING: Existing data may be lost & messed up
--

CREATE TABLE IF NOT EXISTS `sensors` (
  `id` int(11) NOT NULL auto_increment,
  `ip` varchar(15) NOT NULL,
  PRIMARY KEY  (`id`)
) ;

INSERT INTO `sensors` (`ip`) (SELECT DISTINCT `sensor` FROM `sessions`) ;

UPDATE `sessions` SET `sensor` =
    (SELECT `id` FROM `sensors` WHERE `sensors`.`ip` = `sessions`.`sensor`) ;

ALTER TABLE `sessions` CHANGE `sensor` `sensor` INT( 4 ) NOT NULL ;

CREATE TABLE IF NOT EXISTS `ttylog` (
  `id` int(11) NOT NULL auto_increment,
  `session` int(11) NOT NULL,
  `ttylog` mediumblob NOT NULL,
  PRIMARY KEY  (`id`)
) ;

/*INSERT INTO `ttylog` (`session`, `ttylog`)
    (SELECT `id`, `ttylog` FROM `sessions` WHERE LENGTH(`ttylog`) > 0) ;

ALTER TABLE `sessions` DROP `ttylog` ;

ALTER TABLE `sessions` ADD `termtitle` VARCHAR( 255 ) NULL DEFAULT NULL ;

/*ALTER TABLE `sessions` ADD `client` INT( 4 ) NULL DEFAULT NULL ;
CREATE TABLE `clients` (
    `id` INT( 4 ) NOT NULL AUTO_INCREMENT ,
    `version` VARCHAR( 50 ) NOT NULL ,
    PRIMARY KEY ( `id` )
) ;*/

/* For the asynchronous mysql code, change session to use a 32 character
 * string instead of int(11) */

ALTER TABLE `auth` CHANGE `session` `session` CHAR( 32 ) NOT NULL ;
ALTER TABLE `input` CHANGE `session` `session` CHAR( 32 ) NOT NULL ;
ALTER TABLE `sessions` CHANGE `id` `id` CHAR( 32 ) NOT NULL ;
ALTER TABLE `ttylog` CHANGE `session` `session` CHAR( 32 ) NOT NULL ;

/* Remove an unnecessary feature 
ALTER TABLE `sessions` DROP `termtitle` ;*/

CREATE TABLE IF NOT EXISTS `downloads` (
  `id` int(11) NOT NULL auto_increment,
  `session` CHAR( 32 ) NOT NULL,
  `timestamp` datetime NOT NULL,
  `url` text NOT NULL,
  `outfile` text NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `session` (`session`,`timestamp`)
) ;




