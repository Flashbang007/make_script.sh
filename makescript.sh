#!/bin/bash -x

LIBRARY="/usr/local/lib/flashbang_lib.sh"
SCRIPT="$1"
SCPATH="${HOME}/bin"

if [ -f $LIBRARY ]; then
        source $LIBRARY
fi

print_help() {
echo -e "
Usage: $SCRIPTNAME (SCRIPTNAME) [OPTION] [ARGS]

        -h      show this help
        -d      [DIRNAME] make script in DIR
                Standard path $SCPATH
        -l      [LIBRARY] import your own library
"
}

OPTIND=2
while getopts 'hd:l:' opt
 do
        case $opt in
                l)
                        USERLIBRARY="$OPTARG"
                ;;
                d)
                        SCPATH="$OPTARG"
                ;;
                h)
                        print_help
                        exit 0
                ;;
                \?)
                        echo "Invalid option: -$OPTARG"
                        exit 1
                ;;
        esac
 done


[ -z $SCRIPT ] && echo "no sctiptname" && exit 1
[[ $SCRIPT =~ -.* ]] && echo "invalid Argument $SCRIPT. first scriptname, then OPTIONS" && print_help && exit 1
[ ! -d $SCPATH ] && echo "$SCPATH not existant" && exit 1

cd $SCPATH
touch $SCRIPT
chmod 744 $SCRIPT
echo "#!/bin/bash
" >> $SCRIPT

if [ -f $USERLIBRARY ]; then
        echo -e "source $USERLIBRARY" >> $SCRIPT
else
        echo "$USERLIBRARY not found"
        rm $SCRIPT
        exit 2
fi
if [ -f $LIBRARY ]; then
        echo -e "source $LIBRARY" >> $SCRIPT
        grep -E "^#" $LIBRARY >> $SCRIPT
fi

vi $SCRIPT

exit 0
