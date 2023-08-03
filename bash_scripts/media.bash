function img2pdf() {
    mkdir tmp_convert_pdf
    for img in "$@"; do
        convert $img ${img%.*}.pdf
        mv ${img%.jpg}.pdf tmp_convert_pdf
    done

    pdftk ./tmp_convert_pdf/*.pdf cat output combined.pdf
    rm -r tmp_convert_pdf
}

function readpdf() {
    convert -density 300 $1 -depth 8 -strip -background white -alpha off file.tiff
    tesseract file.tiff $1
    rm file.tiff
}

function audio2ImageVideo() {
    input_image="$1"
    input_audio="$2"
    output_name="$3"
    echo ${input_audio##*.}
    if [[ ${input_audio##*.} == "png" ]] || [[ ${input_audio##*.} == "jpg" ]]; then
        echo "Ensure that the script is run as: "
        echo "audio2ImageVideo input_image input_audio output_name"
        return 1
    fi

    ffmpeg -loop 1 -framerate 2 -i "$input_image" -i "$input_audio" -c:v libx264 -preset medium -tune stillimage -crf 18 -c:a copy -shortest -pix_fmt yuv420p "$output_name".mkv
}

function convertAudio() {
    type="$1"
    for file in "$type"; do
        ffmpeg -i "$file" "$file".mp3
    done
}

function concateVideo() {
    input_video_type="$1"
    output_name="$2"
    ffmpeg -f concat -safe 0 -i <(for f in ./*.$input_video_type; do echo "file '$PWD/$f'"; done) -c copy $output_name
}

function convert_all_to_MTS_and_Concate_out_m4v() {
    for f in ./*; do ffmpeg -i "$f" -q 0 "${f%.*}.mts"; done
    ffmpeg -f concat -safe 0 -i <(for f in ./*.mts; do echo "file '$PWD/$f'"; done) -c copy output.mts
    ffmpeg -i output.mts output.m4v
    rm *.mts
}

function restart_audio() {
    systemctl --user restart pulseaudio
}