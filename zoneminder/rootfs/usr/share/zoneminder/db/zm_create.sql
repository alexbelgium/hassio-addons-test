-- MySQL dump 10.13 Distrib 5.6.13, for Linux (i686)
--
-- Host: localhost Database: @ZM_DB_NAME@
-- ------------------------------------------------------
-- Server version 5.6.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `@ZM_DB_NAME@`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `@ZM_DB_NAME@`;

USE `@ZM_DB_NAME@`;

--
-- Table structure for table `Config`
--

DROP TABLE IF EXISTS `Config`;
CREATE TABLE `Config` (
  `Id` smallint(5) unsigned NOT NULL default '0',
  `Name` varchar(32) NOT NULL default '',
  `Value` text NOT NULL,
  `Type` tinytext NOT NULL,
  `DefaultValue` text,
  `Hint` tinytext,
  `Pattern` tinytext,
  `Format` tinytext,
  `Prompt` tinytext,
  `Help` text,
  `Category` varchar(32) NOT NULL default '',
  `Readonly` tinyint(3) unsigned NOT NULL default '0',
  `Private` BOOLEAN NOT NULL DEFAULT FALSE,
  `Requires` text,
  PRIMARY KEY (`Name`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `ControlPresets`
--

DROP TABLE IF EXISTS `ControlPresets`;
CREATE TABLE `ControlPresets` (
  `MonitorId` int(10) unsigned NOT NULL default '0',
  `Preset` int(10) unsigned NOT NULL default '0',
  `Label` varchar(64) NOT NULL default '',
  PRIMARY KEY (`MonitorId`,`Preset`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Controls`
--

DROP TABLE IF EXISTS `Controls`;
CREATE TABLE `Controls` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `Type` enum('Local','Remote','File','Ffmpeg','Libvlc','cURL','WebSite','NVSocket','VNC') NOT NULL default 'Local',
  `Protocol` varchar(64) default NULL,
  `CanWake` tinyint(3) unsigned NOT NULL default '0',
  `CanSleep` tinyint(3) unsigned NOT NULL default '0',
  `CanReset` tinyint(3) unsigned NOT NULL default '0',
  `CanReboot` tinyint(3) unsigned NOT NULL default '0',
  `CanZoom` tinyint(3) unsigned NOT NULL default '0',
  `CanAutoZoom` tinyint(3) unsigned NOT NULL default '0',
  `CanZoomAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanZoomRel` tinyint(3) unsigned NOT NULL default '0',
  `CanZoomCon` tinyint(3) unsigned NOT NULL default '0',
  `MinZoomRange` int(10) unsigned default NULL,
  `MaxZoomRange` int(10) unsigned default NULL,
  `MinZoomStep` int(10) unsigned default NULL,
  `MaxZoomStep` int(10) unsigned default NULL,
  `HasZoomSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinZoomSpeed` int(10) unsigned default NULL,
  `MaxZoomSpeed` int(10) unsigned default NULL,
  `CanFocus` tinyint(3) unsigned NOT NULL default '0',
  `CanAutoFocus` tinyint(3) unsigned NOT NULL default '0',
  `CanFocusAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanFocusRel` tinyint(3) unsigned NOT NULL default '0',
  `CanFocusCon` tinyint(3) unsigned NOT NULL default '0',
  `MinFocusRange` int(10) unsigned default NULL,
  `MaxFocusRange` int(10) unsigned default NULL,
  `MinFocusStep` int(10) unsigned default NULL,
  `MaxFocusStep` int(10) unsigned default NULL,
  `HasFocusSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinFocusSpeed` int(10) unsigned default NULL,
  `MaxFocusSpeed` int(10) unsigned default NULL,
  `CanIris` tinyint(3) unsigned NOT NULL default '0',
  `CanAutoIris` tinyint(3) unsigned NOT NULL default '0',
  `CanIrisAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanIrisRel` tinyint(3) unsigned NOT NULL default '0',
  `CanIrisCon` tinyint(3) unsigned NOT NULL default '0',
  `MinIrisRange` int(10) unsigned default NULL,
  `MaxIrisRange` int(10) unsigned default NULL,
  `MinIrisStep` int(10) unsigned default NULL,
  `MaxIrisStep` int(10) unsigned default NULL,
  `HasIrisSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinIrisSpeed` int(10) unsigned default NULL,
  `MaxIrisSpeed` int(10) unsigned default NULL,
  `CanGain` tinyint(3) unsigned NOT NULL default '0',
  `CanAutoGain` tinyint(3) unsigned NOT NULL default '0',
  `CanGainAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanGainRel` tinyint(3) unsigned NOT NULL default '0',
  `CanGainCon` tinyint(3) unsigned NOT NULL default '0',
  `MinGainRange` int(10) unsigned default NULL,
  `MaxGainRange` int(10) unsigned default NULL,
  `MinGainStep` int(10) unsigned default NULL,
  `MaxGainStep` int(10) unsigned default NULL,
  `HasGainSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinGainSpeed` int(10) unsigned default NULL,
  `MaxGainSpeed` int(10) unsigned default NULL,
  `CanWhite` tinyint(3) unsigned NOT NULL default '0',
  `CanAutoWhite` tinyint(3) unsigned NOT NULL default '0',
  `CanWhiteAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanWhiteRel` tinyint(3) unsigned NOT NULL default '0',
  `CanWhiteCon` tinyint(3) unsigned NOT NULL default '0',
  `MinWhiteRange` int(10) unsigned default NULL,
  `MaxWhiteRange` int(10) unsigned default NULL,
  `MinWhiteStep` int(10) unsigned default NULL,
  `MaxWhiteStep` int(10) unsigned default NULL,
  `HasWhiteSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinWhiteSpeed` int(10) unsigned default NULL,
  `MaxWhiteSpeed` int(10) unsigned default NULL,
  `HasPresets` tinyint(3) unsigned NOT NULL default '0',
  `NumPresets` tinyint(3) unsigned NOT NULL default '0',
  `HasHomePreset` tinyint(3) unsigned NOT NULL default '0',
  `CanSetPresets` tinyint(3) unsigned NOT NULL default '0',
  `CanMove` tinyint(3) unsigned NOT NULL default '0',
  `CanMoveDiag` tinyint(3) unsigned NOT NULL default '0',
  `CanMoveMap` tinyint(3) unsigned NOT NULL default '0',
  `CanMoveAbs` tinyint(3) unsigned NOT NULL default '0',
  `CanMoveRel` tinyint(3) unsigned NOT NULL default '0',
  `CanMoveCon` tinyint(3) unsigned NOT NULL default '0',
  `CanPan` tinyint(3) unsigned NOT NULL default '0',
  `MinPanRange` int(10) default NULL,
  `MaxPanRange` int(10) default NULL,
  `MinPanStep` int(10) default NULL,
  `MaxPanStep` int(10) default NULL,
  `HasPanSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinPanSpeed` int(10) default NULL,
  `MaxPanSpeed` int(10) default NULL,
  `HasTurboPan` tinyint(3) unsigned NOT NULL default '0',
  `TurboPanSpeed` int(10) default NULL,
  `CanTilt` tinyint(3) unsigned NOT NULL default '0',
  `MinTiltRange` int(10) default NULL,
  `MaxTiltRange` int(10) default NULL,
  `MinTiltStep` int(10) default NULL,
  `MaxTiltStep` int(10) default NULL,
  `HasTiltSpeed` tinyint(3) unsigned NOT NULL default '0',
  `MinTiltSpeed` int(10) default NULL,
  `MaxTiltSpeed` int(10) default NULL,
  `HasTurboTilt` tinyint(3) unsigned NOT NULL default '0',
  `TurboTiltSpeed` int(10) default NULL,
  `CanAutoScan` tinyint(3) unsigned NOT NULL default '0',
  `NumScanPaths` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Devices`
--

DROP TABLE IF EXISTS `Devices`;
CREATE TABLE `Devices` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` tinytext NOT NULL,
  `Type` enum('X10') NOT NULL default 'X10',
  `KeyString` varchar(32) NOT NULL default '',
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Events`
--

DROP TABLE IF EXISTS `Events`;
CREATE TABLE `Events` (
  `Id` bigint unsigned NOT NULL auto_increment,
  `MonitorId` int(10) unsigned NOT NULL default '0',
  `StorageId`	smallint(5) unsigned default 0,
  `SecondaryStorageId`	smallint(5) unsigned default 0,
  `Name` varchar(64) NOT NULL default '',
  `Cause` TEXT,
  `StartDateTime` datetime default NULL,
  `EndDateTime` datetime default NULL,
  `Width` smallint(5) unsigned NOT NULL default '0',
  `Height` smallint(5) unsigned NOT NULL default '0',
  `Length` decimal(10,2) NOT NULL default '0.00',
  `Frames` int(10) unsigned default NULL,
  `AlarmFrames` int(10) unsigned default NULL,
  `DefaultVideo` VARCHAR( 64 ) DEFAULT '' NOT NULL,
  `SaveJPEGs` TINYINT,
  `TotScore` int(10) unsigned NOT NULL default '0',
  `AvgScore` smallint(5) unsigned default '0',
  `MaxScore` smallint(5) unsigned default '0',
  `Archived` tinyint(3) unsigned NOT NULL default '0',
  `Videoed` tinyint(3) unsigned NOT NULL default '0',
  `Uploaded` tinyint(3) unsigned NOT NULL default '0',
  `Emailed` tinyint(3) unsigned NOT NULL default '0',
  `Messaged` tinyint(3) unsigned NOT NULL default '0',
  `Executed` tinyint(3) unsigned NOT NULL default '0',
  `Notes` text,
  `StateId` int(10) unsigned NOT NULL,
  `Orientation` enum('ROTATE_0','ROTATE_90','ROTATE_180','ROTATE_270','FLIP_HORI','FLIP_VERT') NOT NULL default 'ROTATE_0',
  `DiskSpace`   bigint unsigned default NULL,
  `Scheme`   enum('Deep','Medium','Shallow') NOT NULL default 'Medium',
  `Locked`    BOOLEAN NOT NULL DEFAULT False,
  PRIMARY KEY (`Id`),
  KEY `Events_MonitorId_idx` (`MonitorId`),
  KEY `Events_StorageId_idx` (`StorageId`),
  KEY `Events_StartDateTime_idx` (`StartDateTime`),
  KEY `Events_EndDateTime_DiskSpace` (`EndDateTime`,`DiskSpace`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Events_Hour`;
CREATE TABLE `Events_Hour` (
  `EventId` BIGINT unsigned NOT NULL,
  `MonitorId` int(10) unsigned NOT NULL,
  `StartDateTime` datetime default NULL,
  `DiskSpace`   bigint default NULL,
  PRIMARY KEY (`EventId`),
  KEY `Events_Hour_MonitorId_idx` (`MonitorId`),
  KEY `Events_Hour_StartDateTime_idx` (`StartDateTime`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Events_Day`;
CREATE TABLE `Events_Day` (
  `EventId` BIGINT unsigned NOT NULL,
  `MonitorId` int(10) unsigned NOT NULL,
  `StartDateTime` datetime default NULL,
  `DiskSpace`   bigint default NULL,
  PRIMARY KEY (`EventId`),
  KEY `Events_Day_MonitorId_idx` (`MonitorId`),
  KEY `Events_Day_StartDateTime_idx` (`StartDateTime`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Events_Week`;
CREATE TABLE `Events_Week` (
  `EventId` BIGINT unsigned NOT NULL,
  `MonitorId` int(10) unsigned NOT NULL,
  `StartDateTime` datetime default NULL,
  `DiskSpace`   bigint default NULL,
  PRIMARY KEY (`EventId`),
  KEY `Events_Week_MonitorId_idx` (`MonitorId`),
  KEY `Events_Week_StartDateTime_idx` (`StartDateTime`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Events_Month`;
CREATE TABLE `Events_Month` (
  `EventId` BIGINT unsigned NOT NULL,
  `MonitorId` int(10) unsigned NOT NULL,
  `StartDateTime` datetime default NULL,
  `DiskSpace`   bigint default NULL,
  PRIMARY KEY (`EventId`),
  KEY `Events_Month_MonitorId_idx` (`MonitorId`),
  KEY `Events_Month_StartDateTime_idx` (`StartDateTime`)
) ENGINE=@ZM_MYSQL_ENGINE@;


DROP TABLE IF EXISTS `Events_Archived`;
CREATE TABLE `Events_Archived` (
  `EventId` BIGINT unsigned NOT NULL,
  `MonitorId` int(10) unsigned NOT NULL,
  `DiskSpace`   bigint default NULL,
  PRIMARY KEY (`EventId`),
  KEY `Events_Archived_MonitorId_idx` (`MonitorId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Filters`
--

DROP TABLE IF EXISTS `Filters`;
CREATE TABLE `Filters` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `UserId`  int(10) unsigned,
  `ExecuteInterval` int(10) unsigned NOT NULL default '60',
  `Query_json` text NOT NULL,
  `AutoArchive` tinyint(3) unsigned NOT NULL default '0',
  `AutoUnarchive` tinyint(3) unsigned NOT NULL default '0',
  `AutoVideo` tinyint(3) unsigned NOT NULL default '0',
  `AutoUpload` tinyint(3) unsigned NOT NULL default '0',
  `AutoEmail` tinyint(3) unsigned NOT NULL default '0',
	`EmailTo`				TEXT,
	`EmailSubject`	TEXT,
	`EmailBody`			TEXT,
  `AutoMessage` tinyint(3) unsigned NOT NULL default '0',
  `AutoExecute` tinyint(3) unsigned NOT NULL default '0',
  `AutoExecuteCmd` tinytext,
  `AutoDelete` tinyint(3) unsigned NOT NULL default '0',
  `AutoMove` tinyint(3) unsigned NOT NULL default '0',
  `AutoMoveTo`	smallint(5) unsigned NOT NULL default 0,
  `AutoCopy` tinyint(3) unsigned NOT NULL default '0',
  `AutoCopyTo`	smallint(5) unsigned NOT NULL default 0,
  `UpdateDiskSpace` tinyint(3) unsigned NOT NULL default '0',
  `Background` tinyint(1) unsigned NOT NULL default '0',
  `Concurrent` tinyint(1) unsigned NOT NULL default '0',
  `LockRows` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY (`Id`),
  KEY `Name` (`Name`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Frames`
--

DROP TABLE IF EXISTS `Frames`;
CREATE TABLE `Frames` (
  `Id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `EventId` BIGINT UNSIGNED NOT NULL default '0',
  FOREIGN KEY (`EventId`) REFERENCES `Events` (`Id`) ON DELETE CASCADE,
  `FrameId` int(10) unsigned NOT NULL default '0',
  `Type` enum('Normal','Bulk','Alarm') NOT NULL default 'Normal',
  `TimeStamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `Delta` decimal(8,2) NOT NULL default '0.00',
  `Score` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY (`Id`),
  INDEX `EventId_idx` (`EventId`),
  KEY `Type` (`Type`),
  KEY `TimeStamp` (`TimeStamp`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Groups`
--

DROP TABLE IF EXISTS `Groups`;
CREATE TABLE `Groups` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `ParentId` int(10) unsigned,
  FOREIGN KEY (`ParentId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Groups_Monitors`
--

DROP TABLE IF EXISTS `Groups_Monitors`;
CREATE TABLE `Groups_Monitors` (
    `Id` INT(10) unsigned NOT NULL auto_increment,
    `GroupId` int(10) unsigned NOT NULL,
    FOREIGN KEY (`GroupId`) REFERENCES `Groups` (`Id`) ON DELETE CASCADE,
    `MonitorId` int(10) unsigned NOT NULL,
    FOREIGN KEY (`MonitorId`) REFERENCES `Monitors` (`Id`) ON DELETE CASCADE,
    PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

CREATE INDEX `Groups_Monitors_GroupId_idx` ON `Groups_Monitors` (`GroupId`);
CREATE INDEX `Groups_Monitors_MonitorId_idx` ON `Groups_Monitors` (`MonitorId`);

--
-- Table structure for table `Logs`
--

DROP TABLE IF EXISTS `Logs`;
CREATE TABLE `Logs` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TimeKey` decimal(16,6) NOT NULL,
  `Component` varchar(32) NOT NULL,
  `ServerId` int(10) unsigned,
  `Pid` int(10) DEFAULT NULL,
  `Level` tinyint(3) NOT NULL,
  `Code` char(3) NOT NULL,
  `Message` text NOT NULL,
  `File` varchar(255) DEFAULT NULL,
  `Line` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `TimeKey` (`TimeKey`)
) ENGINE=@ZM_MYSQL_ENGINE@;

CREATE INDEX `Logs_TimeKey_idx` ON `Logs` (`TimeKey`);
CREATE INDEX `Logs_Level_idx` ON `Logs` (`Level`);
--
-- Table structure for table `Manufacturers`
--

DROP TABLE IF EXISTS `Manufacturers`;
CREATE TABLE `Manufacturers` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name`  varchar(64) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY (`Name`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Models`
--

DROP TABLE IF EXISTS `Models`;
CREATE TABLE `Models` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name`  varchar(64) NOT NULL,
  `ManufacturerId` int(10),
  PRIMARY KEY (`Id`),
  UNIQUE KEY (`ManufacturerId`,`Name`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `MonitorPresets`
--

DROP TABLE IF EXISTS `MonitorPresets`;
CREATE TABLE `MonitorPresets` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `ModelId`  int unsigned, FOREIGN KEY (`ModelId`) REFERENCES `Models` (Id),
  `Name` varchar(64) NOT NULL default '',
  `Type` enum('Local','Remote','File','Ffmpeg','Libvlc','cURL','WebSite','NVSocket','VNC') NOT NULL default 'Local',
  `Device` tinytext,
  `Channel` tinyint(3) unsigned default NULL,
  `Format` int(10) unsigned default NULL,
  `Protocol` varchar(16) default NULL,
  `Method` varchar(16) default NULL,
  `Host` varchar(64) default NULL,
  `Port` varchar(8) default NULL,
  `Path` varchar(255) default NULL,
  `SubPath` varchar(64) default NULL,
  `Width` smallint(5) unsigned default NULL,
  `Height` smallint(5) unsigned default NULL,
  `Palette` int(10) unsigned default NULL,
  `MaxFPS` decimal(5,3) default NULL,
  `Controllable` tinyint(3) unsigned NOT NULL default '0',
  `ControlId` varchar(16) default NULL,
  `ControlDevice` varchar(255) default NULL,
  `ControlAddress` varchar(255) default NULL,
  `DefaultRate` smallint(5) unsigned NOT NULL default '100',
  `DefaultScale` smallint(5) unsigned NOT NULL default '100',
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Monitors`
--

DROP TABLE IF EXISTS `Monitors`;
CREATE TABLE `Monitors` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `Notes` TEXT,
  `ServerId` int(10) unsigned,
  `StorageId`	smallint(5) unsigned default 0,
  `ManufacturerId`  int unsigned, FOREIGN KEY (`ManufacturerId`) REFERENCES `Manufacturers` (Id),
  `ModelId`  int unsigned, FOREIGN KEY (`ModelId`) REFERENCES `Models` (Id),
  `Type` enum('Local','Remote','File','Ffmpeg','Libvlc','cURL','WebSite','NVSocket','VNC') NOT NULL default 'Local',
  `Function` enum('None','Monitor','Modect','Record','Mocord','Nodect') NOT NULL default 'Monitor',
  `Capturing` enum('None','Ondemand', 'Always') NOT NULL default 'Always',
  `Analysing` enum('None','Always') NOT NULL default 'Always',
  `AnalysisSource` enum('Primary','Secondary') NOT NULL DEFAULT 'Primary',
  `Recording` enum('None', 'OnMotion', 'Always') NOT NULL default 'Always',
  `Enabled` tinyint(3) unsigned NOT NULL default '1',
  `DecodingEnabled` tinyint(3) unsigned NOT NULL default '1',
  `JanusEnabled` BOOLEAN NOT NULL default false,
  `JanusAudioEnabled` BOOLEAN NOT NULL default false,
  `LinkedMonitors` varchar(255),
  `Triggers` set('X10') NOT NULL default '',
  `EventStartCommand` VARCHAR(255) NOT NULL DEFAULT '',
  `EventEndCommand` VARCHAR(255) NOT NULL DEFAULT '',
  `ONVIF_URL` VARCHAR(255) NOT NULL DEFAULT '',
  `ONVIF_Username` VARCHAR(64) NOT NULL DEFAULT '',
  `ONVIF_Password` VARCHAR(64) NOT NULL DEFAULT '',
  `ONVIF_Options` VARCHAR(64) NOT NULL DEFAULT '',
  `ONVIF_Event_Listener`  BOOLEAN NOT NULL DEFAULT FALSE,
  `use_Amcrest_API`  BOOLEAN NOT NULL DEFAULT FALSE,
  `Device` tinytext NOT NULL default '',
  `Channel` tinyint(3) unsigned NOT NULL default '0',
  `Format` int(10) unsigned NOT NULL default '0',
  `V4LMultiBuffer`	tinyint(1) unsigned,
  `V4LCapturesPerFrame`	tinyint(3) unsigned,
  `Protocol` varchar(16),
  `Method` varchar(16) default '',
  `Host` varchar(64),
  `Port` varchar(8) NOT NULL default '',
  `SubPath` varchar(64) NOT NULL default '',
  `Path` varchar(255),
  `SecondPath` varchar(255),
  `Options` varchar(255),
  `User` varchar(64),
  `Pass` varchar(64),
  `Width` smallint(5) unsigned NOT NULL default '0',
  `Height` smallint(5) unsigned NOT NULL default '0',
  `Colours` tinyint(3) unsigned NOT NULL default '1',
  `Palette` int(10) unsigned NOT NULL default '0',
  `Orientation` enum('ROTATE_0','ROTATE_90','ROTATE_180','ROTATE_270','FLIP_HORI','FLIP_VERT') NOT NULL default 'ROTATE_0',
  `Deinterlacing` int(10) unsigned NOT NULL default '0',
  `DecoderHWAccelName`  varchar(64),
  `DecoderHWAccelDevice`  varchar(255),
  `SaveJPEGs` TINYINT NOT NULL DEFAULT '3' ,
  `VideoWriter` TINYINT NOT NULL DEFAULT '0',
  `OutputCodec` int(10) unsigned NOT NULL default 0,
  `Encoder`     varchar(32),
  `OutputContainer` enum('auto','mp4','mkv'),
  `EncoderParameters` TEXT,
  `RecordAudio` TINYINT NOT NULL DEFAULT '0',
  `RecordingSource`  enum('Primary','Secondary','Both') NOT NULL DEFAULT 'Primary',
  `RTSPDescribe` tinyint(1) unsigned,
  `Brightness` mediumint(7) NOT NULL default '-1',
  `Contrast` mediumint(7) NOT NULL default '-1',
  `Hue` mediumint(7) NOT NULL default '-1',
  `Colour` mediumint(7) NOT NULL default '-1',
  `EventPrefix` varchar(32) NOT NULL default 'Event-',
  `LabelFormat` varchar(64),
  `LabelX` smallint(5) unsigned NOT NULL default '0',
  `LabelY` smallint(5) unsigned NOT NULL default '0',
  `LabelSize` smallint(5) unsigned NOT NULL DEFAULT '1',
  `ImageBufferCount` smallint(5) unsigned NOT NULL default '3',
  `MaxImageBufferCount` smallint(5) unsigned NOT NULL default '0',
  `WarmupCount` smallint(5) unsigned NOT NULL default '0',
  `PreEventCount` smallint(5) unsigned NOT NULL default '10',
  `PostEventCount` smallint(5) unsigned NOT NULL default '10',
  `StreamReplayBuffer` int(10) unsigned NOT NULL default '0',
  `AlarmFrameCount` smallint(5) unsigned NOT NULL default '1',
  `SectionLength` int(10) unsigned NOT NULL default '600',
  `MinSectionLength` int(10) unsigned NOT NULL default '10',
  `FrameSkip` smallint(5) unsigned NOT NULL default '0',
  `MotionFrameSkip` smallint(5) unsigned NOT NULL default '0',
  `AnalysisFPSLimit` decimal(5,2) default NULL,
  `AnalysisUpdateDelay` smallint(5) unsigned NOT NULL default '0',
  `MaxFPS` decimal(5,2) default NULL,
  `AlarmMaxFPS` decimal(5,2) default NULL,
  `FPSReportInterval` smallint(5) unsigned NOT NULL default '250',
  `RefBlendPerc` tinyint(3) unsigned NOT NULL default '6',
  `AlarmRefBlendPerc` tinyint(3) unsigned NOT NULL default '6',
  `Controllable` tinyint(3) unsigned NOT NULL default '0',
  `ControlId` int(10) unsigned,
  `ControlDevice` varchar(255) default NULL,
  `ControlAddress` varchar(255) default NULL,
  `AutoStopTimeout` decimal(5,2) default NULL,
  `TrackMotion` tinyint(3) unsigned NOT NULL default '0',
  `TrackDelay` smallint(5) unsigned,
  `ReturnLocation` tinyint(3) NOT NULL default '-1',
  `ReturnDelay` smallint(5) unsigned,
  `ModectDuringPTZ` tinyint(3) unsigned NOT NULL default '0',
  `DefaultRate` smallint(5) unsigned NOT NULL default '100',
  `DefaultScale` smallint(5) unsigned NOT NULL default '100',
  `DefaultCodec` enum('auto','MP4','MJPEG') NOT NULL default 'auto',
  `SignalCheckPoints` INT UNSIGNED NOT NULL default '0',
  `SignalCheckColour` varchar(32) NOT NULL default '#0000BE',
  `WebColour` varchar(32) NOT NULL default 'red',
  `Exif` tinyint(1) unsigned NOT NULL default '0',
  `Sequence` smallint(5) unsigned default NULL,
  `ZoneCount` TINYINT NOT NULL DEFAULT 0,
  `Refresh` int(10) unsigned default NULL,
  `Latitude`  DECIMAL(10,8),
  `Longitude`  DECIMAL(11,8),
  `RTSPServer`  BOOLEAN NOT NULL DEFAULT FALSE,
  `RTSPStreamName`  varchar(255) NOT NULL default '',
  `Importance`  enum('Normal','Less','Not') NOT NULL default 'Normal',
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

CREATE INDEX `Monitors_ServerId_idx` ON `Monitors` (`ServerId`);

DROP TABLE IF EXISTS `Monitor_Status`;
CREATE TABLE `Monitor_Status` (
  `MonitorId` int(10) unsigned NOT NULL,
  `Status`  enum('Unknown','NotRunning','Running','Connected','Signal') NOT NULL default 'Unknown',
  `CaptureFPS`  DECIMAL(10,2) NOT NULL default 0,
  `AnalysisFPS`  DECIMAL(5,2) NOT NULL default 0,
  `CaptureBandwidth`  INT NOT NULL default 0,
  PRIMARY KEY (`MonitorId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Event_Summaries`;
CREATE TABLE `Event_Summaries` (
  `MonitorId` int(10) unsigned NOT NULL,
  `TotalEvents` int(10) default NULL,
  `TotalEventDiskSpace` bigint default NULL,
  `HourEvents` int(10) default NULL,
  `HourEventDiskSpace` bigint default NULL,
  `DayEvents` int(10) default NULL,
  `DayEventDiskSpace` bigint default NULL,
  `WeekEvents` int(10) default NULL,
  `WeekEventDiskSpace` bigint default NULL,
  `MonthEvents` int(10) default NULL,
  `MonthEventDiskSpace` bigint default NULL,
  `ArchivedEvents` int(10) default NULL,
  `ArchivedEventDiskSpace` bigint default NULL,
  PRIMARY KEY (`MonitorId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `States`
-- PP - Added IsActive to track custom run states
-- Also made sure Name is unique

DROP TABLE IF EXISTS `States`;
CREATE TABLE `States` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `Definition` text NOT NULL,
  `IsActive` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY (`Name`)
) ENGINE=@ZM_MYSQL_ENGINE@;
INSERT INTO States (Name,Definition,IsActive) VALUES ('default','','1');


--
-- Table structure for table `Servers`
--

DROP TABLE IF EXISTS `Servers`;
CREATE TABLE `Servers` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Protocol`  TEXT,
  `Hostname` TEXT,
  `Port`      INTEGER UNSIGNED,
  `PathToIndex`  TEXT,
  `PathToZMS`  TEXT,
  `PathToApi`  TEXT,
  `Name` varchar(64) NOT NULL default '',
  `State_Id`	int(10) unsigned,
  `Status` enum('Unknown','NotRunning','Running') NOT NULL default 'Unknown',
  `CpuLoad` DECIMAL(5,1) default NULL,
  `TotalMem` bigint unsigned default null,
  `FreeMem` bigint unsigned default null,
  `TotalSwap` bigint  unsigned default null,
  `FreeSwap` bigint unsigned default null, 
  `zmstats`  BOOLEAN NOT NULL DEFAULT FALSE,
  `zmaudit`  BOOLEAN NOT NULL DEFAULT FALSE,
  `zmtrigger`  BOOLEAN NOT NULL DEFAULT FALSE,
  `zmeventnotification`  BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

CREATE INDEX `Servers_Name_idx` ON `Servers` (`Name`);

--
-- Table structure for table `Stats`
--

DROP TABLE IF EXISTS `Stats`;
CREATE TABLE `Stats` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MonitorId` int(10) unsigned NOT NULL default '0',
  FOREIGN KEY (`MonitorId`) REFERENCES `Monitors` (`Id`) ON DELETE CASCADE,
  `ZoneId` int(10) unsigned NOT NULL default '0',
  FOREIGN KEY (`ZoneId`) REFERENCES `Zones` (`Id`) ON DELETE CASCADE,
  `EventId` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`EventId`) REFERENCES `Events` (`Id`) ON DELETE CASCADE,
  `FrameId` int(10) unsigned NOT NULL default '0',
  `PixelDiff` tinyint(3) unsigned NOT NULL default '0',
  `AlarmPixels` int(10) unsigned NOT NULL default '0',
  `FilterPixels` int(10) unsigned NOT NULL default '0',
  `BlobPixels` int(10) unsigned NOT NULL default '0',
  `Blobs` smallint(5) unsigned NOT NULL default '0',
  `MinBlobSize` int(10) unsigned NOT NULL default '0',
  `MaxBlobSize` int(10) unsigned NOT NULL default '0',
  `MinX` smallint(5) unsigned NOT NULL default '0',
  `MaxX` smallint(5) unsigned NOT NULL default '0',
  `MinY` smallint(5) unsigned NOT NULL default '0',
  `MaxY` smallint(5) unsigned NOT NULL default '0',
  `Score` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY (`Id`),
  KEY `EventId` (`EventId`),
  KEY `MonitorId` (`MonitorId`),
  KEY `ZoneId` (`ZoneId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `TriggersX10`
--

DROP TABLE IF EXISTS `TriggersX10`;
CREATE TABLE `TriggersX10` (
  `MonitorId` int(10) unsigned NOT NULL default '0',
  `Activation` varchar(32) default NULL,
  `AlarmInput` varchar(32) default NULL,
  `AlarmOutput` varchar(32) default NULL,
  PRIMARY KEY (`MonitorId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Username` varchar(32) character set latin1 collate latin1_bin NOT NULL default '',
  `Password` varchar(64) NOT NULL default '',
  `Language` varchar(8),
  `Enabled` tinyint(3) unsigned NOT NULL default '1',
  `Stream` enum('None','View') NOT NULL default 'None',
  `Events` enum('None','View','Edit') NOT NULL default 'None',
  `Control` enum('None','View','Edit') NOT NULL default 'None',
  `Monitors` enum('None','View','Edit') NOT NULL default 'None',
  `Groups` enum('None','View','Edit') NOT NULL default 'None',
  `Devices` enum('None','View','Edit') NOT NULL default 'None',
  `Snapshots` enum('None','View','Edit') NOT NULL default 'None',
  `System` enum('None','View','Edit') NOT NULL default 'None',
  `MaxBandwidth` varchar(16),
  `MonitorIds` text,
  `TokenMinExpiry`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `APIEnabled`  tinyint(3) UNSIGNED NOT NULL default 1,
  `HomeView`  varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `UC_Username` (`Username`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `ZonePresets`
--

DROP TABLE IF EXISTS `ZonePresets`;
CREATE TABLE `ZonePresets` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name` varchar(64) NOT NULL default '',
  `Type` enum('Active','Inclusive','Exclusive','Preclusive','Inactive','Privacy') NOT NULL default 'Active',
  `Units` enum('Pixels','Percent') NOT NULL default 'Pixels',
  `CheckMethod` enum('AlarmedPixels','FilteredPixels','Blobs') NOT NULL default 'Blobs',
  `MinPixelThreshold` smallint(5) unsigned default NULL,
  `MaxPixelThreshold` smallint(5) unsigned default NULL,
  `MinAlarmPixels` int(10) unsigned default NULL,
  `MaxAlarmPixels` int(10) unsigned default NULL,
  `FilterX` tinyint(3) unsigned default NULL,
  `FilterY` tinyint(3) unsigned default NULL,
  `MinFilterPixels` int(10) unsigned default NULL,
  `MaxFilterPixels` int(10) unsigned default NULL,
  `MinBlobPixels` int(10) unsigned default NULL,
  `MaxBlobPixels` int(10) unsigned default NULL,
  `MinBlobs` smallint(5) unsigned default NULL,
  `MaxBlobs` smallint(5) unsigned default NULL,
  `OverloadFrames` smallint(5) unsigned NOT NULL default '0',
  `ExtendAlarmFrames` smallint(5) unsigned not null default 0,
  PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Table structure for table `Zones`
--

DROP TABLE IF EXISTS `Zones`;
CREATE TABLE `Zones` (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `MonitorId` int(10) unsigned NOT NULL default '0',
  FOREIGN KEY (`MonitorId`) REFERENCES `Monitors` (`Id`) ON DELETE CASCADE,
  `Name` varchar(64) NOT NULL default '',
  `Type` enum('Active','Inclusive','Exclusive','Preclusive','Inactive','Privacy') NOT NULL default 'Active',
  `Units` enum('Pixels','Percent') NOT NULL default 'Pixels',
  `NumCoords` tinyint(3) unsigned NOT NULL default '0',
  `Coords` tinytext NOT NULL,
  `Area` int(10) unsigned NOT NULL default '0',
  `AlarmRGB` int(10) unsigned default '0',
  `CheckMethod` enum('AlarmedPixels','FilteredPixels','Blobs') NOT NULL default 'Blobs',
  `MinPixelThreshold` smallint(5) unsigned default NULL,
  `MaxPixelThreshold` smallint(5) unsigned default NULL,
  `MinAlarmPixels` int(10) unsigned default NULL,
  `MaxAlarmPixels` int(10) unsigned default NULL,
  `FilterX` tinyint(3) unsigned default NULL,
  `FilterY` tinyint(3) unsigned default NULL,
  `MinFilterPixels` int(10) unsigned default NULL,
  `MaxFilterPixels` int(10) unsigned default NULL,
  `MinBlobPixels` int(10) unsigned default NULL,
  `MaxBlobPixels` int(10) unsigned default NULL,
  `MinBlobs` smallint(5) unsigned default NULL,
  `MaxBlobs` smallint(5) unsigned default NULL,
  `OverloadFrames` smallint(5) unsigned NOT NULL default '0',
  `ExtendAlarmFrames` smallint(5) unsigned not null default 0,
  PRIMARY KEY (`Id`),
  KEY `MonitorId` (`MonitorId`)
) ENGINE=@ZM_MYSQL_ENGINE@;

DROP TABLE IF EXISTS `Storage`;
CREATE TABLE `Storage` (
	`Id`	smallint(5) unsigned NOT NULL auto_increment,
	`Path`	varchar(64)	NOT NULL default '',
	`Name`	varchar(64) NOT NULL default '',
	`Type`	enum('local','s3fs') NOT NULL default 'local',
  `Url` varchar(255) default NULL,
  `DiskSpace`   bigint default NULL,
  `Scheme`   enum('Deep','Medium','Shallow') NOT NULL default 'Medium',
  `ServerId` int(10) unsigned,
  `DoDelete`  BOOLEAN NOT NULL DEFAULT true,
  `Enabled`  BOOLEAN NOT NULL DEFAULT true,
	PRIMARY KEY (`Id`)
) ENGINE=@ZM_MYSQL_ENGINE@;

--
-- Create a default storage location
--
insert into Storage VALUES (NULL, '@ZM_DIR_EVENTS@', 'Default', 'local', NULL, NULL, 'Medium', 0, true, true );

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

--
-- Initial data to be loaded into ZoneMinder database
--

--
-- Create a default admin user.
--
INSERT INTO `Users` (
  `Username`,
  `Password`,
  `Language`,
  `Enabled`,
  `Stream`,
  `Events`,
  `Control`,
  `Monitors`,
  `Groups`,
  `Devices`,
  `Snapshots`,
  `System`,
  `MaxBandwidth`,
  `MonitorIds`,
  `TokenMinExpiry`,
  `APIEnabled`,
  `HomeView`
  ) VALUES (
    'admin',
    '$2b$12$NHZsm6AM2f2LQVROriz79ul3D6DnmFiZC.ZK5eqbF.ZWfwH9bqUJ6',
    '' /* Language */,
    1 /* Enabled */,
    'View' /* Stream */,
    'Edit' /* Events */,
    'Edit' /* Control */,
    'Edit' /* Monitors */,
    'Edit' /* Groups */,
    'Edit' /* Devices */,
    'Edit' /* Snapshots */,
    'Edit' /* System */,
    '' /* Max Bandwidth */,
    '' /* MonitorIds */,
    0 /* TokenMinExpiry */,
    0 /* Api Endabled */,
    '' /* Homeview */);

--
-- Add a sample filter to purge the oldest 100 events when the disk is 95% full
--

INSERT INTO `Filters`
  (
    `Name`,
    `Query_json`,
    `AutoArchive`,
    `AutoVideo`,
    `AutoUpload`,
    `AutoEmail`,
    `EmailTo`,
    `EmailSubject`,
    `EmailBody`,
    `AutoMessage`,
    `AutoExecute`,
    `AutoExecuteCmd`,
    `AutoDelete`,
    `AutoMove`,
    `AutoMoveTo`,
    `AutoCopy`,
    `AutoCopyTo`,
    `UpdateDiskSpace`,
    `UserId`,
    `Background`,
    `Concurrent`
  )
  VALUES
  (
    'PurgeWhenFull',
    '{"sort_field":"Id","terms":[{"val":0,"attr":"Archived","op":"="},{"cnj":"and","val":95,"attr":"DiskPercent","op":">="},{"cnj":"and","obr":"0","attr":"EndDateTime","op":"IS NOT","val":"NULL","cbr":"0"}],"limit":100,"sort_asc":1}',
    0/*AutoArchive*/,
    0/*AutoVideo*/,
    0/*AutoUpload*/,
    0/*AutoEmail*/,
    ''/*EmailTo*/,
    ''/*EmailSubject*/,
    ''/*EmailBody*/,
    0/*AutoMessage*/,
    0/*AutoExecute*/,'',
    1/*AutoDelete*/,
    0/*AutoMove*/,0/*MoveTo*/,
    0/*AutoCopy*/,0/*CopyTo*/,
    0/*UpdateDiskSpace*/,
    1/*UserId = admin*/,
    1/*Background*/,
    0/*Concurrent*/
  );
INSERT INTO `Filters`
  (
    `Name`,
    `Query_json`,
    `AutoArchive`,
    `AutoVideo`,
    `AutoUpload`,
    `AutoEmail`,
    `EmailTo`,
    `EmailSubject`,
    `EmailBody`,
    `AutoMessage`,
    `AutoExecute`,
    `AutoExecuteCmd`,
    `AutoDelete`,
    `AutoMove`,
    `AutoMoveTo`,
    `AutoCopy`,
    `AutoCopyTo`,
    `UpdateDiskSpace`,
    `UserId`,
    `Background`,
    `Concurrent`
  )
VALUES (
  'Update DiskSpace',
  '{"terms":[{"attr":"DiskSpace","op":"IS","val":"NULL"},{"cnj":"and","obr":"0","attr":"EndDateTime","op":"IS NOT","val":"NULL","cbr":"0"}]}',
  0/*AutoArchive*/,
  0/*AutoVideo*/,
  0/*AutoUpload*/,
  0/*AutoEmail*/,
  ''/*EmailTo*/,
  ''/*EmailSubject*/,
  ''/*EmailBody*/,
  0/*AutoMessage*/,
  0/*AutoExecute*/,'',
  0/*AutoDelete*/,
  0/*AutoMove*/,0/*MoveTo*/,
  0/*AutoCopy*/,0/*CopyTo*/,
  1/*UpdateDiskSpace*/,
  1/*UserId=admin*/,
  1/*Background*/,
  0/*Concurrent*/
);

--
-- Add in some sample control protocol definitions
--
INSERT INTO `Controls` VALUES (NULL,'Pelco-D','Local','PelcoD',1,1,0,0,1,1,0,0,1,NULL,NULL,NULL,NULL,1,0,3,1,1,0,0,1,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,20,1,1,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,1,0,63,1,254,1,NULL,NULL,NULL,NULL,1,0,63,1,254,0,0);
INSERT INTO `Controls` VALUES (NULL,'Pelco-P','Local','PelcoP',1,1,0,0,1,1,0,0,1,NULL,NULL,NULL,NULL,1,0,3,1,1,0,0,1,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,20,1,1,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,1,0,63,1,254,1,NULL,NULL,NULL,NULL,1,0,63,1,254,0,0);
INSERT INTO `Controls` VALUES (NULL,'Sony VISCA','Local','Visca',1,1,0,0,1,0,0,0,1,0,16384,10,4000,1,1,6,1,1,1,0,1,0,1536,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,3,1,1,1,1,0,1,1,0,1,-15578,15578,100,10000,1,1,50,1,254,1,-7789,7789,100,5000,1,1,50,1,254,0,0);
INSERT INTO `Controls` VALUES (NULL,'Axis API v2','Remote','AxisV2',0,0,0,0,1,0,0,1,0,0,9999,10,2500,0,NULL,NULL,1,1,0,1,0,0,9999,10,2500,0,NULL,NULL,1,1,0,1,0,0,9999,10,2500,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,12,1,1,1,1,1,0,1,0,1,-360,360,1,90,0,NULL,NULL,0,NULL,1,-360,360,1,90,0,NULL,NULL,0,NULL,0,0);
INSERT INTO `Controls` VALUES (NULL,'Panasonic IP','Remote','PanasonicIP',0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,8,1,1,1,0,1,0,0,1,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,0,0);
INSERT INTO `Controls` VALUES (NULL,'Neu-Fusion NCS370','Remote','Ncs370',0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,24,1,0,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,0,0);
INSERT INTO `Controls` VALUES (NULL,'AirLink SkyIPCam 7xx','Remote','SkyIPCam7xx',0,0,1,0,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,8,1,1,1,0,1,0,1,0,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,1,NULL,NULL,NULL,NULL,0,NULL,NULL,0,NULL,0,0);
INSERT INTO `Controls` VALUES (NULL,'Pelco-D','Ffmpeg','PelcoD',1,1,0,0,1,1,0,0,1,NULL,NULL,NULL,NULL,1,0,3,1,1,0,0,1,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,20,1,1,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,1,0,63,1,254,1,NULL,NULL,NULL,NULL,1,0,63,1,254,0,0);
INSERT INTO `Controls` VALUES (NULL,'Pelco-P','Ffmpeg','PelcoP',1,1,0,0,1,1,0,0,1,NULL,NULL,NULL,NULL,1,0,3,1,1,0,0,1,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,1,0,1,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,20,1,1,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,1,0,63,1,254,1,NULL,NULL,NULL,NULL,1,0,63,1,254,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam FI8620','Ffmpeg','FI8620_Y2k',0,0,0,0,1,0,0,0,1,1,10,1,10,1,1,63,1,1,0,0,1,1,63,1,63,1,1,63,1,1,0,0,1,0,0,0,0,1,0,255,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,255,1,8,0,1,1,1,0,0,0,1,1,1,360,1,360,1,1,63,0,0,1,1,90,1,90,1,1,63,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam FI8608W','Ffmpeg','FI8608W_Y2k',1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,255,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,255,1,8,0,1,1,1,0,0,0,1,1,0,0,0,0,1,1,128,0,0,1,0,0,0,0,1,1,128,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam FI8908W','Remote','FI8908W',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam FI9821W','Ffmpeg','FI9821W_Y2k',1,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,1,0,100,1,1,0,0,1,0,100,0,100,1,0,100,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,0,100,0,100,1,0,100,1,16,0,1,1,1,0,0,0,1,1,0,360,0,360,1,0,4,0,0,1,0,90,0,90,1,0,4,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Loftek Sentinel','Remote','LoftekSentinel',0,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,255,16,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,6,1,1,0,0,0,1,10,0,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Toshiba IK-WB11A','Remote','Toshiba_IK_WB11A',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,10,0,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'WanscamPT','Remote','Wanscam',1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,16,0,0,0,0,0,1,16,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'3S Domo N5071', 'Remote', '3S', 0, 0, 1, 0,1, 0, 1, 1, 0, 0, 9999, 0, 9999, 0, 0, 0, 1, 1, 1, 1, 0, 0, 9999, 20, 9999, 0, 0, 0, 1, 1, 1, 1, 0, 0, 9999, 1, 9999, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 64, 1, 0, 1, 1, 0, 0, 0, 0, 1, -180, 180, 40, 100, 1, 40, 100, 0, 0, 1, -180, 180, 40, 100, 1, 40, 100, 0, 0, 0, 0);
INSERT INTO `Controls` VALUES (NULL,'ONVIF Camera','Ffmpeg','onvif',0,0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,255,16,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,6,1,1,0,0,0,1,10,1,1,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam 9831W','Ffmpeg','FI9831W',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,16,1,1,1,1,0,0,0,1,1,0,360,0,360,1,0,4,0,0,1,0,90,0,90,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Foscam FI8918W','Ffmpeg','FI8918W',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,8,0,1,1,1,0,0,0,1,1,0,360,0,360,1,0,4,0,0,1,0,90,0,90,1,0,4,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'SunEyes SP-P1802SWPTZ','Libvlc','SPP1802SWPTZ',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,8,0,1,1,0,0,0,0,1,1,0,0,0,0,1,0,64,0,0,1,0,0,0,0,1,0,64,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Wanscam HW0025','Libvlc','WanscamHW0025', 1, 1, 1, 0,1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 16, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 350, 0, 0, 1, 0, 10, 0, 0, 1, 0, 0, 0, 0, 1, 0, 10, 0, 0, 0, 0);
INSERT INTO `Controls` VALUES (NULL,'IPCC 7210W','Remote','IPCC7210W', 1, 1, 1, 0,1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 16, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `Controls` VALUES (NULL,'Vivotek ePTZ','Remote','Vivotek_ePTZ',0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,1,0,5,0,0,1,0,0,0,0,1,0,5,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Netcat ONVIF','Ffmpeg','Netcat',0,0,1,0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,100,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,100,5,5,0,0,0,1,255,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Keekoon','Remote','Keekoon', 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `Controls` VALUES (NULL,'HikVision','Local','',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,20,1,1,1,1,0,0,0,1,1,0,0,0,0,1,1,100,0,0,1,0,0,0,0,1,1,100,1,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Maginon Supra IPC','cURL','MaginonIPC',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Floureon 1080P','Ffmpeg','Floureon',0,0,0,0,1,0,0,0,1,1,18,1,1,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,20,0,1,1,1,0,0,0,1,1,0,0,0,0,1,1,8,0,0,1,0,0,0,0,1,1,8,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Reolink RLC-423','Ffmpeg','Reolink',0,0,1,0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,64,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Reolink RLC-411','Ffmpeg','Reolink',0,0,1,0,1,0,0,0,1,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Reolink RLC-420','Ffmpeg','Reolink',0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'D-LINK DCS-3415','Remote','DCS3415',0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'D-Link DCS-5020L','Remote','DCS5020L',1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,24,1,0,1,1,1,0,1,0,1,0,0,1,30,0,0,0,0,0,1,0,0,1,30,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'IOS Camera','Ffmpeg','IPCAMIOS',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Dericam P2','Ffmpeg','DericamP2',0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,10,0,1,1,1,0,0,0,1,1,0,0,0,0,1,1,45,0,0,1,0,0,0,0,1,1,45,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Trendnet','Remote','Trendnet',1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'PSIA','Remote','PSIA',0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,20,0,1,1,1,0,0,1,0,1,0,0,0,0,1,-100,100,0,0,1,0,0,0,0,1,-100,100,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'Dahua','Ffmpeg','Dahua',0,0,1,1,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,20,1,1,1,1,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `Controls` VALUES (NULL,'FOSCAMR2C','Libvlc','FOSCAMR2C',1,1,1,0,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,1,12,0,1,1,1,0,0,0,1,1,NULL,NULL,NULL,NULL,1,0,4,0,NULL,1,NULL,NULL,NULL,NULL,1,0,4,0,NULL,0,0);
INSERT INTO `Controls` VALUES (NULL,'Amcrest HTTP API','Ffmpeg','Amcrest_HTTP',0,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,5,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,5);

--
-- Add some monitor preset values
--

INSERT into MonitorPresets VALUES (NULL,NULL,'Amcrest, IP8M-T2499EW 640x480, RTP/RTSP','Ffmpeg','rtsp',0,255,'rtsp','rtpRtsp','NULL',554,'rtsp://<username>:<password>@<ip-address>/cam/realmonitor?channel=1&subtype=1',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'Amcrest, IP8M-T2499EW 3840x2160, RTP/RTSP','Ffmpeg','rtsp',0,255,'rtsp','rtpRtsp','NULL',554,'rtsp://<username>:<password>@<ip-address>/cam/realmonitor?channel=1&subtype=0',NULL,3840,2160,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 320x240, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=320x240',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 320x240, mpjpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=320x240&req_fps=5',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 320x240, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=320x240',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 320x240, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=320x240',NULL,320,240,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 640x480, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=640x480',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 640x480, mpjpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=640x480&req_fps=5',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 640x480, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=640x480',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 640x480, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=640x480',NULL,640,480,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 320x240, mpjpeg, B&W','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=320x240&color=0',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP, 640x480, mpjpeg, B&W','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=640x480&color=0',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 320x240, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=320x240',NULL,320,240,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 320x240, mpjpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=320x240&req_fps=5',NULL,320,240,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 320x240, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=320x240',NULL,320,240,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 320x240, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=320x240',NULL,320,240,3,5.0,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 640x480, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=640x480',NULL,640,480,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 640x480, mpjpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/mjpg/video.cgi?resolution=640x480&req_fps=5',NULL,640,480,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 640x480, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=640x480',NULL,640,480,3,NULL,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis IP PTZ, 640x480, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/axis-cgi/jpg/image.cgi?resolution=640x480',NULL,640,480,3,5.0,1,4,NULL,'<ip-address>:<port>',100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'Axis IP, mpeg4, unicast','Remote','rtsp',0,255,'rtsp','rtpUni','<ip-address>',554,'/mpeg4/media.amp','/trackID=',NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'Axis IP, mpeg4, multicast','Remote','rtsp',0,255,'rtsp','rtpMulti','<ip-address>',554,'/mpeg4/media.amp','/trackID=',NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'Axis IP, mpeg4, RTP/RTSP','Remote','rtsp',0,255,'rtsp','rtpRtsp','<ip-address>',554,'/mpeg4/media.amp','/trackID=',NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'Axis IP, mpeg4, RTP/RTSP/HTTP','Remote',NULL,NULL,NULL,'rtsp','rtpRtspHttp','<ip-address>',554,'/mpeg4/media.amp','/trackID=',NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'D-link DCS-930L, 640x480, mjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/mjpeg.cgi',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'D-Link DCS-5020L, 640x480, mjpeg','Remote','http',0,0,'http','simple','<username>:<pwd>@<ip-address>','80','/video.cgi',NULL,640,480,0,NULL,1,'34',NULL,'<username>:<pwd>@<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 320x240, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/nphMotionJpeg?Resolution=320x240&Quality=Standard',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 320x240, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=320x240&Quality=Standard',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 320x240, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=320x240&Quality=Standard',NULL,320,240,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 640x480, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/nphMotionJpeg?Resolution=640x480&Quality=Standard',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 640x480, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=640x480&Quality=Standard',NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP, 640x480, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=640x480&Quality=Standard',NULL,640,480,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 320x240, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/nphMotionJpeg?Resolution=320x240&Quality=Standard',NULL,320,240,3,NULL,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 320x240, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=320x240&Quality=Standard',NULL,320,240,3,NULL,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 320x240, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=320x240&Quality=Standard',NULL,320,240,3,5.0,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 640x480, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/nphMotionJpeg?Resolution=640x480&Quality=Standard',NULL,640,480,3,NULL,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 640x480, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=640x480&Quality=Standard',NULL,640,480,3,NULL,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Panasonic IP PTZ, 640x480, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/SnapshotJPEG?Resolution=640x480&Quality=Standard',NULL,640,480,3,5.0,1,5,NULL,'<ip-address>:<port>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Gadspot IP, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/Jpeg/CamImg.jpg',NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Gadspot IP, jpeg, max 5 FPS','Remote','http',0,0,'http','simple','<ip-address>',80,'/Jpeg/CamImg.jpg',NULL,NULL,NULL,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Gadspot IP, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/GetData.cgi',NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Gadspot IP, mpjpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/Jpeg/CamImg.jpg',NULL,NULL,NULL,3,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'IP Webcam by Pavel Khlebovich 1920x1080','Remote','/dev/video<?>','0',255,'http','simple','<ip-address>','8080','/video','',1920,1080,0,NULL,0,'0','','',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'VEO Observer, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/Jpeg/CamImg.jpg',NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Blue Net Video Server, jpeg','Remote','http',0,0,'http','simple','<ip-address>',80,'/cgi-bin/image.cgi?control=0&id=admin&passwd=admin',NULL,320,240,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT into MonitorPresets VALUES (NULL,NULL,'ACTi IP, mpeg4, unicast','Remote',NULL,NULL,NULL,'rtsp','rtpUni','<ip-address>',7070,'','/track',NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis FFMPEG H.264','Ffmpeg',NULL,NULL,NULL,NULL,NULL,'rtsp://<host/address>/axis-media/media.amp?videocodec=h264',NULL,NULL,NULL,640,480,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Vivotek FFMPEG','Ffmpeg',NULL,NULL,NULL,NULL,NULL,'rtsp://<host/address>:554/live.sdp',NULL,NULL,NULL,352,240,NULL,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Axis FFMPEG','Ffmpeg',NULL,NULL,NULL,NULL,NULL,'rtsp://<host/address>/axis-media/media.amp',NULL,NULL,NULL,640,480,NULL,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'ACTi TCM FFMPEG','Ffmpeg',NULL,NULL,NULL,NULL,NULL,'rtsp://admin:123456@<host/address>:7070',NULL,NULL,NULL,320,240,NULL,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), PAL, 320x240','Local','/dev/video<?>',0,255,NULL,'v4l2',NULL,NULL,NULL,NULL,320,240,1345466932,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), PAL, 320x240, max 5 FPS','Local','/dev/video<?>',0,255,NULL,'v4l2',NULL,NULL,NULL,NULL,320,240,1345466932,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), PAL, 640x480','Local','/dev/video<?>',0,255,NULL,'v4l2',NULL,NULL,NULL,NULL,640,480,1345466932,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), PAL, 640x480, max 5 FPS','Local','/dev/video<?>',0,255,NULL,'v4l2',NULL,NULL,NULL,NULL,640,480,1345466932,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), NTSC, 320x240','Local','/dev/video<?>',0,45056,NULL,'v4l2',NULL,NULL,NULL,NULL,320,240,1345466932,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), NTSC, 320x240, max 5 FPS','Local','/dev/video<?>',0,45056,NULL,'v4l2',NULL,NULL,NULL,NULL,320,240,1345466932,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), NTSC, 640x480','Local','/dev/video<?>',0,45056,NULL,'v4l2',NULL,NULL,NULL,NULL,640,480,1345466932,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L2), NTSC, 640x480, max 5 FPS','Local','/dev/video<?>',0,45056,NULL,'v4l2',NULL,NULL,NULL,NULL,640,480,1345466932,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), PAL, 320x240','Local','/dev/video<?>',0,0,NULL,'v4l1',NULL,NULL,NULL,NULL,320,240,13,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), PAL, 320x240, max 5 FPS','Local','/dev/video<?>',0,0,NULL,'v4l1',NULL,NULL,NULL,NULL,320,240,13,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), PAL, 640x480','Local','/dev/video<?>',0,0,NULL,'v4l1',NULL,NULL,NULL,NULL,640,480,13,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), PAL, 640x480, max 5 FPS','Local','/dev/video<?>',0,0,NULL,'v4l1',NULL,NULL,NULL,NULL,640,480,13,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), NTSC, 320x240','Local','/dev/video<?>',0,1,NULL,'v4l1',NULL,NULL,NULL,NULL,320,240,13,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), NTSC, 320x240, max 5 FPS','Local','/dev/video<?>',0,1,NULL,'v4l1',NULL,NULL,NULL,NULL,320,240,13,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), NTSC, 640x480','Local','/dev/video<?>',0,1,NULL,'v4l1',NULL,NULL,NULL,NULL,640,480,13,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'BTTV Video (V4L1), NTSC, 640x480, max 5 FPS','Local','/dev/video<?>',0,1,NULL,'v4l1',NULL,NULL,NULL,NULL,640,480,13,5.0,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Remote ZoneMinder','Remote',NULL,NULL,NULL,'http','simple','<ip-address>',80,'/cgi-bin/nph-zms?mode=jpeg&monitor=<monitor-id>&scale=100&maxfps=5&buffer=0',NULL,NULL,NULL,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Foscam FI8620 FFMPEG H.264','Ffmpeg',NULL,NULL,NULL,NULL,'','','','rtsp://<username>:<pwd>@<ip-address>:554/11',NULL,704,576,0,NULL,1,'10','<admin_pwd>','<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Foscam FI8608W FFMPEG H.264','Ffmpeg',NULL,NULL,NULL,NULL,'','','','rtsp://<username>:<pwd>@<ip-address>:554/11',NULL,640,480,0,NULL,1,'11','<admin_pwd>','<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Foscam FI9821W FFMPEG H.264','Ffmpeg',NULL,NULL,NULL,NULL,'','','','rtsp://<username>:<pwd>@<ip-address>:88/videoMain',NULL,1280,720,0,NULL,1,'12','<admin_pwd>','<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Loftek Sentinel PTZ, 640x480, mjpeg','Remote','http',0,0,NULL,NULL,'<ip-address>','80','/videostream.cgi?user=<username>&pwd=<password>&resolution=32&rate=11',NULL,640,480,4,NULL,1,'13','','<username>:<pwd>@<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Airlink 777W PTZ, 640x480, mjpeg','Remote','http',0,0,NULL,NULL,'<username>:<password>@<ip-address>','80','/cgi/mjpg/mjpg.cgi',NULL,640,480,4,NULL,1,'7','','<username>:<pwd>@<ip-address>',100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'SunEyes SP-P1802SWPTZ','Libvlc','/dev/video<?>','0',255,'','rtpMulti','','80','rtsp://<ip-address>:554/11','',1920,1080,0,0.00,1,'16','-speed=64','<ip-address>:<port>',100,33);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Qihan IP, 1280x720, RTP/RTSP','Ffmpeg','rtsp',0,255,'rtsp','rtpRtsp',NULL,554,'rtsp://<ip-address>/tcp_live/ch0_0',NULL,1280,720,3,NULL,0,NULL,NULL,NULL,100,100);
INSERT INTO MonitorPresets VALUES (NULL,NULL,'Qihan IP, 1920x1080, RTP/RTSP','Ffmpeg','rtsp',0,255,'rtsp','rtpRtsp',NULL,554,'rtsp://<ip-address>/tcp_live/ch0_0',NULL,1920,1080,3,NULL,0,NULL,NULL,NULL,100,100);

--
-- Add some zone preset values
--
INSERT INTO ZonePresets VALUES (1,'Default','Active','Percent','Blobs',25,NULL,3,75,3,3,3,75,2,NULL,1,NULL,0,0);
INSERT INTO ZonePresets VALUES (2,'Fast, low sensitivity','Active','Percent','AlarmedPixels',60,NULL,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0);
INSERT INTO ZonePresets VALUES (3,'Fast, medium sensitivity','Active','Percent','AlarmedPixels',40,NULL,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0);
INSERT INTO ZonePresets VALUES (4,'Fast, high sensitivity','Active','Percent','AlarmedPixels',20,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0);
INSERT INTO ZonePresets VALUES (5,'Best, low sensitivity','Active','Percent','Blobs',60,NULL,36,NULL,7,7,24,NULL,20,NULL,1,NULL,0,0);
INSERT INTO ZonePresets VALUES (6,'Best, medium sensitivity','Active','Percent','Blobs',40,NULL,16,NULL,5,5,12,NULL,10,NULL,1,NULL,0,0);
INSERT INTO ZonePresets VALUES (7,'Best, high sensitivity','Active','Percent','Blobs',20,NULL,8,NULL,3,3,6,NULL,5,NULL,1,NULL,0,0);

DROP TABLE IF EXISTS Maps;

CREATE TABLE Maps (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name`      VARCHAR(64) NOT NULL,
  `Filename`  VARCHAR(64) NOT NULL default '',
  `NumCoords` tinyint(3) unsigned NOT NULL default '0',
  `Coords` tinytext NOT NULL,
  `ParentId`   int(1) unsigned,
  PRIMARY KEY (`Id`)
);

DROP TABLE IF EXISTS MontageLayouts;

CREATE TABLE MontageLayouts (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name`    TEXT  NOT NULL,
  `Positions` LONGTEXT,
  /*`Positions` JSON,*/
  PRIMARY KEY (`Id`)
);

INSERT INTO MontageLayouts (`Name`,`Positions`) VALUES ('Freeform', '{ "default":{"float":"left","left":"0px","right":"0px","top":"0px","bottom":"0px","width":"auto"} }' );
INSERT INTO MontageLayouts (`Name`,`Positions`) VALUES ('2 Wide', '{ "default":{"float":"left", "width":"50%","left":"0px","right":"0px","top":"0px","bottom":"0px"} }' );
INSERT INTO MontageLayouts (`Name`,`Positions`) VALUES ('3 Wide', '{ "default":{"float":"left", "width":"33%","left":"0px","right":"0px","top":"0px","bottom":"0px"} }' );
INSERT INTO MontageLayouts (`Name`,`Positions`) VALUES ('4 Wide', '{ "default":{"float":"left", "width":"25%","left":"0px","right":"0px","top":"0px","bottom":"0px"} }' );
INSERT INTO MontageLayouts (`Name`,`Positions`) VALUES ('5 Wide', '{ "default":{"float":"left", "width":"20%","left":"0px","right":"0px","top":"0px","bottom":"0px"} }' );

CREATE TABLE Sessions (
  id char(32) not null,
  access INT(10) UNSIGNED DEFAULT NULL,
  data text,
  PRIMARY KEY(id)
) ENGINE=InnoDB;

CREATE TABLE Snapshots (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `Name`  VARCHAR(64),
  `Description` TEXT,
  `CreatedBy`   int(10),
  `CreatedOn`   datetime default NULL,
  PRIMARY KEY(Id)
) ENGINE=InnoDB;

CREATE TABLE Snapshot_Events (
  `Id` int(10) unsigned NOT NULL auto_increment,
  `SnapshotId` int(10) unsigned NOT NULL,
  FOREIGN KEY (`SnapshotId`) REFERENCES `Snapshots` (`Id`) ON DELETE CASCADE,
  `EventId`    bigint unsigned NOT NULL,
  FOREIGN KEY (`EventId`) REFERENCES `Events` (`Id`) ON DELETE CASCADE,
  KEY `Snapshot_Events_SnapshotId_idx` (`SnapshotId`),
  PRIMARY KEY(Id)
) ENGINE=InnoDB;


-- We generally don't alter triggers, we drop and re-create them, so let's keep them in a separate file that we can just source in update scripts.
source @PKGDATADIR@/db/triggers.sql

source @PKGDATADIR@/db/manufacturers.sql
source @PKGDATADIR@/db/models.sql
--
-- Apply the initial configuration
--
-- This section is autogenerated by zmconfgen.pl
-- Do not edit this file as any changes will be overwritten
--