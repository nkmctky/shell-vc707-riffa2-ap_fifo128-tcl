#!/bin/bash

PROGNAME=$(basename $0)
VERSION="0.1.1"

usage() {
  echo "usage: ./make" 1>&2
  echo "Options:" 1>&2
  echo "    -removeip    : Remove current ip in shell project." 1>&2
  echo "    -addip       : Add ip files in ip-src to shell project." 1>&2
  echo "    no argument  : Open shell project." 1>&2
  exit 1
}

for i in "$@"
do
case $i in
	    '-h'|'--help' )
            usage
            exit 1
        ;;
        '--version' )
            echo $VERSION
            exit 1
            ;;
        -removeip)
        	REMOVEIP=1
        	shift 1
        	;;
        -addip)
        	ADDIP=1
        	shift 1
        	;;        
        -*)
		shift 1
        ;;
        *)
        ;;
esac
done

if [ $REMOVEIP ]; then
	echo "Removing current ip in shell."
	ip_files=()
	cd ip-src
	for entry in "."/*
	do
	   ip_files+=( $(echo "$entry" | awk '{print substr($0, 3)}') )
	done
	cd ..
	cd xilinx/vc707/VC707_Gen2x8If128/prj
	i=0
	for e in ${ip_files[@]}; do
	    echo "remove_files ${e}" >> .hcode.script.removeip.tcl
	    let i++
	done

	 
	vivado -nolog -nojournal -mode batch -source .hcode.script.removeip.tcl ./VC707_Gen2x8If128.xpr
	rm -rf .hcode.script.removeip.tcl        
	cd ../../../..

	
	exit 1
fi

if [ $ADDIP ]; then
	echo "Adding ip in ip-src to shell."
	cd xilinx/vc707/VC707_Gen2x8If128/prj
	echo "add_files ../../../../ip-src" >> .hcode.script.addip.tcl

	vivado -nolog -nojournal -mode batch -source .hcode.script.addip.tcl ./VC707_Gen2x8If128.xpr
	rm -rf .hcode.script.removeip.tcl
        cd ../../../..
	exit 1
fi

cd xilinx/vc707/VC707_Gen2x8If128/prj
vivado -mode batch -source run.tcl
cd ../../..
