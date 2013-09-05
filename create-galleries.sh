#!/bin/sh

D="$(dirname "$0")"

GALLERIES=source/images/galleries
THUMBNAILS=thumbs
SCALED=scaled
MD5=_md5
# Names which start with an underscore '_' are not copied into public my jekyll/octopress

THUMBNAIL_GEOMETRY=64x48
SCALED_GEOMETRY=640x480

calc_md5() {
    cat "$1"|md5sum|(read a b; echo "$a")
}

md5name() {
  (
    srcImage="$1"
    dir="$(dirname "${srcImage}")"
    base="$(basename "${srcImage}")"
    echo "${dir}/${MD5}/${base}.md5"
  )
}

create_md5() {
  (
    srcImage="$1"
    dstMd5="$(md5name "${srcImage}")"
    calc_md5 "${srcImage}" >"${dstMd5}"
  )
}

check_md5() {
  (
    srcImage="$1"
    srcMd5="$(md5name "${srcImage}")"
    test -s "${srcMd5}" && test "$(calc_md5 "${srcImage}")" = "$(cat "${srcMd5}")"
  )
}

create_image() {
  (
    srcImage="$1"
    dstImage="$2"
    shift 2
    if ! check_md5 "${srcImage}" "$(md5name  "${srcImage}")"; then
      (
        set -x
        convert "$@" "${srcImage}" "${dstImage}"
      )
    fi
  )
}

create_thumbnail() {
  (
    create_image "$1" "$2" "-thumbnail" "${THUMBNAIL_GEOMETRY}"
  )
}

create_scaled() {
  (
    create_image "$1" "$2" "-scale" "${SCALED_GEOMETRY}"
  )
}

for gallery in "${D}/${GALLERIES}/"*; do
  echo $gallery;
  for d in "${gallery}/${MD5}" "${gallery}/${THUMBNAILS}" "${gallery}/${SCALED}"; do
    if [ ! -d "${d}" ]; then
      mkdir -p "${d}"
    fi
  done
  for image in "${gallery}/"*; do
    if [ -f "${image}" ]; then
      base_image="$(basename "${image}")"
      create_thumbnail "${image}" "${gallery}/${THUMBNAILS}/${base_image}"
      create_scaled "${image}" "${gallery}/${SCALED}/${base_image}"
      create_md5 "${image}" "${gallery}/${MD5}/${base_image}.md5"
    fi
  done
done

