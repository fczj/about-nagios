#!/bin/bash
# ========================================================================================
# MEM Utilization Statistics plugin for Nagios 
#
# Written by    : xiongzhibiao
# Release   : 1.0
# Creation date : 3 May 2017
# Description   : Nagios plugin (script) to check mem utilization statistics.
#
# Usage         : ./check_mem.sh [-w <warn>] [-c <crit]
# Example       : ./check_mem.sh -w 0.2 -c 0.1
#               when memory free 20% Warning
#               when memory free 10% Critical
# ----------------------------------------------------------------------------------------
# ========================================================================================

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3



#system memory infomation
FREE_MEM=$(free |awk 'NR==2{print ($4+$6+$7)/$2}')
USED_MEM=$(printf "%f" `echo 1-${FREE_MEM}|bc`)

# Plugin variable description
PROGNAME=$(basename $0)
RELEASE="Revision 1.0"
AUTHOR="by xiongzhibiao (xiongzhibiao@calfdata.com)"


print_usage (){
    echo ""
    echo "$PROGNAME $RELEASE - MEM Utilization check script for Nagios"
    echo ""
    echo "Usage: check_mem.sh [flags]"
    echo ""
    echo "Flags:"
    echo "  -w  <number> : Warning level  for free memory"
    echo "  -c  <number> : Critical level  for free memory"
    echo ""
    echo "Usage: $PROGNAME"
    echo "Usage: $PROGNAME --help"
    echo ""
}

print_help() {
    print_usage
        echo ""
        echo "This plugin will check mem utilization (from free command)"
        echo ""
    exit 0
}


while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help)
        print_help
        exit $STATE_OK
        ;;
    -w)
        shift
        MEM_W=${1:="0.2"}
        ;;
    -c)
        shift
        MEM_C=${1:="0.1"}
        ;;
    *)
        print_usage
        exit $STATE_OK
        ;;
    esac
shift
done

#Critical
if [ `expr ${FREE_MEM} \< ${MEM_C}` -eq 1 ];then
    echo "Mem Free ${FREE_MEM},Critical"
    exit $STATE_CRITICAL
fi

#Warning
if [ `expr ${FREE_MEM} \< ${MEM_W}` -eq 1 ];then
    echo "Mem Free ${FREE_MEM},Warning"
    exit $STATE_WARNING
fi


#OK
echo "Mem Free ${FREE_MEM}"
exit $STATE_OK
