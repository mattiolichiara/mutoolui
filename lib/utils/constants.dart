class Constants {
  static const spacing = 0.04;
  static const fontSize = 0.008;
  static const buttonWidth = 0.28;
  static const buttonHeight = 0.09;
  static const iconsSize = 0.01;
  static const rowSpacing = 0.007;

  static const cleanOptions = '''
-p -    password
-g      garbage collect unused objects
-gg     in addition to -g compact xref table
-ggg    in addition to -gg merge duplicate objects
-gggg   in addition to -ggg check streams for duplication
-l      linearize PDF (no longer supported!)
-D      save file without encryption
-E -    save file with new encryption (rc4-40, rc4-128, aes-128, or aes-256)
-O -    owner password (only if encrypting)
-U -    user password (only if encrypting)
-P -    permission flags (only if encrypting)
-a      ascii hex encode binary streams
-d      decompress streams
-z      deflate uncompressed streams
-e -    compression "effort" (0 = default, 1 = min, 100 = max)
-f      compress font streams
-i      compress image streams
-c      clean content streams
-s      sanitize content streams
-t      compact object syntax
-tt     indented object syntax
-L      write object labels
-A      create appearance streams for annotations
-AA     recreate appearance streams for annotations
-m      preserve metadata
-S      subset fonts if possible [EXPERIMENTAL!]
-Z      use objstms if possible for extra compression
--{color,gray,bitonal}-{,lossy-,lossless-}image-subsample-method -
average, bicubic
--{color,gray,bitonal}-{,lossy-,lossless-}image-subsample-dpi -[,-]
DPI at which to subsample [+ target dpi]
--{color,gray,bitonal}-{,lossy-,lossless-}image-recompress-method -[:quality]
never, same, lossless, jpeg, j2k, fax, jbig2
--structure=keep|drop   Keep or drop the structure tree
pages   comma separated list of page numbers and ranges
''';

  static const convertOptions = '''
-p -    password

        -b -    use named page box (MediaBox, CropBox, BleedBox, TrimBox, or ArtBox)
        -A -    number of bits of antialiasing (0 to 8)
        -W -    page width for EPUB layout
        -H -    page height for EPUB layout
        -S -    font size for EPUB layout
        -U -    file name of user stylesheet for EPUB layout
        -X      disable document styles for EPUB layout

        -o -    output file name (%d for page number)
        -F -    output format (default inferred from output file name)
                        raster: cbz, png, pnm, pgm, ppm, pam, pbm, pkm.
                        print-raster: pcl, pclm, ps, pwg.
                        vector: pdf, svg.
                        text: html, xhtml, text, stext.
        -O -    comma separated list of options for output format

        pages   comma separated list of page ranges (N=last page)

Raster output options:
        rotate=N: rotate rendered pages N degrees counterclockwise
        resolution=N: set both X and Y resolution in pixels per inch
        x-resolution=N: X resolution of rendered pages in pixels per inch
        y-resolution=N: Y resolution of rendered pages in pixels per inch
        width=N: render pages to fit N pixels wide (ignore resolution option)
        height=N: render pages to fit N pixels tall (ignore resolution option)
        colorspace=(gray|rgb|cmyk): render using specified colorspace
        alpha: render pages with alpha channel and transparent background
        graphics=(aaN|cop|app): set the rasterizer to use
        text=(aaN|cop|app): set the rasterizer to use for text
                aaN=antialias with N bits (0 to 8)
                cop=center of pixel
                app=any part of pixel

PCL output options:
        colorspace=mono: render 1-bit black and white page
        colorspace=rgb: render full color page
        preset=generic|ljet4|dj500|fs600|lj|lj2|lj3|lj3d|lj4|lj4pl|lj4d|lp2563b|oce9050
        spacing=0: No vertical spacing capability
        spacing=1: PCL 3 spacing (<ESC>*p+<n>Y)
        spacing=2: PCL 4 spacing (<ESC>*b<n>Y)
        spacing=3: PCL 5 spacing (<ESC>*b<n>Y and clear seed row)
        mode2: Enable mode 2 graphics compression
        mode3: Enable mode 3 graphics compression
        eog_reset: End of graphics (<ESC>*rB) resets all parameters
        has_duplex: Duplex supported (<ESC>&l<duplex>S)
        has_papersize: Papersize setting supported (<ESC>&l<sizecode>A)
        has_copies: Number of copies supported (<ESC>&l<copies>X)
        is_ljet4pjl: Disable/Enable HP 4PJL model-specific output
        is_oce9050: Disable/Enable Oce 9050 model-specific output

PCLm output options:
        compression=none: No compression (default)
        compression=flate: Flate compression
        strip-height=N: Strip height (default 16)

PWG output options:
        media_class=<string>: set the media_class field
        media_color=<string>: set the media_color field
        media_type=<string>: set the media_type field
        output_type=<string>: set the output_type field
        rendering_intent=<string>: set the rendering_intent field
        page_size_name=<string>: set the page_size_name field
        advance_distance=<int>: set the advance_distance field
        advance_media=<int>: set the advance_media field
        collate=<int>: set the collate field
        cut_media=<int>: set the cut_media field
        duplex=<int>: set the duplex field
        insert_sheet=<int>: set the insert_sheet field
        jog=<int>: set the jog field
        leading_edge=<int>: set the leading_edge field
        manual_feed=<int>: set the manual_feed field
        media_position=<int>: set the media_position field
        media_weight=<int>: set the media_weight field
        mirror_print=<int>: set the mirror_print field
        negative_print=<int>: set the negative_print field
        num_copies=<int>: set the num_copies field
        orientation=<int>: set the orientation field
        output_face_up=<int>: set the output_face_up field
        page_size_x=<int>: set the page_size_x field
        page_size_y=<int>: set the page_size_y field
        separations=<int>: set the separations field
        tray_switch=<int>: set the tray_switch field
        tumble=<int>: set the tumble field
        media_type_num=<int>: set the media_type_num field
        compression=<int>: set the compression field
        row_count=<int>: set the row_count field
        row_feed=<int>: set the row_feed field
        row_step=<int>: set the row_step field

Text output options:
        preserve-images: keep images in output
        preserve-ligatures: do not expand ligatures into constituent characters
        preserve-spans: do not merge spans on the same line
        preserve-whitespace: do not convert all whitespace into space characters
        inhibit-spaces: don't add spaces between gaps in the text
        paragraph-break: break blocks at paragraph boundaries
        dehyphenate: attempt to join up hyphenated words
        ignore-actualtext: do not apply ActualText replacements
        use-cid-for-unknown-unicode: use character code if unicode mapping fails
        use-gid-for-unknown-unicode: use glyph index if unicode mapping fails
        accurate-bboxes: calculate char bboxes from the outlines
        accurate-ascenders: calculate ascender/descender from font glyphs
        accurate-side-bearings: expand char bboxes to completely include width of glyphs
        collect-styles: attempt to detect text features (fake bold, strikeout, underlined etc)
        clip: do not include text that is completely clipped
        clip-rect=x0:y0:x1:y1 specify clipping rectangle within which to collect content
        structured: collect structure markup
        vectors: include vector bboxes in output
        segment: attempt to segment the page
        table-hunt: hunt for tables within a (segmented) page

PDF output options:
        decompress: decompress all streams (except compress-fonts/images)
        compress=yes|flate|brotli: compress all streams, yes defaults to flate
        compress-fonts: compress embedded fonts
        compress-images: compress images
        compress-effort=0|percentage: effort spent compressing, 0 is default, 100 is max effort
        ascii: ASCII hex encode binary streams
        pretty: pretty-print objects with indentation
        labels: print object labels
        linearize: optimize for web browsers (no longer supported!)
        clean: pretty-print graphics commands in content streams
        sanitize: sanitize graphics commands in content streams
        garbage: garbage collect unused objects
        or garbage=compact: ... and compact cross reference table
        or garbage=deduplicate: ... and remove duplicate objects
        incremental: write changes as incremental update
        objstms: use object streams and cross reference streams
        appearance=yes|all: synthesize just missing, or all, annotation/widget apperance streams
        continue-on-error: continue saving the document even if there is an error
        decrypt: write unencrypted document
        encrypt=rc4-40|rc4-128|aes-128|aes-256: write encrypted document
        permissions=NUMBER: document permissions to grant when encrypting
        user-password=PASSWORD: password required to read document
        owner-password=PASSWORD: password required to edit document
        regenerate-id: (default yes) regenerate document id

SVG output options:
        text=text: Emit text as <text> elements (inaccurate fonts).
        text=path: Emit text as <path> elements (accurate fonts).
        no-reuse-images: Do not reuse images using <symbol> definitions.
''';

  static const createOptions = '''
   -o -    name of PDF file to create
        -O -    comma separated list of output options
        page.txt        content stream with annotations for creating resources

Content stream special commands:
        %%MediaBox LLX LLY URX URY
        %%Rotate Angle
        %%Font Name Filename Encoding
                Filename is either a file or a base 14 font name
                Encoding=Latin|Greek|Cyrillic
        %%CJKFont Name Language WMode Style
                Language=zh-Hant|zh-Hans|ja|ko
                WMode=H|V
                Style=serif|sans)
        %%Image Name Filename

PDF output options:
        decompress: decompress all streams (except compress-fonts/images)
        compress=yes|flate|brotli: compress all streams, yes defaults to flate
        compress-fonts: compress embedded fonts
        compress-images: compress images
        compress-effort=0|percentage: effort spent compressing, 0 is default, 100 is max effort
        ascii: ASCII hex encode binary streams
        pretty: pretty-print objects with indentation
        labels: print object labels
        linearize: optimize for web browsers (no longer supported!)
        clean: pretty-print graphics commands in content streams
        sanitize: sanitize graphics commands in content streams
        garbage: garbage collect unused objects
        or garbage=compact: ... and compact cross reference table
        or garbage=deduplicate: ... and remove duplicate objects
        incremental: write changes as incremental update
        objstms: use object streams and cross reference streams
        appearance=yes|all: synthesize just missing, or all, annotation/widget apperance streams
        continue-on-error: continue saving the document even if there is an error
        decrypt: write unencrypted document
        encrypt=rc4-40|rc4-128|aes-128|aes-256: write encrypted document
        permissions=NUMBER: document permissions to grant when encrypting
        user-password=PASSWORD: password required to read document
        owner-password=PASSWORD: password required to edit document
        regenerate-id: (default yes) regenerate document id
        ''';

  static const drawOptions = '''
        -p -    password

        -o -    output file name (%d for page number)
        -F -    output format (default inferred from output file name)
                raster: png, pnm, pam, pbm, pkm, pwg, pcl, ps, pdf, j2k
                vector: svg, pdf, trace, ocr.trace
                text: txt, html, xhtml, stext, stext.json
                ocr'd text: ocr.txt, ocr.html, ocr.xhtml, ocr.stext, ocr.stext.json
                bitmap-wrapped-as-pdf: pclm, ocr.pdf

        -q      be quiet (don't print progress messages)
        -s -    show extra information:
                m - show memory use
                t - show timings
                f - show page features
                5 - show md5 checksum of rendered image

        -R -    rotate clockwise (default: 0 degrees)
        -r -    resolution in dpi (default: 72)
        -w -    width (in pixels) (maximum width if -r is specified)
        -h -    height (in pixels) (maximum height if -r is specified)
        -f      fit width and/or height exactly; ignore original aspect ratio
        -b -    use named page box (MediaBox, CropBox, BleedBox, TrimBox, or ArtBox)
        -B -    maximum band_height (pXm, pcl, pclm, ocr.pdf, ps, psd and png output only)
        -T -    number of threads to use for rendering (banded mode only)

        -W -    page width for EPUB layout
        -H -    page height for EPUB layout
        -S -    font size for EPUB layout
        -U -    file name of user stylesheet for EPUB layout
        -X      disable document styles for EPUB layout
        -a      disable usage of accelerator file

        -c -    colorspace (mono, gray, grayalpha, rgb, rgba, cmyk, cmykalpha, filename of ICC profile)
        -e -    proof icc profile (filename of ICC profile)
        -G -    apply gamma correction
        -I      invert colors

        -A -    number of bits of antialiasing (0 to 8)
        -A -/-  number of bits of antialiasing (0 to 8) (graphics, text)
        -l -    minimum stroked line width (in pixels)
        -K      do not draw text
        -KK     only draw text
        -D      disable use of display list
        -i      ignore errors
        -m -    limit memory usage in bytes
        -L      low memory mode (avoid caching, clear objects after each page)
        -P      parallel interpretation/rendering
        -N      disable ICC workflow ("N"o color management)
        -O -    Control spot/overprint rendering
                 0 = No spot rendering
                 1 = Overprint simulation (default)
                 2 = Full spot rendering
        -t -    Specify language/script for OCR (default: eng)
        -d -    Specify path for OCR files (default: rely on TESSDATA_PREFIX environment variable)
        -k -{,-}        Skew correction options. auto or angle {0=increase size, 1=maintain size, 2=decrease size}

        -y l    List the layer configs to stderr
        -y -    Select layer config (by number)
        -y -{,-}*       Select layer config (by number), and toggle the listed entries

        -Y      List individual layers to stderr
        -z -    Hide individual layer
        -Z -    Show individual layer

        pages   comma separated list of page numbers and ranges
        ''';

  static const traceOptions = '''
        -p -    password

        -W -    page width for EPUB layout
        -H -    page height for EPUB layout
        -S -    font size for EPUB layout
        -U -    file name of user stylesheet for EPUB layout
        -X      disable document styles for EPUB layout

        -d      use display list

        pages   comma separated list of page numbers and ranges
        ''';

  static const extractOptions = '''
        -p      password
        -r      convert images to rgb
        -a      embed SMasks as alpha channel
        -N      do not use ICC color conversions
        ''';

  static const infoOptions = '''
        -p -    password for decryption
        -F      list fonts
        -I      list images
        -M      list dimensions
        -P      list patterns
        -S      list shadings
        -X      list form and postscript xobjects
        -Z      list ZUGFeRD info
        pages   comma separated list of page numbers and ranges
        ''';

  static const mergeOptions = '''
        -o -    name of PDF file to create
        -O -    comma separated list of output options
        input.pdf       name of input file from which to copy pages
        pages   comma separated list of page numbers and ranges

PDF output options:
        decompress: decompress all streams (except compress-fonts/images)
        compress=yes|flate|brotli: compress all streams, yes defaults to flate
        compress-fonts: compress embedded fonts
        compress-images: compress images
        compress-effort=0|percentage: effort spent compressing, 0 is default, 100 is max effort
        ascii: ASCII hex encode binary streams
        pretty: pretty-print objects with indentation
        labels: print object labels
        linearize: optimize for web browsers (no longer supported!)
        clean: pretty-print graphics commands in content streams
        sanitize: sanitize graphics commands in content streams
        garbage: garbage collect unused objects
        or garbage=compact: ... and compact cross reference table
        or garbage=deduplicate: ... and remove duplicate objects
        incremental: write changes as incremental update
        objstms: use object streams and cross reference streams
        appearance=yes|all: synthesize just missing, or all, annotation/widget apperance streams
        continue-on-error: continue saving the document even if there is an error
        decrypt: write unencrypted document
        encrypt=rc4-40|rc4-128|aes-128|aes-256: write encrypted document
        permissions=NUMBER: document permissions to grant when encrypting
        user-password=PASSWORD: password required to read document
        owner-password=PASSWORD: password required to edit document
        regenerate-id: (default yes) regenerate document id
        ''';

  static const pagesOptions = '''
        -p -    password for decryption
        pages   comma separated list of page numbers and ranges
        ''';

  static const posterOptions = '''
        -p -    password
        -m -    margin (overlap) between pages (pts, or %)
        -x      x decimation factor
        -y      y decimation factor
        -r      split right-to-left
    ''';

  static const recolorOptions = '''
        -c -    Output colorspace (gray(default), rgb, cmyk)
        -r      Remove OutputIntent(s)
        -o -    Output file
  ''';

  static const signOptions = '''
        -p -    password
        -v      verify signature
        -c      clear signatures
        -s -    sign signatures using certificate file
        -P -    certificate password
        -o -    output file name
  ''';

  static const trimOptions = '''
        -b -    Which box to trim to (MediaBox(default), CropBox, BleedBox, TrimBox, ArtBox)
        -m -    Add margins to box (+ve for inwards, -ve outwards).
                        <All> or <V>,<H> or <T>,<R>,<B>,<L>
        -e      Exclude contents of box, rather than include them
        -f      Fallback to mediabox if specified box not available
        -o -    Output file
  ''';

  static const bakeOptions = '''
        -A      keep annotations
        -F      keep forms
        -O -    comma separated list of output options
  ''';

  static const showOptions = '''
        -p -    password
        -o -    output file
        -e      leave stream contents in their original form
        -b      print only stream contents, as raw binary data
        -g      print only object, one line per object, suitable for grep
        -r      force repair before showing any objects
        -L      show object labels
        path: path to an object, starting with either an object number,
                'pages', 'trailer', or a property in the trailer;
                path elements separated by '.' or '/'. Path elements must be
                array index numbers, dictionary property names, or '*'.
  ''';

  static const auditOptions = '''
      -o -    output file
      ''';

  static const barcodeOptions = '''
        -p -    password for encrypted PDF files
        -o -    output file (default: stdout)
        -r -    rotation
        usage to create: mutool barcode -c [options] text
        -o -    output file (default: out.png)
        -q      add quiet zones
        -t      add human readable text (when possible)
        -e -    error correction level (0-8)
        -s -    size of barcode image
        -F -    barcode format (default: qrcode)
                aztec, codabar, code39, code93, code128, databar, databarexpanded,
                datamatrix, ean8, ean13, itf, maxicode, pdf417, qrcode, upca, upce,
                microqrcode, rmqrcode, dxfilmedge, databarlimited
      ''';

}