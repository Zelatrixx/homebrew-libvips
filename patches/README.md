# Patches for libheif + SVT-AV1

## `libheif-1.21.2-encoder_svt_svt4-firefox-td.patch` (**used by the tap**)

Applied by `Formula/libheif@1.21.2.rb`. Supersedes `libheif-1.21.2-svt_av1_build_fix-1.patch` with one extra change:

- **Firefox:** `svt_config.avif` is **never** set to `true` (SVT’s AVIF mode often breaks Firefox even for even dimensions). Still-image parameters (`pred_structure`, `hierarchical_levels`, `intra_period_length`, fps 1/1) stay enabled.

Also includes: round-down odd sizes in `svt_query_encoded_size`, SVT 4.x tune/GOP fixes, strip leading Temporal Delimiter OBU.

**SVT-AV1 4.x:** `hierarchical_levels` must be **2–5** (not `0`); the patch uses **`2`** (minimum), otherwise the encoder aborts with `Only hierarchical levels 2-5 is currently supported`.

Uses paths `a/libheif/plugins/encoder_svt.cc` (works with `patch -p1` from extracted tarball root).

## `libheif-1.21.2-svt_av1_build_fix-1.patch`

Older combined patch **without** the conditional `avif` / Firefox tweak (kept for reference or custom installs).

## `encoder_svt.cc`

**Upstream libheif 1.21.2** `encoder_svt.cc` without patches — example / diff baseline only. The install applies **`libheif-1.21.2-encoder_svt_svt4-firefox-td.patch`**, not this file.
