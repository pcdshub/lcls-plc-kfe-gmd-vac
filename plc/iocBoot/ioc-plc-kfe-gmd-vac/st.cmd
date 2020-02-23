#!../../bin/rhel7-x86_64/adsIoc

< envPaths
epicsEnvSet("IOCNAME", "plc-kfe-gmd-vac" )
epicsEnvSet("ENGINEER", "nolan" )
epicsEnvSet("LOCATION", "PLC-KFE-GMD-VAC" )
epicsEnvSet("IOCSH_PS1", "$(IOCNAME)> " )

cd "$(TOP)"

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/adsIoc.dbd")
adsIoc_registerRecordDeviceDriver(pdbbase)

cd "$(TOP)/db"

epicsEnvSet("ASYN_PORT",     "ASYN_PLC")
epicsEnvSet("IPADDR",        "172.21.92.59")
epicsEnvSet("AMSID",         "172.21.92.59.1.1")
epicsEnvSet("IPPORT",        "851")

adsAsynPortDriverConfigure("$(ASYN_PORT)","$(IPADDR)","$(AMSID)","$(IPPORT)", 1000, 0, 0, 50, 100, 1000, 0)

dbLoadRecords("plc-kfe-gmd-vac.db", "")

cd "$(TOP)"

dbLoadRecords("db/iocAdmin.db", "P=PLC-KFE-GMD-VAC,IOC=PLC-KFE-GMD-VAC" )
dbLoadRecords("db/save_restoreStatus.db", "P=PLC-KFE-GMD-VAC,IOC=plc-kfe-gmd-vac" )

# Setup autosave
set_savefile_path( "$(IOC_DATA)/$(IOC)/autosave" )
set_requestfile_path( "$(TOP)/autosave" )
save_restoreSet_status_prefix( "PLC-KFE-GMD-VAC:" )
save_restoreSet_IncompleteSetsOk( 1 )
save_restoreSet_DatedBackupFiles( 1 )
set_pass0_restoreFile( "$(IOC).sav" )
set_pass1_restoreFile( "$(IOC).sav" )

# Initialize the IOC and start processing records
iocInit()

# Start autosave backups
create_monitor_set( "$(IOC).req", 5, "" )

# All IOCs should dump some common info after initial startup.
< /reg/d/iocCommon/All/post_linux.cmd
