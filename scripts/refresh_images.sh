#!/bin/bash -e
working_dir=${1:-"/Users/mac/Dropbox/private_data/project/devops_consultant/consultant_code/blog/blog_cdn/images"}

function confirm_image_size() {
    local working_dir=${1?}
    local max_size=${2:-"153600"} # 150KB
    cd $working_dir
    echo "Scan image size for *.jpg"
    for img_file in *.jpg; do
        file_size=$(cksum "$img_file" | awk -F' ' '{print $2}')
        if [ $file_size -gt $max_size ]; then
            echo "ERROR: $working_dir/$img_file is too big. Size: ${file_size}"
            exit 1
        fi
    done

    echo "Scan image size for *.png"
    for img_file in *.png; do
        file_size=$(cksum "$img_file" | awk -F' ' '{print $2}')
        if [ $file_size -gt $max_size ]; then
            echo "ERROR: $working_dir/$img_file is too big. Size: ${file_size}"
            exit 1
        fi
    done
    echo "OK: No big images are detected!"
}

function watermark_images(){
    local working_dir=${1?}
    cd "$working_dir"
    for f in `ls origin/*`; do
        target_file="$(basename $f)"
        tmp_file="$f.tmp"
        cp "$f" "$tmp_file"
        echo "composite -dissolve 50% -gravity southeast -quality 100 watermark/dns.png $tmp_file $tmp_file"
        composite -dissolve 50% -gravity southeast -quality 100 watermark/dns.png "$tmp_file" "$tmp_file"
        if [[ "$(basename $tmp_file)" == github* ]]; then
            echo "composite -dissolve 100% -gravity northeast -quality 100 watermark/github.png $tmp_file $tmp_file"
            composite -dissolve 100% -gravity northeast -quality 100 watermark/github.png "$tmp_file" "$tmp_file"
        fi

        if [[ "$(basename $tmp_file)" == linkedin* ]]; then
            echo "composite -dissolve 100% -gravity northeast -quality 100 watermark/linkedin.png $tmp_file $tmp_file"
            composite -dissolve 100% -gravity northeast -quality 100 watermark/linkedin.png "$tmp_file" "$tmp_file"
        fi
        echo "mv $tmp_file $target_file"
        mv "$tmp_file" "$target_file"
    done
}

function compress_images(){
    local working_dir=${1?}
    cd "$working_dir"
    for f in `ls origin/*`; do
        target_file="$(basename $f)"
        # https://developers.google.com/speed/docs/insights/OptimizeImages
        if [[ "$target_file" == *png ]]; then
            echo "convert $target_file -strip $target_file"
            convert $target_file -strip $target_file
            optipng -o2 -strip all $target_file $target_file
        fi

        if [[ "$target_file" == *jpg ]]; then
            echo "convert $target_file -strip $target_file"
            convert $target_file -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace RGB $target_file
        fi
    done
}

function git_push() {
    local working_dir=${1?}
    cd "$working_dir"
    git add ../../../omnigraffle/
    git add *.*
    git add origin/*.*
    git add origin_backup/*.*

    echo "git push to repo"
    git commit -am "update images"
    git push origin master
}

watermark_images "$working_dir"
compress_images "$working_dir"
git_push "$working_dir"
confirm_image_size "$working_dir"
