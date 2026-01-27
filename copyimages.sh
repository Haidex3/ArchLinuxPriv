#!/usr/bin/env bash

SRC="$HOME/.local/share/Steam/steamapps/workshop/content/431960"
DST="$HOME/Documents/GitHub/ArchLinuxPriv/images"

mkdir -p "$DST"

for dir in "$SRC"/*; do
  if [[ -d "$dir" && -f "$dir/scene.pkg" ]]; then
    id="$(basename "$dir")"
    cp "$dir/scene.pkg" "$DST/$id.scene.pkg"
    echo "Copiado: $id.scene.pkg"
  fi
done

echo "✅ Listo. Todos los scene.pkg fueron copiados."
