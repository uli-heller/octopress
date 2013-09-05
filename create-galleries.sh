#!/bin/sh

D="$(dirname "$0")"

GALLERIES=source/images/galleries
THUMBNAILS=thumbs
SCALED=scaled

THUMBNAIL_GEOMETRY=64x48
SCALED_GEOMETRY=640x480

create_image() {
  (
    srcImage="$1"
    dstImage="$2"
    shift 2
    if [ "${srcImage}" -nt "${dstImage}" ]; then
      convert "$@" "${srcImage}" "${dstImage}"
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
  for d in "${gallery}/${THUMBNAILS}" "${gallery}/${SCALED}"; do
    if [ ! -d "${d}" ]; then
      mkdir -p "${d}"
    fi
  done
  for image in "${gallery}/"*; do
    if [ -f "${image}" ]; then
      base_image="$(basename "${image}")"
      create_thumbnail "${image}" "${gallery}/${THUMBNAILS}/${base_image}"
      create_scaled "${image}" "${gallery}/${SCALED}/${base_image}"
    fi
  done
done

