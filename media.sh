#!/bin/bash
# Media Script

### TODO add ability to specify filename

function foo {

    echo "Foo"

}

IFS=$'\n'

export -f foo

files=$(find . -name '*.mkv' -o -name '*.mp4' -exec bash -c 'foo' {} \;)

echo "The following media files have been found:"

printf '  %q\n' ${files[@]}

accept=false
while ! $accept ; do
    read -p "Do you want to add these to Plex Media Center? (y/n):"
    case $REPLY in
        y)
            accept=true
        ;;
        n)
            echo "Cancelling script"
            exit 0
        ;;
        *)
            echo "Invalid response, please try again"
        ;;
    esac
done

