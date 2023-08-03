function ros_build() {
    path=$PWD

    while [[ $path != $HOME && $path != \/ && $path != \/home ]]; do
        if [[ -d "$path/src" && -d "$path/devel" && "$path/build" ]]; then
            catkin_make -C $path
            source $path/devel/setup.bash

            output=""
            # run launch file if available
            for i in $(<$path/params); do
                output+=" $i"
            done 2>/dev/null
            echo $output

            if [[ $output != "" ]]; then
                clear
                # print running title
                echo "-------- Running --------"
                $output
            fi
            return 0
        fi
        path=${path%/*}
    done

    echo To build ROS, navigate to a folder or subfolder with:
    echo
    echo -e '   build, devel, src'
    echo
    return 1
}

function rosbagSplit() {
    bag_file="$1"
    start_sec="$2"
    end_sec="$3"

    info=$(rosbag info $bag_file)

    count=0
    start_found=0
    end_found=0
    for data in $info; do
        if [[ ${data/:*/} == start ]]; then
            start_found=1
            count=0
        fi

        if [ $count == 5 -a $start_found == 1 ]; then
            clock_start=$(echo $data | sed -e "s/[()]//g")
            count=0
            start_found=0
        fi

        if [[ ${data/:*/} == end ]]; then
            end_found=1
            count=0
        fi

        if [ $count == 5 -a $end_found == 1 ]; then
            clock_end=$(echo $data | sed -e "s/[()]//g")
            count=0
            end_found=0
        fi

        ((count++))
    done

    duration=$(echo $end_sec - $start_sec | bc)
    record_start=$(echo $clock_start + $start_sec | bc)
    record_end=$(echo $record_start + $duration | bc)

    echo $duration

    rosbag filter "$1" "${1/.bag/}"-$start_sec-$end_sec.bag "t.secs >= $record_start and t.secs <= $record_end"
}

function rosbag2csv() {
    bagName="$1"
    topics="${@:2}"

    for topic in $topics; do
        witeNameTopic=${topic/\//}
        rostopic echo -b $bagName -p $topic >${bagName%.bag}-${witeNameTopic//\//\-}.csv
    done
}
