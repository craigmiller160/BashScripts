#!/bin/bash
# Media Script

MOVIE_PATH="/home/craig/MediaDrive/Media/Movies"
TV_PATH="/home/craig/MediaDrive/Media/TV Shows"

path=""

function move_media {

    file="$1"
    path="$2"
    
    echo "Running"
    echo $file
    echo $path

}

function movie {

    series=false
    series_name=""
    series_num=0
    film_name=""
    

    accept=false
    while ! $accept ; do
        read -p "Is this film part of a series? (y/n) "
        case $REPLY in
            y|Y)
                accept=true
                series=true
            ;;
            n|N)
                accept=true
                series=false
            ;;
            *)
                echo "Invalid input! Please try again"
            ;;
        esac
    done
    
    if $series ; then
        accept=false
        while ! $accept ; do
            read -p "Series name: "
            if [ "$REPLY" != "" ]; then
                series_name="$REPLY"
                accept=true
            else
                echo "Invalid input, please try again"
            fi
        done
        
        accept=false
        while ! $accept ; do
            read -p "Series order number: "
            case "$REPLY" in
                [0-9]|[0-9][0-9])
                    series_num="$REPLY"
                    accept=true
                ;;
                *)
                    echo "Invalid input! Please try again"
                ;;
            esac
        done
    fi
    
    accept=false
    while ! $accept ; do
        read -p "Film Name: "
        if [ "$REPLY" != "" ]; then
            film_name="$REPLY"
            accept=true
        else
            echo "Invalid input! Please try again"
        fi
    done
    
    if $series ; then
        path="$MOVIE_PATH/+$series_name/$series_num - $film_name"
    else
        path="$MOVIE_PATH/$film_name"
    fi
}

function tv {

    series_name=""
    season_num=0
    ep_num=0
    
    accept=false
    while ! $accept ; do
        read -p "Series name? "
        if [ "$REPLY" != "" ]; then
            series_name="$REPLY"
            accept=true
        else
            echo "Invalid input! Please try again"
        fi
    done
    
    accept=false
    while ! $accept ; do
        read -p "Season number? "
        case "$REPLY" in
            [0-9]|[0-9][0-9])
                    season_num="$REPLY"
                    accept=true
            ;;
            *)
                echo "Invalid input! Please try again"
            ;;
        esac
    done
    
    accept=false
    while ! $accept ; do
        read -p "Episode number? "
        case "$REPLY" in
            [0-9]|[0-9][0-9])
                    ep_num="$REPLY"
                    accept=true
            ;;
            *)
                echo "Invalid input! Please try again"
            ;;
        esac
    done
    
    echo $series_name
    echo $season_num
    echo $ep_num
    
    path="$TV_PATH/$series_name/Season*$season_num"

}

# SCRIPT STARTS HERE

MOVIE_TYPE="Movie"
TV_TYPE="TV"

type=""

echo "Add media to Plex Media Server."
echo ""

accept=false
while ! $accept ; do
    read -p "Is this a movie (m) or tv show (t)? "
    case $REPLY in
        m|M)
            accept=true
            type=$MOVIE_TYPE
        ;;
        t|T)
            accept=true
            type=$TV_TYPE
        ;;
        *)
            echo "Invalid input! Please try again"
        ;;
    esac
done


case $type in
    $MOVIE_TYPE)
        movie
    ;;
    $TV_TYPE)
        tv
    ;;
esac

IFS=$'\n'

export -f move_media
export path=$path
find . \( -name '*.mkv' -o -name '*.mp4' \) -exec bash -c 'move_media {} $path' \;




















# IFS=$'\n'
# 
# export -f foo
# 
# files=$(find . -name '*.mkv' -o -name '*.mp4' -exec bash -c 'foo' {} \;)
# 
# echo "The following media files have been found:"
# 
# printf '  %q\n' ${files[@]}
# 
# accept=false
# while ! $accept ; do
#     read -p "Do you want to add these to Plex Media Center? (y/n):"
#     case $REPLY in
#         y)
#             accept=true
#         ;;
#         n)
#             echo "Cancelling script"
#             exit 0
#         ;;
#         *)
#             echo "Invalid response, please try again"
#         ;;
#     esac
# done

